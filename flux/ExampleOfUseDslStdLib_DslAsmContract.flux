use DslStdLib
use AsmLexer
use AsmSemantic
use AsmAst
use AsmExecutor

program (ExampleOfUseDslStdLib_DslAsmContract) {
      #L 1. Inicializacao do Motor de Assembly Inline de Hardware
      mut as data: asmEngine = dslGetAsmEngine("x86_64")
      println("1. Motor de Assembly Inicializado:")
      println("   Arquitetura: x86_64")

      #L 2. Validacao estatica de registradores da ABI
      mut as list of string: regs_validos = ["rax", "rcx", "rdx", "rbx"]
      mut as bool: ok_regs = dslAsmValidateRegisters(asmEngine, regs_validos)
      println("2. Validacao de registradores:")
      println("   Registradores compativeis: " + ok_regs)

      mut as list of string: regs_invalidos = ["rax", "regInvalido"]
      mut as bool: falha_regs = dslAsmValidateRegisters(asmEngine, regs_invalidos)
      println("   Rejeicao de registrador inexistente: " + (falha_regs == false))

      #L 3. Mapa de registradores (1-index humano vs 0-index maquina)
      mut as map: mapa_regs = dslAsmGetRegisterMap(asmEngine)
      mut as map: reg_rax = mapa_regs["rax"] as map
      println("3. Tabela de registradores (1-index vs 0-index):")
      println("   Registrador:        rax")
      println("   ID Humano (1-based): " + reg_rax["id_humano"])
      println("   Bits de largura:    " + reg_rax["bits"])

      #L 4. Montagem de instrucoes em opcodes de maquina (1-index)
      imut as string: instrucoes = "mov rax, rcx\nrdtsc"
      mut as list of int64: opcodes = dslAsmAssemble(asmEngine, instrucoes)
      println("4. Montagem de assembly (dslAsmAssemble):")
      println("   Primeiro byte montado (indice 1): " + opcodes[1])

      #L 5. Desmontagem (Engenharia reversa de opcodes de maquina)
      mut as string: desmonte = dslAsmDisassemble(asmEngine, opcodes)
      println("5. Desmontagem mnemônica (dslAsmDisassemble):")
      println("   " + desmonte)

      #L 6. Execucao dinamica com mapeamento posicional e move de contexto
      imut as string: script_calc = "mov rax, {1}\nimul rax, {2}\nmov {3}, rax"
      mut as bool: sintaxe_ok = dslIsValidSyntax(asmEngine, script_calc)
      println("6. Validacao sintatica do script assembly:")
      println("   Sintaxe valida: " + sintaxe_ok)

      mut as data: contexto = map{
            "1": 7,
            "2": 6,
            "3": 0
      }
      mut as data: saida = dslExecuteInline(asmEngine, script_calc, contexto)
      mut as map: m_saida = saida as map
      println("7. Execucao dinamica de Assembly Inline (7 * 6):")
      println("   Resultado no operando {3}: " + m_saida["3"])

      #L 7. Modulo da subpasta asm_dsl de biblioteca do usuario
      mut as data: aLex = AsmLexer::initAsmLexer()
      mut as list of data: aToks = AsmLexer::tokenizeAsm(aLex, "mov rax, 42")
      mut as map: at1 = aToks[1] as map
      println("8. Integracao com asm_dsl (1-index):")
      println("   Mnemonic capturado: " + at1["valor"])
}
