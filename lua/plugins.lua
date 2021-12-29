-- Automatically install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  print 'Installing packer close and reopen Neovim...'
  vim.cmd 'packadd packer.nvim'
end

-- Specify packer maps
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>pu", ":PackerSync<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>pi", ":PackerInstall<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>ps", ":PackerStatus<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>pr", ":source lua/plugins.lua<cr>", opts)

packer = require "packer"

-- Configure packer
packer.init {
  compile_path = install_path .. '/plugin/packer.lua',
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
    prompt_border = 'rounded',
  },
}

return packer.startup(function(use)
  -- Personal plugins
  use '~/.local/plugged/vimtex'
  use '~/.local/plugged/file-line'
  use '~/.local/plugged/lists.vim'
  use '~/.local/plugged/wiki.vim'
  use '~/.local/plugged/wiki-ft.vim'
  use '~/.local/plugged/vim-sintef'

  -- Plugin: UI
  use 'Konfekt/FastFold'
  use 'andymass/vim-matchup'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/playground', cmd = 'TSHighlightCapturesUnderCursor' }
  use 'folke/zen-mode.nvim'

  -- Plugin: Completion, LSP and snippets
  use { 'neoclide/coc.nvim', branch = 'release' }
  use 'Shougo/neco-vim'
  use 'Shougo/neoinclude.vim'
  use 'neoclide/coc-neco'
  use 'jsfaint/coc-neoinclude'
  use 'SirVer/ultisnips'

  -- Plugin: Text objects and similar
  use 'wellle/targets.vim'
  use 'machakann/vim-sandwich'

  -- Plugin: Finder, motions, and tags
  use { '~/.fzf', run = './install --all --no-update-rc' }
  use 'junegunn/fzf.vim'
  use 'pbogut/fzf-mru.vim'
  use 'ludovicchabant/vim-gutentags'
  use 'dyng/ctrlsf.vim'
  use 'machakann/vim-columnmove'

  -- Plugin: Debugging, and code runners
  use 'mfussenegger/nvim-dap'

  -- Plugin: Editing
  use 'junegunn/vim-easy-align'
  use 'dhruvasagar/vim-table-mode'
  use 'tpope/vim-commentary'
  use 'tpope/vim-repeat'
  use 'tpope/vim-speeddating'
  use 'zirrostig/vim-schlepp'
  use 'AndrewRadev/splitjoin.vim'
  use 'brianrodri/vim-sort-folds'

  -- Plugin: VCS
  use 'rbong/vim-flog'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'rhysd/git-messenger.vim'
  use 'airblade/vim-rooter'

  -- Plugin: Tmux (incl. filetype)
  use 'christoomey/vim-tmux-navigator'
  use 'benmills/vimux'

  -- Plugin: Various
  use 'itchyny/calendar.vim'
  use { 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' }
  use { 'mbbill/undotree', cmd = 'UndotreeToggle' }
  use { 'tyru/capture.vim', cmd = 'Capture' }
  use 'tpope/vim-unimpaired'
  use 'chrisbra/Colorizer'
  use { 'RRethy/vim-hexokinase', cmd = 'make hexokinase' }
  use 'Vimjas/vim-python-pep8-indent'

  -- Filetype: various
  use 'plasticboy/vim-markdown'
  use 'tpope/vim-scriptease'
  use 'darvelo/vim-systemd'
  use 'gregsexton/MatchTag'
  use 'tpope/vim-apathy'
  use 'rust-lang/rust.vim'
  use 'chunkhang/vim-mbsync'


  use 'wbthomason/packer.nvim'
  -- use 'lewis6991/impatient.nvim'
  -- use 'nathom/filetype.nvim'




  -- use 'numtostr/comment.nvim'
  -- use { 'neovim/nvim-lspconfig', requires = 'mfussenegger/nvim-lsp-compl' }
  -- use {
  --   'nvim-telescope/telescope.nvim',
  --   requires = {
  --     'nvim-lua/plenary.nvim',
  --     { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  --     { 'nvim-telescope/telescope-frecency.nvim', requires = 'tami5/sql.nvim' },
  --   },
  -- }

  -- use { 'norcalli/nvim-colorizer.lua', cmd = 'ColorizerAttachToBuffer' }
  -- use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
