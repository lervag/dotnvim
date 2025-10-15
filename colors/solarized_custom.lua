-- Thanks to Clason for the inspiration:
-- https://gist.github.com/clason/c164d718dcefbc27f08d3e0272cf93ae

vim.o.background = "light"
vim.g.colors_name = "solarized_custom"

-- This enables dynamic reloading of the colorscheme
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "solarized_custom.lua",
  group = vim.api.nvim_create_augroup("init_colors", {}),
  desc = "Reload colorscheme when it is changed",
  callback = function()
    if vim.o.modified and not vim.o.diff then
      -- vim.cmd "highlight clear"
      vim.cmd "silent update"
      vim.cmd "colorscheme solarized_custom"
      vim.notify "Updated colorscheme (notification)"
    end
  end,
})

-- {{{1 Define colors

local base03 = "#002b36"
local base02 = "#073642"
local base02v45 = "#0d5e73"
local base01 = "#586e75"
local base00 = "#657b83"
local base0 = "#839496"
local base1 = "#93a1a1"
local base1light = "#b8c1c1"
local base2v95 = "#f3edda"
local base2 = "#eee8d5"
local base2v91 = "#e8e2ce"
local base3 = "#fdf6e3"
local base3v95 = "#f7f1dd"
local base3v88 = "#e0dac9"
local base3v100s7 = "#fffaed"

local azure1 = "#0080ff"
local azure2 = "#0087ff"
local black = "#000000"
local blue0 = "#268bd2"
local blue0_v50 = "#175480"
local blue1 = "#00afff"
local blue2 = "#9fc6d3"
local cyan0 = "#2aa198"
local cyan1 = "#6dbfb8"
local gold1 = "#ffe055"
local gold2 = "#ffeea2"
local gold3 = "#c6b079"
local gray1 = "#d2e1e0"
local green0 = "#859900"
local green0_v80 = "#b1cc00"
local green1 = "#719e07"
local green2 = "#d7ffaf"
local magenta0 = "#d33682"
local magenta1 = "#ff00ff"
local magenta1d = "#8b008b"
local orange0 = "#cb4b16"
local orange1 = "#ff5f00"
local pink1 = "#f7cfbf"
local pink2 = "#caa894"
local purple1 = "#8787d7"
local red0 = "#dc322f"
local red0_v50 = "#801c1b"
local red1 = "#af0000"
local violet0 = "#6c71c4"
local yellow0 = "#b58900"
local yellow0_v30 = "#4d3800"
local yellow1 = "#ffff5f"

local color00 = base02
local color01 = red0
local color02 = green0
local color03 = yellow0
local color04 = blue0
local color05 = magenta0
local color06 = cyan0
local color07 = base2
local color08 = base03
local color09 = orange0
local color10 = base01
local color11 = base00
local color12 = base0
local color13 = violet0
local color14 = base1
local color15 = base3

local color00l = base02v45
local color01d = red0_v50
local color02l = green0_v80
local color03d = yellow0_v30
local color04d = blue0_v50
local color06l = cyan1
local color07l = base2v95
local color07d = base2v91
local color09l = orange0
local color14l = base1light
local color15d = base3v95
local color15dd = base3v88
local color15w = base3v100s7

vim.g.terminal_color_0 = color00
vim.g.terminal_color_1 = color01
vim.g.terminal_color_2 = color02
vim.g.terminal_color_3 = color03
vim.g.terminal_color_4 = color04
vim.g.terminal_color_5 = color05
vim.g.terminal_color_6 = color06
vim.g.terminal_color_7 = color07
vim.g.terminal_color_8 = color08
vim.g.terminal_color_9 = color09
vim.g.terminal_color_10 = color10
vim.g.terminal_color_11 = color11
vim.g.terminal_color_12 = color12
vim.g.terminal_color_13 = color13
vim.g.terminal_color_14 = color14
vim.g.terminal_color_15 = color15

-- }}}1

