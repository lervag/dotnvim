local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function encode(data)
  return (
    (data:gsub(".", function(x)
      local r, bb = "", x:byte()
      for i = 8, 1, -1 do
        r = r .. (bb % 2 ^ i - bb % 2 ^ (i - 1) > 0 and "1" or "0")
      end
      return r
    end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
      if #x < 6 then
        return ""
      end
      local c = 0
      for i = 1, 6 do
        c = c + (x:sub(i, i) == "1" and 2 ^ (6 - i) or 0)
      end
      return b:sub(c + 1, c + 1)
    end) .. ({ "", "==", "=" })[#data % 3 + 1]
  )
end

local function decode(data)
  data = string.gsub(data, "[^" .. b .. "=]", "")
  return (
    data
      :gsub(".", function(x)
        if x == "=" then
          return ""
        end
        local r, f = "", (b:find(x) - 1)
        for i = 6, 1, -1 do
          r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
        end
        return r
      end)
      :gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then
          return ""
        end
        local c = 0
        for i = 1, 8 do
          c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
      end)
  )
end

vim.keymap.set("x", "[b", function()
  vim.cmd.normal "y"
  local result = decode(vim.fn.getreg "0")
  vim.fn.setreg("0", result)
  vim.cmd.normal "cgv0"
end)
vim.keymap.set("x", "]b", function()
  vim.cmd.normal "y"
  local result = encode(vim.fn.getreg "0")
  vim.fn.setreg("0", result)
  vim.cmd.normal "cgv0"
end)

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "base64.lua",
  group = vim.api.nvim_create_augroup("init_b64", {}),
  desc = "Reload script base64.lua on save",
  callback = function()
    vim.notify("Reloading script: base64.lua", "warn", { title = "init.lua" })
    vim.cmd.runtime "plugin/base64.lua"
  end,
})
