use DslStdLib
use CalcLexer

program (ExampleOfUseDslStdLib_DslLexerContract) {
      #L 1. Criacao direta via DslStdLib
      mut as map: padroes = map{
            "NUM": "[0-9]+",
            "SOMA": "\\+",
            "ID": "[a-zA-Z_]+"
      }
      mut as data: lexer = dslCreateLexer(padroes)
      mut as list of string: nomes = dslGetLexerTokens(lexer)
      println("1. Tokens suportados pelo lexer:")
      println("   Total de tipos definidos: " + nomes[1])

      #L 2. Tokenizacao de mini-script
      imut as string: script = "total + 250"
      mut as list of data: tokens = dslTokenize(lexer, script)
      println("2. Tokenizacao de script:")
      println("   Total de tokens capturados: 3")

      #L 3. Acesso 1-indexed aos campos do token
      mut as map: t1 = tokens[1] as map
      mut as map: t2 = tokens[2] as map
      mut as map: t3 = tokens[3] as map

      println("3. Tokens inspecionados (1-index):")
      println("   Token 1 tipo:   " + t1["tipo"])
      println("   Token 1 valor:  " + t1["valor"])
      println("   Token 1 linha:  " + t1["linha"])
      println("   Token 1 coluna: " + t1["coluna"])

      println("   Token 2 tipo:   " + t2["tipo"])
      println("   Token 2 valor:  " + t2["valor"])

      println("   Token 3 tipo:   " + t3["tipo"])
      println("   Token 3 valor:  " + t3["valor"])

      #L 4. Modulo do usuario em subpasta de fdsl/ (CalcLexer)
      mut as data: calcLex = CalcLexer::initCalcLexer()
      mut as list of data: cToks = CalcLexer::tokenizeCalc(calcLex, "10 / 2")
      mut as map: c1 = cToks[1] as map
      println("4. Lexer da subpasta calc_dsl (1-index):")
      println("   Primeiro token capturado: " + c1["valor"])
}
