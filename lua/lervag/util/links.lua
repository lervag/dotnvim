---@param str string
---@return string
local function decode_html_entities(str)
  local decoded = str
    :gsub("&amp;", "&")
    :gsub("&lt;", "<")
    :gsub("&gt;", ">")
    :gsub("&quot;", '"')
    :gsub("&#39;", "'")
    :gsub("&#x27;", "'")

  return decoded
end

---@param html string
---@param url string
---@return string
local function parse_date(html, url)
  local url_date = url:match "%d%d%d%d[-/]%d%d[-/]%d%d"
  if url_date then
    local date = url_date:gsub("/", "-")
    return date
  end

  local res = vim
    .system({ "pup", "time attr{datetime}" }, { stdin = html })
    :wait().stdout or ""
  local date = res:gsub("^%s*(.-)%s*$", "%1")
  if date ~= "" then
    return date:sub(1, 10)
  end

  local res2 = vim
    .system(
      { "pup", 'meta[property="article:published"] attr{content}' },
      { stdin = html }
    )
    :wait().stdout or ""
  local date2 = res2:gsub("^%s*(.-)%s*$", "%1")
  if date2 ~= "" then
    return date2:sub(1, 10)
  end

  local res3 = vim
    .system({ "pup", 'div:contains("Published") text{}' }, { stdin = html })
    :wait().stdout or ""
  local date3 = res3:gsub("Published%s*(.-)%s*", "%1")
  if date3 and date3 ~= "" then
    return date3:sub(1, 10)
  end

  return ""
end

local link_handlers = {}

link_handlers._generic = function(url)
  if vim.fn.executable "pup" ~= 1 then
    vim.notify("pup is not available, using URL only!", vim.log.levels.WARN)
    return string.format("[${1:title}](%s)", url)
  end

  local curl_res = vim.system({ "curl", "-sL", url }):wait()
  if curl_res.code ~= 0 or not curl_res.stdout or curl_res.stdout == "" then
    return string.format("[${1:title}](%s)", url)
  end

  local title = vim
    .system({ "pup", "title text{}" }, { stdin = curl_res.stdout })
    :wait().stdout or ""
  title =
    decode_html_entities(title):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
  if not title or title == "" then
    return string.format("[${1:title}](%s)", url)
  end

  local link = string.format("[%s](%s)\n", title, url)

  local date_str = parse_date(curl_res.stdout, url)
  if date_str ~= "" then
    return link .. "  " .. date_str
  end
  return link
end

link_handlers["www.reddit.com"] = function(url)
  if vim.fn.executable "jq" ~= 1 then
    vim.notify("jq is not available, using URL only!", vim.log.levels.WARN)
    return string.format("[${1:title}](%s)", url)
  end

  local curl_res = vim
    .system({
      "curl",
      "-sL",
      "-H",
      "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0",
      url .. ".json",
    })
    :wait()
  if curl_res.code ~= 0 or curl_res.stdout == "" then
    return string.format("[${1:title}](%s)", url)
  end

  local title = (vim
    .system({
      "jq",
      "-r",
      ".[0].data.children[0].data.title",
    }, { stdin = curl_res.stdout })
    :wait().stdout or ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")

  if not title or title == "" then
    return string.format("[${1:title}](%s)", url)
  end

  local user = vim
    .system({
      "jq",
      "-r",
      ".[0].data.children[0].data.author",
    }, { stdin = curl_res.stdout })
    :wait().stdout or ""

  local created = vim
    .system({
      "jq",
      "-r",
      ".[0].data.children[0].data.created_utc",
    }, { stdin = curl_res.stdout })
    :wait().stdout or ""
  local date = os.date("%Y-%m-%d", tonumber(created:match "^%d+"))

  return string.format("[%s](%s)\n  %s, u/%s", title, url, date, user)
end

link_handlers["github.com"] = function(url)
  local result = link_handlers._generic(url)

  local title = result:match "^%[([^%]]+)%]"
  if title then
    title = title:gsub("^GitHub %- ", "")
    title = title:gsub(" %· GitHub$", "")
    return string.format("[%s](%s)", title, url)
  end

  return result
end

link_handlers["news.ycombinator.com"] = function(url)
  local curl_res = vim.system({ "curl", "-sL", url }):wait()
  if curl_res.code ~= 0 or not curl_res.stdout or curl_res.stdout == "" then
    return url
  end

  local result = vim
    .system({ "pup", "span.subline .age attr{title}" }, { stdin = curl_res.stdout })
    :wait().stdout or ""
  local date = result:match "%d%d%d%d%-%d%d%-%d%d"
  if date and date ~= "" then
    return date .. ": " .. url
  end

  return url
end

local M = {}

---@param url string
---@return string
M.parse_link_from_url = function(url)
  local domain = url:match "https?://([^/]+)"

  local handler = link_handlers[domain] or link_handlers._generic
  return handler(url)
end

---@return nil
M.create_link_from_clipboard = function()
  local url = vim.fn.getreg "+"
  if url == "" then
    return
  end

  local link = M.parse_link_from_url(url)

  local insert = MiniSnippets.config.expand.insert
    or MiniSnippets.default_insert
  insert { body = link }
end

---@return nil
M.create_link = function()
  local insert = MiniSnippets.config.expand.insert
    or MiniSnippets.default_insert

  insert { body = vim.b.wiki.in_journal == 1 and "[[/$1]]$0" or "[[$1]]$0" }
end

return M
