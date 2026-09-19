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

---@param args string[]
---@return vim.SystemCompleted
local function curl(args)
  return vim
    .system(vim.list_extend({
      "curl",
      "-sL",
      "--connect-timeout",
      "2",
      "--max-time",
      "5",
    }, args))
    :wait()
end

local link_handlers = {}

---@param url string
---@return string
link_handlers._generic = function(url)
  if vim.fn.executable "pup" ~= 1 then
    vim.notify("pup is not available, using URL only!", vim.log.levels.WARN)
    return string.format("[${1:title}](%s)", url)
  end

  local curl_res = curl { url }
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

---@param url string
---@return string
link_handlers["www.reddit.com"] = function(url)
  -- old.reddit.com forces a login redirect on every path, so always fetch via
  -- www.reddit.com regardless of which host the URL uses
  local base = url
    :gsub("[?#].*$", "")
    :gsub("^(https?://)[%w.]-reddit%.com", "%1www.reddit.com")
    :gsub("/+$", "")

  -- Reddit blocks unauthenticated access to the `.json` endpoint (403), but the
  -- Atom feed at `.rss` is still served as long as we send a browser User-Agent.
  local curl_res = curl {
    "-H",
    "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0",
    base .. "/.rss",
  }

  local xml = curl_res.stdout or ""
  if curl_res.code ~= 0 or not xml:find("<feed", 1, true) then
    -- Reddit rate limits aggressively (429) and serves HTML when it does
    vim.notify(
      "reddit: could not fetch feed, using URL only!",
      vim.log.levels.WARN
    )
    return string.format("[${1:title}](%s)", url)
  end

  local entry = xml:match "<entry>(.-)</entry>" or ""

  local title = entry:match "<title>(.-)</title>" or ""
  title =
    decode_html_entities(title):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
  if title == "" then
    return string.format("[${1:title}](%s)", url)
  end

  local user = entry:match "<author><name>/u/(.-)</name>" or ""
  local date = (entry:match "<published>(%d%d%d%d%-%d%d%-%d%d)") or ""

  if date == "" and user == "" then
    return string.format("[%s](%s)", title, url)
  elseif user == "" then
    return string.format("[%s](%s)\n  %s", title, url, date)
  elseif date == "" then
    return string.format("[%s](%s)\n  u/%s", title, url, user)
  end

  return string.format("[%s](%s)\n  %s, u/%s", title, url, date, user)
end

link_handlers["reddit.com"] = link_handlers["www.reddit.com"]
link_handlers["old.reddit.com"] = link_handlers["www.reddit.com"]

---@param url string
---@return string
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

---@param url string
---@return string
link_handlers["news.ycombinator.com"] = function(url)
  local curl_res = curl { url }
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

---@param body string
---@return nil
local function insert_snippet(body)
  local insert = MiniSnippets.config.expand.insert
    or MiniSnippets.default_insert

  local saved_comments = vim.bo.comments
  vim.bo.comments = ""
  local ok, err = pcall(insert, { body = body })
  vim.bo.comments = saved_comments

  if not ok then
    error(err)
  end
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

  ---@cast url string
  local link = M.parse_link_from_url(url)

  insert_snippet(link)
end

---@return nil
M.create_link = function()
  insert_snippet(vim.b.wiki.in_journal == 1 and "[[/$1]]$0" or "[[$1]]$0")
end

return M
