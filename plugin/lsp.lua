local lsp = vim.lsp
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

lsp.handlers["textDocument/hover"] =
  lsp.with(lsp.handlers.hover, { border = "double" })
lsp.handlers["textDocument/signatureHelp"] =
  lsp.with(lsp.handlers.signature_help, { border = "double" })

local lspgroup = vim.api.nvim_create_augroup('init_lsp', { clear = true })
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local find_root = function(markers, file)
  return vim.fs.dirname(vim.fs.find(markers, { upward = true, path = vim.fn.fnamemodify(file, ':p:h') })[1])
end
-- local flags = { debounce_text_changes = 150 }


-- {{{1 Mappings
autocmd('LspAttach', {
  group = lspgroup,
  desc = "Configure LSP: Mappings and similar",
  callback = function(args)
    -- local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- client.server_capabilities.semanticTokensProvider = nil

    map("n", "<leader>ld", lsp.buf.definition)
    map("n", "<leader>lD", lsp.buf.declaration)
    map("n", "<leader>lt", lsp.buf.type_definition)
    map("n", "<leader>lr", lsp.buf.references)
    map("n", "<leader>li", lsp.buf.implementation)
    map("n", "<leader>lk", lsp.buf.signature_help)
    map("n", "<leader>lR", lsp.buf.rename)
    map("n", "<leader>la", lsp.buf.code_action)
    map("n", "<leader>lc", lsp.codelens.run)
    map("n", "<leader>lf", lsp.buf.format)
    map("n", "<leader>lw", function()
      print(vim.inspect(lsp.buf.list_workspace_folders()))
    end)
    map("n", "<leader>lK", lsp.buf.hover)

    -- Unsure if I want/need these
    map('n', '<leader>l5', function()
      local params = lsp.util.make_position_params()
      return lsp.buf_request(0, 'textDocument/definition', params, function(_, result)
        if result == nil or vim.tbl_isempty(result) then return end
        lsp.util.preview_location(result[1], { border = 'rounded' })
      end)
    end)
    map("n", "<leader>l1", function()
      require("telescope.builtin").lsp_document_symbols()
    end)
    map("n", "<leader>l2", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end)
    map("n", "<leader>l3", lsp.buf.document_highlight)
    map("n", "<leader>l4", lsp.buf.clear_references)
  end,
})

-- }}}1


