#!/bin/bash
# Build lite-xl from ../lite-xl and run it with this dir as the user config.
#
# lite-xl finds its data dir relative to the real executable path (<prefix>/bin
# -> <prefix>/share/lite-xl), so we assemble a prefix in ../.run: a copy of the
# binary plus symlinks into the source data/ dir, so edits to Lua files under
# lite-xl/data take effect on restart without rebuilding.  Only start.lua comes
# from the build dir, since meson generates it (version substitution).
#
# Usage: ./run.sh [lite-xl args...]     e.g. ./run.sh ~/projects/foo
#        LITE_CLANGD=/usr/bin/clangd ./run.sh ...   to use a different clangd
set -e

userdir=$(dirname "$(readlink -f "$0")")
root=$(dirname "$userdir")
src=$root/lite-xl
build=$src/build
prefix=$root/.run
datadir=$prefix/share/lite-xl

[ -d "$build" ] || meson setup "$build" "$src"
ninja -C "$build" >&2

mkdir -p "$prefix/bin" "$datadir/core"
# copy then rename so this works while another instance is running
cp "$build/src/lite-xl" "$prefix/bin/lite-xl.new"
mv -f "$prefix/bin/lite-xl.new" "$prefix/bin/lite-xl"

for d in plugins colors fonts; do ln -sfn "$src/data/$d" "$datadir/$d"; done
find "$datadir/core" -maxdepth 1 -type l ! -exec test -e {} \; -delete  # drop stale links
for f in "$src"/data/core/*; do ln -sfn "$f" "$datadir/core/"; done
ln -sfn "$build/start.lua" "$datadir/core/start.lua"

# clangd for the lsp plugin (see init.lua); defaults to the Android NDK's (17.0.2)
: "${LITE_CLANGD:=$HOME/android-sdk/ndk/26.3.11579264/toolchains/llvm/prebuilt/linux-x86_64/bin/clangd}"
export LITE_CLANGD

LITE_USERDIR=$userdir exec "$prefix/bin/lite-xl" "$@"
