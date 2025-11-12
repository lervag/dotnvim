local lspgroup = vim.api.nvim_create_augroup("init_lsp", {})

-- Defaults

local capabilities = vim.lsp.protocol.make_client_capabilities()

---@diagnostic disable-next-line: param-type-not-match
vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = capabilities,
})

-- {{{1 Mappings and autocmds

vim.keymap.set(
  "n",
  "<leader>lq",
  "<cmd>checkhealth lsp<cr>",
  { desc = "Show LSP status/info" }
)

vim.api.nvim_create_autocmd("LspAttach", {
  group = lspgroup,
  desc = "Configure LSP: Mappings and similar",
  callback = function(args)
    local const = require "lervag.const"
    local attached_client =
      assert(vim.lsp.get_client_by_id(args.data.client_id))

    if attached_client:supports_method "textDocument/codeLens" then
      vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
        group = lspgroup,
        desc = "Refresh codelenses",
        buffer = args.buf,
        callback = function()
          vim.lsp.codelens.refresh { bufnr = 0 }
        end,
      })
    end

    if attached_client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

    if attached_client:supports_method "textDocument/documentColor" then
      vim.lsp.document_color.enable(true, args.buf)
    end

    if
      attached_client:supports_method "textDocument/onTypeFormatting"
      and vim.lsp.on_type_formatting
    then
      vim.lsp.on_type_formatting.enable(
        true,
        { client_id = args.data.client_id }
      )
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

      for _, client in pairs(clients) do
        if client:supports_method "textDocument/formatting" then
          table.insert(formatters, client.name)
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
      local params = vim.lsp.util.make_position_params(0, "utf-8")
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
      "<leader>lR",
      "<cmd>Lspsaga rename<cr>",
      -- vim.lsp.buf.rename,
      { desc = "Rename all references" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>la",
      "<cmd>Lspsaga code_action<cr>",
      -- vim.lsp.buf.code_action,
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

---Setup LSP servers
---
---With neovim 0.11, I could use the vim.lsp.config and vim.lsp.enable, but
---these do not allow me to add additionals guard to avoid starting the lsp,
---e.g. for fugitive buffers.
---
---Some references:
---* https://github.com/neovim/neovim/pull/31031
---* https://github.com/neovim/nvim-lspconfig/issues/3494
---
---@param config vim.lsp.Config
local function lsp_enable(config)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = config.filetypes,
    group = lspgroup,
    callback = function(args)
      if
        vim.startswith(args.file, "fugitive://")
        or vim.startswith(args.file, "diffview://")
      then
        return
      end
      ---@diagnostic disable-next-line: undefined-field
      if config.disable and config.disable(args) then
        return
      end
      config = vim.tbl_deep_extend("force", vim.lsp.config["*"] or {}, config)
      if config.root_markers then
        config.root_dir = vim.fs.root(args.buf, config.root_markers)
      end
      if not vim.tbl_isempty(config) then
        vim.lsp.start(config)
      end
    end,
  })
end

-- In addition to these configurations:
-- * ftplugin/java.lua (adds jdtls)

-- {{{1 wiki:bashls

lsp_enable {
  name = "bashls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/bash-language-server",
    "start",
  },
  filetypes = { "sh" },
  settings = {
    bashIde = {
      -- Prevent recursive scanning which will cause issues when opening a file
      -- directly in the home directory (e.g. ~/foo.sh).
      globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
    },
  },
}

-- }}}1
-- {{{1 wiki:cssls

lsp_enable {
  name = "cssls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/vscode-css-language-server",
    "--stdio",
  },
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}

-- }}}1
-- {{{1 wiki:html-ls

lsp_enable {
  name = "html-ls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/vscode-html-language-server",
    "--stdio",
  },
  filetypes = { "html" },
  root_markers = { "package.json", ".git" },
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { "html", "css", "javascript" },
  },
  settings = {},
}

-- }}}1
-- {{{1 wiki:jsonls

lsp_enable {
  name = "jsonls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/vscode-json-language-server",
    "--stdio",
  },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "*.hujson" },
          schema = {
            allowTrailingCommas = true,
          },
        },
      },
    },
  },
}

