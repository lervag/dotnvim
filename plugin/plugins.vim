" Load plugins with vim-plug
"
" Note: Plugins are configured inside
"       * plugins.lua (small Lua configurations)
"       * plugins.vim (small Vimscript configurations)
"       * plugins/    (for individual plugin configuration)

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
  silent !source ~/.config/nvim/init.sh

  " vint: -ProhibitAutocmdWithNoGroup
  autocmd VimEnter * nested PlugInstall --sync | source $MYVIMRC
  " vint: +ProhibitAutocmdWithNoGroup
endif

call plug#begin('~/.local/plugged')

Plug 'junegunn/vim-plug', {'on': []}

call plug#('git@github.com:lervag/vimtex')
call plug#('git@github.com:lervag/file-line')
call plug#('git@github.com:lervag/lists.vim')
call plug#('git@github.com:lervag/wiki.vim')
call plug#('git@github.com:lervag/wiki-ft.vim')
call plug#('git@github.com:lervag/vim-sintef')

" Plugin: UI
Plug 'Konfekt/FastFold'
Plug 'andymass/vim-matchup', {'for': ['tex', 'python']}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'folke/zen-mode.nvim'

" Plugin: Completion, LSP and snippets
Plug 'neovim/nvim-lspconfig'
Plug 'SirVer/ultisnips'

" Plugin: Text objects and similar
Plug 'wellle/targets.vim'
Plug 'machakann/vim-sandwich'

" Plugin: Finder, motions, and tags
Plug 'junegunn/fzf', {
      \ 'dir': '~/.fzf',
      \ 'do': './install --all --no-update-rc',
      \}
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
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
Plug 'tpope/vim-speeddating'
Plug 'booperlv/nvim-gomove'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'brianrodri/vim-sort-folds'

" Plugin: VCS
Plug 'rbong/vim-flog'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'rhysd/git-messenger.vim'
Plug 'airblade/vim-rooter'

" Plugin: Tmux (incl. filetype)
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" Plugin: Various
Plug 'itchyny/calendar.vim'
Plug 'tweekmonster/helpful.vim', {'on': 'HelpfulVersion'}
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'tyru/capture.vim', {'on': 'Capture'}
Plug 'tpope/vim-unimpaired'
Plug 'chrisbra/Colorizer'
Plug 'RRethy/vim-hexokinase', {'do': 'make hexokinase'}
Plug 'Vimjas/vim-python-pep8-indent'

" Filetype: various
Plug 'plasticboy/vim-markdown'
Plug 'gpanders/vim-medieval'
Plug 'tpope/vim-scriptease'
Plug 'darvelo/vim-systemd'
Plug 'gregsexton/MatchTag'
Plug 'tpope/vim-apathy'
Plug 'chunkhang/vim-mbsync'
Plug 'tridactyl/vim-tridactyl'

call plug#end()
