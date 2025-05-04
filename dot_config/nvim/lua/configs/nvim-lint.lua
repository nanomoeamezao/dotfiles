local glci = require("lint").linters.golangcilint
glci.cmd = vim.fn.getenv "GOPATH" .. "/scanner/.tool/golangci-lint"
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
  "--output.text.print-issued-lines=false",
  "--build-tags=production,dbtest,se,sqlite",
  "--config=" .. vim.fn.getenv "GOPATH" .. "/scanner/.golangci.yml",
  "--tests=false",
  "--show-stats=false",
  "--max-issues-per-linter=0",
  "--max-same-issues=0",
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
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})
