-- vim.g.matchup_matchparen_deferred = 1
-- vim.g.matchup_matchparen_offscreen = { method = "popup" }
-- vim.g.matchup_override_vimtex = 1
--
-- vim.pack.add { "https://github.com/andymass/vim-matchup" }

vim.pack.add { "https://github.com/monkoose/matchparen.nvim" }
vim.g.loaded_matchparen = 1
require("matchparen").setup {}
