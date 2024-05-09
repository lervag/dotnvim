local const = require "lervag.const"
local lspgroup = vim.api.nvim_create_augroup("init_lsp", {})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = const.border, title = " hover " }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = const.border, title = "signature" }
)

-- {{{1 Capabilities

-- Fixes issue with jsonls: "Unhandled method textDocument/diagnostic"
-- * It appears that cmp_nvim_lsp is overwriting the capabilities.textDocument
--   wrongly.
-- * I found good help here:
--   https://github.com/dkarter/dotfiles/blob/master/config/nvim/lua/plugins/lsp.lua

-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion = {
  dynamicRegistration = false,
  completionItem = {
    snippetSupport = true,
    commitCharactersSupport = true,
    deprecatedSupport = true,
    preselectSupport = true,
    tagSupport = {
      valueSet = {
        1,
      },
    },
    insertReplaceSupport = true,
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
        "sortText",
        "filterText",
        "insertText",
        "textEdit",
        "insertTextFormat",
        "insertTextMode",
      },
    },
    insertTextModeSupport = {
      valueSet = {
        1,
        2,
      },
    },
    labelDetailsSupport = true,
  },
  contextSupport = true,
  insertTextMode = 1,
  completionList = {
    itemDefaults = {
      "commitCharacters",
      "editRange",
      "insertTextFormat",
      "insertTextMode",
      "data",
    },
  },
}

-- }}}1

-- {{{1 Mappings and autocmds
vim.api.nvim_create_autocmd("LspAttach", {
  group = lspgroup,
  desc = "Configure LSP: Mappings and similar",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client then
      if client.server_capabilities.codeLensProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
          desc = "Refresh codelenses",
          buffer = args.buf,
          callback = function()
            vim.lsp.codelens.refresh { bufnr = 0 }
          end,
        })
      end

      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end
    end

    vim.keymap.set(
      "n",
      "<leader>ld",
      vim.lsp.buf.definition,
      { desc = "Jump to definition" }
    )
    vim.keymap.set("n", "<leader>lF", function()
      local clients = vim.lsp.get_clients { bufnr = args.buf }
      local formatters = {}

      for _, c in pairs(clients) do
        if c.server_capabilities.documentFormattingProvider then
          table.insert(formatters, c.name)
        end
      end

      if #formatters > 1 then
        vim.ui.select(
          formatters,
          { prompt = "Select a formatter" },
          function(_, choice)
            if not choice then
              vim.notify "No formatter selected"
              return
            end

            vim.notify("Formatted with: " .. formatters[choice])
            vim.lsp.buf.format { async = true, name = formatters[choice] }
          end
        )
      elseif #formatters == 1 then
        vim.notify("Formatted with: " .. formatters[1])
        vim.lsp.buf.format { async = true, name = formatters[1] }
      end
    end, { desc = "Format buffer" })
    vim.keymap.set("n", "<leader>lD", function()
      local params = vim.lsp.util.make_position_params()
      return vim.lsp.buf_request(
        0,
        "textDocument/definition",
        params,
        function(_, result)
          if result == nil or vim.tbl_isempty(result) then
            return
          end
          vim.lsp.util.preview_location(result[1], {
            border = const.border,
            title = " Definition ",
          })
        end
      )
    end, { desc = "Show definition" })
    vim.keymap.set(
      "n",
      "<leader>lt",
      vim.lsp.buf.type_definition,
      { desc = "Jump to type definition" }
    )
    vim.keymap.set(
      "n",
      "<leader>lr",
      vim.lsp.buf.references,
      { desc = "List all references" }
    )
    vim.keymap.set(
      "n",
      "<leader>li",
      vim.lsp.buf.implementation,
      { desc = "List all implementations" }
    )
    vim.keymap.set(
      "n",
      "<leader>lK",
      vim.lsp.buf.signature_help,
      { desc = "Show signature information" }
    )
    vim.keymap.set(
      "n",
      "<f6>",
      vim.lsp.buf.rename,
      { desc = "Rename all references" }
    )
    vim.keymap.set(
      "n",
      "<leader>lR",
      "<cmd>Lspsaga rename<cr>",
      { desc = "Rename all references" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>la",
      "<cmd>Lspsaga code_action<cr>",
      { desc = "Select code action" }
    )

    vim.keymap.set(
      "n",
      "<leader>lc",
      vim.lsp.codelens.run,
      { desc = "Run codelens in current line" }
    )
    vim.keymap.set("n", "<leader>lw", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = "List workspace folders" })
    vim.keymap.set(
      "n",
      "<leader>lk",
      vim.lsp.buf.hover,
      { desc = "Display hover information" }
    )
    vim.keymap.set("n", "<leader>lI", function()
      local is_enabled = vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
      vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = 0 })
    end, { desc = "Toggle inlay hints" })

    -- Unsure if I want/need these
    vim.keymap.set("n", "<leader>l1", function()
      require("telescope.builtin").lsp_document_symbols()
    end, { desc = "List LSP document symbols" })
    vim.keymap.set("n", "<leader>l2", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end, { desc = "Dynamically list LSP for workspace symbols" })
    vim.keymap.set(
      "n",
      "<leader>l3",
      vim.lsp.buf.document_highlight,
      { desc = "Resolve document highlights for current position" }
    )
    vim.keymap.set(
      "n",
      "<leader>l4",
      vim.lsp.buf.clear_references,
      { desc = "Remove document highlights" }
    )
  end,
})

