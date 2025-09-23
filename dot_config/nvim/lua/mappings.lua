local map = vim.keymap.set

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })

map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

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
  require("telescope.builtin").lsp_references {}
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

map("n", "<leader>x", "<cmd>bdelete!<CR>", { desc = "Close buffer" })
map("n", "]c", function()
  require("gitsigns").nav_hunk "next"
end, { desc = "go to next change hunk" })
map("n", "[c", function()
  require("gitsigns").nav_hunk "prev"
end, { desc = "go to prev change hunk" })

map("n", "<leader>hp", function()
  require("gitsigns").preview_hunk()
end, { desc = "preview hunk" })

map("n", "<leader>cd", function()
  require("gitsigns").diffthis()
end, { desc = "diffthis file" })

map("n", "<leader>ha", function()
  require("harpoon"):list():add()
end, { desc = "Add harpoon mark" })

map("n", "<leader>hr", function()
  require("harpoon"):list():remove()
end, { desc = "Remove harpoon mark" })

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

map("n", "<leader>hl", function()
  require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end)

-- load the session for the current directory
map("n", "<leader>qs", function()
  require("persistence").load()
end)
-- select a session to load
map("n", "<leader>qS", function()
  require("persistence").select()
end)
-- load the last session
map("n", "<leader>ql", function()
  require("persistence").load { last = true }
end)
-- stop Persistence => session won't be saved on exit
map("n", "<leader>qd", function()
  require("persistence").stop()
end)

map("n", "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", { desc = "View git history for current file" })
map("n", "<leader>do", "<cmd>DiffviewOpen<cr>", { desc = "View modified files" })
map("n", "<leader>dc", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
