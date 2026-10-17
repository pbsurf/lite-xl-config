#!/bin/bash
# Install this config's add-ons with lpm, into plugins/, libraries/ and colors/ here
# (lpm-managed, not tracked). Every installed plugin loads; turn one off with
# config.plugins.<name> = false. Run again after changing the lists below.
#
# Ours come from the lite-xl checkout (its manifest.json) and are symlinked, so edits
# there take effect on restart; upstream ones are copies, changed only by an lpm
# install/upgrade. Order matters: a dependency installed first keeps its install
# mode (json as a copy, widget as our symlinked one). lintplus isn't listed: it comes
# with lsp. lpm's install skips candidates already installed and installs the rest,
# so naming it again would replace ours (0.7) with upstream's (0.2).
#
# LITE_USERDIR selects another user dir, e.g. a copy for headless testing.
set -e
here=$(dirname "$(readlink -f "$0")")
lpm=$here/../lite-xl/scripts/lpm
export LITE_USERDIR=${LITE_USERDIR:-$here}

"$lpm" install --no-install-optional json
"$lpm" install --no-install-optional --symlink \
  widget shapes lsp build debugger repl language_yaml tab_switcher tab_overflow menubar highlight_selection search_ui ephemeral_tabs navigate nerdicons terminal openurl qtcreator
"$lpm" install --no-install-optional \
  bracketmatch language_make
