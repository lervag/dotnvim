local action_state = require "telescope.actions.state"
local actions = require 'telescope.actions'
local builtin = require 'telescope.builtin'
local telescope = require 'telescope'

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
      case_mode = "smart_case",
      fuzzy = false,
      override_file_sorter = true,
      override_generic_sorter = true,
    }
  }
}

telescope.load_extension('fzf')


vim.keymap.set('n', '<leader><leader>', builtin.oldfiles)
vim.keymap.set('n', '<leader>ot', builtin.tags)
vim.keymap.set('n', '<leader>ob', builtin.buffers)
vim.keymap.set('n', '<leader>og', builtin.git_files)

vim.keymap.set('n', '<leader>ev', function()
  builtin.git_files({
    prompt_title = "Find Files: ~/.config/nvim",
    cwd = '~/.config/nvim'
  })
end)

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

vim.keymap.set('n', '<leader>ow', function()
  builtin.find_files({
    preview = { hide_on_startup = false },
    prompt_title = "Wiki files",
    cwd = '~/.local/wiki'
  })
end)

vim.keymap.set('n', '<leader>oz', function()
  local path = '~/.local/zotero'
  builtin.find_files({
    prompt_title = "Zotero",
    cwd = path,
    find_command = { "fd", "--type", "f", "-e", "pdf", "--strip-cwd-prefix" },
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()[1]
        vim.fn.jobstart({'zathura', '--fork', path .. "/" .. selection})
      end)
      return true
    end,
  })
end)