local theme = {
  -- {{{1 Base internal

  Normal = { fg = color11, bg = color15 },
  ColorColumn = { bg = color07 },
  Conceal = { fg = color04 },
  Cursor = { fg = color15, bg = color11 },
  CursorColumn = { bg = color07 },
  CursorLine = { bg = color07 },
  CursorLineNr = { fg = color14 },
  DiffAdd = { bg = green2 },
  DiffChange = { bg = color15d },
  DiffDelete = { bg = pink1 },
  DiffText = { bg = gray1 },
  DiffTextAdd = { link = "DiffAdd" },
  Directory = { fg = color04 },
  ErrorMsg = { fg = color01, bold = true },
  FoldColumn = { fg = gold3, bg = color07 },
  Folded = { fg = color12, bg = color07d },
  IncSearch = { fg = color09, standout = true },
  LineNr = { fg = color14, bg = color07 },
  MatchParen = { bg = color07d, bold = true },
  MatchParenCur = {},
  MatchWord = { fg = black, bold = true },
  MatchWordCur = { bold = true },
  ModeMsg = { fg = color04 },
  MoreMsg = { fg = color04 },
  NonText = { fg = color12 },
  NvimInternalError = { fg = color09, bg = color01 },
  Pmenu = { fg = color11, bg = color15dd },
  PmenuSel = { fg = color00, bg = color14, reverse = true },
  PmenuKind = { fg = black, bg = color15dd },
  PmenuKindSel = { fg = color00, bg = color14, reverse = true },
  PmenuExtra = { fg = color03, bg = color15dd },
  PmenuExtraSel = { fg = color00, bg = color03, reverse = true },
  PmenuSbar = { bg = color15dd },
  PmenuThumb = { bg = color11 },
  PmenuMatch = { fg = azure2, bg = color15dd },
  PmenuMatchSel = { fg = color00, bg = azure2, reverse = true },
  Question = { fg = color06 },
  QuickFixLine = { bg = gold2 },
  RedrawDebugClear = { bg = color11 },
  RedrawDebugComposed = { bg = color02 },
  RedrawDebugNormal = { reverse = true },
  RedrawDebugRecompose = { bg = color09 },
  Search = { fg = magenta1, bold = true, underline = true },
  CurSearch = { fg = azure2, bold = true, underline = true },
  SignColumn = { fg = color11, bg = color07 },
  SpecialKey = { fg = color12, bg = color07 },
  SpellBad = { fg = red1, bold = true },
  SpellCap = { fg = azure2, bold = true },
  SpellLocal = { fg = purple1, bold = true },
  SpellRare = { fg = yellow1, bold = true },
  TermCursor = { bold = true },
  Title = { fg = color09, bold = true },
  WinSeparator = { fg = color10, bg = color07 },
  Visual = { fg = color15, bg = color14 },
  VisualNOS = { bg = color07, reverse = true },
  WarningMsg = { fg = color03 },
  WildMenu = { fg = color00, bg = color07, reverse = true },
  Whitespace = { fg = color12, bg = color07 },

  -- {{{1 Statusline and tabline

  Statusline = { fg = color15, bg = color10 },
  StatuslineNC = { fg = color08, bg = color10 },
  TabLine = { fg = color08, bg = color10 },
  TabLineFill = { fg = color08, bg = color10 },
  TabLineSel = { fg = color10, bg = color15 },
  TabLineSelSep = { fg = color15, bg = color10 },

  SLBlue = { fg = blue0, bg = color10 },
  SLCyan = { fg = color06l, bg = color10 },
  SLGold = { fg = gold1, bg = color10 },
  SLGreen = { fg = color02l, bg = color10 },
  SLGreenLight = { fg = green2, bg = color10 },
  SLPurple = { fg = purple1, bg = color10 },
  SLRed = { fg = orange1, bg = color10 },
  SLYellow = { fg = yellow0, bg = color10 },
  SLItalic = { fg = color15, italic = true, bg = color10 },

  -- {{{1 Cursor colors

  iCursor = { bg = color03 },
  rCursor = { bg = color01 },
  vCursor = { bg = color05 },
  lCursor = { link = "Cursor" },

  -- {{{1 Default syntax groups

  -- :help group-names
  Comment = { fg = color14, italic = true },
  Constant = { fg = color01d },
  ConstantValue = { fg = color06 },
  Error = { fg = color01, bold = true },
  Identifier = { fg = color04 },
  Ignore = { fg = color15 },
  PreProc = { fg = color08 },
  Special = { fg = color01 },
  Statement = { fg = color02 },
  Todo = { fg = color05, bold = true },
  Type = { fg = color03 },
  Underlined = { fg = color13 },

  Boolean = { link = "ConstantValue" },
  Character = { link = "ConstantValue" },
  Float = { link = "ConstantValue" },
  Number = { link = "ConstantValue" },
  String = { link = "ConstantValue" },
  Function = { link = "Identifier" },
  Define = { link = "PreProc" },
  Include = { link = "PreProc" },
  Macro = { link = "PreProc" },
  PreCondit = { link = "PreProc" },
  Delimiter = { link = "PreProc" },
  Debug = { link = "Special" },
  SpecialChar = { link = "Special" },
  SpecialComment = { link = "Special" },
  Tag = { link = "Special" },
  Conditional = { link = "Statement" },
  Exception = { link = "Statement" },
  Keyword = { link = "Statement" },
  Label = { link = "Statement" },
  Operator = { link = "Statement" },
  Repeat = { link = "Statement" },
  StorageClass = { link = "Type" },
  Structure = { link = "Type" },
  Typedef = { link = "Type" },

  NormalFloat = { fg = color11, bg = color07d },
  FloatBorder = { fg = color07d, bg = color15 },
  FloatTitle = { fg = color03, bg = color07d, bold = true },
  FloatFooter = { fg = color01, bg = color04 },

  -- {{{1 Tree-sitter

  -- Highlight groups used by Tree-sitter
  -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights

  -- ["@markup"] = {},
  ["@markup.emphasis"] = { italic = true },
  -- ["@markup.environment"] = {},
  -- ["@markup.environment.name"] = {},
  -- ["@markup.heading"] = {},
  -- ["@markup.link"] = {},
  -- ["@markup.link.label"] = {},       -- other special strings (e.g. dates)
  -- ["@markup.link.url"] = {},
  ["@markup.list"] = { link = "Identifier" },
  -- ["@markup.literal.block"] = {},
  -- ["@markup.math"] = {},
  -- ["@markup.quote"] = {},
  ["@markup.raw"] = { link = "PreProc" },
  ["@markup.strike"] = { strikethrough = true },
  ["@markup.strong"] = { bold = true },
  ["@markup.underline"] = { underline = true },

  ["@markup.heading.1"] = { bold = true, fg = "#aa5858" },
  ["@markup.heading.2"] = { bold = true, fg = "#507030" },
  ["@markup.heading.3"] = { bold = true, fg = "#1030a0" },
  ["@markup.heading.4"] = { bold = true, fg = "#103040" },
  ["@markup.heading.5"] = { bold = true, fg = "#505050" },
  ["@markup.heading.6"] = { bold = true, fg = "#636363" },

  -- ["wikiHeader1"] = { link = "@markup.heading.1" },
  -- ["wikiHeader2"] = { link = "@markup.heading.2" },
  -- ["wikiHeader3"] = { link = "@markup.heading.3" },
  -- ["wikiHeader4"] = { link = "@markup.heading.4" },
  -- ["wikiHeader5"] = { link = "@markup.heading.5" },
  -- ["wikiHeader6"] = { link = "@markup.heading.6" },

  -- ["@comment"] = {},
  -- ["@comment.documentation"] = {},
  -- ["@comment.error"] = {},
  -- ["@comment.note"] = {},
  -- ["@comment.todo"] = {},
  -- ["@comment.warning"] = {},

  ["@diff.delta"] = { link = "DiffChange" },
  ["@diff.minus"] = { link = "DiffDelete" },
  ["@diff.plus"] = { link = "DiffAdd" },

  -- ["@tag"] = {},
  -- ["@tag.attribute"] = {},
  -- ["@tag.delimiter"] = {},

  -- ["@type"] = {},
  -- ["@type.builtin"] = {},
  -- ["@type.definition"] = {},
  -- ["@attribute"] = {},
  -- ["@property"] = {},

  -- ["@function"] = {},
  ["@function.builtin"] = { fg = magenta1d },
  -- ["@function.call"] = {},
  -- ["@function.macro"] = {},
  -- ["@function.method"] = {},
  -- ["@function.method.call"] = {},

  ["@variable"] = { fg = color10 },
  -- ["@variable.builtin"] = {},
  -- ["@variable.member"] = {},
  ["@variable.parameter"] = { link = "PreProc" },

  -- ["@keyword"] = {},
  -- ["@keyword.conditional"] = {},
  -- ["@keyword.conditional.ternary"] = {},
  -- ["@keyword.coroutine"] = {},
  -- ["@keyword.debug"] = {},
  -- ["@keyword.directive"] = {},
  -- ["@keyword.directive.define"] = {},
  -- ["@keyword.exception"] = {},
  -- ["@keyword.function"] = {},
  -- ["@keyword.include"] = {},
  -- ["@keyword.operator"] = {},
  -- ["@keyword.repeat"] = {},
  -- ["@keyword.return"] = {},

  -- ["@string"] = {},
  -- ["@string.documentation"] = {},
  -- ["@string.escape"] = {},
  -- ["@string.regexp"] = {},
  -- ["@string.special.url"] = {},
  -- ["@string.special.symbol"] = {},

  ["@constructor"] = { link = "PreProc" },
  -- ["@label"] = {},
  -- ["@module"] = {},
  -- ["@none"] = {},
  -- ["@operator"] = {},
  -- ["@character"] = {},
  -- ["@character.special"] = {},
  -- ["@boolean"] = {},
  -- ["@number"] = {},
  -- ["@number.float"] = {},

  -- ["@constant"] = {},
  -- ["@constant.builtin"] = {},
  -- ["@constant.macro"] = {},

  -- ["@punctuation.delimiter"] -- delimiters (e.g. `--` / `.` / `,`)
  -- ["@punctuation.bracket"]   -- brackets (e.g. `()` / `{}` / `[]`)

  -- {{{1 LSP semantic highlighting

  -- See :help lsp-semantic-highlight

  ["@lsp.type.variable"] = { link = "@variable" },
  ["@lsp.type.class"] = { link = "@type" },
  ["@lsp.type.enum"] = { link = "@type" },
  ["@lsp.type.type"] = { link = "@type" },
  ["@lsp.type.interface"] = { link = "@type" },
  ["@lsp.type.enumMember"] = { link = "@constant" },
  ["@lsp.type.decorator"] = { link = "@function" },
  ["@lsp.type.function"] = { link = "@function" },
  ["@lsp.type.macro"] = { link = "@macro" },
  ["@lsp.type.method"] = { link = "@method" },
  ["@lsp.type.namespace"] = { link = "@module" },
  ["@lsp.type.parameter"] = { link = "@parameter" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.type.struct"] = { link = "@structure" },
  -- ["@lsp.type.typeParameter"] = { link = "TypeDef" },

  -- Mods: affect all types with given modifier
  ["@lsp.mod.deprecated"] = { underline = true, bold = true, bg = color03 },
  ["@lsp.mod.defaultLibrary"] = { link = "@function.builtin" },
  ["@lsp.mod.unused"] = { bg = color03, italic = true },
  ["@lsp.mod.undefined"] = { bg = color04, italic = true },
  -- ["@lsp.mod.declaration"] = {},
  -- ["@lsp.mod.readonly"] = { italic = true },
  -- ["@lsp.mod.functionScope"] = {},
  -- ["@lsp.mod.classScope"] = {},
  -- ["@lsp.mod.fileScope"] = {},
  -- ["@lsp.mod.globalScope"] = {},

  -- Typemods: affect all of a specific type with the given modifier
  -- ["@lsp.typemod.function.declaration"] = {},
  -- ["@lsp.typemod.function.defaultLibrary"] = {},
  -- ["@lsp.typemod.function.async"] = { bold = true },

  -- {{{1 LSP and Diagnostics

  -- See :help lsp-highlight
  LspReferenceRead = { bg = color07, underline = true },
  LspReferenceWrite = { bg = color07, bold = true, italic = true },
  LspReferenceText = { bg = color07, bold = true },
  LspCodeLens = { bg = color07, fg = color00, bold = true },
  LspCodeLensSeparator = { bg = color07, fg = color04, bold = true },
  LspInlayHint = { fg = color12, bg = color15d },

  -- See :help diagnostic-highlights
  DiagnosticError = { fg = color01, bold = true },
  DiagnosticWarn = { fg = color03, bold = true },
  DiagnosticInfo = { fg = color04 },
  DiagnosticHint = { fg = color06 },
  DiagnosticOk = { fg = green1 },
  DiagnosticVirtualTextError = { fg = color01, bold = true },
  DiagnosticVirtualTextWarn = { fg = color03, bold = true },
  DiagnosticVirtualTextInfo = { fg = blue2, italic = true },
  DiagnosticVirtualTextHint = { fg = color06l, italic = true },
  DiagnosticVirtualTextOk = { fg = green1 },
  DiagnosticSignError = { fg = color01, bg = color07, bold = true },
  DiagnosticSignWarn = { fg = color03, bg = color07, bold = true },
  DiagnosticSignInfo = { fg = color04, bg = color07 },
  DiagnosticSignHint = { fg = color06, bg = color07 },
  DiagnosticSignOk = { fg = green1, bg = color07 },

  -- {{{1 Various plugins

  SignFold = { fg = color08, bg = color07 },

  ctrlsfSelectedLine = { fg = blue1, bold = true },

  codeBlockBackground = { bg = color15w },

  DapSign = { fg = purple1, bg = color07 },
  DapStatus = { fg = pink1, bg = color10 },

  CmpGhostText = { fg = color14l, italic = true },
  CmpItemAbbrMatch = { fg = azure2 },
  CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },
  CmpItemKind = { fg = color00l },
  CmpItemMenu = { fg = black },
  CmpItemKindFunction = { fg = color05 },
  CmpItemKindMethod = { link = "CmpItemKindFunction" },

  TelescopeBorder = { fg = black, bg = color07d, bold = true },
  TelescopeMatching = { fg = blue0, bold = true },
  TelescopeMultiIcon = { link = "TelescopeMultiSelection" },
  TelescopeMultiSelection = { fg = green0, bold = true },
  TelescopeNormal = { bg = color07d },
  TelescopePromptCounter = { fg = green0, bold = true },
  TelescopePromptNormal = { fg = blue0, bg = color07d },
  TelescopePromptPrefix = { fg = black },
  TelescopeTitle = { fg = color03, bold = true },

  LTSymbol = { fg = base02 },

  -- ChatGPTBorder = { link = FloatBorder },
  -- ChatGPTCompletion = { link = FloatBorder },
  ChatGPTQuestion = { fg = cyan0, italic = true, bold = true },
  -- ChatGPTTotalTokens = { link = FloatBorder },
  -- ChatGPTTotalTokensBorder = { link = FloatBorder },
  -- ChatGPTWelcome = { fg = pink, italic = true },

  -- Lspsaga
  -- Refer to: ~/.local/plugged/lspsaga.nvim/lua/lspsaga/highlight.lua
  SagaNormal = { link = "NormalFloat" },
  SagaLightBulb = { fg = gold3, bold = true },
  RenameNormal = { fg = color13, bg = color07d },
  TitleString = { fg = color09, bg = color07d, bold = true },
  ActionPreviewTitle = { link = "TitleString" },
  CodeActionNumber = { fg = color08 },

  MiniNotifyBorder = { fg = color12, bg = color07l },
  MiniNotifyNormal = { fg = color04, bg = color07l },
  MiniNotifyTitle = { fg = color03, bg = color07l, bold = true },

  MiniDiffSignAdd = { fg = color02l, bg = color07 },
  MiniDiffSignChange = { fg = blue2, bg = color07 },
  MiniDiffSignDelete = { fg = red0, bg = color07 },
  MiniDiffOverAdd = { bg = green2 },
  MiniDiffOverChange = { fg = color02l, bold = true },
  MiniDiffOverDelete = { bg = pink1 },
  MiniDiffOverContext = { fg = color14, bg = color15, italic = true },

  TroubleIndent = { fg = "fg" },
  TroubleLspPos = { fg = color14, italic = true },
  TroublePreview = { fg = magenta1 },

  FlashLabel = { fg = azure2, underline = true, bold = true },
  FlashPromptIcon = { fg = yellow0, bold = true },

  MiniIconsAzure = { fg = azure1 },
  MiniIconsBlue = { fg = blue1 },
  MiniIconsCyan = { fg = cyan0 },
  MiniIconsGreen = { fg = green1 },
  MiniIconsGrey = {},
  MiniIconsOrange = { fg = orange1 },
  MiniIconsPurple = { fg = purple1 },
  MiniIconsRed = { fg = red0 },
  MiniIconsYellow = { fg = yellow0 },

  MiniSnippetsCurrent = { fg = azure1 },
  MiniSnippetsCurrentReplace = { fg = purple1 },
  MiniSnippetsFinal = { fg = black },
  MiniSnippetsUnvisited = { fg = orange1 },
  MiniSnippetsvisited = { fg = green1 },

  SnacksInputNormal = { link = "NormalFloat" },
  SnacksInputBorder = { link = "FloatBorder" },
  SnacksInputTitle = { link = "FloatTitle" },
  SnacksInputIcon = { fg = cyan0, bg = color07d },

  Lensline = { fg = pink2, italic = true },

  -- {{{1 Filetype Vimscript

  vimCmdSep = { fg = color04 },
  vimCommentString = { fg = color13 },
  vimGroup = { fg = color04, underline = true },
  vimHiGroup = { fg = color04 },
  vimHiLink = { fg = color04 },
  vimIsCommand = { fg = color12 },
  vimSynMtchOpt = { fg = color03 },
  vimSynType = { fg = color06 },

  vimContinue = { link = "Comment" },
  vimCommand = { link = "Type" },
  vimFunc = { link = "Function" },
  vimUserFunc = { link = "Function" },
  vipmVar = { link = "Identifier" },
  vimMapModKey = { link = "PreProc" },
  vimNotation = { link = "PreProc" },

  -- {{{1 Filetype Vim help

  helpHyperTextEntry = { fg = color02 },
  helpHyperTextJump = { fg = color04, underline = true },
  helpNote = { fg = color05 },
  helpOption = { fg = color06 },
  helpVim = { fg = color05 },
  helpExample = { link = "PreProc" },
  helpHeader = { link = "Special" },
  helpSpecial = { link = "Special" },
  helpIgnore = { link = "Special" },
  helpBacktick = { link = "Special" },
  helpBar = { link = "Special" },
  helpStar = { link = "Special" },

  -- {{{1 Filetype pandoc

  pandocBlockQuote = { fg = color04 },
  pandocBlockQuoteLeader1 = { fg = color04 },
  pandocBlockQuoteLeader2 = { fg = color06 },
  pandocBlockQuoteLeader3 = { fg = color03 },
  pandocBlockQuoteLeader4 = { fg = color01 },
  pandocBlockQuoteLeader5 = { fg = color11 },
  pandocBlockQuoteLeader6 = { fg = color14 },
  pandocCitation = { fg = color05 },
  pandocCitationDelim = { fg = color05 },
  pandocCitationID = { fg = color05, underline = true },
  pandocCitationRef = { fg = color05 },
  pandocComment = { fg = color14, italic = true },
  pandocDefinitionBlock = { fg = color13 },
  pandocDefinitionIndctr = { fg = color13 },
  pandocDefinitionTerm = { fg = color13, standout = true },
  pandocEmphasis = { fg = color11, italic = true },
  pandocEmphasisDefinition = { fg = color13, italic = true },
  pandocEmphasisHeading = { fg = color09 },
  pandocEmphasisNested = { fg = color11 },
  pandocEmphasisNestedDefinition = { fg = color13 },
  pandocEmphasisNestedHeading = { fg = color09 },
  pandocEmphasisNestedTable = { fg = color04 },
  pandocEmphasisTable = { fg = color04, italic = true },
  pandocEscapePair = { fg = color01 },
  pandocFootnote = { fg = color02 },
  pandocFootnoteDefLink = { fg = color02 },
  pandocFootnoteInline = { fg = color02, underline = true },
  pandocFootnoteLink = { fg = color02, underline = true },
  pandocHeading = { fg = color09 },
  pandocHeadingMarker = { fg = color03 },
  pandocImageCaption = { fg = color13, underline = true },
  pandocLinkDefinition = { fg = color06, underline = true },
  pandocLinkDefinitionID = { fg = color04 },
  pandocLinkDelim = { fg = color14 },
  pandocLinkLabel = { fg = color04, underline = true },
  pandocLinkText = { fg = color04, underline = true },
  pandocLinkTitle = { fg = color12, underline = true },
  pandocLinkTitleDelim = { fg = color14, underline = true },
  pandocLinkURL = { fg = color12, underline = true },
  pandocListMarker = { fg = color05 },
  pandocListReference = { fg = color05, underline = true },
  pandocMetadata = { fg = color04 },
  pandocMetadataDelim = { fg = color14 },
  pandocMetadataKey = { fg = color04 },
  pandocNonBreakingSpace = { fg = color01, reverse = true },
  pandocRule = { fg = color04 },
  pandocRuleLine = { fg = color04 },
  pandocStrikeout = { fg = color14, reverse = true },
  pandocStrikeoutDefinition = { fg = color13, reverse = true },
  pandocStrikeoutHeading = { fg = color09, reverse = true },
  pandocStrikeoutTable = { fg = color04, reverse = true },
  pandocStrongEmphasis = { fg = color11 },
  pandocStrongEmphasisDefinition = { fg = color13 },
  pandocStrongEmphasisEmphasis = { fg = color11 },
  pandocStrongEmphasisEmphasisDefinition = { fg = color13 },
  pandocStrongEmphasisEmphasisHeading = { fg = color09 },
  pandocStrongEmphasisEmphasisTable = { fg = color04 },
  pandocStrongEmphasisHeading = { fg = color09 },
  pandocStrongEmphasisNested = { fg = color11 },
  pandocStrongEmphasisNestedDefinition = { fg = color13 },
  pandocStrongEmphasisNestedHeading = { fg = color09 },
  pandocStrongEmphasisNestedTable = { fg = color04 },
  pandocStrongEmphasisTable = { fg = color04 },
  pandocStyleDelim = { fg = color14 },
  pandocSubscript = { fg = color13 },
  pandocSubscriptDefinition = { fg = color13 },
  pandocSubscriptHeading = { fg = color09 },
  pandocSubscriptTable = { fg = color04 },
  pandocSuperscript = { fg = color13 },
  pandocSuperscriptDefinition = { fg = color13 },
  pandocSuperscriptHeading = { fg = color09 },
  pandocSuperscriptTable = { fg = color04 },
  pandocTable = { fg = color04 },
  pandocTableStructure = { fg = color04 },
  pandocTableZebraDark = { fg = color04, bg = color07 },
  pandocTableZebraLight = { fg = color04 },
  pandocTitleBlock = { fg = color04 },
  pandocTitleBlockTitle = { fg = color04 },
  pandocTitleComment = { fg = color04 },
  pandocVerbatimBlock = { fg = color03 },
  pandocVerbatimInline = { fg = color03 },
  pandocVerbatimInlineDefinition = { fg = color13 },
  pandocVerbatimInlineHeading = { fg = color09 },
  pandocVerbatimInlineTable = { fg = color04 },

  pandocCodeBlock = { link = "pandocVerbatimBlock" },
  pandocCodeBlockDelim = { link = "pandocVerbatimBlock" },
  pandocEscapedCharacter = { link = "pandocEscapePair" },
  pandocLineBreak = { link = "pandocEscapePair" },
  pandocMetadataTitle = { link = "pandocMetadata" },
  pandocTableStructureEnd = { link = "pandocTableStructure" },
  pandocTableStructureTop = { link = "pandocTableStructure" },
  pandocVerbatimBlockDeep = { link = "pandocVerbatimBlock" },

  -- {{{1 Filetype Git

  gitcommitBranch = { fg = color05 },
  gitcommitComment = { fg = color14, italic = true },
  gitcommitDiscardedFile = { fg = color01 },
  gitcommitDiscardedType = { fg = color01 },
  gitcommitFile = { fg = color11 },
  gitcommitHeader = { fg = color14 },
  gitcommitOnBranch = { fg = color14 },
  gitcommitSelectedFile = { fg = color02 },
  gitcommitSelectedType = { fg = color02 },
  gitcommitUnmerged = { fg = color02 },
  gitcommitUnmergedFile = { fg = color03 },
  gitcommitUntrackedFile = { fg = color06 },

  gitcommitDiscarded = { link = "gitcommitComment" },
  gitcommitDiscardedArrow = { link = "gitcommitDiscardedFile" },
  gitcommitNoBranch = { link = "gitcommitBranch" },
  gitcommitSelected = { link = "gitcommitComment" },
  gitcommitSelectedArrow = { link = "gitcommitSelectedFile" },
  gitcommitUnmergedArrow = { link = "gitcommitUnmergedFile" },
  gitcommitUntracked = { link = "gitcommitComment" },

  -- {{{1 Filetype Haskell

  hsImport = { fg = color05 },
  hsImportLabel = { fg = color06 },
  hsModuleName = { fg = color02, underline = true },
  hsNiceOperator = { fg = color06 },
  hsStatement = { fg = color06 },
  hsString = { fg = color12 },
  hsStructure = { fg = color06 },
  hsType = { fg = color03 },
  hsTypedef = { fg = color06 },
  hsVarSym = { fg = color06 },
  hs_DeclareFunction = { fg = color09 },
  hs_OpFunctionName = { fg = color03 },
  hs_hlFunctionName = { fg = color04 },

  hsDelimTypeExport = { link = "Delimiter" },
  hsImportParams = { link = "Delimiter" },
  hsModuleStartLabel = { link = "hsStructure" },
  hsModuleWhereLabel = { link = "hsModuleStartLabel" },
  htmlLink = { link = "Function" },

  -- {{{1 Filetype diff

  diffAdded = { link = "Statement" },
  diffBDiffer = { fg = color03 },
  diffCommon = { fg = color03 },
  diffDiffer = { fg = color03 },
  diffIdentical = { fg = color03 },
  QiffIdentical = { fg = color03 },
  AiffDiffer = { fg = color03 },
  diffIsA = { fg = color03 },
  diffLine = { link = "Identifier" },
  diffNoEOL = { fg = color03 },
  diffOnly = { fg = color03 },
  diffRemoved = { fg = color09 },

  -- {{{1 Filetype tex

  texArg = { fg = color04 },
  texTodoArg = { fg = color01 },
  texArgNew = { fg = color05 },
  texCmdPart = { fg = color03 },
  texCmdRef = { fg = color03 },
  texEnvArgName = { fg = color09l },
  texFootnoteArg = { fg = color14, italic = true },
  texMathCmd = { fg = color01d },
  texMathDelim = { fg = color08 },
  texMathOper = { fg = color03 },
  texMathZone = { fg = color01 },
  texOpt = { fg = color04d },
  texPartArgTitle = { fg = color03d },
  texRefArg = { fg = color00 },
  texSymbol = { fg = color00 },
  texTitleArg = { fg = color03d, bold = true },

  texAuthorArg = { link = "texArg" },
  texCmdBooktabs = { link = "texEnvArgName" },
  texCmdItem = { link = "PreProc" },
  texMathEnvArgName = { link = "texMathCmd" },
  texMathSymbol = { link = "texMathCmd" },
  texNewenvArgName = { link = "texArgNew" },
  texPgfType = { link = "texCmd" },
  texSpecialChar = { link = "texSymbol" },
  texTabularChar = { link = "texMathOper" },

  -- {{{1 Various filetypes

  cPreCondit = { fg = color09 },

  htmlArg = { fg = color12 },
  htmlEndTag = { fg = color14 },
  htmlSpecialTagName = { fg = color04, italic = true },
  htmlTag = { fg = color14 },
  htmlTagN = { fg = color10 },
  htmlTagName = { fg = color04 },
  htmlStrike = { fg = color15dd },

  javaScript = { fg = color03 },

  perlHereDoc = { fg = color10 },
  perlStatementFileDesc = { fg = color06 },
  perlVarPlain = { fg = color03 },

  rubyDefine = { fg = color10 },

  -- }}}1
}

for k, v in pairs(theme) do
  vim.api.nvim_set_hl(0, k, v)
end

-- vim: foldmethod=marker
