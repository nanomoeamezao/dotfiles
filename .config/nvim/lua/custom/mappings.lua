local map = require("core.utils").map

-- telescope
map("n", "<leader>fp", ":Telescope media_files <CR>")
map("n", "<leader>te", ":Telescope <CR>")

-- truezen
map("n", "<leader>ta", ":TZAtaraxis <CR>")
map("n", "<leader>tm", ":TZMinimalist <CR>")
map("n", "<leader>tf", ":TZFocus <CR>")
map("n", "<leader>tt", ":Twilight <CR>")
local gs = require "gitsigns"
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
-- map("n", "gR", "<cmd>lua vim.lsp.buf.references()<CR>")
