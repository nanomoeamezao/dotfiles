local vfn = vim.fn
local map = vim.keymap.set
local conf = require("nvconfig").lsp

local lspconfig = require "lspconfig"
local servers = {
  "gopls",
  "pylsp",
  "lua_ls",
  "docker_compose_language_service",
  "dockerls",
  "bashls",
  "jsonls",
  "ts_ls",
}

local on_attach_lspconfig = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "<leader>ra", function()
    require "nvchad.lsp.renamer" ()
  end, opts "NvRenamer")
  -- setup signature popup
  if conf.signature and client.server_capabilities.signatureHelpProvider then
    require("nvchad.lsp.signature").setup(client, bufnr)
  end
end

local range_format = "textDocument/rangeFormatting"
local formatting = "textDocument/formatting"

local gopls_caps = {
  -- go.nvim
  textDocument = {
    completion = {
      completionItem = {
        commitCharactersSupport = true,
        deprecatedSupport = true,
        documentationFormat = { "markdown", "plaintext" },
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        snippetSupport = true,
        resolveSupport = {
          properties = {
            "documentation",
            "details",
            "additionalTextEdits",
          },
        },
      },
      contextSupport = true,
      dynamicRegistration = true,
    },
  },
}

local function get_capabilities(name)
  if name == "gopls" then
    return require("blink.cmp").get_lsp_capabilities(gopls_caps)
  elseif name == "clangd" or name == "ccls" then
    local c = require("blink.cmp").get_lsp_capabilities()
    c.offsetEncoding = { "utf-16" }
    return c
  else
    return require("blink.cmp").get_lsp_capabilities()
  end
end

for _, lsp in ipairs(servers) do
  caps = get_capabilities(lsp)
  lspconfig[lsp].setup {
    capabilities = caps,
    on_attach = function(client, bufnr)
      on_attach_lspconfig(client, bufnr)
      if lsp == "gopls" or lsp == "dockerls" or lsp == "docker_compose_language_service" then
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
        -- vim.lsp.buf.inlay_hint(bufnr, true)
        return
      end
    end,
    flags = {
      debounce_text_changes = 100,
      allow_incremental_sync = true,
    },
    settings = {
      gopls = {
        semanticTokens = true,
        gofumpt = true,
        directoryFilters = { "-gen", "-docs", "-dist", "-cache", "-tmpbd", "-output", "-tmp" },
        codelenses = {
          generate = false,   -- show the `go generate` lens.
          gc_details = false, -- Show a code lens toggling the display of gc's choices.
          test = false,
          tidy = false,
          vendor = false,
          regenerate_cgo = false,
          upgrade_dependency = false,
        },
        buildFlags = { "-tags", "vault,dbtest,file_search_feature,mage" },
        completeUnimported = true,
        staticcheck = true,
        diagnosticsDelay = "500ms",
        analyses = {
          nillness = true,
          unusedparams = true,
          unusedwrite = true,
          unusedvariable = true,
          shadow = true,
          nonewvars = true,
          ST1003 = true,
          undeclaredname = true,
          fillreturns = true,
          useany = true,
        },
      },
    },
    handlers = {
      [range_format] = function(...)
        vim.lsp.handlers[range_format](...)
        if vfn.getbufinfo("%")[1].changed == 1 then
          vim.cmd "noautocmd write"
        end
      end,
      [formatting] = function(...)
        vim.lsp.handlers[formatting](...)
        if vfn.getbufinfo("%")[1].changed == 1 then
          vim.cmd "noautocmd write"
        end
      end,
    },
  }
end
