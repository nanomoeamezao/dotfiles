local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
   b.diagnostics.buf.with { args = { "lint" } },
   b.formatting.buf,
   b.diagnostics.yamllint,
   b.diagnostics.checkmake,
   b.formatting.prettierd.with { filetypes = { "yaml", "toml" } },
   -- b.formatting.pg_format,
   b.formatting.sqlfluff.with { extra_args = { "--dialect", "postgres" } },

   -- Lua
   b.formatting.stylua,
   b.diagnostics.luacheck.with { extra_args = { "--global vim" } },
   b.diagnostics.sqlfluff.with { extra_args = { "--dialect", "postgres" } },

   -- Shell
   -- b.formatting.shfmt,
   -- b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

   b.diagnostics.golangci_lint.with { extra_args = { "-c", "~/code/testing_images/.golangci.yml" } },
   b.code_actions.gitsigns,
}

local M = {}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
   if client.resolved_capabilities.document_formatting then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
         group = augroup,
         buffer = bufnr,
         callback = function()
            vim.lsp.buf.formatting_sync()
         end,
      })
   end
end

M.setup = function()
   null_ls.setup {
      debug = false,
      sources = sources,
      debounce = 100,
      -- format on save
      on_attach = on_attach,
   }
end

return M
