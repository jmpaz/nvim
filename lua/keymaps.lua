vim.g.maplocalleader = ','

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
-- Disable default vertical and horizontal split keymaps
vim.keymap.set('n', '<C-w>v', '<nop>', { desc = 'Disable default vertical split' })
vim.keymap.set('n', '<C-w>s', '<nop>', { desc = 'Disable default horizontal split' })
--
-- Create new splits
vim.keymap.set('n', '<C-w>|', '<cmd>vsplit<CR>', { desc = 'Create a vertical split' })
vim.keymap.set('n', '<C-w>-', '<cmd>split<CR>', { desc = 'Create a horizontal split' })

-- Tabs
vim.keymap.set('n', '<C-w>t', '<cmd>tab split<CR>', { desc = 'Open in new tab' }) -- pairs with <C-w>T
vim.keymap.set('n', '<C-Left>', '<cmd>tabprevious<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', '<C-Right>', '<cmd>tabnext<CR>', { desc = 'Go to next tab' })
vim.keymap.set('n', '<C-t>n', '<cmd>tabnew<CR>', { desc = 'Create new tab' })
vim.keymap.set('n', '<C-t>x', '<cmd>tabclose<CR>', { desc = 'Close tab' })

-- [[ Autocommands ]]
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
