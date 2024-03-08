local ns = vim.api.nvim_create_namespace "foldsign"

vim.api.nvim_create_autocmd(
{
  "VimEnter",
  "WinEnter",
  "BufWinEnter",
  "ModeChanged",
  "CursorMoved",
  "CursorHold"
}, {
  desc = "Update fold signs",
  group = vim.api.nvim_create_augroup("init_foldsigns", {}),
  callback = function()
    local i0 = vim.fn.line "w0" - 1
    local i1 = vim.fn.line "w$"
    vim.api.nvim_buf_clear_namespace(0, ns, i0, i1)

    for i = i0, i1 do
      if vim.fn.foldclosed(i) == i then
        vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
          sign_text = "",
          sign_hl_group = "SignFold",
        })
      end
    end
  end
})
