local M = {}
-- truezen
M.truezen = {
   n = {
      ["<leader>ta"] = { "<cmd> TZAtaraxis <CR>", "   truzen ataraxis" },
      ["<leader>tm"] = { "<cmd> TZMinimalist <CR>", "   truzen minimal" },
      ["<leader>tf"] = { "<cmd> TZFocus <CR>", "   truzen focus" },
   },
}

M.replace = {
   n = {
      ["gr"] = { "<Plug>ReplaceWithRegisterOperator", "replace with register" },
   },
}

M.telescope = {
   n = {
      ["<leader>gb"] = { "<cmd> Telescope git_branches <CR>", "list git branches" },
      ["<leader>gf"] = { "<cmd> Telescope git_files <CR>", "list git files" },
      ["<leader>ft"] = { "<cmd> TodoTelescope <CR>", "telescope for todo items" },
   },
}
M.lsp = {
   n = {
      ["ge"] = {
         function()
            vim.diagnostic.open_float()
         end,
         "open lsp float",
      },
      ["<leader>fr"] = {
         function()
            require("telescope.builtin").lsp_references()
         end,
         "telescope lsp references",
      },
      ["<leader>fd"] = {
         function()
            require("telescope.builtin").diagnostics()
         end,
         " telescope lsp diagnostics",
      },
      ["[d"] = {
         function()
            vim.lsp.diagnostic.goto_prev()
         end,
         "lsp next diagnostic",
      },
      ["]d"] = {
         function()
            vim.lsp.diagnostic.goto_next()
         end,
         "lsp next diagnostic",
      },
      ["<leader>m"] = {
         function()
            vim.lsp.stop_client(vim.lsp.get_active_clients())
         end,
         "stop all lsp clients",
      },
      ["<leader>ca"] = {
         function()
            vim.lsp.buf.code_action()
         end,
         "code action",
      },
      ["<leader>cs"] = {
         function()
            require("telescope").extensions.luasnip.luasnip {}
         end,
         "list snippets",
      },
      ["gd"] = {
         function()
            require("telescope.builtin").lsp_definitions {}
         end,
         "lsp definition",
      },
   },
   v = {
      ["<leader>ca"] = { "<cmd> '<,'> lua vim.lsp.buf.range_code_action()<CR>", "range code actions" },
   },
}

M.git = {
   n = {
      ["<leader>hp"] = {
         function()
            require("gitsigns").preview_hunk()
         end,
         "preview hunk",
      },
   },
}

vim.keymap.set("n", "]c", function()
   if vim.wo.diff then
      return "]c"
   end
   vim.schedule(function()
      require("gitsigns").next_hunk()
   end)
   return "<Ignore>"
end, { expr = true })

vim.keymap.set("n", "[c", function()
   if vim.wo.diff then
      return "[c"
   end
   vim.schedule(function()
      require("gitsigns").prev_hunk()
   end)
   return "<Ignore>"
end, { expr = true })

M.dap = {
   n = {
      ["<F10>"] = {
         function()
            require("dap").continue()
         end,
         "dap continue",
      },
      ["<F9>"] = {
         function()
            require("dap").step_over()
         end,
         "dap step over",
      },
      ["<F8>"] = {
         function()
            require("dap").step_into()
         end,
         "dap step into",
      },
      ["<F7>"] = {
         function()
            require("dap").toggle_breakpoint()
         end,
         "dap toggle breakpoint",
      },
      ["<F6>"] = {
         function()
            require("dap-go").debug_test()
         end,
         "dap debug test",
      },
      ["<leader>de"] = {
         function()
            require("dapui").eval()
         end,
         "eval under cursor",
      },
      ["<leader>dt"] = {
         function()
            require("dapui").toggle()
         end,
         "toggle dap ui",
      },
      ["<leader>db"] = {
         function()
            require("telescope").extensions.dap.list_breakpoints {}
         end,
         "list breakpoints",
      },
      ["<leader>dv"] = {
         function()
            require("telescope").extensions.dap.variables {}
         end,
         "list variables",
      },
   },
}

M.general = {
   n = {
      ["<leader><S-x>"] = { "<cmd> %bdel! <CR>", "close all buffers" },
   },
}

M.disabled = {
   n = {
      ["<S-b>"] = "",
      ["gr"] = "",
      ["v"] = "",
   },
}
vim.keymap.set("n", "<F5>", function()
   require("nvterm.terminal").toggle "float"
   require("nvterm.terminal").send("make build GO_BUILD_TAGS=rest,static_ui,noauth && make run", "float")
end)

return M
