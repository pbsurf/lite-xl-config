@echo off
rem Windows counterpart of addons.sh: copies this config's add-ons (and the upstream ones
rem they need) into plugins\, libraries\ and colors\ here; needs CMake, no lpm.
rem Run again after changing the add-ons in the lite-xl checkout or the list in
rem lite-xl\cmake\InstallAddons.cmake (keep it in step with addons.sh).
rem If cmake isn't on PATH: use the one in Visual Studio's
rem Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin.
setlocal
cmake -DSRC="%~dp0..\lite-xl" -DUSERDIR="%~dp0." -P "%~dp0..\lite-xl\cmake\InstallAddons.cmake"
