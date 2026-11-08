@echo off
setlocal enabledelayedexpansion

echo ==============================================================================
echo [TheFlux] Recompilacao Nativa de Drivers (flux_*) e Suites (examples_*)
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

if not exist "bin" mkdir "bin"

set /a TOTAL_DRIVERS=0
set /a TOTAL_EXAMPLES=0

:: 2. Recompilacao de .\flux_*.flux -> bin\flux_*.exe
echo [+] [1/2] Recompilando drivers da raiz (.\flux_*.flux)...
for %%f in (flux_*.flux) do (
    echo     [*] Compilando %%f -^> bin\%%~nf.exe...
    del /q /f "bin\%%~nf.exe" "bin\%%~nf.ll" 2>nul
    bin\fluxc.exe --no-run --target llvm -o "bin\%%~nf" "%%f"
    if errorlevel 1 (
        echo [ERRO] Falha ao compilar %%f.
        goto fail
    )
    if not exist "bin\%%~nf.exe" (
        echo [ERRO] Binario bin\%%~nf.exe nao foi gerado.
        goto fail
    )
    del /q /f "bin\%%~nf.ll" 2>nul
    set /a TOTAL_DRIVERS+=1
)
echo [OK] !TOTAL_DRIVERS! drivers flux_*.exe gerados com exito.

:: 3. Recompilacao de examples\examples_*.flux -> bin\examples_*.exe
echo [+] [2/2] Recompilando executores de exemplos (examples\examples_*.flux)...
for %%f in (examples\examples_*.flux) do (
    echo     [*] Compilando %%f -^> bin\%%~nf.exe...
    del /q /f "bin\%%~nf.exe" "bin\%%~nf.ll" 2>nul
    bin\fluxc.exe --no-run --target llvm -o "bin\%%~nf" "%%f"
    if errorlevel 1 (
        echo [ERRO] Falha ao compilar %%f.
        goto fail
    )
    if not exist "bin\%%~nf.exe" (
        echo [ERRO] Binario bin\%%~nf.exe nao foi gerado.
        goto fail
    )
    set /a TOTAL_EXAMPLES+=1
)
echo [OK] !TOTAL_EXAMPLES! executores examples_*.exe gerados com exito.

echo ==============================================================================
echo [SUCESSO] Recompilacao concluida (!TOTAL_DRIVERS! drivers + !TOTAL_EXAMPLES! suites).
echo ==============================================================================
exit /b 0

:fail
echo ==============================================================================
echo [ERRO] Falha durante a recompilacao dos binarios.
echo ==============================================================================
exit /b 1
