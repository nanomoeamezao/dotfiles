local glci = require("lint").linters.golangcilint
glci.cmd = vim.fn.getenv "GOPATH" .. "/scanner/.tool/custom-gcl"
glci.args = {
  "run",
  "--output.json.path=stdout",
  -- Overwrite values possibly set in .golangci.yml
  "--output.text.path=",
  "--output.tab.path=",
  "--output.html.path=",
  "--output.checkstyle.path=",
  "--output.code-climate.path=",
  "--output.junit-xml.path=",
  "--output.teamcity.path=",
  "--output.sarif.path=",
  "--issues-exit-code=0",
  "--show-stats=false",
  -- Get absolute path of the linted file
  "--path-mode=abs",
  "--tests=false",
  "--fix=false",
  "--disable=nilaway",
  function()
    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
  end,
}
require("lint").linters_by_ft = {
  sh = { "shellcheck" },
  css = { "stylelint" },
  yaml = { "yamllint" },
  lua = { "selene" },
  go = { "golangcilint" },
  sql = { "sqlfluff" },
}
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("lint", { clear = true }),
  callback = function()
    -- local final_args = {}
    -- for _, v in ipairs(glci.args) do
    --   if type(v) == "function" then
    --     table.insert(final_args, v())
    --   else
    --     table.insert(final_args, v)
    --   end
    -- end
    -- vim.print(glci.cmd .. " " .. table.concat(final_args, " "))
    require("lint").try_lint()
  end,
})
