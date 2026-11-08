@echo off
setlocal enabledelayedexpansion

echo ==============================================================================
echo [TheFlux] Pipeline de Bootstrapping 100%% Nativo (Marco M5)
echo ==============================================================================

cd /d "%~dp0\.."

:: 1. Verificacao de Ferramentas Nativas (Clang e LLVM-AR)
where clang >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Clang nao encontrado no PATH. Instale o LLVM 18+ para continuar.
    exit /b 1
)
where llvm-ar >nul 2>&1
if errorlevel 1 (
    echo [ERRO] llvm-ar nao encontrado no PATH. Instale o LLVM 18+ para continuar.
    exit /b 1
)

:: 2. Portao Boot-0: Compilacao da Runtime Modular C
echo [+] [Boot-0] Compilando Runtime Modular C (libfluxrt.a)...
call scripts\build_runtime.bat
if errorlevel 1 (
    echo [ERRO] Falha ao compilar runtime modular.
    exit /b 1
)

:: 3. Portao Boot-0.5: Empacotamento de libfluxcompiler.a
echo [+] [Boot-0.5] Empacotando biblioteca do compilador (libfluxcompiler.a)...
if not exist "build\intermediates" mkdir "build\intermediates"
if not exist "bin" mkdir "bin"
if not exist "lib" mkdir "lib"

if exist "build\intermediates\stage1_compiler.ll" (
    clang -O2 -Wno-deprecated-declarations -Wno-override-module -c build\intermediates\stage1_compiler.ll -o build\intermediates\stage1_compiler.o
    if errorlevel 1 goto fail
)

del /q /f lib\libfluxcompiler.a lib\fluxcompiler.lib 2>nul
llvm-ar rc lib\libfluxcompiler.a build\intermediates\stage1_compiler.o
if errorlevel 1 goto fail
copy /y lib\libfluxcompiler.a lib\fluxcompiler.lib >nul 2>&1
if errorlevel 1 goto fail

:: Linka bin\fluxc.exe a partir de stage1.ll e libfluxcompiler atualizado
echo [+] [Boot-0.8] Linkando bin\fluxc.exe a partir de stage1.ll e libfluxcompiler...
clang -O2 -Wno-deprecated-declarations -Wno-override-module -o bin\fluxc.exe build\intermediates\stage1.ll -Llib -lfluxcompiler -lfluxrt -ladvapi32 -lws2_32 -lkernel32
if errorlevel 1 goto fail

:: 4. Portao Boot-1: Validacao de Autonomia do Compilador Nativo (bin/fluxc.exe)
echo [+] [Boot-1] Verificando autonomia e CLI de bin/fluxc.exe...
bin\fluxc.exe --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] bin\fluxc.exe falhou no teste --version
    exit /b 1
)
bin\fluxc.exe -v >nul 2>&1
if errorlevel 1 (
    echo [ERRO] bin\fluxc.exe falhou no teste -v
    exit /b 1
)
bin\fluxc.exe --explain E0001 >nul 2>&1
if errorlevel 1 (
    echo [ERRO] bin\fluxc.exe falhou no teste --explain E0001
    exit /b 1
)
echo [OK] Portao Boot-1 Aprovado: bin/fluxc.exe operacional e autonomo.

:: 5. Portao Boot-2: Fixpoint e Certificacao Deterministica (M5)
echo [+] [Boot-2] Limpando artefatos intermediarios anteriores (stage2.* / stage3.*)...
del /q /f build\intermediates\stage2.* build\intermediates\stage3.* 2>nul

echo [+] [Boot-2] Iniciando Certificacao de Fixpoint (Stage 1 -^> Stage 2 -^> Stage 3)...

:: Stage 1 -> Stage 2
echo [*] Compilando src/main.flux com bin/fluxc.exe (Stage 1) -^> build/intermediates/stage2...
bin\fluxc.exe --no-run --target llvm -o build\intermediates\stage2 src\main.flux
if errorlevel 1 (
    echo [ERRO] Falha ao compilar stage2 com bin/fluxc.exe.
    exit /b 1
)
if not exist "build\intermediates\stage2.ll" (
    echo [ERRO] build/intermediates/stage2.ll nao foi gerado.
    exit /b 1
)
if not exist "build\intermediates\stage2.exe" (
    echo [ERRO] build/intermediates/stage2.exe nao foi gerado.
    exit /b 1
)

:: Stage 2 -> Stage 3
echo [*] Compilando src/main.flux com stage2.exe (Stage 2) -^> build/intermediates/stage3...
build\intermediates\stage2.exe --no-run --target llvm -o build\intermediates\stage3 src\main.flux
if errorlevel 1 (
    echo [ERRO] Falha ao compilar stage3 com stage2.exe.
    exit /b 1
)
if not exist "build\intermediates\stage3.ll" (
    echo [ERRO] build/intermediates/stage3.ll nao foi gerado.
    exit /b 1
)

