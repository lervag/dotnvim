local flog = require "flog"

local function open_commit()
  vim.fn["flog#floggraph#mark#Set"]("m", ".")
  local cmd = vim.fn["flog#Format"] "vertical botright Gsplit %h:%p"
  flog.exec_tmp(cmd, {
    blur = true,
    static = false
  })
end

local function open_current()
  local state = vim.fn["flog#state#GetBufState"]()
  local has_commit_mark = vim.fn["flog#state#HasCommitMark"](state, "m") > 0

  if has_commit_mark then
    vim.cmd [[
      call flog#state#RemoveCommitMark(flog#state#GetBufState(), "m")
    ]]
  end

  local cmd = vim.fn["flog#Format"] "vertical botright Gsplit %p"
  flog.exec_tmp(cmd, {
    blur = true,
    static = false
  })
end

local function diff_marked()
  local state = vim.fn["flog#state#GetBufState"]()
  local has_commit_mark = vim.fn["flog#state#HasCommitMark"](state, "m") > 0

  local cmd = "vertical botright Gsplit %h:%p | Gdiffsplit "
  cmd = vim.fn["flog#Format"](cmd .. (has_commit_mark and "%(h'm)" or "%p"))

  flog.exec_tmp(cmd, {
    blur = true,
    static = false
  })
end

vim.opt_local.list = false

local opts = { buffer = true }

vim.keymap.set("n", "q", "<plug>(FlogQuit)", opts)
vim.keymap.set("n", "<f5>", "<plug>(FlogUpdate)", opts)
vim.keymap.set("n", "<tab>", open_commit, opts)
vim.keymap.set("n", "p", open_current, opts)
vim.keymap.set("n", "df", diff_marked, opts)
