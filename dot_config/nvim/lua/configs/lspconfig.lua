local vfn = vim.fn
local map = vim.keymap.set

dofile(vim.g.base46_cache .. "lsp")
require("nvchad.lsp").diagnostic_config()

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

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "<leader>ra", require "nvchad.lsp.renamer", opts "NvRenamer")
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
            "edit",
            "documentation",
            "details",
            "additionalTextEdits",
          },
        },
      },
      completionList = {
        itemDefaults = {
          "editRange",
          "insertTextFormat",
          "insertTextMode",
          "data",
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
  local caps = get_capabilities(lsp)
  vim.lsp.config(lsp, {
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
        buildFlags = { "-tags", "se,vault,dbtest,file_search_feature,mage,licensing" },
        completeUnimported = true,
        staticcheck = true,
        diagnosticsDelay = "500ms",
        analyses = {
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
  })
  vim.lsp.enable(lsp)
end
