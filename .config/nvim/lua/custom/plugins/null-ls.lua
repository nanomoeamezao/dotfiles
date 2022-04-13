local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
   b.diagnostics.buf,
   b.formatting.goimports,
   -- b.diagnostics.protoc_gen_lint,
   b.code_actions.refactoring,
   -- webdev stuff
   b.formatting.deno_fmt,
   b.formatting.prettierd.with { filetypes = { "html", "markdown", "css" } },

   -- Lua
   b.formatting.stylua,
   b.diagnostics.luacheck.with { extra_args = { "--global vim" } },

   -- Shell
   b.formatting.shfmt,
   b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

   b.diagnostics.golangci_lint,
}

local M = {}

M.setup = function()
   null_ls.setup {
      debug = false,
      sources = sources,
      debounce = 100,
      -- format on save
      on_attach = function(client)
         if client.resolved_capabilities.document_formatting then
            vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
         end
      end,
   }
end

return M
