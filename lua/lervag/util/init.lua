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

return M
