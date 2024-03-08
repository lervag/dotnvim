local lsp = vim.lsp
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local const = require "lervag.const"

lsp.handlers["textDocument/hover"] =
  lsp.with(lsp.handlers.hover, { border = const.border, title = " hover " })
lsp.handlers["textDocument/signatureHelp"] = lsp.with(
  lsp.handlers.signature_help,
  { border = const.border, title = "signature" }
)

local lspgroup = vim.api.nvim_create_augroup("init_lsp", { clear = true })
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local find_root = function(markers, file)
  return vim.fs.dirname(
    vim.fs.find(
      markers,
      { upward = true, path = vim.fn.fnamemodify(file, ":p:h") }
    )[1]
  )
end

-- {{{1 Mappings and autocmds
autocmd("LspAttach", {
  group = lspgroup,
  desc = "Configure LSP: Mappings and similar",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client then
      if client.server_capabilities.codeLensProvider then
        autocmd({ "CursorHold", "InsertLeave" }, {
          desc = "Refresh codelenses",
          buffer = args.buf,
          callback = vim.lsp.codelens.refresh,
        })
      end

      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(args.buf, true)
      end
    end

    map("n", "<leader>ld", lsp.buf.definition, { desc = "Jump to definition" })
    map("n", "<leader>lD", function()
      local params = lsp.util.make_position_params()
      return lsp.buf_request(
        0,
        "textDocument/definition",
        params,
        function(_, result)
          if result == nil or vim.tbl_isempty(result) then
            return
          end
          lsp.util.preview_location(result[1], {
            border = const.border,
            title = " Definition ",
          })
        end
      )
    end, { desc = "Show definition" })
    map(
      "n",
      "<leader>lt",
      lsp.buf.type_definition,
      { desc = "Jump to type definition" }
    )
    map("n", "<leader>lr", lsp.buf.references, { desc = "List all references" })
    map(
      "n",
      "<leader>li",
      lsp.buf.implementation,
      { desc = "List all implementations" }
    )
    map(
      "n",
      "<leader>lK",
      lsp.buf.signature_help,
      { desc = "Show signature information" }
    )
    map("n", "<f6>", lsp.buf.rename, { desc = "Rename all references" })
    map(
      "n",
      "<leader>lR",
      "<cmd>Lspsaga rename<cr>",
      { desc = "Rename all references" }
    )
    map(
      { "n", "v" },
      "<leader>la",
      "<cmd>Lspsaga code_action<cr>",
      { desc = "Select code action" }
    )

    map(
      "n",
      "<leader>lc",
      lsp.codelens.run,
      { desc = "Run codelens in current line" }
    )
    map("n", "<leader>lf", lsp.buf.format, { desc = "Format buffer" })
    map("n", "<leader>lw", function()
      print(vim.inspect(lsp.buf.list_workspace_folders()))
    end, { desc = "List workspace folders" })
    map(
      "n",
      "<leader>lk",
      lsp.buf.hover,
      { desc = "Display hover information" }
    )
    map("n", "<leader>lI", function()
      local is_enabled = vim.lsp.inlay_hint.is_enabled(0)
      vim.lsp.inlay_hint.enable(0, not is_enabled)
    end, { desc = "Toggle inlay hints" })

    -- Unsure if I want/need these
    map("n", "<leader>l1", function()
      require("telescope.builtin").lsp_document_symbols()
    end, { desc = "List LSP document symbols" })
    map("n", "<leader>l2", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end, { desc = "Dynamically list LSP for workspace symbols" })
    map(
      "n",
      "<leader>l3",
      lsp.buf.document_highlight,
      { desc = "Resolve document highlights for current position" }
    )
    map(
      "n",
      "<leader>l4",
      lsp.buf.clear_references,
      { desc = "Remove document highlights" }
    )
  end,
})

-- }}}1

