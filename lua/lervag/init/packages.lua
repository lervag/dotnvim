local my_border = require("lervag.const").border

---@type LazySpec
local M = {
  -- Personal
  {
    url = "git@github.com:lervag/vimtex",
    dev = true,
    init = function()
      -- See also ~/.config/nvim/ftplugin/tex.lua
      vim.g.vimtex_compiler_silent = 1
      vim.g.vimtex_complete_bib = {
        simple = 1,
        menu_fmt = "@year, @author_short, @title",
      }
      vim.g.vimtex_context_pdf_viewer = "zathura"
      vim.g.vimtex_doc_handlers = { "vimtex#doc#handlers#texdoc" }
      vim.g.vimtex_fold_types = {
        markers = { enabled = 0 },
        sections = { parse_levels = 1 },
      }
      vim.g.vimtex_format_enabled = 1
      vim.g.vimtex_imaps_leader = "¨"
      vim.g.vimtex_imaps_list = {
        {
          lhs = "ii",
          rhs = "\\item ",
          leader = "",
          wrapper = "vimtex#imaps#wrap_environment",
          context = { "itemize", "enumerate", "description" },
        },
        { lhs = ".", rhs = "\\cdot" },
        { lhs = "*", rhs = "\\times" },
        { lhs = "a", rhs = "\\alpha" },
        { lhs = "r", rhs = "\\rho" },
        { lhs = "p", rhs = "\\varphi" },
      }
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_quickfix_ignore_filters = { "Generic hook" }
      vim.g.vimtex_syntax_conceal_disable = 1
      vim.g.vimtex_toc_config = {
        split_pos = "full",
        mode = 2,
        fold_enable = 1,
        show_help = 0,
        hotkeys_enabled = 1,
        hotkeys_leader = "",
        refresh_always = 0,
      }
      vim.g.vimtex_view_automatic = 0
      vim.g.vimtex_view_forward_search_on_start = 0
      vim.g.vimtex_view_method = "zathura"

      vim.g.vimtex_grammar_vlty = {
        lt_command = "languagetool",
        show_suggestions = 1,
      }

      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("init_vimtex", {}),
        pattern = "VimtexEventViewReverse",
        desc = "VimTeX: Center view on inverse search",
        command = [[ normal! zMzvzz ]],
      })
    end,
  },
  {
    url = "git@github.com:lervag/wiki.vim",
    dev = true,
    init = function()
      vim.g.wiki_root = "~/.local/wiki"
      vim.g.wiki_filetypes = { "wiki", "md" }
      vim.g.wiki_toc_title = "Innhald"
      vim.g.wiki_viewer = { pdf = "zathura" }
      vim.g.wiki_export = { output = "printed" }
      vim.g.wiki_mappings_local = {
        ["<plug>(wiki-link-transform-operator)"] = "gL",
        ["<plug>(wiki-link-remove)"] = "dsl",
      }
      vim.g.wiki_toc_depth = 2
      vim.g.wiki_link_schemes = {
        gl = {
          resolver = function(url)
            local parts = vim.split(url.stripped, "/")

            local scheme = "https"
            local type
            if parts[3]:sub(1, 1) == "!" then
              type = "/-/merge_requests/"
              parts[3] = parts[3]:sub(2)
            else
              type = "/-/issues/"
            end

            local stripped = "gitlab.sikt.no/"
              .. parts[1]
              .. "/"
              .. parts[2]
              .. type
              .. parts[3]

            return {
              scheme = scheme,
              stripped = stripped,
              url = scheme .. "://" .. stripped,
            }
          end,
        },
        jira = {
          resolver = function(url)
            return {
              scheme = "https",
              stripped = "unit.atlassian.net/browse/" .. url.stripped,
              url = "https://unit.atlassian.net/browse/" .. url.stripped,
            }
          end,
        },
        file = {
          handler = vim.fn["personal#wiki#file_handler"],
        },
        hn = {
          resolver = function(url)
            return {
              scheme = "https",
              url = "https://news.ycombinator.com/item?id=" .. url.stripped,
            }
          end,
        },
      }

      vim.g.wiki_template_month_names = {
        "Januar",
        "Februar",
        "Mars",
        "April",
        "Mai",
        "Juni",
        "Juli",
        "August",
        "September",
        "Oktober",
        "November",
        "Desember",
      }
      vim.g.wiki_template_title_week = "# Samandrag veke %(week), %(year)"
      vim.g.wiki_template_title_month = "# Samandrag frå %(month-name) %(year)"

      vim.g.wiki_templates = {
        {
          match_func = function(ctx)
            return ctx.path:sub(-5) == ".wiki" and not ctx.path:find "journal/"
          end,
          source_func = function(ctx)
            return vim.fn["personal#wiki#template"](ctx)
          end,
        },
      }

      local g = vim.api.nvim_create_augroup("init_wiki", {})
      vim.api.nvim_create_autocmd("User", {
        group = g,
        pattern = "WikiLinkFollowed",
        desc = "Wiki: Center view on link follow",
        command = [[ normal! zz ]],
      })
      vim.api.nvim_create_autocmd("User", {
        group = g,
        pattern = "WikiBufferInitialized",
        desc = "Wiki: add mapping for gf",
        command = [[ nmap <buffer> gf <plug>(wiki-link-follow) ]],
      })
    end,
  },
  {
    url = "git@github.com:lervag/lists.vim",
    dev = true,
    init = function()
      vim.g.lists_filetypes = { "md", "wiki", "txt" }
    end,
  },
  {
    url = "git@github.com:lervag/file-line",
    dev = true,
  },
  {
    url = "git@github.com:lervag/wiki-ft.vim",
    dev = true,
  },

  -- UI
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "<leader>qq",
        "<cmd>Trouble diagnostics_local_or_error toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>ls",
        "<cmd>Trouble symbols toggle<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>ll",
        "<cmd>Trouble lsp toggle<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
    },
    opts = {
      auto_preview = false,
      preview = {
        type = "main",
        wo = {
          number = true,
          foldenable = false,
        },
      },
      modes = {
        diagnostics_local_or_error = {
          mode = "diagnostics",
          filter = {
            any = {
              buf = 0,
              {
                severity = vim.diagnostic.severity.ERROR,
                function(item)
                  return item.filename:find(vim.loop.cwd(), 1, true)
                end,
              },
            },
          },
          win = {
            size = 0.4,
            wo = {
              winhighlight = "",
            },
          },
        },
        symbols = {
          focus = true,
          win = {
            size = 70,
          },
        },
        lsp = {
          focus = true,
          win = {
            position = "right",
            size = 70,
          },
        },
      },
    },
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_override_vimtex = 1
      vim.g.matchup_transmute_enabled = 1
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = "all",
        highlight = {
          enable = true,
          disable = { "latex" },
        },
        indent = {
          enable = true,
          disable = { "latex" },
        },
        matchup = {
          enable = true,
        },
      }

      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "ZenMode" },
    },
    opts = {
      window = {
        backdrop = 1,
        width = 120,
        height = 1,
      },
      plugins = {
        tmux = { enabled = true },
      },
      on_open = function(_)
        vim.cmd [[
        call system('xdotool windowstate --toggle FULLSCREEN $(xdotool getactivewindow)')
        ]]
      end,
      on_close = function()
        vim.cmd [[
        call system('xdotool windowstate --toggle FULLSCREEN $(xdotool getactivewindow)')
        ]]
      end,
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        prompt_align = "center",
        relative = "editor",
        prefer_width = 80,
        max_width = nil,
        min_width = nil,
        border = my_border,
      },
      select = {
        telescope = {
          layout_config = {
            width = 0.9,
            height = 0.9,
          },
        },
      },
    },
  },
  {
    "echasnovski/mini.icons",
    opts = {
      lsp = {
        snippet = {
          glyph = "",
        },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "echasnovski/mini.notify",
    config = function()
      local mininotify = require "mini.notify"

      vim.keymap.set("n", "<leader>n", mininotify.show_history)

      mininotify.setup {
        content = {
          format = function(notif)
            return " " .. notif.msg
          end,
          sort = function(notif_arr)
            local res, present_msg = {}, {}
            for _, notif in ipairs(notif_arr) do
              if not present_msg[notif.msg] then
                table.insert(res, notif)
                present_msg[notif.msg] = true
              end
            end
            return mininotify.default_sort(res)
          end,
        },

        lsp_progress = {
          enable = true,
          duration_last = 3000,
        },

        window = {
          config = function(buf_id)
            local line_widths = vim.tbl_map(
              vim.fn.strdisplaywidth,
              vim.api.nvim_buf_get_lines(buf_id, 0, -1, true)
            )
            local width = 15
            for _, l_w in ipairs(line_widths) do
              width = math.max(width, l_w)
            end

            local height = 0
            for _, l_w in ipairs(line_widths) do
              height = height + math.floor(math.max(l_w - 1, 0) / width) + 1
            end

            return {
              row = 1,
              width = math.min(width + 1, math.floor(0.8 * vim.o.columns)),
              height = height,
              border = { "┏", " ", " ", " ", " ", " ", "┗", "┃" },
              title = "NOTIFICATIONS",
              title_pos = "right",
            }
          end,
          winblend = 0,
        },
      }

      vim.notify = mininotify.make_notify()
    end,
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      view_options = {
        natural_order = false,
        show_hidden = true,
      },
      keymaps = {
        q = "actions.close",
        ["<c-h>"] = false,
        ["<c-l>"] = false,
      },
      float = {
        border = my_border,
      },
      preview = {
        border = my_border,
      },
    },
  },
  {
    "Robitx/gp.nvim",
    keys = {
      { "<f1>", "<cmd>GpChatToggle<cr>", desc = "GpChat" },
    },
    cmd = {
      "GpImage",
      "GpChatNew",
      "GpChatPaste",
      "GpChatToggle",
      "GpChatFinder",
    },
    opts = {
      openai_api_key = { "pass", "openai-api-key" },
      toggle_target = "tabnew",
      agents = {
        {
          name = "ChatGPT4o",
          chat = true,
          command = false,
          model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
          system_prompt = "You are a general AI assistant.\n\n"
            .. "The user provided the additional info about how they would like you to respond:\n\n"
            .. "- Be brief and consise!\n"
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. "- Ask question if you need clarification to provide better answer.\n"
            .. "- Think deeply and carefully from first principles step by step.\n"
            .. "- Zoom out first to see the big picture and then zoom in to details.\n"
            .. "- Use Socratic method to improve your thinking and coding skills.\n"
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n"
        },
        {
          name = "o1-mini",
          chat = true,
          command = false,
          model = { model = "o1-mini", temperature = 1.1, top_p = 1 },
          system_prompt = "You are a general AI assistant.\n\n"
            .. "The user provided the additional info about how they would like you to respond:\n\n"
            .. "- Be brief and consise!\n"
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. "- Ask question if you need clarification to provide better answer.\n"
            .. "- Think deeply and carefully from first principles step by step.\n"
            .. "- Zoom out first to see the big picture and then zoom in to details.\n"
            .. "- Use Socratic method to improve your thinking and coding skills.\n"
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n"
        },
      },
    },
    config = function(opts)
      require('gp').setup(opts.opts)

      -- Monkey patch the dispatcher after setup
      local dispatcher = require 'gp.dispatcher'
      local original_prepare_payload = dispatcher.prepare_payload
      dispatcher.prepare_payload = function(messages, model, provider)
        local output = original_prepare_payload(messages, model, provider)
        if provider == 'openai' and model.model:sub(1, 2) == 'o3' then
          for i = #messages, 1, -1 do
            if messages[i].role == 'system' then
              table.remove(messages, i)
            end
          end
          output.max_tokens = nil
          output.temperature = nil
          output.top_p = nil
          output.stream = true
        end
        return output
      end
    end
  },
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      render = function(props)
        local snippet = {}
        local us_ok, us_canjump = pcall(vim.fn["UltiSnips#CanJumpForwards"])
        if us_ok and us_canjump > 0 then
          local trigger =
            vim.fn.pyeval "UltiSnips_Manager._active_snippets[0].snippet.trigger"
          if #trigger == 0 then
            trigger = "lsp"
          end
          snippet = {
            (" %s"):format(trigger),
            group = "Underlined",
          }
        end

        local diagnostics = {}
        for _, cfg in ipairs {
          {
            severity = vim.diagnostic.severity.ERROR,
            group = "DiagnosticVirtualTextError",
            symbol = " ",
          },
          {
            severity = vim.diagnostic.severity.WARN,
            group = "DiagnosticVirtualTextWarn",
            symbol = " ",
          },
          {
            severity = vim.diagnostic.severity.INFO,
            group = "DiagnosticVirtualTextInfo",
            symbol = " ",
          },
          {
            severity = vim.diagnostic.severity.HINT,
            group = "DiagnosticVirtualTextHint",
            symbol = " ",
          },
        } do
          local n = #vim.diagnostic.get(props.buf, { severity = cfg.severity })
          if n > 0 then
            local label = (#diagnostics > 0 and " " or "") .. cfg.symbol .. n
            table.insert(diagnostics, { label, group = cfg.group })
          end
        end

        local width_warning = {}
        if props.focused and vim.o.modifiable and not vim.o.readonly then
          local textwidth = vim.o.textwidth
          local width = vim.fn.charcol "$" - 1
          if textwidth > 0 and width > textwidth then
            width_warning = {
              ("  %s > %s"):format(width, textwidth),
              group = "DiagnosticVirtualTextError",
            }
          end
        end

        ---@param left integer
        ---@param right integer
        ---@return string | table
        local function separator(left, right)
          if left > 0 and right > 0 then
            return { " │ ", group = "MatchWord" }
          end
          return ""
        end

        return {
          snippet,
          separator(#snippet, #diagnostics + #width_warning),
          diagnostics,
          separator(#snippet + #diagnostics, #width_warning),
          width_warning,
        }
      end,
    },
  },

  -- Completion, LSP and snippets
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lua",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "Allaman/emoji.nvim",
    },
    config = function()
      local function feedkeys(str, mode)
        local keys = vim.api.nvim_replace_termcodes(str, true, true, true)
        vim.api.nvim_feedkeys(keys, mode or "m", true)
      end

      local cmp = require "cmp"

      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
        },
        formatting = {
          format = function(entry, item)
            if entry.source.name == "omni" then
              local icon, hl = MiniIcons.get("filetype", "vim")
              item.kind = icon .. " "
              item.kind_hl_group = hl
              item.menu = item.menu:gsub("[%[%]]", "")
              return item
            end

            local icon, hl = MiniIcons.get("lsp", item.kind)
            item.kind = icon .. " " .. item.kind:lower()
            item.kind_hl_group = hl

            if not item.menu then
              item.menu = ({
                nvim_lsp = "lsp",
                nvim_lua = "luals",
                ultisnips = "snip",
              })[entry.source.name] or string.format(
                "%s",
                entry.source.name
              )
            end

            return item
          end,
        },
        completion = {
          keyword_length = 2,
        },
        preselect = cmp.PreselectMode.None,
        experimental = {
          ghost_text = { hl_group = "CmpGhostText" },
        },
        sources = {
          { name = "ultisnips" },
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "path", option = { trailing_slash = true } },
          { name = "emoji" },
          { name = "calc" },
        },
        mapping = {
          ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<c-u>"] = cmp.mapping.confirm { select = true },
          ["<c-j>"] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
              feedkeys "<plug>(ultisnips_jump_forward)"
            else
              fallback()
            end
          end),
          ["<c-k>"] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
              feedkeys "<plug>(ultisnips_jump_backward)"
            else
              fallback()
            end
          end),
          ["<cr>"] = function(fallback)
            if cmp.visible() then
              cmp.mapping.abort()
            end
            fallback()
          end,
          ["<C-l>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              return cmp.complete_common_string()
            end
            fallback()
          end, { "i", "c" }),
          ["<tab>"] = cmp.mapping {
            i = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                feedkeys "<plug>(ultisnips_jump_forward)"
              else
                fallback()
              end
            end,
            s = function(fallback)
              if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                feedkeys "<plug>(ultisnips_jump_forward)"
              else
                fallback()
              end
            end,
          },
          ["<s-tab>"] = cmp.mapping {
            i = function(_)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                feedkeys "<plug>(ultisnips_jump_backward)"
              else
                feedkeys("<bs>", "n")
              end
            end,
            s = function(fallback)
              if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                feedkeys "<plug>(ultisnips_jump_backward)"
              else
                fallback()
              end
            end,
          },
          ["<c-n>"] = cmp.mapping {
            i = function(fallback)
              if cmp.visible() then
                cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
              else
                fallback()
              end
            end,
          },
          ["<c-p>"] = cmp.mapping {
            i = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
              else
                fallback()
              end
            end,
          },
        },
      }

      cmp.setup.filetype("lua", {
        sources = {
          { name = "ultisnips" },
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "path", option = { trailing_slash = true } },
          { name = "calc" },
        },
      })

      cmp.setup.filetype("wiki", {
        sources = {
          { name = "ultisnips" },
          { name = "omni", trigger_characters = { "[" } },
          { name = "path", option = { trailing_slash = true } },
          { name = "emoji" },
          { name = "calc" },
        },
      })

      cmp.setup.filetype("tex", {
        sources = {
          { name = "ultisnips" },
          { name = "vimtex" },
          { name = "path", option = { trailing_slash = true } },
          { name = "calc" },
        },
      })

      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = {
          { name = "ultisnips" },
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "vim-dadbod-completion" },
          { name = "path", option = { trailing_slash = true } },
          { name = "calc" },
        },
      })

      cmp.setup.filetype({ "markdown", "help" }, {
        window = {
          documentation = cmp.config.disable,
        },
      })
    end,
  },
  {
    "micangl/cmp-vimtex",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    ft = "tex",
  },
  {
    "quangnguyen30192/cmp-nvim-ultisnips",
    lazy = true,
    opts = {
      documentation = function(snippet)
        local snippet_docs =
          string.format("```%s\n%s\n```", vim.bo.filetype, snippet.value)
        local formatted = table.concat(
          vim.lsp.util.convert_input_to_markdown_lines(snippet_docs),
          "\n"
        )
        if snippet.description == "" then
          return formatted
        end

        local description = "*" .. snippet.description:sub(2, -2) .. "*"
        return string.format("%s\n\n%s", description, formatted)
      end,
    },
  },
  {
    "SirVer/ultisnips",
    event = "VeryLazy",
    config = function()
      vim.g.UltiSnipsJumpForwardTrigger = "<plug>(ultisnips_jump_forward)"
      vim.g.UltiSnipsJumpBackwardTrigger = "<plug>(ultisnips_jump_backward)"
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
      vim.g.UltiSnipsSnippetDirectories =
        { vim.env.HOME .. "/.config/nvim/UltiSnips" }

      vim.keymap.set("n", "<leader>es", "<cmd>UltiSnipsEdit!<cr>")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
  },
  {
    "glepnir/lspsaga.nvim",
    cmd = "Lspsaga",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("lspsaga").setup {
        symbol_in_winbar = {
          enable = false,
        },
        lightbulb = {
          enable_in_insert = false,
          sign = false,
        },
        callhierarchy = {
          layout = "normal",
        },
        ui = {
          code_action = " ",
          title = false,
          border = my_border,
        },
      }
    end,
  },
  {
    "nvim-lua/lsp-status.nvim",
    lazy = true,
  },
  {
    "barreiroleo/ltex-extra.nvim",
    lazy = true,
  },
  {
    "mfussenegger/nvim-jdtls",
    lazy = true,
  },
  {
    "stevearc/conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format {
            async = true,
            lsp_format = "fallback",
          }
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          markdown = {
            "prettierd",
            "markdownlint",
            "markdown-toc",
          },
          graphql = { "prettierd" },
          groovy = { "npm-groovy-lint" },
          javascript = { "prettierd" },
          sql = { "pg_format" },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPost",
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        typescript = { "eslint_d" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        graphql = { "eslint_d" },
      }

      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "chrisgrieser/nvim-rulebook",
    keys = {
      {
        "<leader>qri",
        function()
          require("rulebook").ignoreRule()
        end,
      },
      {
        "<leader>qrl",
        function()
          require("rulebook").lookupRule()
        end,
      },
      {
        "<leader>lF",
        function()
          require("rulebook").suppressFormatter()
        end,
        mode = { "n", "x" },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
    },
    keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "gitlab-ci-ls",
        "black",
        "markdown-toc",
        "markdownlint",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- Text objects and similar
  {
    "echasnovski/mini.ai",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    lazy = false,
    keys = {
      { "sas", "saiW", remap = true },
    },
    config = function()
      local catchall = {
        { "%b()", "^.().*().$" },
        { "%b[]", "^.().*().$" },
        { "%b{}", "^.().*().$" },
        { "'.-'", "^.().*().$" },
        { '".-"', "^.().*().$" },
        { "`.-`", "^.().*().$" },
      }

      require("mini.surround").setup {
        custom_surroundings = {
          d = { input = catchall },
          r = { input = catchall },
        },
        n_lines = 50,
      }
    end,
  },

  -- Finder, motions, and tags
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "Allaman/emoji.nvim",
    },
    cmd = "Telescope",
    init = function()
      vim.keymap.set("n", "<leader><leader>", function()
        require("telescope.builtin").oldfiles()
      end)
      vim.keymap.set("n", "<leader>ob", function()
        require("telescope.builtin").buffers()
      end)
      vim.keymap.set("n", "<leader>og", function()
        require("telescope.builtin").git_files()
      end)

      vim.keymap.set("n", "<leader>ev", function()
        require("lervag.util.ts").files_nvim()
      end)
      vim.keymap.set("n", "<leader>ez", function()
        require("lervag.util.ts").files_dotfiles()
      end)

      vim.keymap.set("n", "<leader>oo", function()
        require("lervag.util.ts").files()
      end)
      vim.keymap.set("n", "<leader>op", function()
        require("lervag.util.ts").files_plugged()
      end)
      vim.keymap.set("n", "<leader>ow", function()
        require("lervag.util.ts").files_wiki()
      end)
      vim.keymap.set("n", "<leader>oz", function()
        require("lervag.util.ts").files_zotero()
      end)
    end,
    config = function()
      -- https://github.com/nvim-telescope/telescope.nvim/issues/559
      local function stopinsert(callback)
        return function(prompt_bufnr)
          vim.cmd.stopinsert()
          vim.schedule(function()
            callback(prompt_bufnr)
          end)
        end
      end

      local actions = require "telescope.actions"
      local telescope = require "telescope"
      telescope.setup {
        defaults = {
          create_layout = require("lervag.util.ts_layout").layout,
          sorting_strategy = "ascending",
          preview = {
            hide_on_startup = true,
          },
          file_ignore_patterns = {
            "%.git/",
            "/tags$",
          },
          history = false,
          mappings = {
            n = {
              ["q"] = "close",
              ["<esc>"] = "close",
            },
            i = {
              ["<cr>"] = stopinsert(actions.select_default),
              ["|"] = stopinsert(actions.select_horizontal),
              ["<c-v>"] = stopinsert(actions.select_vertical),
              ["<tab>"] = "move_selection_next",
              ["<s-tab>"] = "move_selection_previous",
              ["<esc>"] = "close",
              ["<C-h>"] = "which_key",
              ["<C-u>"] = false,
              ["<C-x>"] = "toggle_selection",
            },
          },
        },
        pickers = {
          find_files = {
            follow = true,
            hidden = true,
            find_command = {
              "fd",
              "--type",
              "f",
              "--color",
              "never",
              "--strip-cwd-prefix",
            },
          },
        },
        extensions = {
          fzf = {
            case_mode = "smart_case",
            fuzzy = false,
            override_file_sorter = true,
            override_generic_sorter = true,
          },
        },
      }

      telescope.load_extension "fzf"
    end,
  },
  {
    "rgroli/other.nvim",
    -- See wiki:other.nvim
    command = "Other",
    keys = {
      { "<leader>ot", "<cmd>Other<cr>", desc = "Other" },
      { "<leader>ov", "<cmd>OtherVSplit<cr>", desc = "OtherVSplit" },
    },
    config = function()
      require("other-nvim").setup {
        mappings = {
          {
            pattern = "(.*)src/main/(.*).scala$",
            target = "%1src/test/%2Test.scala",
            context = "Scala test",
          },
          {
            pattern = "(.*)src/main/(.*).scala$",
            target = "%1src/test/%2Spec.scala",
            context = "Scala test",
          },
          {
            pattern = "(.*)src/test/(.*)Spec.scala$",
            target = "%1src/main/%2.scala",
            context = "Scala implementation",
          },
          {
            pattern = "(.*)src/test/(.*)Test.scala$",
            target = "%1src/main/%2.scala",
            context = "Scala implementation",
          },
        },
      }
    end,
  },
  {
    "dyng/ctrlsf.vim",
    cmd = "CtrlSF",
    keys = {
      { "<leader>ff", ":CtrlSF ", desc = "CtrlSF" },
      { "<leader>ft", "<cmd>CtrlSFToggle<cr>", desc = "CtrlSFToggle" },
      { "<leader>fu", "<cmd>CtrlSFUpdate<cr>", desc = "CtrlSFUpdate" },
      {
        "<leader>ff",
        "<plug>CtrlSFVwordExec",
        mode = "x",
        desc = "CtrlSF",
      },
    },
    config = function()
      vim.g.ctrlsf_indent = 2
      vim.g.ctrlsf_regex_pattern = 1
      vim.g.ctrlsf_position = "bottom"
      vim.g.ctrlsf_context = "-B 2"
      vim.g.ctrlsf_default_root = "project+fw"
      vim.g.ctrlsf_populate_qflist = 1
      vim.g.ctrlsf_extra_backend_args = {
        rg = "--hidden",
      }
    end,
  },
  {
    "machakann/vim-columnmove",
    event = "VeryLazy",
    config = function()
      vim.g.columnmove_no_default_key_mappings = 1

      vim.fn["columnmove#utility#map"]("nxo", "f", "øf", "block")
      vim.fn["columnmove#utility#map"]("nxo", "t", "øt", "block")
      vim.fn["columnmove#utility#map"]("nxo", "F", "øF", "block")
      vim.fn["columnmove#utility#map"]("nxo", "T", "øT", "block")
      vim.fn["columnmove#utility#map"]("nxo", ";", "ø;", "block")
      vim.fn["columnmove#utility#map"]("nxo", ",", "ø,", "block")
      vim.fn["columnmove#utility#map"]("nxo", "w", "øw", "block")
      vim.fn["columnmove#utility#map"]("nxo", "b", "øb", "block")
      vim.fn["columnmove#utility#map"]("nxo", "e", "øe", "block")
      vim.fn["columnmove#utility#map"]("nxo", "W", "øW", "block")
      vim.fn["columnmove#utility#map"]("nxo", "B", "øB", "block")
      vim.fn["columnmove#utility#map"]("nxo", "E", "øE", "block")
      vim.fn["columnmove#utility#map"]("nxo", "ge", "øge", "block")
      vim.fn["columnmove#utility#map"]("nxo", "gE", "øgE", "block")
    end,
  },

  -- Debugging, and code runners
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = true,
      },
      {
        "LiadOz/nvim-dap-repl-highlights",
        config = true,
      },
    },
    config = function()
      -- NOTE: This script defines the global dap configuration. Adapters and
      --       configurations are defined elsewhere. Assuming I remember to
      --       update the following list, these are the relevant files:
      --
      --       Python
      --         ~/.config/nvim/ftplugin/python.lua
      --         Plugin: "HiPhish/debugpy.nvim" (see below)
      --
      --       Java:
      --         ~/.config/nvim/ftplugin/java.lua
      --
      --       Scala:
      --         ~/.config/nvim/ftplugin/scala.lua
      --
      --       Lua:
      --         ~/.config/nvim/ftplugin/lua.lua

      local dap = require "dap"
      local widgets = require "dap.ui.widgets"

      dap.set_log_level "INFO"

      dap.listeners.before.attach.dapui_config = function()
        require("dapui").open()
      end
      dap.listeners.before.launch.dapui_config = function()
        require("dapui").open()
      end
      dap.listeners.before.event_exited.dapui_config = function(_, status)
        require("dapui").close()
        vim.notify("Process finished (exit code = " .. status.exitCode .. ")")
      end
      dap.listeners.before.disconnect.dapui_config = function()
        require("dapui").close()
        dap.repl.close()
      end

      -- Define sign symbols
      vim.fn.sign_define {
        -- stylua: ignore start
        { text = "🡆", texthl = "DapSign", name = "DapStopped", linehl = "CursorLine" },
        { text = "●", texthl = "DapSign", name = "DapBreakpoint" },
        { text = "", texthl = "DapSign", name = "DapBreakpointCondition" },
        { text = "▪", texthl = "DapSign", name = "DapBreakpointRejected" },
        { text = "◉", texthl = "DapSign", name = "DapLogPoint" },
        -- stylua: ignore end
      }

      ---@diagnostic disable: missing-fields
      local mappings = {
        ["<leader>dd"] = dap.continue,
        ["<leader>dD"] = dap.run_last,
        ["<leader>dc"] = dap.run_to_cursor,
        ["<leader>dx"] = dap.terminate,
        ["<leader>dX"] = function()
          require("dapui").close()
        end,
        ["<leader>dp"] = dap.step_back,
        ["<leader>dn"] = dap.step_over,
        ["<leader>dj"] = dap.step_into,
        ["<leader>dk"] = dap.step_out,
        ["<leader>dK"] = dap.up,
        ["<leader>dJ"] = dap.down,
        ["<leader>dr"] = dap.repl.toggle,
        ["<leader>db"] = dap.toggle_breakpoint,
        ["<leader>d<c-b>"] = dap.clear_breakpoints,
        ["<leader>dB"] = function()
          vim.ui.input(
            { prompt = "Breakpoint condition: " },
            function(condition)
              dap.set_breakpoint(condition)
            end
          )
        end,
        ["<leader>dw"] = function()
          vim.ui.input({ prompt = "Watch: " }, function(watch)
            dap.set_breakpoint(nil, nil, watch)
          end)
        end,
        ["<leader>dW"] = function()
          vim.ui.input({ prompt = "Watch condition: " }, function(condition)
            vim.ui.input({ prompt = "Watch: " }, function(watch)
              dap.set_breakpoint(condition, nil, watch)
            end)
          end)
        end,
        ["<leader>dh"] = function()
          widgets.hover("<cexpr>", {
            border = my_border,
            title = " hover ",
          })
        end,
        ["<leader>de"] = function()
          require("dapui").eval()
        end,
        ["<leader>dE"] = function()
          vim.ui.input({
            prompt = " evaluate ",
            border = my_border,
          }, function(expr)
            widgets.hover(expr, {
              border = my_border,
              title = " evaluated: " .. expr .. " ",
            })
          end)
        end,
      }

      for lhs, rhs in pairs(mappings) do
        vim.keymap.set("n", lhs, rhs)
      end

      vim.keymap.set("v", "<leader>de", function()
        require("dapui").eval()
      end)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    opts = {
      controls = { enabled = false },
      icons = {
        current_frame = "🡆",
      },
      layouts = {
        {
          elements = {
            { id = "stacks", size = 0.25 },
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 45,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 1.0 },
          },
          size = 20,
          position = "bottom",
        },
      },
    },
  },
  {
    "HiPhish/debugpy.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    cmd = "Debugpy",
    config = function()
      require("debugpy").run = function(cfg)
        require("dap").run(vim.tbl_extend("keep", cfg, {
          justMyCode = false,
        }))
      end
    end,
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    lazy = true,
    keys = {
      {
        "<leader>dl",
        [[:lua require "osv".launch {port = 8086}<cr>]],
        desc = "Launch OSV server",
      },
    },
  },
  {
    "andrewferrier/debugprint.nvim",
    opts = {
      filetypes = {
        scala = {
          left = 'println("',
          left_var = 'println(s"',
          mid_var = "${",
          right = '")',
          right_var = '})"',
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- input = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
    },
  },

  -- Editing
  {
    "tpope/vim-repeat",
  },
  {
    "junegunn/vim-easy-align",
    keys = {
      {
        -- See plugin/align.vim
        "ga",
        "<plug>(align)",
        mode = { "n", "v" },
        desc = "My custom LiveEasyAlign",
      },
    },
    config = function()
      vim.g.easy_align_bypass_fold = 1
    end,
  },
  {
    "dhruvasagar/vim-table-mode",
    event = "BufReadPost",
    config = function()
      vim.g.table_mode_auto_align = 0
      vim.g.table_mode_corner = "|"
    end,
  },
  {
    "monaqa/dial.nvim",
    lazy = true,
    init = function()
      vim.keymap.set("n", "<C-a>", function()
        return require("dial.map").manipulate("increment", "normal")
      end)
      vim.keymap.set("n", "<C-x>", function()
        return require("dial.map").manipulate("decrement", "normal")
      end)
      vim.keymap.set("v", "<C-a>", function()
        return require("dial.map").manipulate("increment", "visual")
      end)
      vim.keymap.set("v", "<C-x>", function()
        return require("dial.map").manipulate("decrement", "visual")
      end)
      vim.keymap.set("n", "g<C-a>", function()
        return require("dial.map").manipulate("increment", "gnormal")
      end)
      vim.keymap.set("n", "g<C-x>", function()
        return require("dial.map").manipulate("decrement", "gnormal")
      end)
      vim.keymap.set("v", "g<C-a>", function()
        return require("dial.map").manipulate("increment", "gvisual")
      end)
      vim.keymap.set("v", "g<C-x>", function()
        return require("dial.map").manipulate("decrement", "gvisual")
      end)
    end,
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%d/%m/%Y"],
          augend.date.alias["%H:%M:%S"],
          augend.semver.alias.semver,
          augend.hexcolor.new {
            case = "lower",
          },
          augend.constant.alias.bool,
          augend.constant.new {
            elements = { "yes", "no" },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "and", "or" },
            word = true,
            cyclic = true,
          },
          augend.case.new {
            types = { "camelCase", "snake_case" },
            cyclic = true,
          },
        },
      }
    end,
  },
  {
    "booperlv/nvim-gomove",
    enabled = false,
    keys = {
      { "<left>", "<plug>GoNSMLeft", desc = "nvim-gomove" },
      { "<down>", "<plug>GoNSMDown", desc = "nvim-gomove" },
      { "<up>", "<plug>GoNSMUp", desc = "nvim-gomove" },
      { "<right>", "<plug>GoNSMRight", desc = "nvim-gomove" },
      { "<c-left>", "<plug>GoNSDLeft", desc = "nvim-gomove" },
      { "<c-down>", "<plug>GoNSDDown", desc = "nvim-gomove" },
      { "<c-up>", "<plug>GoNSDUp", desc = "nvim-gomove" },
      { "<c-right>", "<plug>GoNSDRight", desc = "nvim-gomove" },
      { "<left>", "<plug>GoVSMLeft", mode = "x", desc = "nvim-gomove" },
      { "<down>", "<plug>GoVSMDown", mode = "x", desc = "nvim-gomove" },
      { "<up>", "<plug>GoVSMUp", mode = "x", desc = "nvim-gomove" },
      { "<right>", "<plug>GoVSMRight", mode = "x", desc = "nvim-gomove" },
      { "<c-left>", "<plug>GoVSDLeft", mode = "x", desc = "nvim-gomove" },
      { "<c-down>", "<plug>GoVSDDown", mode = "x", desc = "nvim-gomove" },
      { "<c-up>", "<plug>GoVSDUp", mode = "x", desc = "nvim-gomove" },
      { "<c-right>", "<plug>GoVSDRight", mode = "x", desc = "nvim-gomove" },
    },
    opts = {
      map_defaults = false,
      move_past_end_col = true,
    },
  },
  {
    "AndrewRadev/inline_edit.vim",
    keys = {
      { "<leader>ee", "<cmd>InlineEdit<cr>", desc = "inline_edit" },
      { "<leader>ee", ":InlineEdit ", mode = "x", desc = "inline_edit" },
    },
    init = function()
      vim.g.inline_edit_proxy_type = "tempfile"
      vim.g.inline_edit_modify_statusline = 0
      vim.g.inline_edit_patterns = {
        {
          main_filetype = "wiki",
          callback = "inline_edit#MarkdownFencedCode",
        },
        {
          main_filetype = "hurl",
          callback = "inline_edit#MarkdownFencedCode",
        },
        {
          main_filetype = "scala",
          sub_filetype = "sql",
          indent_adjustment = 1,
          include_margins = 1,
          start = [[\(sql\|SQL\)"""]],
          ["end"] = [["""]],
        },
      }
    end,
  },
  {
    "AndrewRadev/linediff.vim",
    keys = {
      { "<leader>ed", ":Linediff<cr> ", mode = "x", desc = "linediff" },
      { "<leader>ed", "<plug>(linediff-operator)", desc = "linediff" },
    },
    config = function()
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("init_linediff", {}),
        pattern = "LinediffBufferReady",
        desc = "Linediff buffer ready",
        command = [[ nnoremap <buffer> <leader>eq :LinediffReset<cr> ]],
      })
    end,
  },
  {
    "xorid/asciitree.nvim",
    cmd = { "AsciiTree" },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    opts = {
      filetypes = {
        wiki = {
          template = "![$CURSOR]($FILE_PATH)",
          dir_path = "aux",
        },
      },
      files = {
        ["/home/lervag/notes.md"] = {
          dir_path = "/home/lervag/documents/anki/lervag/collection.media/",
          template = "![$FILE_NAME_NO_EXT]($FILE_NAME)",
        },
      },
      custom = {
        {
          -- For apy edit notes
          trigger = function() -- returns true to enable
            return vim.fn.bufname():match "^edit_node_.+%.md"
          end,
          dir_path = "/home/lervag/documents/anki/lervag/collection.media/",
          template = "![$FILE_NAME_NO_EXT]($FILE_NAME)",
        },
      },
    },
    keys = {
      { "<leader>ep", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
  },
  {
    "Allaman/emoji.nvim",
    lazy = true,
    opts = {
      enable_cmp_integration = true,
      plugin_path = vim.fn.expand "$HOME/.local/plugged/",
    },
  },
  {
    "Wansmer/treesj",
    keys = {
      {
        "gS",
        function()
          require("treesj").toggle()
        end,
        desc = "TreeSJ Toggle",
      },
    },
    config = function()
      require("treesj").setup {
        use_default_keymaps = false,
      }
    end,
  },
  {
    "aaronik/treewalker.nvim",
    keys = {
      { "<up>", "<cmd>Treewalker Up<cr>", mode = { "n", "v" } },
      { "<down>", "<cmd>Treewalker Down<cr>", mode = { "n", "v" } },
      { "<left>", "<cmd>Treewalker Left<cr>", mode = { "n", "v" } },
      { "<right>", "<cmd>Treewalker Right<cr>", mode = { "n", "v" } },
      { "<s-up>", "<cmd>Treewalker SwapUp<cr>", mode = { "n", "v" } },
      { "<s-down>", "<cmd>Treewalker SwapDown<cr>", mode = { "n", "v" } },
    },
    config = true,
  },

  -- VCS
  {
    "tpope/vim-fugitive",
    lazy = false,
    dependencies = {
      {
        "tpope/vim-rhubarb",
        init = function()
          vim.g.loaded_rhubarb = 1
        end,
      },
      {
        "shumphrey/fugitive-gitlab.vim",
        init = function()
          vim.g.loaded_fugitive_gitlab = 1
          vim.g.fugitive_gitlab_domains = { "https://gitlab.sikt.no" }
        end,
      },
    },
    cmd = { "Git", "Gedit", "Gdiff" },
    keys = {
      {
        "<leader>gs",
        function()
          require("lervag.util.git").toggle_fugitive()
        end,
        desc = "fugitive",
      },
      { "<leader>gd", "<cmd>Gdiff<cr>:WinResize<cr>", desc = "fugitive" },
      { "<leader>gb", ":GBrowse<cr>", mode = { "n", "x" }, desc = "fugitive" },
      {
        "<leader>gB",
        function()
          require("telescope.builtin").git_branches()
        end,
        desc = "fugitive",
      },
    },
    config = function()
      -- See also:
      -- * ftplugin/fugitive.vim
      -- * ftplugin/git.vim
      -- * ftplugin/gitcommit.vim
      vim.g.fugitive_browse_handlers = {
        vim.fn["rhubarb#FugitiveUrl"],
        vim.fn["gitlab#fugitive#handler"],
      }
      local g = vim.api.nvim_create_augroup("init_fugitive", {})
      vim.api.nvim_create_autocmd("WinEnter", {
        group = g,
        pattern = "index",
        desc = "Fugitive: reload status",
        callback = function()
          vim.fn["fugitive#ReloadStatus"](-1, 0)
        end,
      })
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = g,
        pattern = "fugitive://",
        desc = "Fugitive: hidden fugitive buffers",
        callback = function()
          vim.bo.bufhidden = "delete"
        end,
      })

      -- oil.nvim disables netrw and thus the :Browse command, which is needed
      -- by fugitive for :GBrowse.
      vim.api.nvim_create_user_command("Browse", function(args)
        vim.ui.open(args.args)
      end, {
        desc = "Enables using GBrowse without netrw",
        nargs = 1,
      })
    end,
  },
  {
    "echasnovski/mini.diff",
    lazy = false,
    keys = {
      {
        "yod",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle diff overlay",
      },
    },
    opts = {
      view = {
        signs = { add = "▕▏", change = "▕▏", delete = "▁▁" },
      },
    },
  },
  {
    "rbong/vim-flog",
    dependencies = { "tpope/vim-fugitive" },
    cmd = { "Flog" },
    keys = {
      {
        "<leader>gl",
        function()
          local branch = vim.fn.FugitiveHead()
          local branch_origin = "origin/" .. branch
          if pcall(vim.fn["fugitive#RevParse"], branch_origin) then
            branch_origin = " " .. branch_origin
          else
            branch_origin = ""
          end
          vim.cmd("Flog -- HEAD " .. branch .. branch_origin)
        end,
        desc = "Flog",
      },
    },
    config = function()
      -- See also ftplugin/floggraph.vim
      vim.g.flog_enable_dynamic_commit_hl = true
      vim.g.flog_enable_extended_chars = true
      vim.g.flog_default_opts = {
        format = "%h %s%d",
        date = "format:%Y-%m-%d %H:%M",
      }
    end,
  },
  {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_patterns = { ".git", ".hg", ".bzr", ".svn", "build.sbt" }
      vim.g.rooter_silent_chdir = 1
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    keys = {
      {
        "<leader>gL",
        "<cmd>DiffviewFileHistory %<cr>",
        silent = true,
        desc = "diffview.nvim",
      },
      {
        "<leader>gL",
        ":DiffviewFileHistory<cr>",
        mode = { "x" },
        silent = true,
        desc = "diffview.nvim",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local diffview = require "diffview"

      local quit_diffview = function()
        if vim.g.mergemode then
          vim.cmd "quitall!"
        else
          diffview.close()
        end
      end

      diffview.setup {
        enhanced_diff_hl = true,
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
          file_history = {
            disable_diagnostics = true,
          },
        },
        -- See defaults here:
        -- ~/.local/plugged/diffview.nvim/lua/diffview/config.lua:120
        keymaps = {
          file_panel = {
            ["<leader>e"] = false,
            ["<leader>eq"] = quit_diffview,
          },
          file_history_panel = {
            ["<leader>e"] = false,
            ["<leader>eq"] = quit_diffview,
          },
          view = {
            ["<leader>e"] = false,
            ["<leader>eq"] = quit_diffview,
            ["<leader>ee"] = function()
              diffview.emit "toggle_stage_entry"
            end,
          },
        },
      }

      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = "diffview:///panels/*",
        callback = function()
          if vim.api.nvim_win_get_config(0).zindex then
            vim.api.nvim_win_set_config(0, {
              border = my_border,
            })
          end
        end,
      })
    end,
  },

  -- Tmux (incl. filetype)
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "tmux-navigator" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "tmux-navigator" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "tmux-navigator" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "tmux-navigator" },
    },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
  },
  {
    "benmills/vimux",
    cmd = { "VimuxOpenRunner" },
    keys = {
      { "<leader>io", "<cmd>call VimuxOpenRunner()<cr>", desc = "vimux" },
      { "<leader>iq", "<cmd>VimuxCloseRunner<cr>", desc = "vimux" },
      { "<leader>ip", "<cmd>VimuxPromptCommand<cr>", desc = "vimux" },
      { "<leader>in", "<cmd>VimuxInspectRunner<cr>", desc = "vimux" },
      { "<leader>ii", "<cmd>VimuxRunCommand 'jkk'<cr>", desc = "vimux" },
      {
        "<leader>is",
        "<cmd>set opfunc=personal#vimux#operator<cr>g@",
        desc = "vimux",
      },
      {
        "<leader>iss",
        "<cmd>call VimuxRunCommand(getline('.'))<cr>",
        desc = "vimux",
      },
      {
        "<leader>is",
        [["vy :call VimuxSendText(@v)<cr>]],
        mode = "x",
        desc = "vimux",
      },
    },
    init = function()
      vim.g.VimuxOrientation = "h"
      vim.g.VimuxHeight = "50"
      vim.g.VimuxResetSequence = ""
    end,
  },

  -- Various
  {
    "oclay1st/maven.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Maven", "MavenInit", "MavenExec" },
    keys = {
      {
        "<Leader>M",
        function()
          require("maven").toggle_projects_view()
        end,
        desc = "Maven",
      },
    },
    opts = {
      dependencies_view = {
        resolved_dependencies_win = {
          border = { style = my_border },
        },
        dependency_usages_win = {
          border = { style = my_border },
        },
        filter_win = {
          border = { style = my_border },
        },
      },
      initializer_view = {
        name_win = {
          border = { style = my_border },
        },
        package_win = {
          border = { style = my_border },
        },
        archetypes_win = {
          input_win = {
            border = { style = my_border },
          },
          options_win = {
            border = { style = my_border },
          },
        },
        archetype_version_win = {
          border = { style = my_border },
        },
        workspaces_win = {
          border = { style = my_border },
        },
      },
      execute_view = {
        input_win = {
          border = { style = my_border },
        },
        options_win = {
          border = { style = my_border },
        },
      },
      help_view = {
        border = { style = my_border },
      },
    },
  },
  {
    "itchyny/calendar.vim",
    keys = {
      {
        "<leader>c",
        "<cmd>Calendar -position=here<cr>",
        desc = "calendar.vim",
      },
    },
    init = function()
      -- See also ftplugin/calendar.vim
      vim.g.calendar_first_day = "monday"
      vim.g.calendar_date_endian = "big"
      vim.g.calendar_frame = "space"
      vim.g.calendar_week_number = 1
    end,
  },
  {
    "tweekmonster/helpful.vim",
    cmd = { "HelpfulVersion" },
  },
  {
    "tyru/capture.vim",
    cmd = { "Capture" },
  },
  {
    "idanarye/nvim-impairative",
    event = "VeryLazy",
    config = function()
      local impairative = require "impairative"

      impairative
        .toggling({
          enable = "[o",
          disable = "]o",
          toggle = "yo",
          show_message = true,
        })
        :option({ key = "h", option = "hlsearch" })
        :option({ key = "l", option = "list" })
        :option({ key = "n", option = "number" })
        :option({ key = "r", option = "relativenumber" })
        :option({ key = "s", option = "spell" })
        :option { key = "w", option = "wrap" }

      impairative
        .operations({ backward = "[", forward = "]" })
        :command_pair({
          key = "l",
          backward = "lprevious",
          forward = "lnext",
        })
        :command_pair({
          key = "L",
          backward = "lfirst",
          forward = "llast",
        })
        :command_pair({
          key = "q",
          backward = "cprevious",
          forward = "cnext",
        })
        :command_pair({
          key = "Q",
          backward = "cfirst",
          forward = "clast",
        })
        :command_pair({
          key = "t",
          backward = "tprevious",
          forward = "tnext",
        })
        :command_pair({
          key = "T",
          backward = "tfirst",
          forward = "tlast",
        })
        :jump_in_buf({
          key = "n",
          desc = "jump to the {previous|next} SCM conflict marker or diff/path hunk",
          extreme = {
            key = "N",
            desc = "jump to the {first|last} SCM conflict marker or diff/path hunk",
          },
          fun = require("impairative.helpers").conflict_marker_locations,
        })
        :text_manipulation({
          key = "u",
          line_key = true,
          desc = "{encode|decode} URL",
          backward = require("impairative.helpers").encode_url,
          forward = require("impairative.helpers").decode_url,
        })
        :text_manipulation({
          key = "x",
          line_key = true,
          desc = "{encode|decode} XML",
          backward = require("impairative.helpers").encode_xml,
          forward = require("impairative.helpers").decode_xml,
        })
        :text_manipulation({
          key = "y",
          line_key = true,
          desc = "{escape|unescape} strings (C escape rules)",
          backward = require("impairative.helpers").encode_string,
          forward = require("impairative.helpers").decode_string,
        })
        :text_manipulation {
          key = "C",
          line_key = true,
          desc = "{escape|unescape} strings (C escape rules)",
          backward = require("impairative.helpers").encode_string,
          forward = require("impairative.helpers").decode_string,
        }
    end,
  },
  {
    "uga-rosa/ccc.nvim",
    cmd = {
      "CccPick",
      "CccConvert",
      "CccHighlighterEnable",
      "CccHighlighterDisable",
      "CccHighlighterToggle",
    },
    keys = {
      { "<f4>", "<cmd>CccPick<cr>", desc = "ccc.nvim" },
      { "<s-f4>", "<cmd>CccHighlighterToggle<cr>", desc = "ccc.nvim" },
      { "<f16>", "<cmd>CccHighlighterToggle<cr>", desc = "ccc.nvim" },
    },
    config = function()
      local ccc = require "ccc"
      ccc.setup {
        point_char = "❚",
        empty_point_bg = false,
        inputs = {
          ccc.input.rgb,
          ccc.input.hsv,
          ccc.input.hsl,
          ccc.input.cmyk,
        },
        win_opts = {
          border = my_border,
        },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("init_ccc", {}),
        pattern = "solarized_custom.lua",
        desc = "Activate CccHighlighter for colorscheme file",
        command = "CccHighlighterEnable",
      })
    end,
  },
  {
    "chrisbra/Colorizer",
    cmd = { "ColorHighlight" },
  },
  {
    "dstein64/vim-startuptime",
    cmd = { "StartupTime" },
  },
  {
    "echuraev/translate-shell.vim",
    cmd = { "Trans" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      {
        "tpope/vim-dadbod",
        lazy = true,
      },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true,
      },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "kelvinauta/focushere.nvim",
    cmd = { "FocusHere", "FocusClear" },
    keys = {
      { "zF", ":FocusClear<cr>" },
      { "zf", ":FocusHere<cr>", mode = "v" },
    },
    config = true,
  },

  -- Various filetype plugins
  {
    "yorickpeterse/nvim-pqf",
    event = "VeryLazy",
    config = function()
      require("pqf").setup {
        show_multiple_lines = true,
        signs = {
          error = { text = "", hl = "DiagnosticSignError" },
          warning = { text = "", hl = "DiagnosticSignWarn" },
          info = { text = "", hl = "DiagnosticSignInfo" },
          hint = { text = "", hl = "DiagnosticSignHint" },
        },
      }
    end,
  },
  {
    "Vimjas/vim-python-pep8-indent",
  },
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "preservim/vim-markdown",
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_follow_anchor = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_toml_frontmatter = 1
      vim.g.vim_markdown_new_list_item_indent = 2
      vim.g.vim_markdown_no_extensions_in_markdown = 1
      vim.g.vim_markdown_no_default_key_mappings = 1
      vim.g.vim_markdown_conceal = 2
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_strikethrough = 1
    end,
  },
  {
    "gpanders/vim-medieval",
    config = function()
      vim.g.medieval_langs = {
        "python=python3",
        "sh",
        "bash",
        "console=bash",
      }
    end,
  },
  {
    "tpope/vim-scriptease",
  },
  {
    "darvelo/vim-systemd",
  },
  {
    "tpope/vim-apathy",
  },
  {
    "chunkhang/vim-mbsync",
  },
  {
    "tridactyl/vim-tridactyl",
  },
  {
    "hat0uma/csvview.nvim",
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      },
      view = {
        display_mode = "border",
      },
    },
  },
}

return M
