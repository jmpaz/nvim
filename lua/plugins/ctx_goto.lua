local M = {}

local uv, api, fn = vim.loop, vim.api, vim.fn

local function buf_lines() return api.nvim_buf_get_lines(0, 0, -1, false) end
local function cur()
  local r, c = unpack(api.nvim_win_get_cursor(0))
  return r, c + 1
end
local function is_url(s) return s:match('^https?://') end
local function exists(p) return p and uv.fs_stat(p) ~= nil end
local function join(a, b) return a:sub(-1) == '/' and (a .. b) or (a .. '/' .. b) end
local function expand_home(p) return (p or ''):gsub('^~', vim.env.HOME or '~') end

local function brace_expand(s)
  local pre, inner, post = s:match('^(.-){([^}]+)}(.*)$')
  if not inner then return { s } end
  local out = {}
  for item in inner:gmatch('([^,]+)') do
    item = item:gsub('^%s+', ''):gsub('%s+$', '')
    for _, r in ipairs(brace_expand(post)) do
      out[#out + 1] = pre .. item .. r
    end
  end
  return out
end

local function fenced_block_at_cursor()
  local lines, row = buf_lines(), cur() - 1
  local si, lang
  for i = row, 1, -1 do
    local L = lines[i]
    if L:match('^```') then
      si = i
      lang = L:match('^```%s*([%w_-]+)') or ''
      break
    end
  end
  if not si then return nil end
  for j = si + 1, #lines do
    if lines[j]:match('^```%s*$') then return { start_i = si, end_i = j, lang = lang } end
  end
end

-- see https://github.com/jmpaz/contextualize/blob/main/docs/usage.md#payload
local function find_root(block)
  if not block or (block.lang ~= 'yaml' and block.lang ~= 'yml') then return nil end
  local lines = buf_lines()
  for i = block.start_i, block.end_i do
    local root = lines[i]:match('^%s*root:%s*(.+)%s*$')
    if root then
      root = root:gsub('#.*$', ''):gsub('^["\'](.-)["\']$', '%1'):gsub('%s+$', '')
      if root ~= '' then return root end
    end
  end
end

local function find_root_in_yaml_file()
  local ft = vim.bo.filetype
  if ft ~= 'yaml' and ft ~= 'yml' then return nil end
  for _, line in ipairs(buf_lines()) do
    local root = line:match('^root:%s*(.+)%s*$')
    if root then
      root = root:gsub('#.*$', ''):gsub('^["\'](.-)["\']$', '%1'):gsub('%s+$', '')
      if root ~= '' then return root end
    end
  end
end

local function path_under_cursor()
  local _, col = cur()
  local line = api.nvim_get_current_line():gsub('%s+#.*$', '')
  local cands = {}
  local function add(pat)
    local s = 1
    while true do
      local a, b, cap = line:find(pat, s)
      if not a then break end
      cands[#cands + 1] = { s = a, e = b, text = cap or line:sub(a, b) }
      s = b + 1
    end
  end
  add([["([^"]+)"]])
  add([['([^']+)']])
  add([[https?://%S+]])
  add([[%f[%S]%-%s*([%w%._%-%/{}:,=]+)]])
  add([[path:%s*([%w%._%-%/{}:,=]+)]])
  add([[source:%s*([%w%._%-%/{}:,=]+)]])
  add([[([%w%._%-%/{}:,=]+/%S+)]])
  for _, c in ipairs(cands) do
    if c.s <= col and col <= c.e then return c.text end
  end
end

local function sanitize(tok) return tok:gsub('%s+$', ''):gsub(',$', '') end

local function markdown_target(tok)
  if tok:sub(1, 1) ~= '[' then return tok end
  local label_close = tok:find('%]')
  if not label_close then return tok end
  local open_paren = tok:find('%(', label_close + 1)
  local close_paren = tok:match('^.*()%)%s*$')
  if not open_paren or not close_paren or open_paren >= close_paren then return tok end
  local target = tok:sub(open_paren + 1, close_paren - 1)
  target = target:gsub('^%s*<', ''):gsub('>%s*$', '')
  return target ~= '' and target or tok
end
local function filename_alias(tok) return tok:match('::filename=([^%s]+)$') end

local function prefer_note_files(path)
  if path:match('%.[^/%.]+$') then return {} end
  local seen, matches = {}, {}
  local function add(p)
    if exists(p) and not seen[p] then matches[#matches + 1], seen[p] = p, true end
  end
  local env_ext = vim.env.ZK_NOTE_EXTENSION or vim.env.ZK_DEFAULT_NOTE_EXTENSION or vim.env.ZK_NOTEBOOK_EXT
  if env_ext and env_ext ~= '' then
    if env_ext:sub(1, 1) ~= '.' then env_ext = '.' .. env_ext end
    add(path .. env_ext)
  end
  add(path .. '.md')
  add(path .. '.markdown')
  add(path .. '.txt')
  if fn and fn.glob then
    local globbed = fn.glob(path .. '.*', 0, 1)
    for _, g in ipairs(globbed) do add(g) end
  end
  return matches
end

local function resolve(tok, root)
  tok = sanitize(tok)
  tok = markdown_target(tok)
  local base = expand_home(root or vim.env.ZK_NOTEBOOK_DIR or vim.loop.cwd() or '')
  local out = {}

  local alias = filename_alias(tok)
  tok = tok:gsub('::filename=[^%s]+$', '')

  for _, p in ipairs(brace_expand(tok)) do
    p = p:gsub('%s+$', '')
    if is_url(p) then
      out[#out + 1] = { kind = 'url', target = p }
    else
      p = expand_home(p)
      if not p:match('^/') then p = join(base, p) end
      out[#out + 1] = { kind = 'file', target = p }
    end
  end

  if alias and not is_url(alias) then
    local ap = alias
    if not ap:match('^/') then ap = join(base, ap) end
    table.insert(out, 1, { kind = 'file', target = ap })
  end

  local existing = {}
  for _, e in ipairs(out) do
    if e.kind == 'file' then
      if exists(e.target) then
        existing[#existing + 1] = e
      else
        local alts = prefer_note_files(e.target)
        for _, alt in ipairs(alts) do
          existing[#existing + 1] = { kind = 'file', target = alt }
        end
      end
    end
  end
  if #existing > 0 then return existing end
  return out
end

local function open(entry, vsplit)
  if entry.kind == 'url' then
    vim.cmd((vsplit and 'vnew | read ' or 'enew | read ') .. entry.target)
    return
  end
  vim.cmd(string.format('%s %s', vsplit and 'vsplit' or 'edit', fn.fnameescape(entry.target)))
end

local function fallback(vsplit)
  local ok, patch = pcall(require, 'config.lsp_patch')
  if ok and patch and patch.goto_definition then return patch.goto_definition(vsplit) end
  return vim.lsp.buf.definition()
end

function M.smart_goto(vsplit)
  local tok = path_under_cursor()
  if not tok then return fallback(vsplit) end
  local block = fenced_block_at_cursor()
  local root = find_root(block) or find_root_in_yaml_file()
  if root == '~' then root = expand_home(root) end
  local cands = resolve(tok, root)
  if #cands == 0 then return fallback(vsplit) end
  if #cands == 1 then return open(cands[1], vsplit) end
  vim.ui.select(cands, { prompt = 'Open path', format_item = function(it) return it.target end }, function(choice)
    if choice then open(choice, vsplit) end
  end)
end

function M.setup()
  api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'md', 'yaml', 'yml' },
    callback = function(args)
      local o = { buffer = args.buf, noremap = true, silent = true }
      vim.keymap.set('n', 'gd', function() M.smart_goto(false) end, vim.tbl_extend('force', o, { desc = 'smart goto' }))
      vim.keymap.set(
        'n',
        'g ',
        function() M.smart_goto(true) end,
        vim.tbl_extend('force', o, { desc = 'smart goto (vsplit)' })
      )
    end,
  })
end

return M
