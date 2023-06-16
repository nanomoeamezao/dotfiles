local on_attach_lspconfig = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
-- lspservers with default config
local servers = {
  "gopls",
  "html",
  "cssls",
  "clangd",
  "emmet_ls",
  "pylsp",
  "lua_ls",
  "docker_compose_language_service",
  "dockerls",
  -- "groovyls",
}

local gopls_caps = function()
  local caps = require("cmp_nvim_lsp").default_capabilities()
  caps.textDocument.completion = {
    completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,

      preselectSupport = false,
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
    },
    contextSupport = true,
    dynamicRegistration = true,
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
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
          range = true,
        }
        return
      elseif lsp == "dockerls" or lsp == "docker_compose_language_service" then
        on_attach_lspconfig(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
        return
      end
      on_attach_lspconfig(client, bufnr)
    end,
    flags = {
      debounce_text_changes = 100,
    },
    settings = {
      gopls = {
        semanticTokens = true,
        gofumpt = true,
        directoryFilters = { "-gen", "-docs", "-dist", "-cache", "-tmpbd", "-output", "-tmp" },
        codelenses = { gc_details = false },
        buildFlags = { "-tags", "vault,dbtest" },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
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
        completion = {
          callSnippet = "Replace",
        },
        workspace = {
          checkThirdParty = false,
        },
        runtime = {
          version = "LuaJIT",
        },
      },
    },
  }
end
