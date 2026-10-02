use DslStdLib
use RuleLexer
use RuleAst
use RuleExecutor
use AsmAst
use AsmExecutor

program (ExampleOfUseDslStdLib_DslSandboxContract) {
      #L 1. Motor de Assembly com limites de Sandbox
      mut as data: asmEngine = AsmAst::getEngine("x86_64")

      mut as bool: ok_to = dslSetTimeout(asmEngine, 250)
      println("1. Configuracao de Timeout (250ms):")
      println("   Limite de tempo aplicado: " + ok_to)

      mut as bool: ok_il = dslSetInstructionLimit(asmEngine, 5000)
      println("2. Configuracao de Limite de Instrucoes (Gas):")
      println("   Cota de instrucoes aplicada: " + ok_il)

      mut as bool: ok_mem = dslSetMemoryLimit(asmEngine, 1048576)
      println("3. Configuracao de Teto de Memoria (1MB):")
      println("   Teto de memoria aplicado: " + ok_mem)

      #L 2. Execucao de Assembly sob controle do Sandbox
      mut as data: ctx = map{
            "1": 15,
            "2": 3,
            "3": 0
      }
      mut as data: res = AsmExecutor::executeAsmInline(asmEngine, "mov rax, {1}\nimul rax, {2}\nmov {3}, rax", ctx)
      mut as map: m = res as map
      println("4. Execucao governada com sucesso (15 * 3):")
      println("   Resultado: " + m["3"])

      #L 3. Governanca na DSL de regras de negocio
      mut as data: rLexer = RuleLexer::initRuleLexer()
      mut as data: rParser = RuleAst::createRuleParser(rLexer)
      mut as bool: rSand = RuleExecutor::configureRuleSandbox(rParser, 500, 1000)
      println("5. Sandbox aplicado na DSL de regras:")
      println("   Configuracao bem-sucedida: " + rSand)
}
