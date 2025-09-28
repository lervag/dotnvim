vim.fn["personal#markdown#init"]()

vim.bo.indentexpr = "personal#markdown#indentexpr(v:lnum)"
vim.wo.conceallevel = 0

vim.keymap.set(
  "n",
  "<leader>aa",
  "<cmd>call personal#markdown#create_notes()<cr>",
  { buffer = true }
)
vim.keymap.set("n", "<leader>ai", function()
  require("img-clip").pasteImage {
    dir_path = "/home/lervag/documents/anki/lervag/collection.media",
    template = "![$FILE_NAME_NO_EXT]($FILE_NAME)",
  }
end, { buffer = true })
vim.keymap.set(
  "n",
  "<leader>a<c-i>",
  "<cmd>call personal#markdown#prepare_image()<cr>",
  { buffer = true }
)
vim.keymap.set(
  "n",
  "<leader>aI",
  "<cmd>call personal#markdown#view_image()<cr>",
  { buffer = true }
)

vim.keymap.set(
  "n",
  "<leader>ar",
  "<cmd>call medieval#eval('', #{ after: { _, _ -> personal#markdown#place_signs() } })",
  { buffer = true }
)

vim.keymap.set("i", "LLM", function()
  local link = ""
  local url = vim.fn.getreg "+"

  if vim.fn.executable "pup" ~= 1 then
    vim.notify("Consider installing pup!", vim.log.levels.WARN)
    link = string.format("[$0](%s)", url)
  else
    local text = vim
      .system({
        "bash",
        "-c",
        string.format("curl -s %s | pup 'h1 text{}'", url),
      })
      :wait().stdout or ""
    text = vim.fn.substitute(vim.trim(text), "\n", "", "g")

    link = string.format("[${1:%s}](%s)", text, url)
  end

  local insert = MiniSnippets.config.expand.insert
    or MiniSnippets.default_insert

  insert { body = link }
end, { buffer = true })
