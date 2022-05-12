require "custom.mappings"
require "custom.autochad_cmds"

vim.g.neovide_cursor_animation_length = 0.03
vim.g.neovide_cursor_trail_length = 0.05

vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.laststatus = 3
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true, noremap = true })
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
}

vim.cmd [[
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
]]
--
-- local dap, dapui = require "dap", require "dapui"
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--    dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--    dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--    dapui.close()
-- end
--
vim.cmd [[
let g:lightspeed_last_motion = ''
    augroup lightspeed_last_motion
    autocmd!
    autocmd User LightspeedSxEnter let g:lightspeed_last_motion = 'sx'
    autocmd User LightspeedFtEnter let g:lightspeed_last_motion = 'ft'
    augroup end
    map <expr> ; g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"
]]
