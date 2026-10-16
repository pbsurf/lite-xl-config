-- put user settings here
-- this module will be loaded after everything else when the application starts
-- it will be automatically reloaded when saved

local core = require "core"
local keymap = require "core.keymap"
local config = require "core.config"
local style = require "core.style"
local common = require "core.common"

------------------------------ Plugins ---------------------------------------

-- add-ons are installed by lpm with addons.sh; all installed plugins load, like
-- those in data/plugins, unless disabled with config.plugins.<name> = false

------------------------------ Themes ----------------------------------------

-- light theme, matching Qt Creator (addons/colors/qtcreator.lua in lite-xl):
core.reload_module("colors.qtcreator")

--------------------------- Key bindings -------------------------------------

-- key binding:
-- keymap.add { ["ctrl+escape"] = "core:quit" }

-- pass 'true' for second parameter to overwrite an existing binding

-- ctrl+tab cycles tabs in most-recently-used order (tab_switcher plugin): a list
-- opens while ctrl is held, each tab press moves down it, releasing ctrl switches.
-- ctrl+pageup/pagedown cycle in displayed order, as in browsers; moving tabs goes
-- to ctrl+shift+pageup/pagedown.
keymap.add({
  ["ctrl+tab"] = { "tab-switcher:previous-tab", "tab-switcher:switch-to-last-tab" },
  ["ctrl+shift+tab"] = { "tab-switcher:next-tab", "tab-switcher:switch-to-oldest-tab" },
  ["ctrl+pageup"] = "root:switch-to-previous-tab",
  ["ctrl+pagedown"] = "root:switch-to-next-tab",
  ["ctrl+shift+pageup"] = "root:move-tab-left",
  ["ctrl+shift+pagedown"] = "root:move-tab-right",
}, true)

-- alt+drag selects a rectangular block (ctrl+drag still does too, after ctrl+click
-- adds a cursor)
keymap.add { ["alt+1lclick"] = "doc:select-block" }

------------------------------- Fonts ----------------------------------------

style.code_font = renderer.font.load("/home/mwhite/.fonts/Menlo-Regular.ttf", 12 * SCALE)

-- customize fonts:
-- style.font = renderer.font.load(DATADIR .. "/fonts/FiraSans-Regular.ttf", 14 * SCALE)
-- style.code_font = renderer.font.load(DATADIR .. "/fonts/JetBrainsMono-Regular.ttf", 14 * SCALE)
--
-- DATADIR is the location of the installed Lite XL Lua code, default color
-- schemes and fonts.
-- USERDIR is the location of the Lite XL configuration directory.
--
-- font names used by lite:
-- style.font          : user interface
-- style.big_font      : big text in welcome screen
-- style.icon_font     : icons
-- style.icon_big_font : toolbar icons
-- style.code_font     : code
--
-- the function to load the font accept a 3rd optional argument like:
--
-- {antialiasing="grayscale", hinting="full", bold=true, italic=true, underline=true, smoothing=true, strikethrough=true}
--
-- possible values are:
-- antialiasing: grayscale, subpixel
-- hinting: none, slight, full
-- bold: true, false
-- italic: true, false
-- underline: true, false
-- smoothing: true, false
-- strikethrough: true, false

------------------------------ Plugins ----------------------------------------

-- disable plugin loading setting config entries:

-- disable plugin detectindent, otherwise it is enabled by default:
-- config.plugins.detectindent = false

-- or env var LITE_SCALE=2
config.plugins.scale.mode = "ui"
config.plugins.scale.default_scale = 2.0

config.plugins.lineguide.enabled = true

-- ctrl+tab: true shows the list of tabs while ctrl is held; false switches
-- immediately, each further tab press going one tab further back in history
config.plugins.tab_switcher = { show_list = true }

-- lintplus (LSP diagnostics): squiggly underline under each problem's range;
-- the message shows on mouse hover (lsp plugin) and in the status bar
config.lint = { lens_style = "squiggle", inline_messages = false }
-- hover shows errors and warnings; ctrl+hover also symbol info and hints
config.plugins.lsp = { mouse_hover_mode = "important" }
-- word completions only on ctrl+space; LSP's still pop up while typing
config.plugins.autocomplete.symbols_on_typing = false

