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

-- Load the plugins
vim.pack.add {
  "https://github.com/lervag/wiki-ft.vim",
  "https://github.com/lervag/wiki.vim",
}
