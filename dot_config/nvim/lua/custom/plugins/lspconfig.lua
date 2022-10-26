local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- lspservers with default config
local servers = { "gopls", "html", "cssls", "clangd", "emmet_ls", "bashls", "sqls", "pylsp" }
-- local servers = { "gopls", "html", "cssls", "clangd", "emmet_ls", "sumneko_lua", "bashls", "sqls" }

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      if lsp == "sqls" then
        on_attach(client, bufnr)
        require("sqls").on_attach(client, bufnr)
        return
      end
      on_attach(client, bufnr)
    end,
    flags = {
      debounce_text_changes = 100,
    },
    settings = {
      gopls = {
        gofumpt = true,
        directoryFilters = { "-gen", "-docs", "-dist", "-tools" },
        codelenses = { gc_details = false },
        buildFlags = { "-tags", "vault,dbtest" },
      },
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  }
end
