@echo off
setlocal enabledelayedexpansion

echo ==============================================================================
echo [TheFlux] Recuperacao de Emergencia Cold-Start a partir da Semente Dourada
echo ==============================================================================

cd /d "%~dp0\..\.."

if "%1"=="--full-cold" (
    echo [*] Executando cold-start 100%% nativo a partir de bootstrap/seed/ir/stage1.ll ^(zero legacy^)...
    if not exist "bootstrap\seed\ir\stage1.ll" (
        echo [ERRO] bootstrap/seed/ir/stage1.ll nao encontrado.
        exit /b 1
    )
    if not exist "build\intermediates" mkdir "build\intermediates"
    if not exist "bin" mkdir "bin"
    if not exist "lib" mkdir "lib"
    call scripts\build_runtime.bat
    if errorlevel 1 (
        echo [ERRO] Falha ao compilar runtime C em scripts\build_runtime.bat.
        exit /b 1
    )
    copy /y "bootstrap\seed\ir\stage1.ll" "build\intermediates\stage1.ll" >nul 2>&1
    clang -O2 -Wno-deprecated-declarations -Wno-override-module -o bin\fluxc.exe build\intermediates\stage1.ll -Llib -lfluxrt -ladvapi32 -lws2_32 -lkernel32
    if errorlevel 1 (
        echo [ERRO] Falha ao linkar bin/fluxc.exe a partir de stage1.ll.
        exit /b 1
    )
    bin\fluxc.exe --no-run --target llvm -o bin\fluxvm src\Fvm\fluxvm.flux
    if errorlevel 1 (
        echo [ERRO] Falha ao compilar bin/fluxvm.exe no cold-start.
        exit /b 1
    )
    del /q /f bin\fluxvm.ll 2>nul
    echo [OK] Cold-start 100%% nativo concluido. bin/fluxc.exe e bin/fluxvm.exe reconstruidos com sucesso.
    exit /b 0
)

echo [*] Restaurando binarios certificados da Golden Seed (bootstrap/seed/) para bin/ e lib/...
if not exist "bin" mkdir "bin"
if not exist "lib" mkdir "lib"
if not exist "build\intermediates" mkdir "build\intermediates"

copy /y "bootstrap\seed\bin\fluxc.exe" "bin\fluxc.exe"
if errorlevel 1 (
    echo [ERRO] Falha ao copiar bin/fluxc.exe da semente.
    exit /b 1
)
copy /y "bootstrap\seed\bin\fluxvm.exe" "bin\fluxvm.exe"
if errorlevel 1 (
    echo [ERRO] Falha ao copiar bin/fluxvm.exe da semente.
    exit /b 1
)
copy /y "bootstrap\seed\lib\libfluxrt.a" "lib\libfluxrt.a"
copy /y "bootstrap\seed\lib\fluxrt.lib" "lib\fluxrt.lib"
if exist "bootstrap\seed\ir\stage1.ll" copy /y "bootstrap\seed\ir\stage1.ll" "build\intermediates\stage1.ll" >nul 2>&1

echo [OK] Semente Dourada restaurada em bin/, lib/ e build/intermediates/ com sucesso!
exit /b 0
