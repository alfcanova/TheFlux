use DslStdLib
use CalcLexer
use CalcAst
use CalcExecutor
use RuleLexer
use RuleAst
use RuleExecutor

program (ExampleOfUseDslStdLib_DslExecutionContract) {
      #L 1. Inicializacao do Parser e geracao de AST
      mut as data: lexer = CalcLexer::initCalcLexer()
      mut as data: parser = CalcAst::createCalcParser(lexer)
      mut as map: ast = dslGenerateAst(parser, "10 + 20")

      #L 2. Compilacao da AST para alvos nativos
      mut as data: comp_vmbc = dslCompile(ast, "vmbc")
      println("1. Compilacao de AST:")
      println("   Compilado para vmbc (> 0): " + (comp_vmbc != 0))

      mut as data: comp_llvm = dslCompile(ast, "llvm")
      println("   Compilado para llvm (> 0): " + (comp_llvm != 0))

      #L 3. Execucao inline consumindo contexto (move)
      mut as data: contexto_calc = map{
            "1": 10,
            "2": 20
      }
      mut as data: res_calc = dslExecuteInline(parser, "10 + 20", contexto_calc)
      mut as map: m_calc = res_calc as map
      println("2. Execucao inline dinamica da calculadora:")
      println("   Resultado computado: " + m_calc["resultado"])

      #L 4. Execucao inline de regra de negocio (RuleExecutor)
      mut as data: rLexer = RuleLexer::initRuleLexer()
      mut as data: rParser = RuleAst::createRuleParser(rLexer)
      mut as data: ctx_regra = map{
            "saldo": 1500
      }
      mut as data: res_regra = RuleExecutor::executeRuleInline(rParser, "se saldo > 1000 entao aprovar", ctx_regra)
      mut as map: m_regra = res_regra as map
      println("3. Execucao de regra de negocio:")
      println("   Status resultante: " + m_regra["status"])
}