-- {{{1 lua-ls
-- https://github.com/LuaLS/lua-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
autocmd('FileType', {
  pattern = 'lua',
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = 'luals',
      cmd = { 'lua-language-server' },
      root_dir = find_root({ '.stylua.toml', 'stylua.toml' }, args.file),
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT', },
          diagnostics = {
            -- globals = { "vim" },
            disable = { 'undefined-global', 'lowercase-global' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },
          completion = {
            callSnippet = 'Replace',
            -- keywordSnippet = "Replace",
            showWord = 'Disable',
          },
        },
      },
      single_file_support = true,
      log_level = vim.lsp.protocol.MessageType.Warning,
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 pyright
-- https://github.com/microsoft/pyright
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/pyright.lua
autocmd('FileType', {
  pattern = 'python',
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = 'pyright',
      cmd = { 'pyright-langserver', '--stdio' },
      root_dir = find_root({
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
      }, args.file),
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = 'workspace',
          },
        },
      },
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 bashls
-- https://github.com/mads-hartmann/bash-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/bashls.lua
autocmd('FileType', {
  pattern = 'sh',
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = 'bashls',
      cmd = { "bash-language-server", "start" },
      root_dir = find_root({ '.git' }, args.file),
      single_file_support = true,
      settings = {
        bashIde = {
          -- Glob pattern for finding and parsing shell script files in the workspace.
          -- Used by the background analysis features across files.

          -- Prevent recursive scanning which will cause issues when opening a file
          -- directly in the home directory (e.g. ~/foo.sh).
          --
          -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
          globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
        },
      },
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 texlab (DISABLED)
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/texlab.lua
-- Settings from clason
-- * https://gist.github.com/clason/3701040203c6625c24eb099cd3ef6d5c
-- autocmd('FileType', {
--   pattern = { 'tex', 'bib' },
--   group = lspgroup,
--   callback = function(args)
--     lsp.start {
--       name = 'texlab',
--       cmd = { vim.fn.stdpath 'data' .. '/lsp/texlab' },
--       root_dir = find_root({ '.latexmkrc' }, args.file),
--       settings = {
--         texlab = {
--           latexFormatter = 'none',
--           formatterLineLength = 0,
--           forwardSearch = {
--             executable = '/Applications/Skim.app/Contents/SharedSupport/displayline',
--             args = { '%l', '%p', '%f', '-g' },
--           },
--         },
--       },
--       capabilities = capabilities,
--       on_attach = compl_attach,
--     }
--     lsp.protocol.SymbolKind = {
--       'file',
--       'sec',
--       'fold',
--       '',
--       'class',
--       'float',
--       'lib',
--       'field',
--       'label',
--       'enum',
--       'misc',
--       'cmd',
--       'thm',
--       'equ',
--       'strg',
--       'arg',
--       '',
--       '',
--       'PhD',
--       '',
--       '',
--       'item',
--       'book',
--       'artl',
--       'part',
--       'coll',
--     }
--     lsp.protocol.CompletionItemKind = {
--       'string',
--       '',
--       '',
--       '',
--       'field',
--       '',
--       'class',
--       'misc',
--       '',
--       'library',
--       'thesis',
--       'argument',
--       '',
--       '',
--       'snippet',
--       'color',
--       'file',
--       '',
--       'folder',
--       '',
--       '',
--       'book',
--       'article',
--       'part',
--       'collect',
--     }
--   end,
-- })

-- }}}1
-- {{{1 ltex (DISABLED)
-- https://valentjn.github.io/ltex/
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/ltex.lua
-- autocmd('FileType', {
--   pattern = { 'bib', 'gitcommit', 'markdown', 'org', 'plaintex', 'rst', 'rnoweb', 'tex', 'pandoc' },
--   group = lspgroup,
--   callback = function(args)
--     lsp.start {
--       name = 'ltex',
--       cmd = { 'ltex-ls' },
--       autostart = false,
--       root_dir = find_root({ '.git' }, args.file),
--       single_file_support = true,
--       get_language_id = function(_, filetype)
--         local language_id_mapping = {
--           bib = 'bibtex',
--           plaintex = 'tex',
--           rnoweb = 'sweave',
--           rst = 'restructuredtext',
--           tex = 'latex',
--           xhtml = 'xhtml',
--           pandoc = 'markdown',
--         }
--         local language_id = language_id_mapping[filetype]

--         if language_id then
--           return language_id
--         else
--           return filetype
--         end
--       end,
--       on_attach = function(_, _)
--         require("ltex_extra").setup {
--           load_langs = { "en-GB" },
--           path = vim.fn.stdpath "config" .. "/spell",
--         }
--       end,
--       settings = {
--         ltex = {
--           checkFrequency = "save",
--           language = "en-GB",
--           -- language = os.getenv 'PROJECT_LANG' or 'en-GB',
--         },
--       },
--       capabilities = capabilities,
--     }
--   end,
-- })

-- }}}1

-- TODO: Configure these

-- {{{1 cssls
-- https://github.com/hrsh7th/vscode-langservers-extracted
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/cssls.lua
-- cmd = { "vscode-css-languageserver", "--stdio" },

-- }}}1
-- {{{1 html
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/html.lua

-- }}}1
-- {{{1 jsonls
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/jsonls.lua
-- cmd = { "vscode-json-languageserver", "--stdio" },

-- }}}1
-- {{{1 Kotlin Language Server
-- https://github.com/fwcd/kotlin-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/kotlin_language_server.lua
-- root_dir = require("lspconfig.util").find_git_ancestor,

-- }}}1
-- {{{1 rust_analyzer
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/rust_analyzer.lua
-- settings = {
--   ["rust-analyzer"] = {
--     cargo = { allFeatures = true },
--     checkOnSave = { allFeatures = true, command = "clippy" },
--   },
-- },

-- }}}1
-- {{{1 tsserver
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/tsserver.lua

-- }}}1
-- {{{1 vimls
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/vimls.lua

-- }}}1
-- {{{1 yamlls
-- https://github.com/redhat-developer/yaml-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/yamlls.lua

-- This may be useful:
-- * https://github.com/someone-stole-my-name/yaml-companion.nvim
-- * https://www.reddit.com/r/neovim/comments/ur6u3g/yamlcompanionnvim_get_set_and_autodetect_yaml/

--   settings = {
--     redhat = { telemetry = { enabled = false } },
--     yaml = {
--       validate = true,
--       format = { enable = true },
--       hover = true,
--       schemaStore = {
--         enable = true,
--         url = "https://www.schemastore.org/api/json/catalog.json",
--       },
--       schemaDownload = { enable = true },
--       schemas = {},
--       trace = { server = "debug" },
--     },
--   },

-- }}}1

-- vim: fdm=marker
