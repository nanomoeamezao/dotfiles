local opt = vim.opt
local g = vim.g

opt.termguicolors = true

-- opt.tabstop = 4
opt.timeoutlen = 400
opt.clipboard = ""
opt.title = true
opt.relativenumber = true

g.markdown_folding = 1
g.neovide_cursor_animation_length = 0
g.neovide_cursor_trail_length = 0
g.neovide_refresh_rate = 60
opt.guifont = "JetBrainsMono Nerd Font:h9"
opt.spelllang = "en,ru"
opt.swapfile = false
opt.completeopt = { "menuone", "noselect" }

vim.cmd "set diffopt+=linematch:50"

opt.langmap =
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