-- }}}1

---Setup FileType autocommand for an LSP server
---@param filetypes string | string[] FileType patterns
---@param option_cb function
local function create_autocommand(filetypes, option_cb)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    group = lspgroup,
    callback = function(args)
      if args.file:sub(1, 12) == "fugitive:///" then
        return
      end
      local options = option_cb(args)
      if not vim.tbl_isempty(options) then
        vim.lsp.start(options)
      end
    end,
  })
end

-- {{{1 wiki:bashls

create_autocommand("sh", function(args)
  return {
    name = "bashls",
    cmd = { "bash-language-server", "start" },
    root_dir = vim.fs.root(args.buf, { ".git" }),
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
end)

-- }}}1
-- {{{1 wiki:cssls

create_autocommand({ "css", "scss", "less" }, function(args)
  return {
    name = "cssls",
    cmd = { "vscode-css-language-server", "--stdio" },
    root_dir = vim.fs.root(args.buf, { "package.json", ".git" }),
    single_file_support = true,
    settings = {
      css = { validate = true },
      scss = { validate = true },
      less = { validate = true },
    },
    capabilities = capabilities,
  }
end)

-- }}}1
-- {{{1 html

-- https://github.com/hrsh7th/vscode-langservers-extracted
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/html.lua

create_autocommand("html", function(args)
  return {
    name = "html-ls",
    cmd = { "vscode-html-language-server", "--stdio" },
    root_dir = vim.fs.root(args.buf, { "package.json", ".git" }),
    single_file_support = true,
    settings = {},
    init_options = {
      provideFormatter = true,
      embeddedLanguages = { css = true, javascript = true },
      configurationSection = { "html", "css", "javascript" },
    },
    capabilities = capabilities,
  }
end)

-- }}}1
-- {{{1 jdtls

-- see ftplugin/java.lua

-- }}}1
-- {{{1 jsonls

-- https://github.com/hrsh7th/vscode-langservers-extracted
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/jsonls.lua

create_autocommand({ "json", "jsonc" }, function(args)
  return {
    name = "jsonls",
    cmd = { "vscode-json-language-server", "--stdio" },
    root_dir = vim.fs.root(args.buf, { ".git" }),
    single_file_support = true,
    settings = {},
    init_options = {
      provideFormatter = true,
    },
    capabilities = capabilities,
  }
end)

-- }}}1
-- {{{1 GitLab CICD LS

-- https://github.com/alesbrelih/gitlab-ci-ls
-- To install locally:
--   cargo install gitlab-ci-ls
--   Add to path: ~/.cargo/bin

create_autocommand("yaml", function(args)
  if not args.file:match "gitlab%-ci" then
    return {}
  else
    return {}
  end

  local cache_dir = "/home/lervag/.cache/gitlab-ci-ls/"
  return {
    name = "gitlab-ci-ls",
    cmd = { "gitlab-ci-ls" },
    root_dir = vim.fs.root(args.buf, { ".gitlab*", ".git" }),
    init_options = {
      cache_path = cache_dir,
      log_path = cache_dir .. "/log/gitlab-ci-ls.log",
    },
    capabilities = capabilities,
  }
end)

-- }}}1
-- {{{1 graphql

-- https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli

create_autocommand(
  { "typescript", "typescriptreact", "graphql" },
  function(args)
    return {
      name = "graphql-lsp",
      cmd = { "graphql-lsp", "server", "-m", "stream" },
      root_dir = vim.fs.root(args.buf, { ".graphqlrc.yml", ".git" }),
      settings = {},
      capabilities = capabilities,
    }
  end
)

-- }}}1
-- {{{1 Kotlin Language Server

-- https://github.com/fwcd/kotlin-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/kotlin_language_server.lua

create_autocommand("kotlin", function(args)
  return {
    name = "kotlin-ls",
    cmd = { "kotlin-language-server" },
    root_dir = vim.fs.root(args.buf, {
      "settings.gradle",
      "settings.gradle.kts",
      "build.xml",
      "pom.xml",
      ".git",
    }),
    single_file_support = true,
    settings = {},
    init_options = {
      provideFormatter = true,
      embeddedLanguages = { css = true, javascript = true },
      configurationSection = { "html", "css", "javascript" },
    },
    capabilities = capabilities,
  }
end)

-- }}}1
-- {{{1 ltex (DISABLED)

-- TODO: Denne er oppdatert og fungerer annerledes nå!
--       Se README.md for mer info om hvordan man konfigurerer!
--       https://github.com/barreiroleo/ltex_extra.nvim

-- https://valentjn.github.io/ltex/
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/ltex.lua

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'bib', 'gitcommit', 'markdown', 'org', 'plaintex', 'rst', 'rnoweb', 'tex', 'pandoc' },
--   group = lspgroup,
--   callback = function(args)
--     lsp.start {
--       name = 'ltex',
--       cmd = { 'ltex-ls' },
--       autostart = false,
--       root_dir = vim.fs.root(args.buf, { '.git' }),
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

create_autocommand("lua", function(args)
  return {
    name = "lua-language-server",
    cmd = { "lua-language-server" },
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
    capabilities = capabilities,
    root_dir = vim.fs.root(args.buf, {
      ".luarc.json",
      ".stylua.toml",
      "stylua.toml",
    }),
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
      local path = "."
      if client.workspace_folders then
        path = client.workspace_folders[1].name
      end
      if
        vim.uv.fs_stat(path .. "/.luarc.json")
        or vim.uv.fs_stat(path .. "/.luarc.jsonc")
      then
        return
      end

      client.config.settings.Lua =
        vim.tbl_deep_extend("force", client.config.settings.Lua, {
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
        })
    end,
  }
end)

-- }}}1
-- {{{1 Metals

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt" },
  group = lspgroup,
  callback = function(args)
    if args.file:sub(1, 12) == "fugitive:///" then
      return
    end

    local metals = require "metals"
    local tvp = require "metals.tvp"

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
      defaultBspToBuildTool = true,
      decorationColor = "DiagnosticVirtualTextHint",
      excludedPackages = {
        "akka.actor.typed.javadsl",
        "com.github.swagger.akka.javadsl",
      },
      enableSemanticHighlighting = false,
    }

    metals_config.on_attach = function(_, bufnr)
      metals.setup_dap()

      vim.notify("Metals started for buffer " .. bufnr)

      vim.keymap.set(
        "n",
        "<leader>lo",
        ":MetalsOrganizeImports<cr>",
        { buffer = bufnr, desc = "Metals: Organize imports" }
      )
      vim.keymap.set(
        "v",
        "K",
        metals.type_of_range,
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
        tvp.toggle_tree_view,
        { buffer = bufnr, desc = "Metals: Toggle tree view" }
      )
      vim.keymap.set(
        "n",
        "<leader>mr",
        tvp.reveal_in_tree,
        { buffer = bufnr, desc = "Metals: Reveal in tree" }
      )
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

create_autocommand("python", function(args)
  return {
    name = "pyright",
    cmd = { "pyright-langserver", "--stdio" },
    root_dir = vim.fs.root(args.buf, {
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
    }),
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
end)

-- }}}1
-- {{{1 rust_analyzer

-- https://github.com/rust-analyzer/rust-analyzer
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/rust_analyzer.lua

create_autocommand("rust", function(args)
  return {
    name = "rust-analyzer",
    cmd = { "rust-analyzer" },
    root_dir = vim.fs.root(args.buf, { "Cargo.toml" }),
    single_file_support = true,
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { allFeatures = true, command = "clippy" },
      },
    },
    capabilities = capabilities,
  }
end)

-- }}}1
-- {{{1 texlab (DISABLED)

-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/texlab.lua
-- Settings from clason
-- * https://gist.github.com/clason/3701040203c6625c24eb099cd3ef6d5c

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'tex', 'bib' },
--   group = lspgroup,
--   callback = function(args)
--     lsp.start {
--       name = 'texlab',
--       cmd = { vim.fn.stdpath 'data' .. '/lsp/texlab' },
--       root_dir = vim.fs.root(args.buf, { '.latexmkrc' }),
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
-- {{{1 typescript-language-server

-- wiki:typescript-language-server

create_autocommand({
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
}, function(args)
  return {
    name = "typescript-language-server",
    cmd = { "typescript-language-server", "--stdio" },
    root_dir = vim.fs.root(
      args.buf,
      { "tsconfig.json", "package.json", ".git" }
    ),
    single_file_support = true,
    settings = {},
    init_options = { hostInfo = "neovim" },
    capabilities = capabilities,
  }
end)

-- }}}1
-- {{{1 vimls

-- https://github.com/iamcco/vim-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/vimls.lua

create_autocommand("vim", function(args)
  return {
    name = "vimls",
    cmd = { "vim-language-server", "--stdio" },
    root_dir = vim.fs.root(args.buf, { ".git" }),
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
end)

-- }}}1
-- {{{1 yamlls

-- https://github.com/redhat-developer/yaml-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/yamlls.lua

-- This may be useful:
-- * https://github.com/someone-stole-my-name/yaml-companion.nvim
-- * https://www.reddit.com/r/neovim/comments/ur6u3g/yamlcompanionnvim_get_set_and_autodetect_yaml/

create_autocommand({ "yaml", "yaml.docker-compose" }, function(args)
  return {
    name = "yamlls",
    cmd = { "yaml-language-server", "--stdio" },
    root_dir = vim.fs.root(args.buf, { ".git" }),
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
end)

-- }}}1

-- vim: fdm=marker
