require "nvchad.mappings"


local map = vim.keymap.set
local nomap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "gr", "<Plug>ReplaceWithRegisterOperator", { desc = "replace with register" })
map("n", "<leader>gb", "<cmd> Telescope git_branches <CR>", { desc = "list git branches" })
map("n", "<leader>gf", "<cmd> Telescope git_files <CR>", { desc = "list git files" })
map("n", "<leader>ft", "<cmd> TodoTelescope <CR>", { desc = "telescope for todo items" })
map("n", "<leader>fo", function()
  require("telescope").extensions.smart_open.smart_open()
end, { desc = "open latest files" })
map("n", "<leader>fg", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end)
map("n", "<leader>f.", "<cmd> Telescope resume<cr>")
map("n", "ge", function()
  vim.diagnostic.open_float()
end)
map("n", "<leader>fr", function()
  require("telescope.builtin").lsp_references()
end)
map("n", "<leader>m", function()
  vim.lsp.stop_client(vim.lsp.get_clients())
end)
map("n", "<leader>cs", function()
  require("telescope").extensions.luasnip.luasnip {}
end)
map("n", "gd", function()
  require("telescope.builtin").lsp_definitions {}
end)
map("n", "gi", function()
  require("telescope.builtin").lsp_implementations {}
end)
map("n", "<leader>gT", function()
  require("telescope.builtin").lsp_type_definitions {}
end)
map("n", "<leader>co", function()
  vim.lsp.buf.code_action {
    filter = function(a)
      return a.title == "Organize Imports"
    end,
    apply = true,
  }
end)
map("n", "<leader>cu", function()
  require("symbol-usage").toggle_globally()
end)
map("v", "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "range code actions" })

map("n", "gD", vim.lsp.buf.declaration)
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>sh", vim.lsp.buf.signature_help)
map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)

map("n", "<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end)

map("n", "<leader>D", vim.lsp.buf.type_definition)
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)

map("n", "<leader>hp", function()
  require("gitsigns").preview_hunk()
end, { desc = "preview hunk" })
map("n", "<leader>cc", "<cmd>G commit -a<CR>", { desc = "commit all changes" })
map("n", "<leader>cp", "<cmd>G push<CR>", { desc = "git push" })

map("n", "<F10>", "<cmd> DapContinue <CR>", { desc = "dap continue" })
map("n", "<F9>", function()
  require("dap").step_over()
end, { desc = "dap step over" })
map("n", "<F8>", function()
  require("dap").step_into()
end, { desc = "dap step into" })
map("n", "<F7>", "<cmd> DapToggleBreakpoin <CR>", { desc = "dap toggle breakpoint" })
map("n", "<leader>dB", function()
  require("dap").toggle_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "dap toggle breakpoint with condition" })
map("n", "<F6>", function()
  require("dap-go").debug_test()
end, { desc = "dap debug test" })
map("n", "<leader>de", function()
  require("dapui").eval()
end, { desc = "eval under cursor" })
map("n", "<leader>dt", function()
  require("dapui").toggle {}
end, { desc = "toggle dap ui" })
map("n", "<leader>db", function()
  require("telescope").extensions.dap.list_breakpoints {}
end, { desc = "list breakpoints" })
map("n", "<leader>dv", function()
  require("telescope").extensions.dap.variables {}
end, { desc = "list variables" })

map("n", "<F1>", function()
  require("neotest").run.run { enter = true }
end, { desc = "run nearest test" })
map("n", "<F2>", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "run test in current file" })
map("n", "<F3>", function()
  require("neotest").summary.toggle()
end, { desc = "open test summary" })
map("n", "<F4>", function()
  require("neotest").output.open { enter = true }
end, { desc = "run last test" })

map("n", "<leader><S-x>", "<cmd> %bdel! <CR>", { desc = "close all buffers" })
map("n", "<C-ы>", "<cmd> w <CR>")
map("n", "<C-в>", "<C-d>")
map("n", "]q", "<cmd>cn<CR>")

map("n", "tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Goto next buffer" })
map("n", "S-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Goto prev buffer" })
map("n", "<leader>x", "<cmd>bdelete!<CR>", { desc = "Close buffer" })
map("n", "]c", function()
  require("gitsigns").next_hunk()
end, { desc = "go to next change hunk" })
map("n", "[c", function()
  require("gitsigns").prev_hunk()
end, { desc = "go to prev change hunk" })

map("n", "<leader>ha", function()
  require("harpoon"):list():add()
end, { desc = "Add harpoon mark" })

map("n", "<leader>hr", function()
  require("harpoon"):list():remove()
end, { desc = "Remove harpoon mark" })

map("n", "<leader>hn", function()
  require("harpoon"):list():next()
end, { desc = "Go to next harpoon mark" })
map("n", "<leader>hp", function()
  require("harpoon"):list():prev()
end, { desc = "Go to previous harpoon mark" })
local function toggle_telescope(harpoon_files)
  local conf = require("telescope.config").values
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
      .new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table {
          results = file_paths,
        },
        previewer = conf.file_previewer {},
        sorter = conf.generic_sorter {},
      })
      :find()
end

map("n", "<leader>fh", function()
  toggle_telescope(require("harpoon"):list())
end)

-- load the session for the current directory
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end)
-- select a session to load
vim.keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end)
-- load the last session
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load { last = true }
end)
-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end)

-- nomap("n", "<S-b>")
nomap("n", "<tab>")
nomap("n", "<S-tab>")
nomap("n", "<A-h>")
nomap("n", "<A-v>")
nomap("n", "<A-i>")
nomap("n", ";")
nomap("n", "<leader>h")
-- nomap("n", "<C-i>")
--

