vim.pack.add { "https://github.com/machakann/vim-columnmove" }

vim.g.columnmove_no_default_key_mappings = 1

vim.fn["columnmove#utility#map"]("nxo", "f", "øf", "block")
vim.fn["columnmove#utility#map"]("nxo", "t", "øt", "block")
vim.fn["columnmove#utility#map"]("nxo", "F", "øF", "block")
vim.fn["columnmove#utility#map"]("nxo", "T", "øT", "block")
vim.fn["columnmove#utility#map"]("nxo", ";", "ø;", "block")
vim.fn["columnmove#utility#map"]("nxo", ",", "ø,", "block")
vim.fn["columnmove#utility#map"]("nxo", "w", "øw", "block")
vim.fn["columnmove#utility#map"]("nxo", "b", "øb", "block")
vim.fn["columnmove#utility#map"]("nxo", "e", "øe", "block")
vim.fn["columnmove#utility#map"]("nxo", "W", "øW", "block")
vim.fn["columnmove#utility#map"]("nxo", "B", "øB", "block")
vim.fn["columnmove#utility#map"]("nxo", "E", "øE", "block")
vim.fn["columnmove#utility#map"]("nxo", "ge", "øge", "block")
vim.fn["columnmove#utility#map"]("nxo", "gE", "øgE", "block")
