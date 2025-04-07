@echo off

cd ../src
cls
set "file=%~1"
if "%file%"=="" set "file=main"
nusmv "%file%.smv"
cd ../scripts
