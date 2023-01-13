if exists('g:loaded_plugins') | finish | endif
let g:loaded_plugins = 1

let g:plug_window = 'new|wincmd o'

nnoremap <silent> <leader>pi :PlugInstall<cr>
nnoremap <silent> <leader>pu :PlugUpdate<cr>
nnoremap <silent> <leader>ps :PlugStatus<cr>
nnoremap <silent> <leader>pc :PlugClean<cr>
nnoremap <silent> <leader>pr :Runtime vim-plug.vim<cr>

" Source init script if plug.vim is not available
if !filereadable(expand('~/.config/nvim/autoload/plug.vim'))
  silent !source ~/.config/nvim/bootstrap.sh

  " vint: -ProhibitAutocmdWithNoGroup
  unlet g:loaded_plugins
  autocmd VimEnter * nested PlugInstall --sync | runtime init/plugins.vim
  " vint: +ProhibitAutocmdWithNoGroup
endif

call plug#begin('~/.local/plugged')

Plug 'junegunn/vim-plug', {'on': []}

call plug#('git@github.com:lervag/vimtex')
call plug#('git@github.com:lervag/file-line')
call plug#('git@github.com:lervag/lists.vim')
call plug#('git@github.com:lervag/wiki.vim')
call plug#('git@github.com:lervag/wiki-ft.vim')
call plug#('git@github.com:lervag/vim-sikt')

" Plugin: UI
Plug 'andymass/vim-matchup'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'folke/zen-mode.nvim'
Plug 'lewis6991/impatient.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'https://gitlab.com/yorickpeterse/nvim-pqf'
Plug 'rcarriga/nvim-notify'
Plug 'j-hui/fidget.nvim'
Plug 'justinmk/vim-dirvish'
Plug 'Eandrju/cellular-automaton.nvim'
Plug 'aduros/ai.vim'

" Plugin: Completion, LSP and snippets
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'SirVer/ultisnips'
Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-omni'
Plug 'hrsh7th/cmp-path'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'barreiroleo/ltex-extra.nvim'
Plug 'mfussenegger/nvim-jdtls'

" Plugin: Text objects and similar
Plug 'wellle/targets.vim'
Plug 'machakann/vim-sandwich'

" Plugin: Finder, motions, and tags
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Plug 'nvim-telescope/telescope-frecency.nvim'
" Plug 'tami5/sqlite.lua'
Plug 'ludovicchabant/vim-gutentags'
Plug 'dyng/ctrlsf.vim'
Plug 'machakann/vim-columnmove'

" Plugin: Debugging, and code runners
Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'HiPhish/debugpy.nvim'
Plug 'jbyuki/one-small-step-for-vimkind'

" Plugin: Editing
Plug 'junegunn/vim-easy-align'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'monaqa/dial.nvim'
Plug 'ggandor/leap.nvim'
Plug 'booperlv/nvim-gomove'
Plug 'brianrodri/vim-sort-folds'
Plug 'AndrewRadev/inline_edit.vim'
Plug 'AndrewRadev/linediff.vim'

" Plugin: VCS
Plug 'rbong/vim-flog'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-rooter'
Plug 'sindrets/diffview.nvim'

" Plugin: Tmux (incl. filetype)
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" Plugin: Various
Plug 'itchyny/calendar.vim'
Plug 'tweekmonster/helpful.vim', {'on': 'HelpfulVersion'}
Plug 'tyru/capture.vim', {'on': 'Capture'}
Plug 'tpope/vim-unimpaired'
Plug 'chrisbra/Colorizer'
Plug 'nvim-colortils/colortils.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'dstein64/vim-startuptime'
Plug 'echuraev/translate-shell.vim'

" Filetype: various
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'scalameta/nvim-metals'
Plug 'preservim/vim-markdown'
Plug 'gpanders/vim-medieval'
Plug 'tpope/vim-scriptease'
Plug 'darvelo/vim-systemd'
Plug 'gregsexton/MatchTag'
Plug 'tpope/vim-apathy'
Plug 'chunkhang/vim-mbsync'
Plug 'tridactyl/vim-tridactyl'

call plug#end()

" Source plugin configuration only when they are available
if exists('g:loaded_plugins')
  lua require('impatient')
  runtime! init/plugins/*
endif
