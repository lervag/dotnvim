-- Use space as leader key
vim.g.mapleader = " "

-- Ting jeg kan bruke i maps
-- <cr> (forsiktig med wiki.vim-konflikt)

vim.keymap.set({ "n", "i" }, "<f1>", "<nop>")
vim.keymap.set("n", "<space>", "<nop>")

vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "dp", "dpk]c")
vim.keymap.set("n", "do", "dok]c")
vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "<c-e>", "<c-^>")
vim.keymap.set("n", "<c-w><c-e>", "<c-w><c-^>")
vim.keymap.set({ "n", "x" }, "j", function()
  return vim.v.count > 1 and "j" or "gj"
end, { expr = true })
vim.keymap.set({ "n", "x" }, "k", function()
  return vim.v.count > 1 and "k" or "gk"
end, { expr = true })
vim.keymap.set("n", "gV", "`[V`]")
vim.keymap.set("o", "gV", "<cmd>normal gV<cr>")
vim.keymap.set("o", "gv", "<cmd>normal! gv<cr>")
vim.keymap.set("n", "zS", "<cmd>Inspect<cr>")
vim.keymap.set("n", "z<c-s>", "<cmd>InspectTree<cr>")
vim.keymap.set("n", "<c-w>-", "<c-w>s")
vim.keymap.set("n", "<c-w><bar>", "<c-w>v")
vim.keymap.set("n", "<c-w>§", "<c-w><bar>")
vim.keymap.set("n", "<f3>", "<cmd>call personal#spell#toggle_language()<cr>")
vim.keymap.set("n", "y@", function()
  local file = vim.fn.expand "%:p"
  if file == "" then
    return
  end

  -- Use Rooter to find root path
  local root = vim.fn.FindRootDirectory()
  if root ~= "" then
    file = vim.fn["vimtex#paths#relative"](file, root)
  end

  if file == "" then
    return
  end

  local path = file .. ":" .. vim.fn.line "."
  vim.fn.setreg("*", path)
  vim.fn.setreg("+", path)
  vim.notify("Copied path: " .. path)
end)

-- Navigation
vim.keymap.set("n", "gb", "<cmd>bnext<cr>", { silent = true })
vim.keymap.set("n", "gB", "<cmd>bprevious<cr>", { silent = true })
vim.keymap.set("n", "zv", "zMzvzz")
vim.keymap.set("n", "zj", "<cmd>silent! normal! zcjzOzz<cr>")
vim.keymap.set("n", "zk", "<cmd>silent! normal! zckzOzz<cr>")

-- Simple math stuff
vim.keymap.set("x", "++", function()
  return vim.fn["personal#visual_math#yank_and_analyse"]()
end, { silent = true, expr = true })
vim.keymap.set("n", "++", "vip++<esc>", { remap = true })

-- Terminal mappings
vim.keymap.set(
  "n",
  "<c-c><c-c>",
  "<cmd>split term://%:p:h//zsh<cr>i",
  { silent = true }
)
vim.keymap.set("t", "<esc>", "<c-\\><c-n>")
vim.keymap.set("t", "<c-w>", "<c-\\><c-n><c-w>")

-- Utility maps for repeatable quickly change/delete current word
vim.keymap.set("n", "c*", "*``cgn")
vim.keymap.set("n", "c#", "*``cgN")
vim.keymap.set("n", "cg*", "g*``cgn")
vim.keymap.set("n", "cg#", "g*``cgN")
vim.keymap.set("n", "d*", "*``dgn")
vim.keymap.set("n", "d#", "*``dgN")
vim.keymap.set("n", "dg*", "g*``dgn")
vim.keymap.set("n", "dg#", "g*``dgN")
vim.keymap.set("n", "<bs>", "ciw")

