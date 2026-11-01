use DslStdLib
use CalcLexer
use CalcAst
use CalcSemantic
use RuleLexer
use RuleAst
use RuleSemantic

program (ExampleOfUseDslStdLib_DslParserContract) {
      #L 1. Inicializacao do Parser da DSL de Calculo
      mut as data: lexer = CalcLexer::initCalcLexer()
      mut as data: parser = CalcAst::createCalcParser(lexer)

      #L 2. Validacao de expressao valida
      imut as string: expr_valida = "10 + 20 * 30"
      mut as bool: ok_sintaxe = dslIsValidSyntax(parser, expr_valida)
      println("1. Validacao de expressao valida:")
      println("   Sintaxe integra: " + ok_sintaxe)

      #L 3. Deteccao de erro de sintaxe
      imut as string: expr_invalida = "10 + + 20"
      mut as bool: invalida = dslIsValidSyntax(parser, expr_invalida)
      println("2. Validacao de expressao com erro:")
      println("   Sintaxe rejeitada com sucesso: " + (invalida == false))

      #L 4. Extracao de erros estruturados (1-index)
      mut as list of data: erros = dslGetErrors(parser, expr_invalida)
      mut as map: err1 = erros[1] as map
      println("3. Diagnostico estruturado (1-index):")
      println("   Linha do erro:   " + err1["linha"])
      println("   Coluna do erro:  " + err1["coluna"])
      println("   Mensagem:        " + err1["mensagem"])

      #L 5. Formatacao visual com carets (^)
      mut as string: relatorio = dslFormatErrors(erros, expr_invalida)
      println("4. Relatorio visual formatado:")
      println("   " + relatorio)

      #L 6. Modulo de semantica da subpasta rule_dsl
      mut as data: rLexer = RuleLexer::initRuleLexer()
      mut as data: rParser = RuleAst::createRuleParser(rLexer)
      mut as bool: rOk = RuleSemantic::validateRule(rParser, "se saldo > 100 entao aprovar")
      println("5. Validacao de regra de negocio (rule_dsl):")
      println("   Regra valida: " + rOk)
}
