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
    ["<leader>fn"] = { "<cmd> Telescope neorg find_linkable<cr>" },
    ["<leader>fN"] = { "<cmd> Telescope neorg search_headings<cr>" },
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
      -- function()
      -- require("telescope.builtin").diagnostics()
      -- end,
      "<cmd>Trouble workspace_diagnostics<cr>",
      " telescope lsp diagnostics",
    },
    ["[d"] = {
      function()
        vim.diagnostic.goto_prev { wrap = true, float = true }
      end,
      "lsp next diagnostic",
    },
    ["]d"] = {
      function()
        vim.diagnostic.goto_next { wrap = true, float = true }
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
    ["gi"] = {
      function()
        require("telescope.builtin").lsp_implementations {}
      end,
      "lsp implementations",
    },
    ["<leader>gT"] = {
      function()
        require("telescope.builtin").lsp_type_definitions {}
      end,
      "lsp type definitions",
    },
    ["<leader>la"] = {
      "<cmd> AerialToggle <cr>",
    },
  },
  v = {
    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "range code actions",
    },
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
    -- ["<leader>cm"] = {
    --   function()
    --     require("custom.misc").delta_commits()
    --   end,
    --   "delta git commits",
    -- },
    -- ["do"] = {
    --   "<cmd> diffget //2 <CR>",
    --   "get diff from left (local)",
    -- },
    -- ["dO"] = {
    --   "<cmd> diffget //3 <CR>",
    --   "get diff from right (remote)",
    -- },
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
      -- function()
      --   require("dap").continue()
      -- end,
      "<cmd> DapContinue <CR>",
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
      "<cmd> DapToggleBreakpoin <CR>",
      "dap toggle breakpoint",
    },
    ["<leader>dB"] = {
      function()
        require("dap").toggle_breakpoint(vim.fn.input "Breakpoint condition: ")
      end,
      "dap toggle breakpoint with condition",
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
        require("dapui").toggle {}
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

M.test = {
  n = {
    ["<F1>"] = {
      function()
        require("neotest").run.run { enter = true }
      end,
      "run nearest test",
    },
    ["<F2>"] = {
      function()
        require("neotest").run.run(vim.fn.expand "%")
      end,
      "run test in current file",
    },
    ["<F3>"] = {
      function()
        require("neotest").summary.toggle()
      end,
      "open test summary",
    },
    ["<F4>"] = {
      function()
        require("neotest").output.open { enter = true }
      end,
      "run last test",
    },
  },
}

M.general = {
  n = {
    ["<leader><S-x>"] = { "<cmd> %bdel! <CR>", "close all buffers" },
    ["<C-ы>"] = { "<cmd> w <CR>" },
    ["<leader>dl"] = {
      function()
        local nvim_docker = require "nvim-docker"
        nvim_docker.containers.list_containers()
      end,
    },
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