-- Qt Creator style matching parens: red on green (colors from the theme)
config.plugins.bracketmatch.style = "block"
config.plugins.bracketmatch.color_char = true

-- terminal plugin: colors of the system terminal (urxvt: white on black, its
-- default palette), shown as given (no contrast adjustment)
config.plugins.terminal.background = { common.color "#000000" }
config.plugins.terminal.text = { common.color "#ffffff" }
config.plugins.terminal.minimum_contrast_ratio = 0
-- compact like urxvt: 13 px cells for the same 24 px Menlo, whose advance is 14.45 px
-- (urxvt's letterSpace -3 applies to cells sized by the widest ASCII glyph, 16 px)
config.plugins.terminal.letter_spacing = (13 - 14.45) / 24
-- and 29 px rows (Menlo's line height here is 27 px)
config.plugins.terminal.line_spacing = 2 / 24
-- ANSI colors 0-15 (black red green yellow blue magenta cyan white, then bright),
-- changed in place once the plugin has loaded: setting `colors` would replace all
-- 256 (16-255 are the standard xterm cube and grays)
core.add_thread(function()
  local palette = {
    "#000000", "#cd0000", "#00cd00", "#cdcd00", "#0000cd", "#cd00cd", "#00cdcd", "#faebd7",
    "#404040", "#ff0000", "#00ff00", "#ffff00", "#0000ff", "#ff00ff", "#00ffff", "#ffffff",
  }
  for i, hex in ipairs(palette) do
    config.plugins.terminal.colors[i - 1] = { common.color(hex) }
  end
end)

-- clangd for C/C++ (lsp plugin); scripts/run.sh sets LITE_CLANGD, else clangd from PATH.
-- Limited for this 2-core, swapless machine: one worker thread (background
-- indexing ran two in parallel and exhausted memory on ~/maps/explore),
-- low-priority indexing, and preambles on disk rather than in memory.
local lspconfig = require "plugins.lsp.config"
lspconfig.clangd.setup {
  command = {
    os.getenv("LITE_CLANGD") or "clangd",
    "--background-index", "--background-index-priority=low",
    "-j=1", "--pch-storage=disk", "--malloc-trim"
  }
}

---------------------------- Miscellaneous -------------------------------------

-- modify list of files to ignore when indexing the project:
-- config.ignore_files = {
--   -- folders
--   "^%.svn/",        "^%.git/",   "^%.hg/",        "^CVS/", "^%.Trash/", "^%.Trash%-.*/",
--   "^node_modules/", "^%.cache/", "^__pycache__/",
--   -- files
--   "%.pyc$",         "%.pyo$",       "%.exe$",        "%.dll$",   "%.obj$", "%.o$",
--   "%.a$",           "%.lib$",       "%.so$",         "%.dylib$", "%.ncb$", "%.sdf$",
--   "%.suo$",         "%.pdb$",       "%.idb$",        "%.class$", "%.psd$", "%.db$",
--   "^desktop%.ini$", "^%.DS_Store$", "^%.directory$",
-- }

config.max_project_files = 20000
config.ignore_files = { "^build$", "^%." }

config.line_limit = 110
config.highlight_current_line = false

config.force_scrollbar_status = "expanded"
config.disabled_transitions.scroll = true  -- scroll instantly, no ease-out

-- Remaining issues --
-- * Markers (Bookmarks) needs a view showing all bookmarks in project
--  * maybe start from https://github.com/drmargarido/TodoTreeView/blob/master/todotreeview-xl.lua
-- * Build:
--  * wrap text in Build Messages; allow viewing even if successful
-- * Debugger: very incomplete
--  * use tree view for variable views
--  * breakpoint list
--  * threads view
--  * locals view
--  * build need to set target_workdir for use by debugger
--  * output view ... terminal plugin?
