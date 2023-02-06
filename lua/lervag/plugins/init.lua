local M = {
  -- {{{1 Dev

  {
    url = "git@github.com:lervag/vimtex",
    dev = true,
    init = function()
      -- See also ~/.config/nvim/ftplugin/tex.vim
      vim.g.vimtex_compiler_silent = 1
      vim.g.vimtex_complete_bib = {
        simple = 1,
        menu_fmt = "@year, @author_short, @title",
      }
      vim.g.vimtex_context_pdf_viewer = "sioyek"
      vim.g.vimtex_doc_handlers = { "vimtex#doc#handlers#texdoc" }
      vim.g.vimtex_echo_verbose_input = 0
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_fold_types = {
        markers = { enabled = 0 },
        sections = { parse_levels = 1 },
      }
      vim.g.vimtex_format_enabled = 1
      vim.g.vimtex_imaps_leader = "¨"
      vim.g.vimtex_imaps_list = {
        {
          lhs = "ii", rhs = "\\item ", leader = "",
          wrapper = "vimtex#imaps#wrap_environment",
          context = { "itemize", "enumerate", "description" }
        },
        { lhs = ".",  rhs = "\\cdot" },
        { lhs = "*",  rhs = "\\times" },
        { lhs = "a",  rhs = "\\alpha" },
        { lhs = "r",  rhs = "\\rho" },
        { lhs = "p",  rhs = "\\varphi" },
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
      vim.g.vimtex_view_method = "sioyek"

      vim.g.vimtex_grammar_vlty = {
        lt_command = "languagetool",
        show_suggestions = 1,
      }

      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("init_vimtex", { clear = true }),
        pattern = "VimtexEventViewReverse",
        desc = "VimTeX: Center view on inverse search",
        command = [[ normal! zMzvzz ]]
      })
    end
  },

  {
    url = "git@github.com:lervag/wiki.vim",
    dev = true,
    init = function()
      vim.g.wiki_root = "~/.local/wiki"
      vim.g.wiki_toc_title = "Innhald"
      -- vim.g.wiki_viewer = { _ = "sioyek" }
      vim.g.wiki_export = { output = "printed" }
      vim.g.wiki_filetypes = { "wiki", "md" }
      vim.g.wiki_mappings_local = {
        ["<plug>(wiki-link-toggle-operator)"]  ="gL",
      }
      vim.g.wiki_month_names = {
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
        "Desember"
      }
      vim.g.wiki_template_title_week = "# Samandrag veke %(week), %(year)"
      vim.g.wiki_template_title_month = "# Samandrag frå %(month-name) %(year)"
      vim.g.wiki_write_on_nav = 1

      vim.g.wiki_toc_depth = 2
      vim.g.wiki_file_handler = "personal#wiki#file_handler"

      vim.g.wiki_templates = {
        {
          match_func = function(ctx)
            return ctx.path:sub(-5) == ".wiki"
              and not ctx.path:find("journal/")
          end,
          source_func = function(ctx)
            return vim.fn["personal#wiki#template"](ctx)
          end
        },
      }

      local g = vim.api.nvim_create_augroup("init_wiki", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = g,
        pattern = "WikiLinkFollowed",
        desc = "Wiki: Center view on link follow",
        command = [[ normal! zz ]]
      })
      vim.api.nvim_create_autocmd("User", {
        group = g,
        pattern = "WikiBufferInitialized",
        desc = "Wiki: add mapping for gf",
        command = [[ nmap <buffer> gf <plug>(wiki-link-follow) ]]
      })
    end
  },

  {
    url = "git@github.com:lervag/lists.vim",
    dev = true,
    init = function()
      vim.g.lists_filetypes = { "markdown", "wiki", "help", "text" }
    end
  },

  {
    url = "git@github.com:lervag/file-line",
    dev = true,
  },

  {
    url = "git@github.com:lervag/wiki-ft.vim",
    dev = true,
  },

  {
    url = "git@github.com:lervag/vim-sikt",
    dev = true,
  },

  -- }}}1
  -- {{{1 UI

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
    event = "BufReadPost",
    build = ":TSUpdate",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = "all",
        ignore_install = { "latex" },
        highlight = {
          enable = true,
          disable = { "vim", "markdown", "bibtex", "make" },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<cr>',
            scope_incremental = '<cr>',
            node_incremental = '<tab>',
            node_decremental = '<s-tab>',
          },
        },
        matchup = {
          enable = true,
        }
      }
    end
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
        anchor = "NW",
        relative = "editor",
        prefer_width = 80,
        max_width = nil,
        min_width = nil,
      },
      select = {
        format_item_override = {
          codeaction = function(action_tuple)
            local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
            local client = vim.lsp.get_client_by_id(action_tuple[1])
            return string.format("%s\t[%s]", title:gsub("\n", "\\n"), client.name)
          end,
        }
      },
    }
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      require("notify").setup {
        timeout = 3000,
        stages = {
          function(state)
            local stages_util = require("notify.stages.util")
            local next_height = state.message.height
            local next_row = stages_util.available_slot(
            state.open_windows,
            next_height,
            stages_util.DIRECTION.TOP_DOWN
            )
            if not next_row then
              return nil
            end
            return {
              relative = "editor",
              anchor = "NE",
              focusable = false,
              width = state.message.width,
              height = state.message.height,
              col = vim.opt.columns:get() - 1,
              row = next_row,
              border = { "", "" ,"", " ", " ", " ", " ", " " },
              style = "minimal",
              opacity = 0,
              noautocmd = true,
            }
          end,
          function()
            return {
              opacity = { 100 },
              col = { vim.opt.columns:get() - 1 },
            }
          end,
          function()
            return {
              col = { vim.opt.columns:get() - 1},
              time = true,
            }
          end,
          function()
            return {
              opacity = {
                0,
                frequency = 2,
                complete = function(cur_opacity)
                  return cur_opacity <= 4
                end,
              },
              col = { vim.opt.columns:get() - 1 },
            }
          end,
        },
        render = function(bufnr, notif, highlights, config)
          local base = require("notify.render.base")
          local left_icon = notif.icon .. " "
          local max_message_width = math.max(unpack(vim.tbl_map(function(line)
            return vim.fn.strchars(line)
          end, notif.message)))

          local right_title = notif.title[2]
          local left_title = notif.title[1]
          local title_accum = vim.str_utfindex(left_icon)
          + vim.str_utfindex(right_title)
          + vim.str_utfindex(left_title)

          local left_buffer = string.rep(" ", math.max(0, max_message_width - title_accum))

          local namespace = base.namespace()
          vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "", "" })
          vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
            virt_text = {
              { left_icon, highlights.icon },
              { left_title .. left_buffer, highlights.title },
            },
            virt_text_win_col = 0,
            priority = 10,
          })
          vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
            virt_text = { { " " }, { right_title, highlights.title } },
            virt_text_pos = "right_align",
            priority = 10,
          })
          vim.api.nvim_buf_set_extmark(bufnr, namespace, 1, 0, {
            virt_text = {
              {
                string.rep(
                "─",
                math.max(vim.str_utfindex(left_buffer) + title_accum + 2, config.minimum_width())
                ),
                highlights.border,
              },
            },
            virt_text_win_col = 0,
            priority = 10,
          })
          vim.api.nvim_buf_set_lines(bufnr, 2, -1, false, notif.message)

          vim.api.nvim_buf_set_extmark(bufnr, namespace, 2, 0, {
            hl_group = highlights.body,
            end_line = 1 + #notif.message,
            end_col = #notif.message[#notif.message],
            priority = 50, -- Allow treesitter to override
          })
        end
      }

      vim.notify = require("notify")
    end
  },

  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    config = true
  },

  {
    "justinmk/vim-dirvish",
    config = function()
      vim.g.dirvish_mode = [[:sort ,^.*[\/],]]
      vim.keymap.set("n", "-", "<Plug>(dirvish_up)")
    end
  },

  {
    "Eandrju/cellular-automaton.nvim",
    enabled = false,
  },

  {
    "aduros/ai.vim",
    enabled = false,
    keys = {
      { "<f1>", "<cmd>AI<cr>", mode = "i" },
      { "<f1>", ":AI ", mode = { "n", "x" } },
    },
    config = function()
      vim.g.ai_no_mappings = 1
      -- Highlightrules are also added in colorscheme!
    end
  },

  -- }}}1
  -- {{{1 Completion, LSP and snippets

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
    },
    config = function()
      local kind_icons = {
        Class = "ﴯ",
        Color = "",
        Constant = "",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "",
        Folder = "",
        Function = "",
        Interface = "",
        Keyword = "",
        Method = "",
        Module = "",
        Operator = "",
        Property = "ﰠ",
        Reference = "",
        Snippet = "",
        Struct = "",
        Text = "",
        TypeParameter = "",
        Unit = "",
        Value = "",
        Variable = "",
      }

      local function formatter(entry, item)
        if entry.source.name == "omni" then
          item.kind = "Ѵ"
          return item
        end

        item.kind = kind_icons[item.kind] .. " "
        item.menu = ({
          buffer = "[buffer]",
          nvim_lsp = "[lsp]",
          nvim_lua = "[lua]",
          ultisnips = "[snip]",
        })[entry.source.name]
        if not item.menu then
          item.menu = string.format("[%s]", entry.source.name)
        end

        return item
      end

      local function feedkeys(str, mode)
        local keys = vim.api.nvim_replace_termcodes(str, true, true, true)
        vim.api.nvim_feedkeys(keys, mode or "m", true)
      end

      local cmp = require "cmp"
      cmp.setup {
        snippet = {
          expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end,
        },
        formatting = { format = formatter },
        completion = {
          keyword_length = 2,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "ultisnips" },
          { name = "path",
            option = { trailing_slash = true } },
          { name = "omni" },
          { name = "calc" },
          { name = "nvim_lsp_signature_help" },
        }),
        mapping = {
          ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<c-u>"] = cmp.mapping.confirm({ select = true }),
          ["<c-j>"] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
              feedkeys("<plug>(ultisnips_jump_forward)")
            else
              fallback()
            end
          end),
          ["<c-k>"] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
              feedkeys("<plug>(ultisnips_jump_backward)")
            else
              fallback()
            end
          end),
          ["<cr>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
          }),
          ["<tab>"] = cmp.mapping({
            i = function(_)
              if cmp.visible() then
                cmp.select_next_item()
              elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                feedkeys("<plug>(ultisnips_jump_forward)")
              else
                feedkeys("<tab>", "n")
              end
            end,
            s = function(fallback)
              if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                feedkeys("<plug>(ultisnips_jump_forward)")
              else
                fallback()
              end
            end
          }),
          ["<s-tab>"] = cmp.mapping({
            i = function(_)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                feedkeys("<plug>(ultisnips_jump_backward)")
              else
                feedkeys("<bs>", "n")
              end
            end,
            s = function(fallback)
              if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                feedkeys("<plug>(ultisnips_jump_backward)")
              else
                fallback()
              end
            end
          }),
        },
      }
    end
  },

  {
    "quangnguyen30192/cmp-nvim-ultisnips",
    lazy = true,
    opts = {
      documentation = function(snippet)
        local snippet_docs = string.format(
        "```%s\n%s\n```",
        vim.bo.filetype, snippet.value)
        local formatted = table.concat(
        vim.lsp.util.convert_input_to_markdown_lines(snippet_docs), "\n")
        if snippet.description == "" then
          return formatted
        end

        local description = "*" .. snippet.description:sub(2, -2) .. "*"
        return string.format("%s\n\n%s", description, formatted)
      end
    }
  },

  {
    "SirVer/ultisnips",
    event = "VeryLazy",
    config = function()
      vim.g.UltiSnipsJumpForwardTrigger = "<plug>(ultisnips_jump_forward)"
      vim.g.UltiSnipsJumpBackwardTrigger = "<plug>(ultisnips_jump_backward)"
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
      vim.g.UltiSnipsSnippetDirectories = { vim.env.HOME .. '/.config/nvim/UltiSnips' }

      vim.keymap.set("n", "<leader>es", "<cmd>UltiSnipsEdit!<cr>")
    end
  },

  {
    "neovim/nvim-lspconfig",
    event = "BufReadPost",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Use separate files for each desired LSP placed in
      -- ~/.config/nvim/lua/lervag/lsp/
      local servers = vim.tbl_map(function(x)
          return x:match("([^/]*).lua$")
        end,
        vim.api.nvim_get_runtime_file("lua/lervag/lsp/*.lua", true)
      )

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      for _, server in pairs(servers) do
        local _, user_opts = pcall(require, "lervag.lsp." .. server)
        local opts = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 150
          }
        }, user_opts)
        lspconfig[server].setup(opts)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "Disable semantic token highlighting engine",
        group = vim.api.nvim_create_augroup("init_lsp", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })
    end
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

  -- }}}1
  -- {{{1 Text objects and similar

  {
    "wellle/targets.vim",
    event = "VeryLazy",
    config = function()
      vim.g.targets_argOpening = "[({[]"
      vim.g.targets_argClosing = "[]})]"
      vim.g.targets_separators = ", . ; : + - = ~ _ * # / | \\ &"
      vim.g.targets_seekRanges = "cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA"
    end
  },

  {
    "machakann/vim-sandwich",
    event = "VeryLazy",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      vim.g.sandwich_no_default_key_mappings = 1
      vim.g.operator_sandwich_no_default_key_mappings = 1
      vim.g.textobj_sandwich_no_default_key_mappings = 1

      -- Support for python like function names
      vim.g["sandwich#magicchar#f#patterns"] = {
        {
          header = [[\<\%(\h\k*\.\)*\h\k*]],
          bra = "(",
          ket = ")",
          footer = "",
        },
      }

      -- Change some default options
      vim.fn["operator#sandwich#set"]("delete", "all", "highlight", 0)
      vim.fn["operator#sandwich#set"]("all", "all", "cursor", "keep")

      vim.cmd [[
        " Surround mappings (similar to surround.vim)
        nmap gs  <plug>(operator-sandwich-add)
        nmap gss <plug>(operator-sandwich-add)iW
        nmap ds  <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-query-a)
        nmap dss <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-auto-a)
        nmap cs  <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-query-a)
        nmap css <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-auto-a)
        xmap sa  <plug>(operator-sandwich-add)
        xmap sd  <plug>(operator-sandwich-delete)
        xmap sr  <plug>(operator-sandwich-replace)

        " Text objects
        xmap is  <plug>(textobj-sandwich-query-i)
        xmap as  <plug>(textobj-sandwich-query-a)
        omap is  <plug>(textobj-sandwich-query-i)
        omap as  <plug>(textobj-sandwich-query-a)
        xmap iss <plug>(textobj-sandwich-auto-i)
        xmap ass <plug>(textobj-sandwich-auto-a)
        omap iss <plug>(textobj-sandwich-auto-i)
        omap ass <plug>(textobj-sandwich-auto-a)

        " Allow repeats while keeping cursor fixed
        runtime autoload/repeat.vim
        nmap . <plug>(operator-sandwich-predot)<plug>(RepeatDot)

        " Default recipes
        let g:sandwich#recipes  = deepcopy(g:sandwich#default_recipes)
        let g:sandwich#recipes += [
              \ {
              \   'buns' : ['{\s*', '\s*}'],
              \   'input' : ['}'],
              \   'kind' : ['delete', 'replace', 'auto', 'query'],
              \   'regex' : 1,
              \   'nesting' : 1,
              \   'match_syntax' : 1,
              \   'skip_break' : 1,
              \   'indentkeys-' : '{,},0{,0}'
              \ },
              \ {
              \   'buns' : ['\[\s*', '\s*\]'],
              \   'input' : [']'],
              \   'kind' : ['delete', 'replace', 'auto', 'query'],
              \   'regex' : 1,
              \   'nesting' : 1,
              \   'match_syntax' : 1,
              \   'indentkeys-' : '[,]'
              \ },
              \ {
              \   'buns' : ['(\s*', '\s*)'],
              \   'input' : [')'],
              \   'kind' : ['delete', 'replace', 'auto', 'query'],
              \   'regex' : 1,
              \   'nesting' : 1,
              \   'match_syntax' : 1,
              \   'indentkeys-' : '(,)'
              \ },
              \]
      ]]
    end
  },

  -- {{{1 Finder, motions, and tags

  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    init = function()
      -- vim.keymap.set('n', '<leader><leader>', function() telescope.extensions.frecency.frecency() end)
      vim.keymap.set('n', '<leader><leader>', function() require('telescope.builtin').oldfiles() end)
      vim.keymap.set('n', '<leader>ot', function() require('telescope.builtin').tags() end)
      vim.keymap.set('n', '<leader>ob', function() require('telescope.builtin').buffers() end)
      vim.keymap.set('n', '<leader>og', function() require('telescope.builtin').git_files() end)

      vim.keymap.set('n', '<leader>ev', function() require('lervag.util.ts').files_nvim() end)
      vim.keymap.set('n', '<leader>ez', function() require('lervag.util.ts').files_dotfiles() end)

      vim.keymap.set('n', '<leader>oo', function() require('lervag.util.ts').files() end)
      vim.keymap.set('n', '<leader>op', function() require('lervag.util.ts').files_plugged() end)
      vim.keymap.set('n', '<leader>ow', function() require('lervag.util.ts').files_wiki() end)
      vim.keymap.set('n', '<leader>oz', function() require('lervag.util.ts').files_zotero() end)
    end,
    config = function()
      -- https://github.com/nvim-telescope/telescope.nvim/issues/559
      local function stopinsert(callback)
        return function(prompt_bufnr)
          vim.cmd.stopinsert()
          vim.schedule(function() callback(prompt_bufnr) end)
        end
      end

      local actions = require("telescope.actions")
      require("telescope").setup {
        defaults = {
          sorting_strategy = 'ascending',
          results_title = false,
          preview = {
            hide_on_startup = true,
          },
          layout_strategy = 'center',
          layout_config = {
            width = 0.95,
            height = 0.99,
          },
          file_ignore_patterns = {
            "%.git/",
            "/tags$",
          },
          history = false,
          borderchars = { "═", " ", " ", " ", " ", " ", " ", " " },
          mappings = {
            n = {
              ["q"] = "close",
              ["<esc>"] = "close",
            },
            i = {
              ["<cr>"] = stopinsert(actions.select_default),
              ["|"] = stopinsert(actions.select_horizontal),
              ["<c-v>"] = stopinsert(actions.select_vertical),
              ["<esc>"] = "close",
              ["<C-h>"] = "which_key",
              ["<C-u>"] = false,
              ["<C-x>"] = "toggle_selection",
            }
          }
        },
        pickers = {
          find_files = {
            follow = true,
            hidden = true,
            no_ignore = true,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
          },
        },
        extensions = {
          fzf = {
            case_mode = "smart_case",
            fuzzy = false,
            override_file_sorter = true,
            override_generic_sorter = true,
          },
          frecency = {
            show_scores = true,
            ignore_patterns = {
              "*.git/*",
              "*/tmp/*",
              "*.cache/*",
              "*.local/wiki/*",
              "/usr/*",
            },
          }
        }
      }

      require("telescope").load_extension('fzf')
    end
  },

  {
    "ludovicchabant/vim-gutentags",
    event = "VeryLazy",
    config = function()
      vim.g.gutentags_define_advanced_commands = 1
      vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. '/ctags'
      vim.g.gutentags_ctags_extra_args = {
        "--tag-relative=yes",
        "--fields=+aimS",
      }
      vim.g.gutentags_file_list_command = {
        markers = {
          ['.git'] = 'git ls-files',
          ['.hg'] = 'hg files',
        },
      }
    end
  },

  {
    "dyng/ctrlsf.vim",
    cmd = "CtrlSF",
    keys = {
      { "<leader>ff", ":CtrlSF ", desc = "CtrlSF" },
      { "<leader>ft", "<cmd>CtrlSFToggle<cr>", desc = "CtrlSFToggle" },
      { "<leader>fu", "<cmd>CtrlSFUpdate<cr>", desc = "CtrlSFUpdate" },
      { "<leader>f", "<plug>CtrlSFVwordExec", mode = "x", desc = "CtrlSF" },
    },
    config = function()
      vim.g.ctrlsf_indent = 2
      vim.g.ctrlsf_regex_pattern = 1
      vim.g.ctrlsf_position = "bottom"
      vim.g.ctrlsf_context = "-B 2"
      vim.g.ctrlsf_default_root = "project+fw"
      vim.g.ctrlsf_populate_qflist = 1
      if vim.fn.executable("rg") then
        vim.g.ctrlsf_ackprg = "rg"
      end
    end
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
    end
  },

  -- {{{1 Debugging, and code runners

  {
    "mfussenegger/nvim-dap",
    event = "BufReadPost",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "nvim-treesitter/nvim-treesitter" }
      },
      "jbyuki/one-small-step-for-vimkind",
      {
        "HiPhish/debugpy.nvim",
        config = function()
          local default_config = {
            justMyCode = false,
          }

          require("debugpy").run = function(config)
            require("dap").run(vim.tbl_extend('keep', config, default_config))
          end
        end
      },
    },
    config = function()
      -- NOTE: This script defines the global dap configuration. Adapters and
      --       configurations are defined elsewhere. Assuming I remember to update
      --       the following list, these are the relevant files:
      --
      --       Python
      --         ~/.config/nvim/init/plugins/debugpy.lua
      --         ~/.config/nvim/ftplugin/python.lua
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

      -- Load virtual text extension
      require "nvim-dap-virtual-text".setup {
        virt_lines = true
      }

      -- Define sign symbols
      vim.fn.sign_define({
        { text='🡆', texthl='DapSign', name = 'DapStopped', linehl='CursorLine'},
        { text='●', texthl='DapSign', name = 'DapBreakpoint'},
        { text='', texthl='DapSign', name = 'DapBreakpointCondition'},
        { text='▪', texthl='DapSign', name = 'DapBreakpointRejected'},
        { text='◉', texthl='DapSign', name = 'DapLogPoint'},
      })

      dap.listeners.before['event_terminated']['my-plugin'] = function(session, body)
        print('Session terminated', vim.inspect(session), vim.inspect(body))
      end

      local mappings = {
        ['<leader>dd'] = dap.continue,
        ['<leader>dD'] = dap.run_last,
        ['<leader>dc'] = dap.run_to_cursor,
        ['<leader>dx'] = dap.terminate,
        ['<leader>dp'] = dap.step_back,
        ['<leader>dn'] = dap.step_over,
        ['<leader>dj'] = dap.step_into,
        ['<leader>dk'] = dap.step_out,

        ['<leader>dl'] = function()
          dap.list_breakpoints()
          vim.cmd [[ :copen ]]
        end,
        ['<leader>db'] = dap.toggle_breakpoint,
        ['<leader>dB'] = function()
          vim.ui.input({ prompt = "Breakpoint condition: " },
          function(condition)
            dap.set_breakpoint(condition)
          end)
        end,

        ['<leader>dw'] = function()
          vim.ui.input({ prompt = "Watch: " },
          function(watch)
            dap.set_breakpoint(nil, nil, watch)
          end)
        end,
        ['<leader>dW'] = function()
          vim.ui.input({ prompt = "Watch condition: " },
          function(condition)
            vim.ui.input({ prompt = "Watch: " },
            function(watch)
              dap.set_breakpoint(condition, nil, watch)
            end)
          end)
        end,

        ['<leader>dK'] = dap.up,
        ['<leader>dJ'] = dap.down,
        ['<leader>dr'] = dap.repl.toggle,
        ['<leader>dh'] = widgets.hover,
        ['<leader>dH'] = function()
          vim.ui.input({ prompt = "Evaluate: " },
          function(expr)
            widgets.hover(expr)
          end)
        end,
        ['<leader>dF'] = function()
          widgets.centered_float(widgets.frames)
        end,
        ['<leader>dL'] = function()
          widgets.centered_float(widgets.scopes)
        end,
      }

      for lhs, rhs in pairs(mappings) do
        vim.keymap.set('n', lhs, rhs)
      end
    end
  },

  -- {{{1 Editing

  {
    "tpope/vim-commentary",
    keys = {
      { "gc", mode = { "n", "v", "o" } },
    },
  },
  {
    "tpope/vim-repeat",
    -- config = function()
    --   vim.cmd.source "autoload/repeat.vim"
    -- end
  },

  {
    "junegunn/vim-easy-align",
    keys = {
      {
        "<leader>ea", "<plug>(LiveEasyAlign)",
        mode = { "n", "v" },
        desc = "LiveEasyAlign"
      },
      {
        "<leader>eA", "<plug>(EasyAlign)",
        mode = { "n", "v" },
        desc = "EasyAlign"
      },
      {
        ".", "<plug>(EasyAlignRepeat)",
        mode = "v",
        desc = "EasyAlignRepeat"
      },
    },
    config = function()
      vim.g.easy_align_bypass_fold = 1
    end
  },

  {
    "dhruvasagar/vim-table-mode",
    event = "BufReadPost",
    config = function()
      vim.g.table_mode_auto_align = 0
      vim.g.table_mode_corner = '|'
    end
  },


  {
    "monaqa/dial.nvim",
    lazy = true,
    init = function()
      vim.keymap.set("n", "<C-a>",  function() return require("dial.map").inc_normal()  end, { expr = true })
      vim.keymap.set("n", "<C-x>",  function() return require("dial.map").dec_normal()  end, { expr = true })
      vim.keymap.set("v", "<C-a>",  function() return require("dial.map").inc_visual()  end, { expr = true })
      vim.keymap.set("v", "<C-x>",  function() return require("dial.map").dec_visual()  end, { expr = true })
      vim.keymap.set("v", "g<C-a>", function() return require("dial.map").inc_gvisual() end, { expr = true })
      vim.keymap.set("v", "g<C-x>", function() return require("dial.map").dec_gvisual() end, { expr = true })
    end,
    config = function()
      local augend = require("dial.augend")
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
            elements = {"yes", "no"},
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = {"and", "or"},
            word = true,
            cyclic = true,
          },
          augend.case.new {
            types = {"camelCase", "snake_case"},
            cyclic = true,
          },
        },
      }
    end
  },

  {
    "ggandor/leap.nvim",
    keys = {
      {"s", "<plug>(leap-forward)"},
      {"S", "<plug>(leap-backward)"},
      {"z", "<plug>(leap-forward)", mode = { "x", "o" }},
      {"Z", "<plug>(leap-backward)", mode = { "x", "o" }},
    },
    config = function()
      opts = require('leap').opts
      opts.case_sensitive = true
      opts.labels = {
          "s", "f", "n", "j", "k",
          "l", "o", "d", "w", "e",
          "h", "m", "v", "g", "u",
          "t", "c", ".", "z"
        }
      opts.safe_labels = {}
    end
  },

  {
    "booperlv/nvim-gomove",
    keys = {
      {"<left>", "<plug>GoNSMLeft"},
      {"<down>", "<plug>GoNSMDown"},
      {"<up>", "<plug>GoNSMUp"},
      {"<right>", "<plug>GoNSMRight"},
      {"<c-left>", "<plug>GoNSDLeft"},
      {"<c-down>", "<plug>GoNSDDown"},
      {"<c-up>", "<plug>GoNSDUp"},
      {"<c-right>", "<plug>GoNSDRight"},
      {"<left>", "<plug>GoVSMLeft", mode = "x"},
      {"<down>", "<plug>GoVSMDown", mode = "x"},
      {"<up>", "<plug>GoVSMUp", mode = "x"},
      {"<right>", "<plug>GoVSMRight", mode = "x"},
      {"<c-left>", "<plug>GoVSDLeft", mode = "x"},
      {"<c-down>", "<plug>GoVSDDown", mode = "x"},
      {"<c-up>", "<plug>GoVSDUp", mode = "x"},
      {"<c-right>", "<plug>GoVSDRight", mode = "x"},
    },
    opts = {
      map_defaults = false,
      move_past_end_col = true,
    }
  },

  {
    "brianrodri/vim-sort-folds",
    keys = {
      { "<leader>s", "<cmd>call sortfolds#SortFolds()<cr>" },
    }
  },

  {
    "AndrewRadev/inline_edit.vim",
    keys = {
      { "<leader>ee", "<cmd>InlineEdit<cr>" },
      { "<leader>ee", ":InlineEdit ", mode = "x" },
    },
    config = function()
      vim.g.inline_edit_proxy_type = "tempfile"
      -- vim.g.inline_edit_modify_statusline = 0
      -- vim.g.inline_edit_new_buffer_command = "tabedit"
    end
  },

  {
    "AndrewRadev/linediff.vim",
    keys = {
      { "<leader>ed", "<cmd>Linediff<cr> ", mode = "x" },
      { "<leader>ed", "<plug>(linediff-operator)" },
    },
    config = function()
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("init_linediff", { clear = true }),
        pattern = "LinediffBufferReady",
        desc = "Linediff buffer ready",
        command = [[ nnoremap <buffer> <leader>eq :LinediffReset<cr> ]]
      })
    end
  },

  -- {{{1 VCS

  {
    "tpope/vim-fugitive",
    dependencies = {
      {
        "tpope/vim-rhubarb",
        config = function()
          -- I only want GBrowse functionality from rhubarb
          vim.g.loaded_rhubarb = 1
        end
      },
    },
    cmd = { "Git", "Gedit", "Gdiff" },
    keys = {
      { "<leader>gs", function() require("lervag.util.git").toggle_fugitive() end },
      { "<leader>gd", "<cmd>Gdiff<cr>:WinResize<cr>" },
      { "<leader>gb", ":GBrowse<cr>", mode = { "n", "x" } },
      { "<leader>gB", "<cmd>Telescope git_branches<cr>" },
    },
    config = function()
      -- See also:
      -- * ftplugin/fugitive.vim
      -- * ftplugin/git.vim
      -- * ftplugin/gitcommit.vim
      vim.g.fugitive_browse_handlers = {
        vim.fn["rhubarb#FugitiveUrl"],
      }
      local g = vim.api.nvim_create_augroup("init_fugitive", { clear = true })
      vim.api.nvim_create_autocmd("WinEnter", {
        group = g,
        pattern = "index",
        desc = "Fugitive: reload status",
        callback = function() vim.fn["fugitive#ReloadStatus"](-1, 0) end
      })
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = g,
        pattern = "fugitive://",
        desc = "Fugitive: hidden fugitive buffers",
        callback = function() vim.bo.bufhidden = "delete" end
      })
    end
  },

  {
    "rbong/vim-flog",
    dependencies = { "tpope/vim-fugitive" },
    cmd = { "Flog" },
    keys = {
      { "<leader>gl", "<cmd>Flog -all<cr>", mode = { "n", "x" } },
      { "<leader>gL", "<cmd>Flog -all -path=%<cr>" },
    },
    config = function()
      -- See also ftplugin/floggraph.vim
      vim.g.flog_default_opts = {
        format = "[%h] %s%d",
        date = "format:%Y-%m-%d %H:%M",
      }
    end
  },

  {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_patterns = { ".git", ".hg", ".bzr", ".svn" }
      vim.g.rooter_silent_chdir = 1
    end
  },

  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- {{{1 Tmux (incl. filetype)

  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end
  },

  {
    "benmills/vimux",
    cmd = { "VimuxOpenRunner" },
    keys = {
      { "<leader>io", "<cmd>call VimuxOpenRunner()<cr>" },
      { "<leader>iq", "<cmd>VimuxCloseRunner<cr>" },
      { "<leader>ip", "<cmd>VimuxPromptCommand<cr>" },
      { "<leader>in", "<cmd>VimuxInspectRunner<cr>" },
      { "<leader>ii", "<cmd>VimuxRunCommand 'jkk'<cr>" },
      { "<leader>is", "<cmd>set opfunc=personal#vimux#operator<cr>g@" },
      { "<leader>iss", "<cmd>call VimuxRunCommand(getline('.'))<cr>" },
      { "<leader>is", [["vy :call VimuxSendText(@v)<cr>]], mode = "x" },
    },
    init = function()
      vim.g.VimuxOrientation = "h"
      vim.g.VimuxHeight = "50"
      vim.g.VimuxResetSequence = ""
    end
  },

  -- {{{1 Various

  {
    "itchyny/calendar.vim",
    keys = {
      { "<leader>c", "<cmd>Calendar -position=here<cr>" },
    },
    init = function()
      -- See also ftplugin/calendar.vim
      vim.g.calendar_first_day = "monday"
      vim.g.calendar_date_endian = "big"
      vim.g.calendar_frame = "space"
      vim.g.calendar_week_number = 1
    end
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
    "tpope/vim-unimpaired",
    event = "VeryLazy",
  },

  {
    "chrisbra/Colorizer",
    event = "BufReadPost",
    config = function()
      vim.g.colorizer_auto_filetype = "css,html"
      vim.g.colorizer_colornames = 0

      local g = vim.api.nvim_create_augroup("init_colorizer", { clear = true })
      vim.api.nvim_create_autocmd("BufRead", {
        group = g,
        pattern = "my_solarized_lua.lua",
        desc = "Activate colorizer for colorscheme file",
        command = "ColorHighlight"
      })
    end
  },

  {
    "nvim-colortils/colortils.nvim",
    event = "BufReadPost",
    opts = {
      background = '#e0dac9',
      color_preview =  "██ %s",
      border = "single",
      mappings = {
        replace_default_format = "<cr>",
        replace_choose_format = "<m-cr>",
        set_register_default_format = "g<cr>",
        set_register_choose_format = "g<m-cr>",
        -- export = "E",
        -- set_value = "c",
        -- transparency = "T",
      }
    }
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
    "Konfekt/FastFold",
    enabled = false,
    config = function()
      vim.g.fastfold_fold_command_suffixes =  { "x", "X", "M", "R" }
      vim.g.fastfold_fold_movement_commands = {}
    end
  },

  -- {{{1 Various filetype plugins

  {
    url = "https://gitlab.com/yorickpeterse/nvim-pqf",
    event = "VeryLazy",
    config = function()
      require('pqf').setup {
        show_multiple_lines = true,
        signs = {
          error = '',
          warning = '',
          info = '',
          hint = ''
        }
      }
    end
  },

  { "Vimjas/vim-python-pep8-indent" },

  -- Metals is configured in
  -- lua/lervag/util/metals.lua
  --
  -- It is loaded manually in ftplugin/{scala,sbt}.lua
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
      vim.g.vim_markdown_conceal = 2
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_strikethrough = 1
    end
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
    end
  },

  {
    "tpope/vim-scriptease",
  },

  {
    "darvelo/vim-systemd",
  },

  {
    "gregsexton/MatchTag",
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

  -- }}}1
}

return M

-- vim: fdm=marker
