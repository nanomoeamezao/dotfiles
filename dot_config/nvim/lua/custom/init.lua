local opt = vim.opt
local g = vim.g

opt.timeoutlen = 400
opt.clipboard = ""
opt.title = true
opt.relativenumber = true
opt.cmdheight = 0
opt.statusline = ""

g.vscode_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/json"

g.markdown_folding = 1
g.neovide_cursor_animation_length = 0
g.neovide_cursor_trail_length = 0
g.neovide_refresh_rate = 60
opt.guifont = "JetBrainsMono Nerd Font:h14"
opt.spelllang = "en,ru"
opt.swapfile = false
opt.completeopt = { "menuone", "noselect" }

vim.cmd "set diffopt+=linematch:50"

opt.langmap =
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
-- local my_group = api.nvim_create_augroup("my_group", { clear = true })
-- Prevent entering buffers in insert mode.
-- https://github.com/nvim-telescope/telescope.nvim/issues/2027
-- au("WinLeave", {
--   group = my_group,
--   callback = function()
--     if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
--     end
--   end,
-- })

vim.cmd [[command! Glint         :setl makeprg=golangci-lint\ run\ --print-issued-lines=false\ --sort-results\ --max-issues-per-linter=0\ --max-same-issues=0 | :GoMake]]
