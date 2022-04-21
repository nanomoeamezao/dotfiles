vim.api.nvim_command [[
autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=300}
]]

vim.cmd [[
hi LspRef guibg=#333842
hi link LspReferenceText  LspRef
hi link LspReferenceRead LspRef
hi link LspReferenceWrite LspRef
    autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
]]
