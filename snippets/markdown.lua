local snippets = {
  {
    prefix = "LLM",
    desc = "Create Markdown link from clipboard",
    body = "",
  },
  {
    prefix = "QQ",
    desc = "Anki question and answer",
    body = [[
Q: $1
A: $0
]],
  },
  {
    prefix = "anki-basic",
    desc = "Anki note: Basic model",
    body = [[
# Basic note
model: Basic
tags: $1

## Front
**${2:$1}**

$3

## Back
$0

]],
  },
  {
    prefix = "template-latex",
    desc = "Template: Minimal LaTeX sample",
    body = [[
```tex
\documentclass{minimal}
\begin{document}
Hello World!
\end{document}
```
]],
  },
  {
    prefix = "template-vim-vimtex",
    desc = "Template: Minimal init.vim for VimTeX",
    body = [[
```vim
set nocompatible
set runtimepath^=~/.local/plugged/vimtex
set runtimepath+=~/.local/plugged/vimtex/after
filetype plugin indent on
syntax enable
```
]],
  },
  {
    prefix = "template-vim-wiki",
    desc = "Template: Minimal init.vim for wiki.vim",
    body = [[
```vim
set nocompatible
set runtimepath^=~/.local/plugged/wiki.vim
filetype plugin indent on
syntax enable
runtime plugin/wiki.vim
WikiIndex
```
]],
  },
  {
    prefix = "template-lua-vimtex",
    desc = "Template: Minimal init.vim for VimTeX",
    body = [=[
```lua
vim.opt.runtimepath:prepend "~/.local/plugged/vimtex"
vim.opt.runtimepath:append "~/.local/plugged/vimtex/after"
vim.cmd [[filetype plugin indent on]]
vim.cmd [[syntax enable]]
```
]=],
  },
  {
    prefix = "template-lua-wiki",
    desc = "Template: Minimal init.vim for wiki.vim",
    body = [=[
```lua
vim.opt.runtimepath:prepend "~/.local/plugged/wiki.vim"
vim.cmd [[filetype plugin indent on]]
vim.cmd [[syntax enable]]

vim.cmd [[runtime plugin/wiki.vim]]
vim.cmd [[WikiIndex]]
```
]=],
  },
}

return snippets

