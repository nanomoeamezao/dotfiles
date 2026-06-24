local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  -- b.formatting.buf,

  -- b.formatting.prettierd,
  -- b.formatting.pg_format,
  b.formatting.sqruff,

  -- Lua
  b.formatting.stylua.with { extra_args = { "--respect-ignores" } },

  -- Shell
  b.formatting.shfmt,

  -- Go
  -- b.formatting.gofumpt,
  -- b.formatting.goimports_reviser.with {
  --   args = { "-company-prefixes", "gitlab.etecs.ru/polygon", "$FILENAME" },
  -- },
  -- b.formatting.goimports,

  -- Git
  b.code_actions.gitsigns,
}

local M = {}

local ignore_ft = { "git", "gitcommit" }
local lsp_formatting = function(bufnr)
  if vim.tbl_contains(ignore_ft, vim.bo[bufnr].filetype) then
    return
  end
  vim.lsp.buf.format {
    bufnr = bufnr,
  }
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- add to your shared on_attach callback
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
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
    debug = true,
    sources = sources,
    debounce = 100,
    default_timeout = 5000000,
    -- format on save
    on_attach = on_attach,
  }
end

return M
