@echo off
del *.lib
@echo Setting environment for using Microsoft Visual Studio 2010 x86 tools.

@call :GetVSCommonToolsDir
@if "%VS100COMNTOOLS%"=="" goto error_no_VS100COMNTOOLSDIR

@call "%VS100COMNTOOLS%VCVarsQueryRegistry.bat" 32bit No64bit

@if "%VSINSTALLDIR%"=="" goto error_no_VSINSTALLDIR
@if "%FrameworkDir32%"=="" goto error_no_FrameworkDIR32
@if "%FrameworkVersion32%"=="" goto error_no_FrameworkVer32
@if "%Framework35Version%"=="" goto error_no_Framework35Version

@set FrameworkDir=%FrameworkDir32%
@set FrameworkVersion=%FrameworkVersion32%

@if not "%WindowsSdkDir%" == "" (
	@set "PATH=%WindowsSdkDir%bin\NETFX 4.0 Tools;%WindowsSdkDir%bin;%PATH%"
	@set "INCLUDE=%WindowsSdkDir%include;%INCLUDE%"
	@set "LIB=%WindowsSdkDir%lib;%LIB%"
)

@rem
@rem Root of Visual Studio IDE installed files.
@rem
@set DevEnvDir=%VSINSTALLDIR%Common7\IDE\

@rem PATH
@rem ----
@if exist "%VSINSTALLDIR%Team Tools\Performance Tools" (
	@set "PATH=%VSINSTALLDIR%Team Tools\Performance Tools;%PATH%"
)
@if exist "%ProgramFiles%\HTML Help Workshop" set PATH=%ProgramFiles%\HTML Help Workshop;%PATH%
@if exist "%ProgramFiles(x86)%\HTML Help Workshop" set PATH=%ProgramFiles(x86)%\HTML Help Workshop;%PATH%
@if exist "%VCINSTALLDIR%VCPackages" set PATH=%VCINSTALLDIR%VCPackages;%PATH%
@set PATH=%FrameworkDir%%Framework35Version%;%PATH%
@set PATH=%FrameworkDir%%FrameworkVersion%;%PATH%
@set PATH=%VSINSTALLDIR%Common7\Tools;%PATH%
@if exist "%VCINSTALLDIR%BIN" set PATH=%VCINSTALLDIR%BIN;%PATH%
@set PATH=%DevEnvDir%;%PATH%

@if exist "%VSINSTALLDIR%VSTSDB\Deploy" (
	@set "PATH=%VSINSTALLDIR%VSTSDB\Deploy;%PATH%"
)

@if not "%FSHARPINSTALLDIR%" == "" (
	@set "PATH=%FSHARPINSTALLDIR%;%PATH%"
)

@rem INCLUDE
@rem -------
@if exist "%VCINSTALLDIR%ATLMFC\INCLUDE" set INCLUDE=%VCINSTALLDIR%ATLMFC\INCLUDE;%INCLUDE%
@if exist "%VCINSTALLDIR%INCLUDE" set INCLUDE=%VCINSTALLDIR%INCLUDE;%INCLUDE%

@rem LIB
@rem ---
@if exist "%VCINSTALLDIR%ATLMFC\LIB" set LIB=%VCINSTALLDIR%ATLMFC\LIB;%LIB%
@if exist "%VCINSTALLDIR%LIB" set LIB=%VCINSTALLDIR%LIB;%LIB%

@rem LIBPATH
@rem -------
@if exist "%VCINSTALLDIR%ATLMFC\LIB" set LIBPATH=%VCINSTALLDIR%ATLMFC\LIB;%LIBPATH%
@if exist "%VCINSTALLDIR%LIB" set LIBPATH=%VCINSTALLDIR%LIB;%LIBPATH%
@set LIBPATH=%FrameworkDir%%Framework35Version%;%LIBPATH%
@set LIBPATH=%FrameworkDir%%FrameworkVersion%;%LIBPATH%

@goto end

@REM -----------------------------------------------------------------------
:GetVSCommonToolsDir
@set VS100COMNTOOLS=
@call :GetVSCommonToolsDirHelper32 HKLM > nul 2>&1
@if errorlevel 1 call :GetVSCommonToolsDirHelper32 HKCU > nul 2>&1
@if errorlevel 1 call :GetVSCommonToolsDirHelper64  HKLM > nul 2>&1
@if errorlevel 1 call :GetVSCommonToolsDirHelper64  HKCU > nul 2>&1
@exit /B 0

:GetVSCommonToolsDirHelper32
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Microsoft\VisualStudio\SxS\VS7" /v "10.0"') DO (
	@if "%%i"=="10.0" (
		@SET "VS100COMNTOOLS=%%k"
	)
)
@if "%VS100COMNTOOLS%"=="" exit /B 1
@SET "VS100COMNTOOLS=%VS100COMNTOOLS%Common7\Tools\"
@exit /B 0

