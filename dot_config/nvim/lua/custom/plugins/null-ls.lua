local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end
local b = null_ls.builtins

local sources = {
  -- Proto
  b.diagnostics.buf.with { args = { "lint" } },
  -- b.formatting.buf,

  -- Yaml\json
  b.formatting.prettierd.with { filetypes = { "yaml", "toml", "json" } },
  b.diagnostics.yamllint,
  b.diagnostics.jsonlint,

  b.diagnostics.checkmake,

  -- b.formatting.pg_format,
  b.formatting.sqlfluff.with { extra_args = { "--dialect", "postgres" } },

  -- Lua
  b.formatting.stylua,
  b.diagnostics.luacheck.with { extra_args = { "--global vim" } },
  b.diagnostics.sqlfluff.with { extra_args = { "--dialect", "postgres" } },

  -- Shell
  b.formatting.shfmt,
  -- b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  b.diagnostics.shellcheck,

  -- Go
  b.formatting.gofumpt,
  b.diagnostics.golangci_lint.with {
    args = { "run", "--fix=false", "--out-format=json", "$DIRNAME", "--path-prefix", "$ROOT" },
    extra_args = { "-c", vim.fn.getenv "GOPATH" .. "/utils/.golangci.yml" },
  },

  -- Git
  b.code_actions.gitsigns,
}

local M = {}

local augroup = vim.api.nvim_create_augroup("NullLspFormatting", {})

local on_attach = function(client, bufnr)
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { bufnr = bufnr }
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