-- {{{1 bashls

-- https://github.com/mads-hartmann/bash-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/bashls.lua

autocmd("FileType", {
  pattern = "sh",
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = "bashls",
      cmd = { "bash-language-server", "start" },
      root_dir = find_root({ ".git" }, args.file),
      single_file_support = true,
      settings = {
        bashIde = {
          -- Prevent recursive scanning which will cause issues when opening a file
          -- directly in the home directory (e.g. ~/foo.sh).
          globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
        },
      },
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 cssls

-- https://github.com/hrsh7th/vscode-langservers-extracted
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/cssls.lua

autocmd("FileType", {
  pattern = { "css", "scss", "less" },
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = "cssls",
      cmd = { "vscode-css-language-server", "--stdio" },
      root_dir = find_root({ "package.json", ".git" }, args.file),
      single_file_support = true,
      settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
      },
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 html

-- https://github.com/hrsh7th/vscode-langservers-extracted
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/html.lua

autocmd("FileType", {
  pattern = "html",
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = "html-ls",
      cmd = { "vscode-html-language-server", "--stdio" },
      root_dir = find_root({ "package.json", ".git" }, args.file),
      single_file_support = true,
      settings = {},
      init_options = {
        provideFormatter = true,
        embeddedLanguages = { css = true, javascript = true },
        configurationSection = { "html", "css", "javascript" },
      },
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 jdtls

-- see ftplugin/java.lua

-- }}}1
-- {{{1 jsonls

-- https://github.com/hrsh7th/vscode-langservers-extracted
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/jsonls.lua

autocmd("FileType", {
  pattern = { "json", "jsonc" },
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = "jsonls",
      cmd = { "vscode-json-language-server", "--stdio" },
      root_dir = find_root({ ".git" }, args.file),
      single_file_support = true,
      settings = {},
      init_options = {
        provideFormatter = true,
      },
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 Kotlin Language Server

-- https://github.com/fwcd/kotlin-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/kotlin_language_server.lua

autocmd("FileType", {
  pattern = "kotlin",
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = "kotlin-ls",
      cmd = { "kotlin-language-server" },
      root_dir = find_root({
        "settings.gradle",
        "settings.gradle.kts",
        "build.xml",
        "pom.xml",
        ".git",
      }, args.file),
      single_file_support = true,
      settings = {},
      init_options = {
        provideFormatter = true,
        embeddedLanguages = { css = true, javascript = true },
        configurationSection = { "html", "css", "javascript" },
      },
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 ltex (DISABLED)

-- TODO: Denne er oppdatert og fungerer annerledes nå!
--       Se README.md for mer info om hvordan man konfigurerer!
--       https://github.com/barreiroleo/ltex_extra.nvim

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

-- ---Force a specific language for ltex-ls
-- ---@param lang string
-- M.set_ltex_lang = function(lang)
--   local clients = vim.lsp.buf_get_clients(0)
--   for _, client in ipairs(clients) do
--     if client.name == "ltex" then
--       vim.notify("Set ltex-ls lang to " .. lang, vim.log.levels.INFO, "core.utils.functions")
--       client.config.settings.ltex.language = lang
--       vim.lsp.buf_notify(0, "workspace/didChangeConfiguration", { settings = client.config.settings })
--       return
--     end
--   end
-- end

-- }}}1
-- {{{1 lua-ls

-- https://github.com/LuaLS/lua-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua

autocmd("FileType", {
  pattern = "lua",
  group = lspgroup,
  callback = function(args)
    if args.file:sub(1, 12) == "fugitive:///" then
      return
    end
    lsp.start {
      name = "lua-language-server",
      cmd = { "lua-language-server" },
      single_file_support = true,
      log_level = vim.lsp.protocol.MessageType.Warning,
      capabilities = capabilities,
      root_dir = find_root({
        ".luarc.json",
        ".stylua.toml",
        "stylua.toml",
      }, args.file),
      settings = {
        Lua = {
          hint = {
            enable = true,
            paramName = "Literal",
            setType = true,
          },
        },
      },
      on_init = function(client)
        local path = ""
        if client.workspace_folders then
          path = client.workspace_folders[1].name
        end

        if
          not vim.uv.fs_stat(path .. "/.luarc.json")
          and not vim.uv.fs_stat(path .. "/.luarc.jsonc")
        then
          client.config.settings =
            vim.tbl_deep_extend("force", client.config.settings, {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/busted/library",
                    "${3rd}/luv/library",
                  },
                },
              },
            })
          client.notify(
            "workspace/didChangeConfiguration",
            { settings = client.config.settings }
          )
        end
      end,
    }
  end,
})

-- }}}1
-- {{{1 Metals

autocmd("FileType", {
  pattern = { "scala", "sbt" },
  group = lspgroup,
  callback = function()
    local metals = require "metals"

    local metals_config = metals.bare_config()
    metals_config.tvp = {
      icons = {
        enabled = true,
        symbols = {
          class = "󰠱",
          enum = "",
          field = "󰜢",
          interface = "",
          method = "󰆧",
          object = "",
          package = "",
          trait = "",
          val = "",
          var = "",
        },
      },
    }
    metals_config.init_options.statusBarProvider = "on"
    metals_config.capabilities = capabilities
    metals_config.settings = {
      showImplicitArguments = true,
      showImplicitConversionsAndClasses = true,
      showInferredType = true,
      decorationColor = "DiagnosticVirtualTextHint",
      excludedPackages = {
        "akka.actor.typed.javadsl",
        "com.github.swagger.akka.javadsl",
      },
      -- enableSemanticHighlighting = false,
    }

    metals_config.on_attach = function(_, bufnr)
      metals.setup_dap()

      vim.keymap.set(
        "v",
        "K",
        require("metals").type_of_range,
        { buffer = bufnr, desc = "Metals: Type of range" }
      )
      vim.keymap.set(
        "n",
        "<leader>mm",
        metals.commands,
        { buffer = bufnr, desc = "Metals: Commands" }
      )
      vim.keymap.set(
        "n",
        "<leader>mk",
        metals.hover_worksheet,
        { buffer = bufnr, desc = "Metals: Hover worksheet" }
      )
      vim.keymap.set(
        "n",
        "<leader>mt",
        require("metals.tvp").toggle_tree_view,
        { buffer = bufnr, desc = "Metals: Toggle tree view" }
      )
      vim.keymap.set(
        "n",
        "<leader>mr",
        require("metals.tvp").reveal_in_tree,
        { buffer = bufnr, desc = "Metals: Reveal in tree" }
      )
      vim.keymap.set("n", "<leader>msi", function()
        metals.toggle_setting "showImplicitArguments"
      end, { buffer = bufnr, desc = "Metals: Show implicit args" })
      vim.keymap.set(
        "n",
        "<leader>mss",
        function()
          metals.toggle_setting "enableSemanticHighlighting"
        end,
        { buffer = bufnr, desc = "Metals: Toggle enableSemanticHighlighting" }
      )
    end

    metals.initialize_or_attach(metals_config)
  end,
})

-- }}}1
-- {{{1 pyright

-- https://microsoft.github.io/pyright/#/
-- https://github.com/microsoft/pyright
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/pyright.lua

autocmd("FileType", {
  pattern = "python",
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = "pyright",
      cmd = { "pyright-langserver", "--stdio" },
      root_dir = find_root({
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
      }, args.file),
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
          },
        },
      },
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 rust_analyzer

-- https://github.com/rust-analyzer/rust-analyzer
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/rust_analyzer.lua

autocmd("FileType", {
  pattern = "rust",
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = "rust-analyzer",
      cmd = { "rust-analyzer" },
      root_dir = find_root({ "Cargo.toml" }, args.file),
      single_file_support = true,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = { allFeatures = true, command = "clippy" },
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
-- {{{1 tsserver

-- https://github.com/typescript-language-server/typescript-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/tsserver.lua

autocmd("FileType", {
  pattern = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = "tsserver",
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = find_root(
        { "tsconfig.json", "package.json", ".git" },
        args.file
      ),
      single_file_support = true,
      settings = {},
      init_options = { hostInfo = "neovim" },
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 vimls

-- https://github.com/iamcco/vim-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/vimls.lua

autocmd("FileType", {
  pattern = "vim",
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = "vimls",
      cmd = { "vim-language-server", "--stdio" },
      root_dir = find_root({ ".git" }, args.file),
      single_file_support = true,
      init_options = {
        isNeovim = true,
        iskeyword = "@,48-57,_,192-255,-#",
        vimruntime = "",
        runtimepath = "",
        diagnostic = { enable = true },
        indexes = {
          runtimepath = true,
          gap = 100,
          count = 3,
          projectRootPatterns = {
            "runtime",
            "nvim",
            ".git",
            "autoload",
            "plugin",
          },
        },
        suggest = { fromVimruntime = true, fromRuntimepath = true },
      },
      capabilities = capabilities,
    }
  end,
})

-- }}}1
-- {{{1 yamlls

-- https://github.com/redhat-developer/yaml-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/yamlls.lua

-- This may be useful:
-- * https://github.com/someone-stole-my-name/yaml-companion.nvim
-- * https://www.reddit.com/r/neovim/comments/ur6u3g/yamlcompanionnvim_get_set_and_autodetect_yaml/

autocmd("FileType", {
  pattern = { "yaml", "yaml.docker-compose" },
  group = lspgroup,
  callback = function(args)
    lsp.start {
      name = "yamlls",
      cmd = { "yaml-language-server", "--stdio" },
      root_dir = find_root({ ".git" }, args.file),
      single_file_support = true,
      settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
          validate = true,
          format = { enable = true },
          hover = true,
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
          },
          schemaDownload = { enable = true },
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          },
          trace = { server = "debug" },
        },
      },
      capabilities = capabilities,
    }
  end,
})

-- }}}1

-- vim: fdm=marker
