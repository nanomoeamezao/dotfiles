local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  -- Proto
  b.diagnostics.buf.with { args = { "lint" } },
  -- b.formatting.buf,

  -- Yaml\json
  b.formatting.prettierd,
  b.diagnostics.yamllint,
  b.diagnostics.jsonlint,

  b.diagnostics.checkmake,

  -- b.formatting.pg_format,
  b.formatting.sqlfluff.with { extra_args = { "--dialect", "postgres" } },

  -- Lua
  b.formatting.stylua,
  b.diagnostics.luacheck,
  b.diagnostics.sqlfluff.with { extra_args = { "--dialect", "postgres" } },

  -- Shell
  b.formatting.shfmt,
  -- b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  b.diagnostics.shellcheck,

  -- Go
  b.formatting.gofumpt,
  b.formatting.goimports,
  b.diagnostics.golangci_lint.with {
    args = { "run", "--fix=false", "--out-format=json", "$DIRNAME", "--path-prefix", "$ROOT" },
    extra_args = { "-c", vim.fn.getenv "GOPATH" .. "/utils/.golangci.yml" },
  },

  -- Git
  b.code_actions.gitsigns,
  -- b.diagnostics.commitlint,
}

local M = {}

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    filter = function(client)
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      return client.name == "null-ls"
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
    debug = true,
    sources = sources,
    debounce = 100,
    -- format on save
    on_attach = on_attach,
  }
end

return M
