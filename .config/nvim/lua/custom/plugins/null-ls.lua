local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
   b.diagnostics.buf,
   -- b.formatting.buf,
   b.diagnostics.yamllint,
   b.formatting.prettierd,
   b.formatting.golines.with { extra_args = { "-m", "150" } },
   b.formatting.pg_format,

   -- Lua
   b.formatting.stylua,
   b.diagnostics.luacheck.with { extra_args = { "--global vim" } },

   -- Shell
   b.formatting.shfmt,
   b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

   b.diagnostics.golangci_lint.with { extra_args = { "-c", "~/code/testing_images/.golangci.yml" } },
}

local M = {}

local lsp_formatting = function(bufnr)
   vim.lsp.buf.formatting_sync {
      filter = function(clients)
         -- filter out clients that you don't want to use
         return vim.tbl_filter(function(client)
            return client.name ~= "buf"
         end, clients)
      end,
      bufnr = bufnr,
   }
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- add to your shared on_attach callback
local on_attach = function(client, bufnr)
   if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
         group = augroup,
         buffer = bufnr,
         callback = function()
            lsp_formatting(bufnr)
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
