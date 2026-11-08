@echo off
setlocal enabledelayedexpansion

echo ==============================================================================
echo [TheFlux] Compilacao Nativa de Ferramentas (src\tools\*)
echo ==============================================================================

cd /d "%~dp0\.."

:: 1. Verificacao de Pre-requisitos
if not exist "bin\fluxc.exe" (
    echo [ERRO] bin\fluxc.exe nao encontrado. Execute scripts\bootstrap.bat primeiro.
    exit /b 1
)
where clang >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Clang nao encontrado no PATH. Instale o LLVM 18+ para continuar.
    exit /b 1
)
if not exist "src\tools" (
    echo [ERRO] Diretorio src\tools nao encontrado.
    exit /b 1
)

if not exist "bin" mkdir "bin"

set /a TOTAL_TOOLS=0

:: 2. Compilacao de arquivos diretos em src\tools\*.flux
for %%f in (src\tools\*.flux) do (
    call :compile_tool "%%f" "%%~nf"
    if errorlevel 1 goto fail
)

:: 3. Compilacao de ferramentas organizadas em subpastas src\tools\<nome>\
for /d %%d in (src\tools\*) do (
    set "TOOL_NAME=%%~nxd"
    if exist "%%d\!TOOL_NAME!.flux" (
        call :compile_tool "%%d\!TOOL_NAME!.flux" "!TOOL_NAME!"
        if errorlevel 1 goto fail
    ) else if exist "%%d\main.flux" (
        call :compile_tool "%%d\main.flux" "!TOOL_NAME!"
        if errorlevel 1 goto fail
    ) else (
        for %%f in ("%%d\*.flux") do (
            call :compile_tool "%%f" "%%~nf"
            if errorlevel 1 goto fail
        )
    )
)

if !TOTAL_TOOLS! equ 0 (
    echo [AVISO] Nenhuma ferramenta .flux encontrada em src\tools\.
) else (
    echo [OK] !TOTAL_TOOLS! ferramenta^(s^) compilada^(s^) com exito em bin\.
)

echo ==============================================================================
echo [SUCESSO] Compilacao de src\tools concluida (!TOTAL_TOOLS! ferramenta^(s^)).
echo ==============================================================================
exit /b 0

:compile_tool
set "SRC_FILE=%~1"
set "OUT_NAME=%~2"
echo     [*] Compilando %SRC_FILE% -^> bin\%OUT_NAME%.exe...
del /q /f "bin\%OUT_NAME%.exe" "bin\%OUT_NAME%.ll" 2>nul
bin\fluxc.exe --no-run --emit-llvm --target llvm -o "bin\%OUT_NAME%" "%SRC_FILE%"
if errorlevel 1 (
    echo [ERRO] Falha ao compilar %SRC_FILE%.
    exit /b 1
)
if exist "scripts\patch_tool_ll.py" (
    python scripts\patch_tool_ll.py "bin\%OUT_NAME%.ll"
    clang -O2 -Wno-deprecated-declarations -Wno-override-module -o "bin\%OUT_NAME%.exe" "bin\%OUT_NAME%.ll" -Llib -lfluxcompiler -lfluxrt -ladvapi32 -lws2_32 -lkernel32
)
if not exist "bin\%OUT_NAME%.exe" (
    echo [ERRO] Binario bin\%OUT_NAME%.exe nao foi gerado.
    exit /b 1
)
del /q /f "bin\%OUT_NAME%.ll" 2>nul
set /a TOTAL_TOOLS+=1
exit /b 0

:fail
echo ==============================================================================
echo [ERRO] Falha durante a compilacao das ferramentas em src\tools.
echo ==============================================================================
exit /b 1
