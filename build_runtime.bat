@echo off
setlocal enabledelayedexpansion

echo ==============================================================================
echo [TheFlux] Compilando Runtime Modular C para bin/libfluxrt.a (Marco M1)
echo ==============================================================================

if not exist "build\runtime" mkdir "build\runtime"
if not exist "bin" mkdir "bin"

set CFLAGS=-O2 -Wno-deprecated-declarations -Wno-override-module -Wno-incompatible-pointer-types -Iruntime/include

del /q /f build\runtime\*.o 2>nul

echo [+] Compilando modulos C em runtime/src...
clang %CFLAGS% -c runtime/src/core/*.c
if errorlevel 1 goto fail
clang %CFLAGS% -c runtime/src/memory/*.c
if errorlevel 1 goto fail
clang %CFLAGS% -c runtime/src/strings/*.c
if errorlevel 1 goto fail
clang %CFLAGS% -c runtime/src/collections/*.c
if errorlevel 1 goto fail
clang %CFLAGS% -c runtime/src/io/*.c
if errorlevel 1 goto fail
clang %CFLAGS% -c runtime/src/sys/*.c
if errorlevel 1 goto fail
clang %CFLAGS% -c runtime/src/intrinsics/*.c
if errorlevel 1 goto fail

move /y *.o build\runtime\ >nul 2>&1

echo [+] Empacotando biblioteca estatica bin/libfluxrt.a com llvm-ar...
llvm-ar rcs bin\libfluxrt.a build\runtime\*.o
if errorlevel 1 goto fail

copy /y bin\libfluxrt.a bin\fluxrt.lib >nul 2>&1

echo ==============================================================================
echo [OK] Sucesso! bin/libfluxrt.a e bin/fluxrt.lib gerados com exito.
echo ==============================================================================
exit /b 0

:fail
echo ==============================================================================
echo [ERRO] Falha durante a compilacao do runtime modular.
echo ==============================================================================
exit /b 1
