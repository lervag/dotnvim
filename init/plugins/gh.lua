require('litee.lib').setup({
  tree = {
    icon_set = "nerd"
  },
})
require('litee.gh').setup({
  icon_set = "nerd",
  map_resize_keys = true,
  keymaps = {
    open = "<cr>",
    expand = "zo",
    collapse = "zc",
    goto_issue = "gd",
    -- show details associated with a node, for example the commit message
    -- for a commit node in the gh.nvim tree.
    details = "d"
  },
})
