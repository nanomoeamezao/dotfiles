require "nvchad.options"

local opt = vim.opt
local g = vim.g

opt.timeoutlen = 400
opt.clipboard = ""
opt.title = true
opt.relativenumber = true
opt.cmdheight = 0
-- opt.statusline = ""

g.vscode_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/json"

g.markdown_folding = 1
g.neovide_cursor_animation_length = 0
g.neovide_cursor_trail_length = 0
g.neovide_refresh_rate = 60
opt.guifont = "JetBrainsMono Nerd Font:h14"
opt.spelllang = "en,ru"
opt.swapfile = false
opt.completeopt = { "menuone", "noselect" }
opt.smoothscroll = true

vim.cmd "set diffopt+=linematch:50"

opt.langmap =
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
vim.cmd [[command! Glint         :setl makeprg=golangci-lint\ run\ --print-issued-lines=false\ --sort-results\ --max-issues-per-linter=0\ --max-same-issues=0 | :GoMake]]
vim.cmd [[autocmd FileType sql xmap <expr> <C-M> db#op_exec()]]
-- o.cursorlineopt ='both' -- to enable cursorline!
