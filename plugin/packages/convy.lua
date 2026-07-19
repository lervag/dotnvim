vim.pack.add { "https://github.com/Necrom4/convy.nvim" }

require("convy").setup {
  notifications = false,
  formats = {
    {
      key = "epoch",
      label = "Epoch Date",
      kind = "custom",
      formats = {
        {
          name = "unix",
          decode = function(text)
            return tonumber(text)
          end,
          encode = function(secs)
            return tostring(math.floor(secs))
          end,
        },
        {
          name = "hex32",
          decode = function(text)
            return tonumber(text, 16)
          end,
          encode = function(secs)
            return string.format("%08X", secs)
          end,
        },
        {
          name = "iso",
          display = "ISO date",
          -- optional: makes `auto` recognise ISO dates
          detect = function(text)
            return text:match "^%d%d%d%d%-%d%d%-%d%d[T ]" ~= nil
          end,
          decode = function(text)
            local y, mo, d, h, mi, s =
              text:match "(%d+)-(%d+)-(%d+)[T ](%d+):(%d+):(%d+)"
            if not y then
              return nil
            end
            local utc_offset = os.time(os.date("!*t", 0))
            ---@diagnostic disable-next-line: param-type-mismatch
            return os.time {
              year = tonumber(y),
              month = tonumber(mo),
              day = tonumber(d),
              hour = tonumber(h),
              min = tonumber(mi),
              sec = tonumber(s),
              isdst = false,
            } - utc_offset
          end,
          encode = function(secs)
            return os.date("!%Y-%m-%dT%H:%M:%SZ", secs)
          end,
        },
      },
    },
  },
}

vim.keymap.set(
  { "n", "x" },
  "<f6>",
  "<cmd>Convy<cr>",
  { desc = "Convert units" }
)
