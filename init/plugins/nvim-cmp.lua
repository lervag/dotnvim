local cmp = require "cmp"

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

local function feedkeys(str)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(str, true, true, true), "m", true)
end

cmp.setup({
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
    { name = "path" },
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
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          feedkeys("<plug>(ultisnips_jump_forward)")
        else
          fallback()
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
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
          feedkeys("<plug>(ultisnips_jump_backward)")
        else
          fallback()
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
})


require "cmp_nvim_ultisnips".setup {
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
