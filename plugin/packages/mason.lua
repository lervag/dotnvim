-- Note: conform.nvim depends on mason.nvim

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == "mason.nvim" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd "nvim-treesitter"
      end
      vim.cmd "MasonUpdate"
    end
  end,
})

vim.pack.add { "https://github.com/williamboman/mason.nvim" }

local opts = {
  ensure_installed = {
    "basedpyright",
    "bash-language-server",
    "css-lsp",
    "emmylua_ls",
    "eslint-lsp",
    "gh-actions-language-server",
    "gitlab-ci-ls",
    "html-lsp",
    "json-lsp",
    "kotlin-lsp",
    "kulala-fmt",
    "markdown-toc",
    "markdownlint",
    "pyrefly",
    "shellcheck",
    "stylua",
    "tombi",
    "tsgo",
    "ty",
    "typescript-language-server",
    "vim-language-server",
    "yaml-language-server",
    "yamllint",
  },
}

require("mason").setup(opts)

local mr = require "mason-registry"
mr.refresh(function()
  for _, tool in ipairs(opts.ensure_installed) do
    local p = mr.get_package(tool)
    if not p:is_installed() then
      p:install()
    end
  end
end)

vim.keymap.set("n", "<leader>pm", "<cmd>Mason<cr>")