:: Verificacao de Fixpoint Deterministico: fc /b
echo [*] Comparando stage2.ll e stage3.ll bit a bit...
fc /b build\intermediates\stage2.ll build\intermediates\stage3.ll >nul 2>&1
if errorlevel 1 (
    echo [ERRO] DIVERGENCIA DETECTADA! stage2.ll e stage3.ll diferem em conteudo.
    exit /b 1
)

echo [*] Registrando hashes SHA-256...
certutil -hashfile build\intermediates\stage2.ll SHA256 | findstr /v ":"
certutil -hashfile build\intermediates\stage3.ll SHA256 | findstr /v ":"

echo ==============================================================================
echo [SUCESSO] FIXPOINT DETERMINISTICO ATINGIDO COM ZERO BYTES DE DIVERGENCIA!
echo          SHA-256(stage2.ll) == SHA-256(stage3.ll)
echo ==============================================================================

:: Promover Stage 2 para compilador de producao bin/fluxc.exe
echo [+] Promovendo build/intermediates/stage2.exe para bin/fluxc.exe...
copy /y build\intermediates\stage2.exe bin\fluxc.exe
if errorlevel 1 (
    echo [ERRO] Falha ao promover stage2.exe para bin/fluxc.exe. Verifique se o executavel esta em uso.
    goto fail
)

:: 5.5. Portao Boot-3: Auto-Teste Funcional Semantico Pos-Promocao
echo [+] [Boot-3] Executando Auto-Teste Funcional Semantico no bin/fluxc.exe promovido...
(
echo function ^(bootFat^) ^(as int64: n^) as int64 {
echo       route {
echo             n ^<= 1 ==^> { emit^(nice, 1, "base"^) }
echo             _ ==^> { emit^(nice, n * bootFat^(n - 1^), "rec"^) }
echo       }
echo }
echo function ^(bootDiv^) ^(as int64: a, as int64: b^) as int64 {
echo       mut as int64: q = ^(a /i b^) ? {
echo             ==^> emit^(fail, 0, "div_zero"^)
echo             ==^> emit^(nice, q, "div_ok"^)
echo       }
echo }
echo program ^(BootSelfTest^) {
echo       print^(bootFat^(5^)^)
echo       mut as int64: r0 = bootDiv^(21, 0^)
echo       print^(r0.sta + ":" + r0.msg^)
echo       mut as int64: r1 = bootDiv^(21, 3^)
echo       print^(r1.sta + ":" + r1.val^)
echo }
) > build\intermediates\boot3_selftest.flux

bin\fluxc.exe build\intermediates\boot3_selftest.flux > build\intermediates\boot3_out.txt 2>&1
if errorlevel 1 (
    echo [ERRO] Portao Boot-3 falhou na execucao de boot3_selftest.flux!
    type build\intermediates\boot3_out.txt
    del /q /f build\intermediates\boot3_selftest.flux build\intermediates\boot3_out.txt 2>nul
    goto fail
)
findstr /c:"120" build\intermediates\boot3_out.txt >nul 2>&1
if errorlevel 1 goto boot3_fail
findstr /c:"fail:div_zero" build\intermediates\boot3_out.txt >nul 2>&1
if errorlevel 1 goto boot3_fail
findstr /c:"nice:7" build\intermediates\boot3_out.txt >nul 2>&1
if errorlevel 1 goto boot3_fail

del /q /f build\intermediates\boot3_selftest.flux build\intermediates\boot3_out.txt 2>nul
echo [OK] Portao Boot-3 Aprovado: Recursao universal e Short Circuit verificados em Stage 2!

:: 6. Compilacao do FluxVM Nativo
echo [+] Compilando bin/fluxvm.exe via Clang...
clang -O3 -Wno-deprecated-declarations -Iruntime -Iruntime/fvm runtime/fvm/fvm_arena.c runtime/fvm/fvm_parser.c runtime/fvm/fvm_core.c runtime/fvm/fvm_main.c runtime/flux_service.c -ladvapi32 -o bin\fluxvm.exe
if errorlevel 1 (
    echo [ERRO] Falha ao compilar bin/fluxvm.exe.
    exit /b 1
)
echo [OK] bin/fluxvm.exe operacional.

echo ==============================================================================
echo [TheFlux] BOOTSTRAPPING CONCLUIDO COM EXITO 100%% NATIVO (MARCO M5)!
echo ==============================================================================
exit /b 0

:boot3_fail
echo [ERRO] Portao Boot-3 reprovado: saida semantica divergente do esperado!
type build\intermediates\boot3_out.txt
del /q /f build\intermediates\boot3_selftest.flux build\intermediates\boot3_out.txt 2>nul
goto fail

:fail
echo ==============================================================================
echo [ERRO] Falha durante o processo de bootstrapping.
echo ==============================================================================
exit /b 1
