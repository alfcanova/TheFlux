use DslStdLib
use CalcLexer
use CalcSemantic
use CalcAst
use CalcExecutor
use RuleLexer
use RuleSemantic
use RuleAst
use RuleExecutor
use AsmLexer
use AsmSemantic
use AsmAst
use AsmExecutor

program (ExampleOfUseDslStdLib_UserDslFolder) {
      println("==================================================")
      println("  Exemplo: DSLs em Subpastas do Usuario (fdsl/)  ")
      println("==================================================")

      #L 1. DSL de Calculo (fdsl/calc_dsl/)
      mut as data: cLexer = CalcLexer::initCalcLexer()
      mut as data: cParser = CalcAst::createCalcParser(cLexer)
      mut as bool: cValido = CalcSemantic::validateCalcExpr(cParser, "50 + 25 * 2")
      println("1. DSL de Calculo (fdsl/calc_dsl/):")
      println("   Sintaxe da expressao valida: " + cValido)

      mut as map: cAst = CalcAst::generateCalcAst(cParser, "50 + 25 * 2")
      mut as string: cDump = CalcAst::dumpCalcAst(cAst)
      println("   AST construida com tipo: " + cAst["tipo"])

      mut as data: cCtx = map{
            "1": 50,
            "2": 50
      }
      mut as data: cRes = CalcExecutor::executeCalcInline(cParser, "50 + 50", cCtx)
      mut as map: cMap = cRes as map
      println("   Calculo executado: " + cMap["resultado"])

      #L 2. DSL de Regras de Negocio (fdsl/rule_dsl/)
      mut as data: rLexer = RuleLexer::initRuleLexer()
      mut as data: rParser = RuleAst::createRuleParser(rLexer)
      mut as bool: rValido = RuleSemantic::validateRule(rParser, "se limite > 500 entao liberar")
      println("2. DSL de Regras (fdsl/rule_dsl/):")
      println("   Regra sintaticamente valida: " + rValido)

      mut as data: rCtx = map{
            "limite": 1000
      }
      mut as data: rRes = RuleExecutor::executeRuleInline(rParser, "se limite > 500 entao liberar", rCtx)
      mut as map: rMap = rRes as map
      println("   Status da regra: " + rMap["status"])

      #L 3. DSL de Assembly Inline (fdsl/asm_dsl/)
      mut as data: aEngine = AsmAst::getEngine("x86_64")
      mut as list of string: aRegs = ["rax", "rcx"]
      mut as bool: aRegsOk = AsmSemantic::validateAsmRegisters(aEngine, aRegs)
      println("3. DSL de Assembly (fdsl/asm_dsl/):")
      println("   Registradores validados: " + aRegsOk)

      mut as list of int64: bytes = AsmAst::assemble(aEngine, "mov rax, rcx\nrdtsc")
      println("   Primeiro byte de maquina (1-index): " + bytes[1])

      mut as data: aCtx = map{
            "1": 8,
            "2": 9,
            "3": 0
      }
      mut as data: aSaida = AsmExecutor::executeAsmInline(aEngine, "mov rax, {1}\nimul rax, {2}\nmov {3}, rax", aCtx)
      mut as map: aMap = aSaida as map
      println("   Multiplicacao em hardware (8 * 9): " + aMap["3"])

      println("==================================================")
      println("  Todas as DSLs incorporadas e executadas com 100%!")
      println("==================================================")
}
