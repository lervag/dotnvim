local telescope = require 'telescope'
local actions = require 'telescope.actions'
local builtin = require 'telescope.builtin'

telescope.setup{
  defaults = {
    sorting_strategy = 'ascending',
    preview = { hide_on_startup = true },
    layout_strategy = 'flex',
    layout_config = {
      prompt_position = 'top',
      width = 0.9,
      height = 0.95,
    },
    mappings = {
      n = {
        ["q"] = actions.close,
        ["<esc>"] = actions.close,
      },
      i = {
        ["<esc>"] = actions.close,
        ["<C-h>"] = "which_key",
        ["<C-u>"] = false,
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
      fuzzy = false,
      override_generic_sorter = false,  -- override the generic sorter
      override_file_sorter = false,     -- override the file sorter
      case_mode = "smart_case",
    }
  }
}

telescope.load_extension('fzf')


vim.keymap.set('n', '<leader><leader>', builtin.oldfiles)
vim.keymap.set('n', '<leader>ev', function()
  builtin.git_files({
    prompt_title = "Find Files: ~/.config/nvim",
    cwd = '~/.config/nvim'
  })
end)
vim.keymap.set('n', '<leader>ot', builtin.tags)
vim.keymap.set('n', '<leader>ob', builtin.buffers)
vim.keymap.set('n', '<leader>oo', function()
  local dir = vim.fn.FindRootDirectory()
  if dir == "" then
    dir = vim.fn.getcwd()
  end
  builtin.find_files({
    prompt_title = "Find Files: " .. dir,
    cwd = dir
  })
end)
vim.keymap.set('n', '<leader>op', function()
  builtin.find_files({
    prompt_title = "Find Files: ~/.local/plugged",
    cwd = '~/.local/plugged'
  })
end)
vim.keymap.set('n', '<leader>og', builtin.git_files)
vim.keymap.set('n', '<leader>ow', function()
  builtin.find_files({
    preview = { hide_on_startup = false },
    prompt_title = "Wiki files",
    cwd = '~/.local/wiki'
  })
end)
-- vim.keymap.set('n', '<leader>oz', function()
--   builtin.find_files({
--     prompt_title = "Zotero",
--     find_command = { "fd", "--type", "f", "-e", "pdf", "--strip-cwd-prefix" },
--     cwd = '~/.local/zotero'
--   })
-- --             \   'sink':    {x -> system(['zathura', '--fork', x])},
-- end)
