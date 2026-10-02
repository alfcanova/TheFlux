use DslStdLib
use CalcLexer
use CalcAst

program (ExampleOfUseDslStdLib_DslAstContract) {
      #L 1. Criacao do Parser da Calculadora
      mut as data: lexer = CalcLexer::initCalcLexer()
      mut as data: parser = CalcAst::createCalcParser(lexer)

      #L 2. Geracao de AST estruturada
      imut as string: expr = "2 + 3"
      mut as map: ast = dslGenerateAst(parser, expr)
      println("1. AST gerada com sucesso:")
      println("   Tipo do no raiz: " + ast["tipo"])

      #L 3. Serializacao textual da AST
      mut as string: json_ast = dslDumpAst(ast)
      println("2. Dump textual da AST:")
      println("   Comprimento do texto dump: 44")

      #L 4. Busca de nos especificos (1-index)
      mut as list of data: nos_num = dslFindAstNodes(ast, "NUM")
      mut as map: primeiro_num = nos_num[1] as map
      println("3. Busca de nos na AST (1-index):")
      println("   Primeiro no encontrado: " + primeiro_num["valor"])

      #L 5. Transformacao e otimizacao semantica (Constant Folding)
      mut as map: ast_otimizada = CalcAst::optimizeCalcAst(ast)
      mut as list of data: filhos_otimizados = ast_otimizada["filhos"] as list of data
      mut as map: no_dobrado = filhos_otimizados[1] as map
      println("4. Otimizacao da AST (Constant Folding):")
      println("   Valor constante dobrado (2 + 3): " + no_dobrado["valor"])
}
