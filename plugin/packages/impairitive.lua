vim.pack.add { "https://github.com/idanarye/nvim-impairative" }

local impairative = require "impairative"

impairative
  .toggling({
    enable = "[o",
    disable = "]o",
    toggle = "yo",
    show_message = true,
  })
  :option({ key = "h", option = "hlsearch" })
  :option({ key = "l", option = "list" })
  :option({ key = "n", option = "number" })
  :option({ key = "r", option = "relativenumber" })
  :option({ key = "s", option = "spell" })
  :option { key = "w", option = "wrap" }

impairative
  .operations({ backward = "[", forward = "]" })
  :command_pair({
    key = "l",
    backward = "lprevious",
    forward = "lnext",
  })
  :command_pair({
    key = "L",
    backward = "lfirst",
    forward = "llast",
  })
  :command_pair({
    key = "q",
    backward = "cprevious",
    forward = "cnext",
  })
  :command_pair({
    key = "Q",
    backward = "cfirst",
    forward = "clast",
  })
  :jump_in_buf({
    key = "c",
    desc = "jump to the {previous|next} SCM conflict marker or diff/path hunk",
    extreme = {
      key = "C",
      desc = "jump to the {first|last} SCM conflict marker or diff/path hunk",
    },
    fun = require("impairative.helpers").conflict_marker_locations,
  })
  :text_manipulation({
    key = "u",
    line_key = true,
    desc = "{encode|decode} URL",
    backward = require("impairative.helpers").encode_url,
    forward = require("impairative.helpers").decode_url,
  })
