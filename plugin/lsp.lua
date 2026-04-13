vim.pack.add {
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mfussenegger/nvim-jdtls",
}

local lsp_utils = require "lervag.util.lsp"
local lspgroup = vim.api.nvim_create_augroup("init_lsp", {})

-- Defaults

local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = capabilities,
  handlers = {
    ["actions/readFile"] = lsp_utils.handler_readfile,
  },
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
    local attached_client = vim.lsp.get_client_by_id(args.data.client_id)
    if not attached_client then
      vim.notify(
        "LspAttach failed for client " .. args.data.client_id,
        vim.log.levels.WARN
      )
      return
    end

    if attached_client:supports_method "textDocument/codeLens" then
      vim.lsp.codelens.enable(true, { bufnr = args.buf })
    end

    if attached_client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

    if attached_client:supports_method "textDocument/documentColor" then
      vim.lsp.document_color.enable(true, { bufnr = args.buf })
    end

    if attached_client:supports_method "textDocument/onTypeFormatting" then
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
      "<leader>l1",
      vim.lsp.buf.incoming_calls,
      { desc = "Incoming calls" }
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
      vim.lsp.buf.rename,
      { desc = "Rename all references" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>la",
      vim.lsp.buf.code_action,
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

      if config.init_options_lazy then
        config.init_options = config.init_options_lazy()
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

---@type vim.lsp.Config
local config_bashls = {
  name = "bashls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/bash-language-server",
    "start",
  },
  filetypes = { "sh" },
  ---@type lspconfig.settings.bashls
  settings = {
    bashIde = {
      -- Prevent recursive scanning which will cause issues when opening a file
      -- directly in the home directory (e.g. ~/foo.sh).
      globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
    },
  },
}
lsp_enable(config_bashls)

