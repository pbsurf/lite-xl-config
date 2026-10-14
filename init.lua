-- put user settings here
-- this module will be loaded after everything else when the application starts
-- it will be automatically reloaded when saved

local core = require "core"
local keymap = require "core.keymap"
local config = require "core.config"
local style = require "core.style"

------------------------------ Plugins ---------------------------------------

-- extras to load from data/extra/plugins (lite-xl-plugins and others); those in
-- data/plugins load unless disabled with config.plugins.<name> = false
config.extra_plugins = {
  "lsp", "lintplus", "build", "debugger", "repl",
  "bracketmatch", "ephemeral_tabs", "language_make", "language_yaml", "search_ui",
  "tab_switcher",
}

------------------------------ Themes ----------------------------------------

-- light theme, matching Qt Creator (see data/extra/colors/qtcreator.lua):
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

-- Qt Creator style matching parens: red on green (colors from the theme)
config.plugins.bracketmatch.style = "block"
config.plugins.bracketmatch.color_char = true

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
