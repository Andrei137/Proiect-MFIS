@echo off
setlocal EnableDelayedExpansion

if "%~1"=="" goto usage

set "CMD_FILE=%TEMP%\nusmv_commands.tmp"
(
    echo go
    echo pick_state
    echo simulate -v
    echo check_ltlspec
    echo quit
) > "%CMD_FILE%"

cd ..

if not exist bin (
    mkdir bin
)

if "%~1"=="-all" (
    for %%F in (src\*.smv) do (
        set "FILENAME=%%~nF"
        call :processFile !FILENAME!
    )
    goto done
)

:loop
if "%~1"=="" goto done

call :processFile %~1
shift
goto loop

:processFile
set "INPUT_FILE=%~1"
set "SMV_PATH=src\%INPUT_FILE%.smv"
set "OUTPUT_FILE=bin\%INPUT_FILE%_output.txt"

echo Processing %SMV_PATH%...
(
    echo === Processing %INPUT_FILE%.smv ===
    nusmv -source "%CMD_FILE%" "%SMV_PATH%"
) > "%OUTPUT_FILE%"

echo Output written to %OUTPUT_FILE%
goto :eof

:done
del "%CMD_FILE%" >nul 2>&1
cd scripts
goto :eof

:usage
echo Usage: logs file1 [file2 ...]  OR  logs -all
exit /b 1
