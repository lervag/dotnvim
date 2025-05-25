local ns = vim.api.nvim_create_namespace "fold_signs"

local function add_fold_signs()
  -- local i0 = vim.fn.line "w0" - 1
  -- local i1 = vim.fn.line "w$"
  -- vim.api.nvim_buf_clear_namespace(0, ns, i0, i1)
  --
  -- for i = i0, i1 do
  --   if vim.fn.foldclosed(i) == i then
  --     vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
  --       sign_text = "",
  --       sign_hl_group = "SignFold",
  --     })
  --   end
  -- end
end

local au_group = vim.api.nvim_create_augroup("fold_signs", {})
vim.api.nvim_create_autocmd({
  "VimEnter",
  "WinEnter",
  "BufWinEnter",
  "ModeChanged",
  "CursorMoved",
  "BufReadPost",
  "DiffUpdated",
}, {
  desc = "Update fold signs",
  group = au_group,
  callback = add_fold_signs,
})
vim.api.nvim_create_autocmd("User", {
  pattern = { "DiffviewDiffBufRead" },
  desc = "Update fold signs",
  group = au_group,
  callback = add_fold_signs,
})

for _, lhs in ipairs {
  "zo",
  "zO",
  "zc",
  "zC",
  "zv",
  "zx",
  "zX",
  "zm",
  "zM",
  "zr",
  "zR",
  "zi",
} do
  if vim.fn.maparg(lhs, "n") == "" then
    vim.keymap.set("n", lhs, function()
      vim.cmd("silent! normal! " .. lhs)
      add_fold_signs()
    end, { unique = true })
  end
end