-- }}}1
-- {{{1 wiki:bicep

lsp_enable {
  name = "bicep-lsp",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/bicep-lsp",
    "start",
  },
  filetypes = { "bicep" },
}

-- }}}1
-- {{{1 wiki:cssls

---@type vim.lsp.Config
local config_cssls = {
  name = "cssls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/vscode-css-language-server",
    "--stdio",
  },
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
  ---@type lspconfig.settings.cssls
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}
lsp_enable(config_cssls)

-- }}}1
-- {{{1 wiki:html-ls

---@type vim.lsp.Config
local config_html_ls = {
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
  ---@type lspconfig.settings.html
  settings = {},
}
lsp_enable(config_html_ls)

-- }}}1
-- {{{1 wiki:jsonls

---@type vim.lsp.Config
local config_jsonls = {
  name = "jsonls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/vscode-json-language-server",
    "--stdio",
  },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  ---@type lspconfig.settings.jsonls
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
lsp_enable(config_jsonls)

-- }}}1
-- {{{1 wiki:gh-actions-lsp

lsp_enable {
  name = "gh-actions-ls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/gh-actions-language-server",
    "--stdio",
  },
  filetypes = { "yaml.github" },
  -- Use a custom lazy value here to postpone slow code
  init_options_lazy = function()
    return lsp_utils.get_ghactions_initoptions()
  end,
}

-- }}}1
-- {{{1 wiki:gitlab-ci-ls

---@type vim.lsp.Config
local config_gitlab_ci_ls = {
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
lsp_enable(config_gitlab_ci_ls)

-- }}}1
-- {{{1 wiki:lua-ls

---@type vim.lsp.Config
local _config_lua_ls = {
  name = "lua-language-server",
  cmd = { "/home/lervag/.local/share/nvim/mason/bin/lua-language-server" },
  filetypes = { "lua" },
  log_level = vim.lsp.protocol.MessageType.Warning,
  root_markers = {
    ".luarc.json",
    ".stylua.toml",
    "stylua.toml",
  },
  ---@type lspconfig.settings.lua_ls
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

-- }}}1
-- {{{1 wiki:emmylua-analyzer-rust

---@type vim.lsp.Config
local config_emmylua = {
  name = "emmylua-ls",
  cmd = { "/home/lervag/.local/share/nvim/mason/bin/emmylua_ls" },
  filetypes = { "lua" },
  root_markers = {
    ".emmyrc.json",
    ".luarc.json",
    ".stylua.toml",
    "stylua.toml",
    "test.lua",
  },
  single_file_support = true,
  ---@type lspconfig.settings.lua_ls
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
lsp_enable(config_emmylua)

-- }}}1
-- {{{1 wiki:kotlin-lsp

---@type vim.lsp.Config
local config_kotlin_lsp = {
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
lsp_enable(config_kotlin_lsp)

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

-- ---@type vim.lsp.Config
-- local config_basedpyright = {
--   name = "basedpyright",
--   disable = function()
--     return true
--   end,
--   cmd = {
--     "/home/lervag/.local/share/nvim/mason/bin/basedpyright-langserver",
--     "--stdio",
--   },
--   filetypes = { "python" },
--   root_markers = {
--     "pyproject.toml",
--     "setup.py",
--     "setup.cfg",
--     "requirements.txt",
--     "Pipfile",
--     "pyrightconfig.json",
--     ".git",
--   },
--   ---@type lspconfig.settings.basedpyright
--   settings = {
--     basedpyright = {
--       analysis = {
--         autoSearchPaths = true,
--         useLibraryCodeForTypes = true,
--         diagnosticMode = "openFilesOnly",
--       },
--     },
--   },
-- }
-- lsp_enable(config_basedpyright)

-- }}}1
-- {{{1 wiki:ty

---@type vim.lsp.Config
local config_ty = {
  name = "ty",
  cmd = { "/home/lervag/.local/share/nvim/mason/bin/ty", "server" },
  -- disable = function() return true end,
  filetypes = { "python" },
  root_markers = {
    "ty.toml",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
  settings = {
    ty = {
      experimental = {
        autoImport = true,
      },
    },
  },
}
lsp_enable(config_ty)

-- }}}1
-- {{{1 wiki:pyrefly

-- ---@type vim.lsp.Config
-- local config_pyrefly = {
--   name = "pyrefly",
--   cmd = { "/home/lervag/.local/share/nvim/mason/bin/pyrefly", "lsp" },
--   disable = function()
--     return true
--   end,
--   filetypes = { "python" },
--   root_markers = {
--     "pyrefly.toml",
--     "pyproject.toml",
--     ".git",
--   },
--   settings = {
--     pyrefly = {},
--   },
-- }
-- lsp_enable(config_pyrefly)

-- }}}1
-- {{{1 wiki:ruff-lsp

---@type vim.lsp.Config
local config_ruff_lsp = {
  name = "ruff",
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    ".git",
  },
  ---@type lspconfig.settings.ruff_lsp
  settings = {
    configurationPreference = "filesystemFirst",
  },
}
lsp_enable(config_ruff_lsp)

-- }}}1
-- {{{1 wiki:rust-analyzer

---@type vim.lsp.Config
local config_rust_analyzer = {
  name = "rust-analyzer",
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  single_file_support = true,
  root_markers = { "Cargo.toml" },
  ---@type lspconfig.settings.rust_analyzer
  settings = {
    ["rust-analyzer"] = {},
  },
}
lsp_enable(config_rust_analyzer)

-- }}}1
-- {{{1 wiki:deno-ls

---@type vim.lsp.Config
local config_deno_ls = {
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
  ---@type lspconfig.settings.denols
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
lsp_enable(config_deno_ls)

-- }}}1
-- {{{1 wiki:tombi

---@type vim.lsp.Config
local config_tombi = {
  name = "tombi",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/tombi",
    "lsp",
  },
  filetypes = { "toml" },
  root_markers = { "pyproject.toml", ".git" },
  ---@param client vim.lsp.Client
  on_init = function(client)
    if not client.server_capabilities then
      return
    end

    client.server_capabilities.semanticTokensProvider = nil
  end,
}
lsp_enable(config_tombi)

-- }}}1
-- {{{1 wiki:typescript-language-server

-- 2025-12-26  --  Tester ut tsgo
---@type vim.lsp.Config
local _config_tsgo = {
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
  ---@type lspconfig.settings.ts_ls
  settings = {
    diagnostics = {
      ignoredCodes = { 6133 },
    },
  },
}

-- }}}1
-- {{{1 wiki:typescript-go

---@type vim.lsp.Config
local config_tsgo = {
  name = "tsgo",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/tsgo",
    "--lsp",
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
  -- init_options = { hostInfo = "neovim" },
  settings = {
    -- diagnostics = {
    --   ignoredCodes = { 6133 },
    -- },
    typescript = {
      inlayHints = {
        parameterNames = {
          enabled = "literals",
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}
lsp_enable(config_tsgo)

-- }}}1
-- {{{1 wiki:vimls

---@type vim.lsp.Config
local config_vimls = {
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
lsp_enable(config_vimls)

-- }}}1
-- {{{1 wiki:yamlls

---@type vim.lsp.Config
local config_yamlls = {
  name = "yamlls",
  cmd = {
    "/home/lervag/.local/share/nvim/mason/bin/yaml-language-server",
    "--stdio",
  },
  filetypes = { "yaml", "yaml.docker-compose" },
  ---@type lspconfig.settings.yamlls
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
  ---@param client vim.lsp.Client
  on_init = function(client)
    if not client.server_capabilities then
      return
    end

    --- https://github.com/neovim/nvim-lspconfig/pull/4016
    --- Since formatting is disabled by default if you check
    --- `client:supports_method('textDocument/formatting')` during `LspAttach`
    --- it will return `false`. This hack sets the capability to `true` to
    --- facilitate autocmd's which check this capability
    client.server_capabilities.documentFormattingProvider = true
  end,
}
lsp_enable(config_yamlls)

-- }}}1

-- vim: fdm=marker
