local opt = vim.opt
local g = vim.g

opt.termguicolors = true

-- opt.tabstop = 4
opt.timeoutlen = 400

g.markdown_folding = 1

g.neovide_cursor_animation_length = 0
g.neovide_cursor_trail_length = 0
g.neovide_refresh_rate = 60
opt.guifont = "UbuntuMono Nerd Font:h11"

opt.spelllang = "en,ru"

opt.swapfile = false
opt.number = true
opt.relativenumber = true

opt.langmap =
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

-- HIGHLIGHT ON YANK
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = 300,
    }
  end,
})

-- HIGHLIGHT LSP SYMBOL
-- vim.api.nvim_create_augroup("dochl", { clear = true })
-- local hlfun = function()
--   vim.lsp.for_each_buffer_client(0, function(client)
--     if client.resolved_capabilities.document_highlight then
--       vim.lsp.buf.document_highlight()
--     end
--   end)
-- end
-- local clearfun = function()
--   vim.lsp.buf.clear_references()
-- end
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, { callback = hlfun })
-- vim.api.nvim_create_autocmd({ "CursorMoved" }, { callback = clearfun })