-- }}}1
-- {{{1 wiki:gitlab-ci-ls

lsp_enable {
  name = "gitlab-ci-ls",
  cmd = { "/home/lervag/.local/share/nvim/mason/bin/gitlab-ci-ls" },
  filetypes = { "yaml" },
  disable = function(args)
    return not args.file:match "gitlab%-ci%."
  end,
  root_markers = { ".gitlab*", ".git" },
  init_options = {
    cache = "/home/lervag/.cache/gitlab-ci-ls/",
    log_path = "/home/lervag/.cache/gitlab-ci-ls/log/gitlab-ci-ls.log",
  },
}

-- }}}1
-- {{{1 wiki:lua-ls

lsp_enable {
  name = "lua-language-server",
  cmd = { "/home/lervag/.local/share/nvim/mason/bin/lua-language-server" },
  disable = function()
    return true
  end,
  filetypes = { "lua" },
  log_level = vim.lsp.protocol.MessageType.Warning,
  root_markers = {
    ".luarc.json",
    ".stylua.toml",
    "stylua.toml",
  },
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
      ---@diagnostic disable-next-line: param-type-mismatch
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

-- }}}1
-- {{{1 wiki:emmylua-analyzer-rust

lsp_enable {
  name = "emmylua-ls",
  cmd = { "/home/lervag/.local/share/nvim/mason/bin/emmylua_ls" },
  filetypes = { "lua" },
  root_markers = {
    ".emmyrc.json",
    ".luarc.json",
    ".stylua.toml",
    "stylua.toml",
  },
  workspace_required = false,
  settings = {
    Lua = {
      semanticTokens = {
        enable = false,
      },
      workspace = {
        library = {
          "$VIMRUNTIME",
        },
      },
    },
  },
}

-- }}}1
-- {{{1 wiki:kotlin-lsp

lsp_enable {
  name = "kotlin-lsp",
  cmd = { "/home/lervag/.local/share/nvim/mason/bin/kotlin-lsp", "--stdio" },
  filetypes = { "kotlin" },
  root_markers = {
    "settings.gradle", -- Gradle (multi-project)
    "settings.gradle.kts", -- Gradle (multi-project)
    "pom.xml", -- Maven
    "build.gradle", -- Gradle
    "build.gradle.kts", -- Gradle
    "workspace.json", -- Used to integrate your own build system
  },
}

-- }}}1
-- {{{1 wiki:Metals

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt" },
  group = lspgroup,
  callback = function(args)
    if args.file:sub(1, 12) == "fugitive:///" then
      return
    end

    local root_dir = vim.fs.root(0, { "build.sbt", ".git" })
    if root_dir == nil then
      vim.notify "Metals: No root dir found!"
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
      verboseCompilation = true,
      inlayHints = {
        hintsInPatternMatch = { enable = true },
        implicitArguments = { enable = true },
        implicitConversions = { enable = true },
        inferredTypes = { enable = true },
        typeParameters = { enable = true },
      },
      defaultBspToBuildTool = true,
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
-- {{{1 wiki:basedpyright

lsp_enable {
  name = "basedpyright",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/basedpyright-langserver",
    "--stdio",
  },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}

-- }}}1
-- {{{1 wiki:pyrefly

lsp_enable {
  name = "pyrefly",
  cmd = { "/home/lervag/.local/share/nvim/mason/bin/pyrefly", "lsp" },
  disable = function()
    return true
  end,
  filetypes = { "python" },
  root_markers = {
    "pyrefly.toml",
    "pyproject.toml",
    ".git",
  },
  settings = {
    pyrefly = {},
  },
}

-- }}}1
-- {{{1 wiki:ruff-lsp

lsp_enable {
  name = "ruff",
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    ".git",
  },
  settings = {
    configurationPreference = "filesystemFirst",
  },
}

-- }}}1
-- {{{1 wiki:rust-analyzer

lsp_enable {
  name = "rust-analyzer",
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  single_file_support = true,
  root_markers = { "Cargo.toml" },
  settings = {
    ["rust-analyzer"] = {},
  },
}

-- }}}1
-- {{{1 wiki:deno-ls

lsp_enable {
  name = "deno ls",
  cmd = { "deno", "lsp" },
  cmd_env = { NO_COLOR = true },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  disable = function(args)
    return not vim.fs.root(args.buf, { "deno.json", "deno.jsonc" })
  end,
  root_markers = { "deno.json", "deno.jsonc", ".git" },
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
          },
        },
      },
    },
  },
}

-- }}}1
-- {{{1 wiki:typescript-language-server

lsp_enable {
  name = "typescript-language-server",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/typescript-language-server",
    "--stdio",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  disable = function(args)
    return not vim.fs.root(args.buf, { "tsconfig.json", "package.json" })
  end,
  root_markers = { "tsconfig.json", "package.json", ".git" },
  init_options = { hostInfo = "neovim" },
  settings = {
    diagnostics = {
      ignoredCodes = { 6133 },
    },
  },
}

-- }}}1
-- {{{1 wiki:vimls

lsp_enable {
  name = "vimls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/vim-language-server",
    "--stdio",
  },
  filetypes = { "vim" },
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
}

-- }}}1
-- {{{1 wiki:yamlls

lsp_enable {
  name = "yamlls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/yaml-language-server",
    "--stdio",
  },
  filetypes = { "yaml", "yaml.docker-compose" },
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
      customTags = {
        "!reference sequence",
        "!reset sequence",
      },
      schemaDownload = { enable = true },
      schemas = {
        kubernetes = { "/deployment.yml", "/deployments/*.yml" },
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/gitlab-ci.yml",
      },
      trace = { server = "debug" },
    },
  },
}

-- }}}1

-- vim: fdm=marker
