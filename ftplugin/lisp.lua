vim.bo.lisp = true

vim.opt_local.path:append "/usr/src/lisp/**"
vim.opt_local.suffixesadd = { ".lisp", ".cl" }
vim.opt_local.lispwords:append { "alet", "alambda", "dlambda", "aif" }
vim.opt_local.iskeyword:append "-"

vim.wo.foldmethod = "marker"
vim.wo.foldmarker = "(,)"
vim.wo.foldminlines = 3
