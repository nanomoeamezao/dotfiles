local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- lspservers with default config
local servers = { "gopls", "html", "cssls", "clangd", "emmet_ls", "sumneko_lua", "bashls" }

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client)
      on_attach(client, bufnr)
      if lsp == "gopls" then
        client.resolved_capabilities.document_formatting = true
        client.resolved_capabilities.document_range_formatting = true
      end
      if lsp == "sumneko_lua" then
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
      end
    end,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 100,
    },
    settings = {
      gopls = {
        gofumpt = true,
        directoryFilters = { "-gen" },
        codelenses = { gc_details = true },
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
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  }
end
