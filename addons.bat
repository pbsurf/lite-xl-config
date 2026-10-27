@echo off
rem Windows counterpart of addons.sh: copies this config's add-ons (and the upstream ones
rem they need) into plugins\, libraries\ and colors\ here; needs CMake, no lpm.
rem Run again after changing the add-ons in the lite-xl checkout or the list in
rem lite-xl\cmake\InstallAddons.cmake (keep it in step with addons.sh).
rem The native modules (libterminal) are taken from %LITE_BUILD%\addons (default: lite-xl\build).
rem It also installs clangd (for the lsp plugin) into tools\clangd here, once.
rem If cmake isn't on PATH: use the one in Visual Studio's
rem Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin.
setlocal
if not defined LITE_BUILD set "LITE_BUILD=%~dp0..\lite-xl\build"
cmake -DSRC="%~dp0..\lite-xl" -DUSERDIR="%~dp0." -DBUILD="%LITE_BUILD%" -P "%~dp0..\lite-xl\cmake\InstallAddons.cmake"
