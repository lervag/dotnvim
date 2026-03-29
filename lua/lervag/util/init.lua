---@type number?
local timing_start = nil
---@type number?
local timing_step = nil

local M = {}

---Source filetype script for specified filetype
---@param ft string The specified filetype
M.ft_depend = function(ft)
  local file =
    vim.api.nvim_get_runtime_file("ftplugin/" .. ft .. ".lua", false)[1]
  local ok, err = pcall(dofile, file)
  if not ok then
    vim.notify("Error loading " .. file .. "\n" .. err, vim.log.levels.ERROR)
  end
end

---Simple utility to time things
---@param description string?
M.time = function(description)
  local now = vim.uv.hrtime()
  if timing_start == nil then
    timing_start = now
    return
  end

  local message
  if timing_step then
    message = string.format(
      "Timing %5.2f ms total %5.2f ms step",
      (now - timing_start) / 1e6,
      (now - timing_step) / 1e6
    )
  else
    message = string.format("Timing %5.2f ms total", (now - timing_start) / 1e6)
  end
  timing_step = now

  if description then
    message = message .. ": " .. description
  end

  print(message)
end

---Load code on specified event
---@param event vim.api.keyset.events | vim.api.keyset.events[]
---@param cf fun(args: vim.api.keyset.create_autocmd.callback_args): boolean?
M.load_on = function(event, cf)
  vim.api.nvim_create_autocmd(event, {
    once = true,
    callback = cf,
  })
end

---Load code on 250 ms delay
---@param cf fun(): nil
---@param delay integer?
M.load_delayed = function(cf, delay)
  vim.defer_fn(cf, delay and delay or 250)
end

return M
