local on_attach_lspconfig = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
-- lspservers with default config
local servers = { "gopls", "html", "cssls", "clangd", "emmet_ls", "pylsp", "sumneko_lua" }

local gopls_caps = function()
  local caps = require("cmp_nvim_lsp").default_capabilities()
  caps.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,

    contextSupport = true,
    dynamicRegistration = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }

  return caps
end

local function get_capabilities(name)
  if name == "gopls" then
    return gopls_caps()
  else
    return capabilities
  end
end

-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = get_capabilities(lsp),
    on_attach = function(client, bufnr)
      if lsp == "gopls" then
        on_attach_lspconfig(client, bufnr)
        return
      end
      on_attach_lspconfig(client, bufnr)
    end,
    flags = {
      debounce_text_changes = 100,
    },
    settings = {
      gopls = {
        gofumpt = true,
        directoryFilters = { "-gen", "-docs", "-dist", "-cache", "-tmpbd", "-output" },
        codelenses = { gc_details = false },
        buildFlags = { "-tags", "vault,dbtest" },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        matcher = "Fuzzy",
        diagnosticsDelay = "500ms",
        symbolMatcher = "fuzzy",
        analyses = {
          unreachable = true,
          nilness = true,
          unusedparams = true,
          useany = true,
          unusedwrite = true,
          ST1003 = true,
          undeclaredname = true,
          fillreturns = true,
          nonewvars = true,
          fieldalignment = false,
          shadow = true,
        },
      },
      Lua = {
        -- runtime = {
        --   -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        --   version = "LuaJIT",
        --   -- Setup your lua path
        --   path = runtime_path,
        -- },
        -- diagnostics = {
        --   globals = { "vim" },
        -- },
        -- workspace = {
        --   library = vim.api.nvim_get_runtime_file("", true),
        --   checkThirdParty = false,
        --   maxPreload = 100000,
        --   preloadFileSize = 10000,
        -- },
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  }
end
