local M = {}
M.setup_lsp = function(attach, capabilities)
   local lspconfig = require "lspconfig"

   -- lspservers with default config
   local servers = { "gopls", "html", "cssls", "bashls", "clangd", "emmet_ls" }

   for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
         on_attach = attach,
         capabilities = capabilities,
         flags = {
            debounce_text_changes = 100,
         },
         settings = {
            gopls = {
               directoryFilters = { "-gen" },
            },
         },
         init_options = {
            usePlaceholders = false,
         },
      }
   end

   -- lua lsp!
   local runtime_path = vim.split(package.path, ";")
   table.insert(runtime_path, "lua/?.lua")
   table.insert(runtime_path, "lua/?/init.lua")
   lspconfig.sumneko_lua.setup {
      on_attach = attach,
      capabilities = capabilities,
      settings = {
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
               library = {
                  vim.api.nvim_get_runtime_file("", true),
               },
               maxPreload = 100000,
               preloadFileSize = 10000,
            },
         },
      },
   }
end

return M
