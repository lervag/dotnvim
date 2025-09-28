local snippets = {
  {
    name = "today",
    prefix = "today",
    body = vim.fn.strftime "%Y-%m-%d",
  },
  {
    name = "yesterday",
    prefix = "yesterday",
    body = vim.fn.strftime("%Y-%m-%d", vim.fn.localtime() - 86400),
  },
  {
    name = "lorem",
    prefix = "lorem",
    body = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  },
  {
    name = "abbrev: VimTeX",
    prefix = "vx",
    body = "VimTeX",
  },
  {
    name = "shebang",
    prefix = "#!",
    body = "#!/usr/bin/env " .. vim.o.filetype,
  },
}

return snippets
