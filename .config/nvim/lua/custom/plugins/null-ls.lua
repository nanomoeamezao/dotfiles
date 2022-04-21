local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
   b.diagnostics.buf,
   b.formatting.golines.with { extra_args = { "-m", "150" } },
   b.formatting.pg_format,

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
      debug = true,
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
