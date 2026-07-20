---A small in-process LSP that fetches a definition for the word under the
---cursor on hover, using https://dictionaryapi.dev.

---@type table<vim.lsp.protocol.Method, fun(params: table, callback:fun(err: lsp.ResponseError?, result: any))>
local handlers = {}

---@param callback fun(err: lsp.ResponseError?, result: lsp.InitializeResult)
handlers["initialize"] = function(_, callback)
  callback(nil, {
    capabilities = {
      hoverProvider = true,
    },
    serverInfo = {
      name = "dict-lsp",
      version = "0.0.1",
    },
  })
end

---@param _ lsp.HoverParams
---@param callback fun(err?: lsp.ResponseError, result: lsp.Hover)
handlers["textDocument/hover"] = function(_, callback)
  local url = ("https://api.dictionaryapi.dev/api/v2/entries/en/%s"):format(
    vim.fn.expand "<cword>"
  )

  vim.net.request(url, {}, function(err, res)
    local contents
    if err or not res then
      contents = "word fetch failed"
    else
      local ok, decoded = pcall(vim.json.decode, res.body)
      if not ok or type(decoded) ~= "table" then
        contents = "word fetch failed"
      elseif decoded[1] then
        contents = vim.tbl_get(
          decoded,
          1,
          "meanings",
          1,
          "definitions",
          1,
          "definition"
        ) or "no definition found"
      else
        -- this api gives a nice message if no result
        contents = decoded.message or "no definition found"
      end
    end
    callback(nil, { contents = contents })
  end)
end

local M = {}

---In-process RPC client for the dict-lsp server.
---@return vim.lsp.rpc.Client
function M.cmd()
  return {
    request = function(method, params, callback)
      if handlers[method] then
        handlers[method](params, callback)
      end
    end,
    notify = function() end,
    is_closing = function() end,
    terminate = function() end,
  } --[[@as vim.lsp.rpc.Client]]
end

return M
