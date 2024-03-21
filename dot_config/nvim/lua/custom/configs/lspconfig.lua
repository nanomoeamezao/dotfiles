local on_attach_lspconfig = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
-- lspservers with default config
local servers = {
  "gopls",
  "html",
  "cssls",
  "ccls",
  "emmet_ls",
  "pylsp",
  "lua_ls",
  "docker_compose_language_service",
  "dockerls",
  "jdtls",
  "bashls",
  "jsonls",
  -- "groovyls",
}
local range_format = "textDocument/rangeFormatting"
local formatting = "textDocument/formatting"

local gopls_caps = function()
  return vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities(), {
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
    workspace = {
      -- PERF: didChangeWatchedFiles is too slow.
      -- TODO: Remove this when https://github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed.
      didChangeWatchedFiles = { dynamicRegistration = false },
    },
  })
end

local function get_capabilities(name)
  if name == "gopls" then
    return gopls_caps()
  elseif name == "clangd" or name == "ccls" then
    capabilities.offsetEncoding = { "utf-16" }
    return capabilities
  else
    return capabilities
  end
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = get_capabilities(lsp),
    on_attach = function(client, bufnr)
      if lsp == "gopls" then
        on_attach_lspconfig(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
        -- vim.lsp.buf.inlay_hint(bufnr, true)
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
      allow_incremental_sync = true,
    },
    settings = {
      gopls = {
        semanticTokens = true,
        gofumpt = true,
        directoryFilters = { "-gen", "-docs", "-dist", "-cache", "-tmpbd", "-output", "-tmp" },
        codelenses = {
          generate = true,   -- show the `go generate` lens.
          gc_details = true, -- Show a code lens toggling the display of gc's choices.
          test = true,
          tidy = true,
          vendor = true,
          regenerate_cgo = true,
          upgrade_dependency = true,
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

local watch_type = require("vim._watch").FileChangeType

local function handler(res, callback)
  if not res.files or res.is_fresh_instance then
    return
  end

  for _, file in ipairs(res.files) do
    local path = res.root .. "/" .. file.name
    local change = watch_type.Changed
    if file.new then
      change = watch_type.Created
    end
    if not file.exists then
      change = watch_type.Deleted
    end
    callback(path, change)
  end
end

function watchman(path, opts, callback)
  vim.system({ "watchman", "watch", path }):wait()

  local buf = {}
  local sub = vim.system({
    "watchman",
    "-j",
    "--server-encoding=json",
    "-p",
  }, {
    stdin = vim.json.encode {
      "subscribe",
      path,
      "nvim:" .. path,
      {
        expression = { "anyof", { "type", "f" }, { "type", "d" } },
        fields = { "name", "exists", "new" },
      },
    },
    stdout = function(_, data)
      if not data then
        return
      end
      for line in vim.gsplit(data, "\n", { plain = true, trimempty = true }) do
        table.insert(buf, line)
        if line == "}" then
          local res = vim.json.decode(table.concat(buf))
          handler(res, callback)
          buf = {}
        end
      end
    end,
    text = true,
  })

  return function()
    sub:kill "sigint"
  end
end

if vim.fn.executable "watchman" == 1 then
  require("vim.lsp._watchfiles")._watchfunc = watchman
end
