@echo off
setlocal enabledelayedexpansion

echo ==============================================================================
echo [TheFlux] Script de Rollback Transacional do Compilador
echo ==============================================================================

cd /d "%~dp0\.."

set "TARGET_TIER=%1"

if "%TARGET_TIER%"=="" (
    echo Uso: scripts\rollback_bootstrap.bat [--prev / --last-good / --golden]
    echo   --prev      : Restaura a versao de bin/ imediatamente anterior ao ultimo build
    echo   --last-good : Restaura o ultimo compilador aprovado em fixpoint stage2/stage3
    echo   --golden    : Restaura a semente base imutavel de bootstrap/seed/
    exit /b 1
)

if "%TARGET_TIER%"=="--prev" (
    echo [*] Executando Rollback para --prev [build/lkg/prev/]...
    if not exist "build\lkg\prev\fluxc.exe" (
        echo [ERRO] Snapshot build/lkg/prev/fluxc.exe nao encontrado!
        exit /b 1
    )
    copy /y "build\lkg\prev\fluxc.exe" "bin\fluxc.exe"
    if exist "build\lkg\prev\fluxvm.exe" copy /y "build\lkg\prev\fluxvm.exe" "bin\fluxvm.exe"
    echo [OK] Rollback para --prev concluido com sucesso!
    bin\fluxc.exe --version
    exit /b 0
)

if "%TARGET_TIER%"=="--last-good" (
    echo [*] Executando Rollback para --last-good [build/lkg/last-good/]...
    if not exist "build\lkg\last-good\fluxc.exe" (
        echo [ERRO] Snapshot build/lkg/last-good/fluxc.exe nao encontrado!
        exit /b 1
    )
    copy /y "build\lkg\last-good\fluxc.exe" "bin\fluxc.exe"
    if exist "build\lkg\last-good\fluxvm.exe" copy /y "build\lkg\last-good\fluxvm.exe" "bin\fluxvm.exe"
    echo [OK] Rollback para --last-good concluido com sucesso!
    bin\fluxc.exe --version
    exit /b 0
)

if "%TARGET_TIER%"=="--golden" (
    echo [*] Executando Rollback para --golden [bootstrap/seed/]...
    call "bootstrap\seed\emergency_cold_seed.bat"
    if errorlevel 1 (
        echo [ERRO] Falha ao restaurar Golden Seed!
        exit /b 1
    )
    echo [OK] Rollback para --golden concluido com sucesso!
    bin\fluxc.exe --version
    exit /b 0
)

echo [ERRO] Parametro desconhecido: %TARGET_TIER%
echo Uso: scripts\rollback_bootstrap.bat [--prev / --last-good / --golden]
exit /b 1
