local builtin = require 'telescope.builtin'
local actions = require 'telescope.actions'
local action_state = require "telescope.actions.state"

local M = {}

function M.files()
  local dir = vim.fn.FindRootDirectory()
  if dir == "" then
    dir = vim.fn.getcwd()
  end
  builtin.find_files({
    prompt_title = "Find Files: " .. dir,
    cwd = dir,
  })
end

function M.files_nvim()
  builtin.git_files({
    prompt_title = "Find Files: ~/.config/nvim",
    cwd = '~/.config/nvim',
  })
end

function M.files_plugged()
  builtin.find_files({
    prompt_title = "Find Files: ~/.local/plugged",
    cwd = '~/.local/plugged',
  })
end

-- local sorters = require("telescope.sorters")
function M.files_wiki()
  builtin.find_files({
    prompt_title = "Wiki files",
    cwd = '~/.local/wiki',
    disable_devicons = true,
    tiebreak = function(_current_entry, _existing_entry, prompt)
      return false
    end,
    -- file_sorter = sorters.get_fzy_sorter,
    -- file_sorter = sorters.fuzzy_with_index_bias,
    file_ignore_patterns = {
      "%.stversions/",
      "%.git/",
    },
    path_display = function(_, path)
      local name = path:match "(.+)%.[^.]+$"
      return name or path
    end,
  })
end

function M.files_zotero()
  local path = '~/.local/zotero/storage'
  builtin.find_files({
    prompt_title = "Zotero",
    cwd = path,
    disable_devicons = true,
    path_display = { "tail" },
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
end

return M
