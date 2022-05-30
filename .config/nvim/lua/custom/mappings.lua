local M = {}
local gs = require "gitsigns"
local ts = require "telescope.builtin"
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
            ts.lsp_references()
         end,
         "telescope lsp references",
      },
      ["<leader>fd"] = {
         function()
            ts.diagnostics()
         end,
         " telescope lsp diagnostics",
      },
   },
}

M.git = {
   n = {
      ["]c"] = {
         function()
            if vim.wo.diff then
               return "]c"
            end
            vim.schedule(function()
               gs.next_hunk()
            end)
            return "<Ignore>"
         end,
         "next hunk",
      },
      ["[c"] = {
         function()
            if vim.wo.diff then
               return "[c"
            end
            vim.schedule(function()
               gs.prev_hunk()
            end)
            return "<Ignore>"
         end,
      },
      ["<leader>hp"] = {
         function()
            gs.preview_hunk()
         end,
         "preview hunk",
      },
   },
}

local dap = require "dap"
local dapgo = require "dap-go"
local dapui = require "dapui"

M.dap = {
   n = {
      ["<F10>"] = {
         function()
            dap.continue()
         end,
         "dap continue",
      },
      ["<F9>"] = {
         function()
            dap.step_over()
         end,
         "dap step over",
      },
      ["<F8>"] = {
         function()
            dap.step_into()
         end,
         "dap step into",
      },
      ["<F7>"] = {
         function()
            dap.toggle_breakpoint()
         end,
         "dap toggle breakpoint",
      },
      ["<F6>"] = {
         function()
            dapgo.debug_test()
         end,
         "dap debug test",
      },
      ["<leader>de"] = {
         function()
            dapui.eval()
         end,
         "eval under cursor",
      },
      ["<leader>dt"] = {
         function()
            dapui.toggle()
         end,
         "toggle dap ui",
      },
   },
}
M.disabled = {
   n = {
      ["<S-b>"] = "",
      ["gr"] = "",
   },
}
local term = require "nvterm.terminal"
vim.keymap.set("n", "<F5>", function()
   term.toggle "float"
   term.send("make build GO_BUILD_TAGS=rest,static_ui,noauth && make run", "float")
end)

return M
