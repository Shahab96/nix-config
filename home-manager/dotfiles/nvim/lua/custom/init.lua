vim.g.maplocalleader = ","
vim.opt.colorcolumn = "80"
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-o>", 'copilot#Accept("<CR>")', { silent = true, expr = true, noremap = true, script = true })
vim.wo.relativenumber = true
vim.g.scrolloff = 8
