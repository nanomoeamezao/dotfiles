local map = nvchad.map
local gs = require "gitsigns"
local ts = require "telescope.builtin"
-- truezen
map("n", "<leader>ta", ":TZAtaraxis <CR>")
map("n", "<leader>tm", ":TZMinimalist <CR>")
map("n", "<leader>tf", ":TZFocus <CR>")
map("n", "<leader>tt", ":Twilight <CR>")
map("n", "gR", "<Plug>ReplaceWithRegisterOperator")

map("n", "ge", function()
   vim.diagnostic.open_float()
end)

map("n", "]d", function()
   vim.diagnostic.goto_next()
end)

-- local git = require "neogit"
-- map("n", "<leader>gg", function()
--    git.open()
-- end)
--
local function bandaid_map(mode, l, r, opts)
   opts = opts or {}
   opts.buffer = bufnr
   vim.keymap.set(mode, l, r, opts)
end

bandaid_map("n", "]c", function()
   if vim.wo.diff then
      return "]c"
   end
   vim.schedule(function()
      gs.next_hunk()
   end)
   return "<Ignore>"
end, { expr = true })

bandaid_map("n", "[c", function()
   if vim.wo.diff then
      return "[c"
   end
   vim.schedule(function()
      gs.prev_hunk()
   end)
   return "<Ignore>"
end, { expr = true })

bandaid_map("n", "<leader>hp", gs.preview_hunk)
bandaid_map("n", "<leader>fr", ts.lsp_references)
vim.keymap.set("n", "<leader>fd", ts.diagnostics)

-- local dap = require "dap"
-- local dapgo = require "dap-go"
-- local dapui = require "dapui"
-- bandaid_map("n", "<F10>", dap.continue)
-- bandaid_map("n", "<F9>", dap.step_over)
-- bandaid_map("n", "<F8>", dap.step_into)
-- bandaid_map("n", "<F7>", dap.toggle_breakpoint)
-- bandaid_map("n", "<F6>", dapgo.debug_test)
-- bandaid_map("n", "<F7>", dap.toggle_breakpoint)
-- bandaid_map("n", "<leader>dt", dapui.toggle)
-- bandaid_map("n", "<leader>de", dapui.eval)
--
local term = require "nvterm.terminal"
map("n", "<F5>", function()
   term.toggle "float"
   term.send("make build GO_BUILD_TAGS=rest,static_ui,noauth && make run", "float")
end)
