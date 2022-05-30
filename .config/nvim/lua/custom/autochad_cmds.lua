vim.cmd [[
autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch' or 'LspReferenceText' or 'LspReferenceWrite' or 'LspReferenceRead'), timeout=300}
]]

-- vim.cmd [[
--     hi LspRef guibg=#333842
--     hi link LspReferenceText  LspRef
--     hi link LspReferenceRead LspRef
--     hi link LspReferenceWrite LspRef
-- ]]
vim.api.nvim_create_augroup("dochl", { clear = true })
local hlfun = function()
   vim.lsp.for_each_buffer_client(0, function(client)
      if client.resolved_capabilities.document_highlight then
         vim.lsp.buf.document_highlight()
      end
   end)
end
local clearfun = function()
   vim.lsp.buf.clear_references()
end
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, { callback = hlfun })
vim.api.nvim_create_autocmd({ "CursorMoved" }, { callback = clearfun })
