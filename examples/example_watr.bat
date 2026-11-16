@echo off
setlocal enabledelayedexpansion

:: ==============================================================================
:: TheFlux Runner: Example WATR (WebAssembly Text Runner via Wasmer)
:: Arquivo: examples/example_watr.bat
:: ==============================================================================

cd /d "%~dp0\.."

if exist "%USERPROFILE%\.wasmer\bin\wasmer.exe" (
    set "PATH=%USERPROFILE%\.wasmer\bin;%PATH%"
)

where wasmer >nul 2>&1
if errorlevel 1 (
    echo [ERRO] 'wasmer' nao encontrado no PATH. Instale o Wasmer para executar os arquivos .wat.
    exit /b 1
)

if not exist "t_wat\*.wat" (
    echo [ERRO] Nenhum arquivo .wat encontrado em t_wat\. Execute bin\examples_wat.exe primeiro.
    exit /b 1
)

:: Prepara entradas padrao para testes interativos
(
echo Ana
echo 30
echo 9.99
echo true
echo A
echo 2+3i
echo 2026-08-28T12:00:00Z
) > t_stdin_interactive.tmp

(
echo andre
echo luiz
) > t_stdin_contract.tmp

(
echo dado
) > t_stdin_dado.tmp

type nul > t_stdin_empty.tmp

set /a ACERTOS=0
set /a ERROS=0

for /f "delims=" %%f in ('dir /b /on "t_wat\*.wat"') do (
    set "NOME=%%f"
    set "STDIN_FILE=t_stdin_empty.tmp"
    if /i "!NOME!"=="input.wat" set "STDIN_FILE=t_stdin_dado.tmp"
    if /i "!NOME!"=="ExampleOfInput.wat" set "STDIN_FILE=t_stdin_interactive.tmp"
    if /i "!NOME!"=="ExampleOfUseIoStdLib_IoInputContract.wat" set "STDIN_FILE=t_stdin_contract.tmp"

    wasmer run "t_wat\%%f" < "!STDIN_FILE!" > t_watr_out.tmp 2>&1
    if !errorlevel! equ 0 (
        set /a ACERTOS+=1
        setlocal disabledelayedexpansion
        for /f "delims=" %%l in ('findstr /n "^" "t_watr_out.tmp"') do (
            set "LINE=%%l"
            setlocal enabledelayedexpansion
            set "LINE=!LINE:*:=!"
            echo   ^| !LINE!
            endlocal
        )
        endlocal
        echo   OK  %%f
    ) else (
        set /a ERROS+=1
        set "LAST_LINE=Sem erro emitido"
        for /f "usebackq delims=" %%l in ("t_watr_out.tmp") do (
            set "LAST_LINE=%%l"
        )
        echo FALHA  %%f: !LAST_LINE!
    )
)

del /q /f t_stdin_*.tmp t_watr_out.tmp 2>nul

echo.
echo !ACERTOS! sucesso, !ERROS! falha(s)

if !ERROS! equ 0 (
    exit /b 0
) else (
    exit /b 1
)
