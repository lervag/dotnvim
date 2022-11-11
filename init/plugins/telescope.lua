local telescope = require 'telescope'
local actions = require'telescope.actions'

-- https://github.com/nvim-telescope/telescope.nvim/issues/559
local function stopinsert(callback)
  return function(prompt_bufnr)
    vim.cmd.stopinsert()
    vim.schedule(function() callback(prompt_bufnr) end)
  end
end

telescope.setup{
  defaults = {
    sorting_strategy = 'ascending',
    results_title = false,
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
    history = false,
    borderchars = { "═", " ", " ", " ", " ", " ", " ", " " },
    mappings = {
      n = {
        ["q"] = "close",
        ["<esc>"] = "close",
      },
      i = {
        ["<cr>"] = stopinsert(actions.select_default),
        ["|"] = stopinsert(actions.select_horizontal),
        ["<c-v>"] = stopinsert(actions.select_vertical),
        ["<esc>"] = "close",
        ["<C-h>"] = "which_key",
        ["<C-u>"] = false,
        ["<C-x>"] = "toggle_selection",
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
        "/usr/*",
      },
    }
  }
}

telescope.load_extension('fzf')


-- Use lambdas to ensure lazy loading
-- vim.keymap.set('n', '<leader><leader>', function()
--   telescope.extensions.frecency.frecency()
-- end)
vim.keymap.set('n', '<leader><leader>', function()
  require('telescope.builtin').oldfiles()
end)
vim.keymap.set('n', '<leader>ot', function()
  require('telescope.builtin').tags()
end)
vim.keymap.set('n', '<leader>ob', function()
  require('telescope.builtin').buffers()
end)
vim.keymap.set('n', '<leader>og', function()
  require('telescope.builtin').git_files()
end)

vim.keymap.set('n', '<leader>ev', function()
  require('init.telescope').files_nvim()
end)
vim.keymap.set('n', '<leader>ez', function()
  require('init.telescope').files_dotfiles()
end)
vim.keymap.set('n', '<leader>oo', function()
  require('init.telescope').files()
end)
vim.keymap.set('n', '<leader>op', function()
  require('init.telescope').files_plugged()
end)
vim.keymap.set('n', '<leader>ow', function()
  require('init.telescope').files_wiki()
end)
vim.keymap.set('n', '<leader>oz', function()
  require('init.telescope').files_zotero()
end)
