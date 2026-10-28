@echo off
rem Windows counterpart of addons.sh, needs CMake, no lpm. Our add-ons are used from the
rem lite-xl checkout (init.lua adds it with core.add_addon_dir), so this only downloads the
rem upstream ones they need into plugins\, libraries\ and colors\ here, and removes copies
rem of ours an earlier version of it made (they'd be used instead). Run again after
rem changing the list in lite-xl\cmake\InstallAddons.cmake (keep it in step with addons.sh).
rem It also installs clangd (for the lsp plugin) into tools\clangd here, once.
rem %LITE_BUILD% (default: lite-xl\build) is checked for the native modules (libterminal).
rem If cmake isn't on PATH: use the one in Visual Studio's
rem Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin.
setlocal
if not defined LITE_BUILD set "LITE_BUILD=%~dp0..\lite-xl\build"
cmake -DSRC="%~dp0..\lite-xl" -DUSERDIR="%~dp0." -DBUILD="%LITE_BUILD%" -P "%~dp0..\lite-xl\cmake\InstallAddons.cmake"