:GetVSCommonToolsDirHelper64
@for /F "tokens=1,2*" %%i in ('reg query "%1\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VS7" /v "10.0"') DO (
	@if "%%i"=="10.0" (
		@SET "VS100COMNTOOLS=%%k"
	)
)
@if "%VS100COMNTOOLS%"=="" exit /B 1
@SET "VS100COMNTOOLS=%VS100COMNTOOLS%Common7\Tools\"
@exit /B 0

@REM -----------------------------------------------------------------------
:error_no_VS100COMNTOOLSDIR
@echo ERROR: Cannot determine the location of the VS Common Tools folder.
@goto end

:error_no_VSINSTALLDIR
@echo ERROR: Cannot determine the location of the VS installation.
@goto end

:error_no_FrameworkDIR32
@echo ERROR: Cannot determine the location of the .NET Framework 32bit installation.
@goto end

:error_no_FrameworkVer32
@echo ERROR: Cannot determine the version of the .NET Framework 32bit installation.
@goto end

:error_no_Framework35Version
@echo ERROR: Cannot determine the .NET Framework 3.5 version.
@goto end

:end

set COREDIR=%CD%

SET /P compile=Do you want to compile beetle-ngp-libretro? [y/n]:
if (%compile% == "y") do (
cd beetle-ngp-libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy beetle-ngp-libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib beetle-ngp-libretro.lib)

SET /P compile=Do you want to compile beetle-pce-fast-libretro? [y/n]:
if (%compile% == "y") do (
cd beetle-pce-fast-libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy beetle-pce-fast-libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib beetle-pce-fast-libretro.lib)

SET /P compile=Do you want to compile beetle-vb-libretro? [y/n]:
if (%compile% == "y") do (
cd beetle-vb-libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy beetle-vb-libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib beetle-vb-libretro.lib)

SET /P compile=Do you want to compile beetle-wswan-libretro? [y/n]:
if (%compile% == "y") do (
cd beetle-wswan-libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy beetle-wswan-libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib beetle-wswan-libretro.lib)

SET /P compile=Do you want to compile fba-libretro? [y/n]:
if (%compile% == "y") do (
cd fba-libretro\svn-current\trunk\projectfiles\msvc-libretro
cd 
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy fba-libretro\svn-current\trunk\projectfiles\msvc-libretro\Release_LTCG\msvc-2010-360.lib fba-libretro.lib)

SET /P compile=Do you want to compile Genesis-Plus-GX? [y/n]:
if (%compile% == "y") do (
cd Genesis-Plus-GX\libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy Genesis-Plus-GX\libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib Genesis-Plus-GX.lib)

SET /P compile=Do you want to compile libretro-fceumm? [y/n]:
if (%compile% == "y") do (
cd libretro-fceumm\src\drivers\libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy libretro-fceumm\src\drivers\libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib libretro-fceumm.lib)

SET /P compile=Do you want to compile libretro-prboom? [y/n]:
if (%compile% == "y") do (
cd libretro-prboom\libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy libretro-prboom\libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib libretro-prboom.lib)

SET /P compile=Do you want to compile mame2003-libretro? [y/n]:
if (%compile% == "y") do (
cd mame2003-libretro\src\libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy mame2003-libretro\src\libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib mame2003-libretro.lib)

SET /P compile=Do you want to compile nxengine-libretro? [y/n]:
if (%compile% == "y") do (
cd nxengine-libretro\nxengine\libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy nxengine-libretro\nxengine\libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib nxengine-libretro.lib)

SET /P compile=Do you want to compile snes9x-next? [y/n]:
if (%compile% == "y") do (
cd snes9x-next\libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy snes9x-next\libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib snes9x-next.lib)

SET /P compile=Do you want to compile tyrquake? [y/n]:
if (%compile% == "y") do (
cd tyrquake\libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy tyrquake\libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib tyrquake.lib)

SET /P compile=Do you want to compile vba-next? [y/n]:
if (%compile% == "y") do (
cd vba-next\libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy vba-next\libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib vba-next.lib)

SET /P compile=Do you want to compile nestopia? [y/n]:
if (%compile% == "y") do (
cd nestopia\libretro\msvc
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG /target:clean
msbuild msvc-2010-360.sln /p:Configuration=Release_LTCG
cd %COREDIR%
copy nestopia\libretro\msvc\msvc-2010-360\Release_LTCG\msvc-2010-360.lib nestopia.lib)