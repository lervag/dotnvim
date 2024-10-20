vim.bo.includeexpr = [[substitute(v:fname,'\.','/','g')]]
vim.bo.suffixesadd = ".kt"

vim.opt_local.formatoptions:remove "t"
vim.bo.comments = [[sO:* -,mO:*  ,exO:*/,s1:/*,mb:*,ex:*/,://]]
vim.bo.commentstring = "// %s"

-- Rely on Treesitter for folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Configure indentation
vim.opt_local.cinoptions:append { "j1", ")100" }
vim.opt_local.indentkeys = { "0}", "0)", "!^F", "o", "O", "e", "<cr>" }
vim.bo.indentexpr = "personal#kotlin#indentexpr()"
