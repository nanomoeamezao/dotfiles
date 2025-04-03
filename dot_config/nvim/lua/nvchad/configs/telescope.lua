dofile(vim.g.base46_cache .. "telescope")

return {
  extensions = {
    smart_open = {
      show_scores = false,
      ignore_patterns = { "*.git/*", "*/tmp/*" },
      match_algorithm = "fzf",
      disable_devicons = false,
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
    },
  },
  pickers = {
    lsp_references = { show_line = false },
    buffers = {
      mappings = {
        n = {
          ["<c-x>"] = require("telescope.actions").delete_buffer,
        },
      },
    },
  },
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },

  extensions_list = { "themes", "terms", "fzf" },
}
