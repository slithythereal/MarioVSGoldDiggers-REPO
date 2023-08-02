@echo off 
cls
title MVGD REQUIREMENTS DOWNLOADER
echo.
echo HELLO. THIS IS THE MVGD REQUIREMENTS DOWNLOADER
echo this will automatically install the dependencies you need for this game
echo if you need help compiling onto macos or linux i suggest joining the Haxe discord and asking questions there 
echo https://discord.gg/tjXpabSpj3
echo.
echo PRESS ANY KEY TO CONTINUE
pause >nul
cls

title MVGD REQUIREMENTS DOWNLOADER - Installing Haxe
echo.
echo --Installing Haxe--
start https://haxe.org/download/version/4.2.5/
echo DOWNLOAD THIS AND RUN THE INSTALLER, AFTER YOU DO THAT PRESS ANY KEY TO CONTINUE
pause >nul
cls

title MVGD REQUIREMENTS DOWNLOADER - Installing git-scm
echo. 
echo --Installing git-scm--
start https://git-scm.com/downloads
echo DOWNLOAD THIS AND RUN THE INSTALLER, AFTER YOU DO THAT PRESS ANY KEY TO CONTINUE
pause >nul
cls

title MVGD REQUIREMENTS DOWNLOADER - Installing Visual Studio Community
echo. 
echo --Installing Visual Studio Community (WINDOWS ONLY)--
start https://apps.microsoft.com/store/detail/visual-studio-community-2019/XP8CDJNZKFM06W
echo while installing this, don't click on any of the options to install workloads. Instead go to the individual components tab and choose the following.
echo.
echo MSVC v142 - VS 2019 C++ x64/x86 build tools
echo Windows SDK (10.0.17763.0)
echo.
echo PRESS ENTER TO CONTINUE WHEN IT'S DONE
pause >nul
cls

title MVGD REQUIREMENTS DOWNLOADER - Installing Dependencies
echo.
echo --INSTALLING DEPENDENCIES--
echo Installing flixel
echo.
haxelib install flixel 
echo.
echo Installing lime
echo.
haxelib install lime
echo.
echo Installing openfl
echo. 
haxelib install openfl
echo.
echo Installing flixel addons
echo. 
haxelib install flixel-addons
echo. 
echo Installing actuate
echo.
haxelib install actuate
echo.
echo FINISHED INSTALLING DEPENDENCIES!!
echo PRESS ANY KEY TO CONTINUE
pause >nul
cls

title MVGD REQUIREMENTS DOWNLOADER - Running Setups
echo.
echo --RUNNING SETUPS--
echo Setting up lime
echo.
haxelib run lime setup
echo. 
echo Setting up flixel
echo. 
haxelib run lime setup flixel
echo. 
echo Setting up flixel tools
echo. 
haxelib run flixel-tools setup
echo. 
echo FINISHED RUNNING SETUPS!!
echo PRESS ANY KEY TO CONTINUE
pause >nul
cls

title MVGD REQUIREMENTS DOWNLOADER - Setting versions
echo. 
echo --SETTING VERSIONS--
echo Setting flixel version to 4.11.0
echo.
haxelib set flixel 4.11.0
echo.
echo. Setting Lime version to 7.9.0
echo. 
haxelib set lime 7.9.0
echo.
echo Setting openfl version to 9.1.0
echo.
haxelib set openfl 9.1.0
echo. 
echo Setting flixel addons version to 2.11.0
echo. 
haxelib set flixel-addons 2.11.0
echo. 
echo Setting hxcpp to 4.2.1
echo. 
haxelib set hxcpp 4.2.1
echo.
echo Setting lime samples to 7.0.0
echo. 
haxelib set lime-samples 7.0.0
echo. 
echo FINISHED SETTING VERSIONS!!
echo PRESS ANY KEY TO CONTINUE
pause >nul
cls

title MVGD REQUIREMENTS DOWNLOADER - Installing Hashlink
echo.
echo Installing Hashlink
echo.
lime setup hl
echo.
echo ALRIGHT JOB WELL DONE you can close this now
echo HAVE FUN WITH WHATEVER ABOMINATIONS YOU MAKE NOW!!
pause >nul
exit