-- Improved search related mappings
vim.keymap.set({ "n", "o" }, "n", function()
  return vim.fn["personal#search#wrap"] "n"
end, { expr = true })
vim.keymap.set({ "n", "o" }, "N", function()
  return vim.fn["personal#search#wrap"] "N"
end, { expr = true })
vim.keymap.set({ "n", "o" }, "gd", function()
  return vim.fn["personal#search#wrap"] "gd"
end, { expr = true })
vim.keymap.set({ "n", "o" }, "gD", function()
  return vim.fn["personal#search#wrap"] "gD"
end, { expr = true })
vim.keymap.set({ "n", "o" }, "*", function()
  return vim.fn["personal#search#wrap"]("*", 1)
end, { expr = true })
vim.keymap.set({ "n", "o" }, "#", function()
  return vim.fn["personal#search#wrap"]("#", 1)
end, { expr = true })
vim.keymap.set({ "n", "o" }, "g*", function()
  return vim.fn["personal#search#wrap"]("g*", 1)
end, { expr = true })
vim.keymap.set({ "n", "o" }, "g#", function()
  return vim.fn["personal#search#wrap"]("g#", 1)
end, { expr = true })
vim.keymap.set("c", "<cr>", function()
  return vim.fn["personal#search#wrap"] "<cr>"
end, { expr = true })
vim.keymap.set("x", "*", function()
  return vim.fn["personal#search#wrap_visual"] "/"
end, { expr = true })
vim.keymap.set("x", "#", function()
  return vim.fn["personal#search#wrap_visual"] "?"
end, { expr = true })

-- Execute lines as vimscript of lua
local function execute(callback)
  local ft = vim.b.__xx_ft or vim.bo.filetype
  if ft ~= "vim" and ft ~= "lua" then
    vim.ui.select({ "vim", "lua" }, {
      prompt = "Select language:",
    }, callback)
  else
    callback(ft)
  end
end

vim.keymap.set("x", "<leader>xx", function()
  local callback = function(filetype)
    local ic = vim.fn.getpos(".")[2]
    local iv = vim.fn.getpos("v")[2]
    local cmd_range = ":" .. math.min(ic, iv) .. "," .. math.max(ic, iv)

    vim.b.__xx_ft = filetype
    if filetype == "vim" then
      vim.cmd(cmd_range .. "yank v")
      vim.cmd ":@v"
    elseif filetype == "lua" then
      vim.cmd(cmd_range .. "lua")
    end
  end

  execute(callback)
end)
vim.keymap.set("n", "<leader>xx", function()
  local callback = function(filetype)
    vim.b.__xx_ft = filetype
    if filetype == "vim" then
      vim.cmd [[:.yank v]]
      vim.cmd [[:@v]]
    elseif filetype == "lua" then
      vim.cmd [[:.lua]]
    end
  end

  execute(callback)
end)

-- Window functions
vim.keymap.set("n", "<c-w><c-o>", function()
  require("lervag.windows").only()
end)
vim.keymap.set("n", "<f2>", function()
  require("lervag.windows").resize()
end)

vim.keymap.set("n", "<leader>pu", vim.pack.update)
vim.keymap.set("n", "<leader>pp", function()
  vim.pack.update(nil, { offline = true })
end)

vim.keymap.set("x", "[b", function()
  vim.cmd.normal "y"
  local result = vim.base64.decode(vim.fn.getreg "0")
  vim.fn.setreg("0", result)
  vim.cmd.normal "cgv0"
end)

vim.keymap.set("x", "]b", function()
  vim.cmd.normal "y"
  local result = vim.base64.encode(vim.fn.getreg "0")
  vim.fn.setreg("0", result)
  vim.cmd.normal "cgv0"
end)

vim.keymap.set("n", "<f5>", function()
  vim.cmd.packadd "nvim.undotree"
  require("undotree").open()
end)

--- "Incremental selection" mappings (treesitter + LSP fallback).

vim.keymap.set({ "x" }, "[t", function()
  require("vim.treesitter._select").select_prev(vim.v.count1)
end, { desc = "Select previous node" })

vim.keymap.set({ "x" }, "]t", function()
  require("vim.treesitter._select").select_next(vim.v.count1)
end, { desc = "Select next node" })

vim.keymap.set({ "x", "o" }, "at", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent (outer) node" })

vim.keymap.set({ "x", "o" }, "it", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child (inner) node" })

vim.keymap.set("n", "<leader>rr", function()
  local session = vim.fn.stdpath "state" .. "/restart_session.vim"
  vim.cmd("mksession! " .. vim.fn.fnameescape(session))
  vim.cmd("restart source " .. vim.fn.fnameescape(session))
end)
