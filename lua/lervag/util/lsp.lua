---Get Github token
---@return string A github token or empty string
local function get_github_token()
  local result = vim.system({ "gh", "auth", "token" }):wait()
  if not result or not result.stdout then
    vim.notify("Could not get gh token", vim.log.levels.WARN)
    return ""
  end
  return result.stdout
end

local function parse_github_remote(url)
  if not url or url == "" then
    return nil
  end

  -- SSH format: git@github.com:owner/repo.git
  local owner, repo = url:match "git@github%.com:([^/]+)/([^/%.]+)"
  if owner and repo then
    return owner, repo:gsub("%.git$", "")
  end

  -- HTTPS format: https://github.com/owner/repo.git
  owner, repo = url:match "github%.com/([^/]+)/([^/%.]+)"
  if owner and repo then
    return owner, repo:gsub("%.git$", "")
  end

  return nil
end

local function get_repo_info(owner, repo)
  local cmd = string.format(
    "gh repo view %s/%s --json id,owner --template '{{.id}}\t{{.owner.type}}' 2>/dev/null",
    owner,
    repo
  )
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end
  local result = handle:read("*a"):gsub("%s+$", "")
  handle:close()

  local id, owner_type = result:match "^(%d+)\t(.+)$"
  if not id then
    return nil
  end

  return {
    id = tonumber(id),
    organizationOwned = owner_type == "Organization",
  }
end

local function get_repos_config()
  local result = vim.system({ "git", "rev-parse", "--show-toplevel" }):wait()
  if not result or not result.stdout then
    return nil
  end
  local git_root = result.stdout

  if git_root == "" then
    return nil
  end

  local handle = io.popen "git remote get-url origin 2>/dev/null"
  if not handle then
    return nil
  end
  local remote_url = handle:read("*a"):gsub("%s+", "")
  handle:close()

  local owner, name = parse_github_remote(remote_url)
  if not owner or not name then
    return nil
  end

  local info = get_repo_info(owner, name)

  return {
    {
      id = info and info.id or 0,
      owner = owner,
      name = name,
      organizationOwned = info and info.organizationOwned or false,
      workspaceUri = "file://" .. git_root,
    },
  }
end

local M = {}

function M.handler_readfile(_, result)
  if type(result.path) ~= "string" then
    return nil, { code = -32602, message = "Invalid path parameter" }
  end

  local file_path = vim.uri_to_fname(result.path)
  if vim.fn.filereadable(file_path) == 1 then
    local f = assert(io.open(file_path, "r"))
    local text = f:read "*a"
    f:close()

    return text, nil
  end

  return nil, { code = -32603, message = "File not found: " .. file_path }
end

function M.get_ghactions_initoptions()
  return {
    sessionToken = get_github_token(),
    repos = get_repos_config(),
  }
end

return M
