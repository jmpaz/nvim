local M = {}

local api = vim.api
local uv = vim.loop

local ns_id = api.nvim_create_namespace('path_titles')
local title_cache = {}
local enabled = true

local function exists(p) return p and uv.fs_stat(p) ~= nil end
local function join(a, b) return a:sub(-1) == '/' and (a .. b) or (a .. '/' .. b) end
local function expand_home(p) return (p or ''):gsub('^~', vim.env.HOME or '~') end

local function parse_frontmatter_title(path)
  if title_cache[path] ~= nil then return title_cache[path] end
  if not exists(path) then
    title_cache[path] = false
    return false
  end
  local f = io.open(path, 'r')
  if not f then
    title_cache[path] = false
    return false
  end
  local first = f:read('*l')
  if first ~= '---' then
    f:close()
    title_cache[path] = false
    return false
  end
  local title = false
  for line in f:lines() do
    if line:match('^%-%-%-') then break end
    local t = line:match('^title:%s*(.+)%s*$')
    if t then
      title = t:gsub('^["\'](.-)["\']$', '%1')
      break
    end
  end
  f:close()
  title_cache[path] = title
  return title
end

local function find_yaml_regions(buf)
  local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
  local ft = vim.bo[buf].filetype
  local regions = {}
  if ft == 'yaml' or ft == 'yml' then
    local root = nil
    for _, line in ipairs(lines) do
      local r = line:match('^root:%s*(.+)%s*$')
      if r then
        root = r:gsub('#.*$', ''):gsub('^["\'](.-)["\']$', '%1'):gsub('%s+$', '')
        break
      end
    end
    regions[#regions + 1] = { start_i = 1, end_i = #lines, root = root }
  else
    local i = 1
    while i <= #lines do
      local lang = lines[i]:match('^```%s*([%w_-]*)')
      if lang and (lang == 'yaml' or lang == 'yml' or lang == '') then
        local start_i = i
        local root = nil
        for j = i + 1, #lines do
          if lines[j]:match('^```%s*$') then
            for k = start_i + 1, j - 1 do
              local r = lines[k]:match('^%s*root:%s*(.+)%s*$')
              if r then
                root = r:gsub('#.*$', ''):gsub('^["\'](.-)["\']$', '%1'):gsub('%s+$', '')
                break
              end
            end
            regions[#regions + 1] = { start_i = start_i + 1, end_i = j - 1, root = root }
            i = j
            break
          end
        end
      end
      i = i + 1
    end
  end
  return regions, lines
end

local function find_paths_in_line(line)
  local results = {}
  local patterns = {
    { pat = [["([^"]+%.md)"]], offset = 1 },
    { pat = [['([^']+%.md)']], offset = 1 },
    { pat = [[%-%s+([%w%._%-%/]+%.md)]], offset = 0 },
    { pat = [[path:%s*([%w%._%-%/]+%.md)]], offset = 0 },
    { pat = [[source:%s*([%w%._%-%/]+%.md)]], offset = 0 },
  }
  for _, p in ipairs(patterns) do
    local s = 1
    while true do
      local a, b, cap = line:find(p.pat, s)
      if not a then break end
      local col = a + p.offset
      for i = a, b do
        if line:sub(i, i + #cap - 1) == cap then
          col = i
          break
        end
      end
      results[#results + 1] = { path = cap, col = col - 1, end_col = col - 1 + #cap }
      s = b + 1
    end
  end
  return results
end

local function resolve_path(path, root)
  local base = expand_home(root or vim.env.ZK_NOTEBOOK_DIR or vim.loop.cwd() or '')
  path = expand_home(path)
  if not path:match('^/') then path = join(base, path) end
  return path
end

local function apply_overlays(buf)
  api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
  if not enabled then return end
  local regions, lines = find_yaml_regions(buf)
  for _, region in ipairs(regions) do
    local root = region.root
    for i = region.start_i, region.end_i do
      local line = lines[i]
      local paths = find_paths_in_line(line)
      for _, p in ipairs(paths) do
        local abs_path = resolve_path(p.path, root)
        local title = parse_frontmatter_title(abs_path)
        if title then
          api.nvim_buf_set_extmark(buf, ns_id, i - 1, p.end_col, {
            virt_text = { { '   ' .. title, 'Comment' } },
            virt_text_pos = 'inline',
          })
        end
      end
    end
  end
end

local function refresh_all()
  title_cache = {}
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) then
      local ft = vim.bo[buf].filetype
      if ft == 'markdown' or ft == 'yaml' or ft == 'yml' then apply_overlays(buf) end
    end
  end
end

function M.toggle()
  enabled = not enabled
  refresh_all()
  vim.notify('Path titles ' .. (enabled and 'enabled' or 'disabled'))
end

function M.refresh(buf)
  buf = buf or api.nvim_get_current_buf()
  title_cache = {}
  apply_overlays(buf)
end

function M.setup()
  api.nvim_create_autocmd({ 'BufEnter', 'BufRead', 'TextChanged', 'InsertLeave' }, {
    pattern = { '*.md', '*.markdown', '*.yaml', '*.yml' },
    callback = function(args) apply_overlays(args.buf) end,
  })
  api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.md', '*.markdown' },
    callback = function() refresh_all() end,
  })
  vim.keymap.set('n', '\\p', M.toggle, { desc = 'Toggle path titles' })
end

return M
