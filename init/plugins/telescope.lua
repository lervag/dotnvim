local telescope = require 'telescope'
local actions = require 'telescope.actions'

telescope.setup{
  defaults = {
    sorting_strategy = 'ascending',
    preview = {
      hide_on_startup = true,
    },
    layout_strategy = 'center',
    layout_config = {
      width = 0.95,
      height = 0.99,
    },
    file_ignore_patterns = {
      "%.git/",
      "/tags$",
    },
    borderchars = { "═", " ", " ", " ", " ", " ", " ", " " },
    mappings = {
      n = {
        ["q"] = actions.close,
        ["<esc>"] = actions.close,
      },
      i = {
        ["<esc>"] = actions.close,
        ["<C-h>"] = "which_key",
        ["<C-u>"] = false,
        ["<C-x>"] = actions.toggle_selection,
      }
    }
  },
  pickers = {
    find_files = {
      follow = true,
      hidden = true,
      no_ignore = true,
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
    },
  },
  extensions = {
    fzf = {
      case_mode = "smart_case",
      fuzzy = false,
      override_file_sorter = true,
      override_generic_sorter = true,
    },
    frecency = {
      show_scores = true,
      ignore_patterns = {
        "*.git/*",
        "*/tmp/*",
        "*.cache/*",
        "*.local/wiki/*",
        "*.config/nvim/*",
      },
    }
  }
}

telescope.load_extension('fzf')
telescope.load_extension('frecency')


local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader><leader>', telescope.extensions.frecency.frecency)
vim.keymap.set('n', '<leader>ot', builtin.tags)
vim.keymap.set('n', '<leader>ob', builtin.buffers)
vim.keymap.set('n', '<leader>og', builtin.git_files)

local mine = require 'init.telescope'
vim.keymap.set('n', '<leader>ev', mine.files_nvim)
vim.keymap.set('n', '<leader>oo', mine.files)
vim.keymap.set('n', '<leader>op', mine.files_plugged)
vim.keymap.set('n', '<leader>ow', mine.files_wiki)
vim.keymap.set('n', '<leader>oz', mine.files_zotero)
