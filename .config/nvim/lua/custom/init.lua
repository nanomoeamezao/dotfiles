require "custom.autochad_cmds"

vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_trail_length = 0

vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.laststatus = 3
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = {
   ["*"] = false,
   ["javascript"] = true,
   ["typescript"] = true,
   ["lua"] = false,
   ["rust"] = true,
   ["c"] = true,
   ["c#"] = true,
   ["c++"] = true,
   ["go"] = true,
   ["python"] = true,
   ["sql"] = false,
}

vim.cmd [[
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
]]
