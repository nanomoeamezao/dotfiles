return {
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "html",
    "python",
    "css",
    "go",
    "gomod",
    "javascript",
    "json",
    "toml",
    "markdown",
    "c",
    "bash",
    "regex",
    "gitignore",
    "dockerfile",
    "comment",
    "yaml",
    "sql",
    "norg",
    "dockerfile",
  },
  highlight = { enable = true },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 2000,
  },
  autotag = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = { "yaml", "python", "c", "cpp" },
  },
}
