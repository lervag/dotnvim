vim.pack.add {
  "https://github.com/Allaman/emoji.nvim",
  "https://github.com/hrsh7th/cmp-calc",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help",
  "https://github.com/hrsh7th/cmp-nvim-lua",
  "https://github.com/hrsh7th/cmp-omni",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/nvim-cmp",
}

require("lervag.util").load_on("InsertEnter", function()
  require("emoji").setup {
    enable_cmp_integration = true,
    plugin_path = vim.fn.expand "$HOME/.local/share/nvim/site/pack/core/opt/",
  }

  local cmp_entry = require "cmp.entry"
  local cmp = require "cmp"

  cmp_entry.get_documentation = require("lervag.util.cmp").get_documentation

  local function feedkeys(str, mode)
    local keys = vim.api.nvim_replace_termcodes(str, true, true, true)
    vim.api.nvim_feedkeys(keys, mode or "m", true)
  end

  cmp.setup {
    snippet = {
      expand = function(args)
        local insert = require("mini.snippets").config.expand.insert
          or require("mini.snippets").default_insert
        insert { body = args.body }
        cmp.resubscribe { "TextChangedI", "TextChangedP" }
        require("cmp.config").set_onetime { sources = {} }
      end,
    },
    formatting = {
      format = function(entry, item)
        if entry.source.name == "omni" then
          local icon, hl = require("mini.icons").get("filetype", "vim")
          item.kind = icon .. " "
          item.kind_hl_group = hl
          item.menu = item.menu:gsub("[%[%]]", "")
          return item
        end

        local icon, hl = require("mini.icons").get("lsp", item.kind)
        item.kind = icon .. " " .. item.kind:lower()
        item.kind_hl_group = hl

        if not item.menu then
          item.menu = ({
            nvim_lsp = "lsp",
            nvim_lua = "luals",
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
    -- experimental = {
    --   ghost_text = { hl_group = "CmpGhostText" },
    -- },
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "path", option = { trailing_slash = true } },
      { name = "emoji" },
      { name = "calc" },
    },
    matching = {
      disallow_fuzzy_matching = true,
    },
    mapping = {
      ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<c-u>"] = cmp.mapping.confirm { select = true },
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
          else
            fallback()
          end
        end,
      },
      ["<s-tab>"] = cmp.mapping {
        i = function(_)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            feedkeys("<bs>", "n")
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
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "path", option = { trailing_slash = true } },
      { name = "calc" },
    },
  })

  cmp.setup.filetype("wiki", {
    sources = {
      { name = "nvim_lsp" },
      { name = "omni", trigger_characters = { "[" } },
      { name = "path", option = { trailing_slash = true } },
      { name = "emoji" },
      { name = "calc" },
    },
  })

  cmp.setup.filetype("tex", {
    sources = {
      { name = "nvim_lsp" },
      { name = "vimtex" },
      { name = "path", option = { trailing_slash = true } },
      { name = "calc" },
    },
  })

  cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "vim-dadbod-completion" },
      { name = "dadbod_grip" },
      { name = "path", option = { trailing_slash = true } },
      { name = "calc" },
    },
  })

  cmp.setup.filetype({ "markdown", "help" }, {
    window = {
      documentation = cmp.config.disable,
    },
  })
end)
