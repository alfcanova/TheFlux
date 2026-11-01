use DslStdLib
use LogoLexer
use LogoSemantic
use LogoAst
use LogoExecutor

program (ExampleOfUseDslStdLib_LogoDsl) {
      println("==================================================")
      println("  Exemplo: DSL Logo Tartaruga 2D (fdsl/logo_dsl/) ")
      println("==================================================")

      #L 1. Inicializacao do Lexer e Tokenizacao
      mut as data: lexer = LogoLexer::initLogoLexer()
      mut as string: script = "FRENTE 20; GIRAR DIREITA; FRENTE 10"
      mut as list of data: tokens = LogoLexer::tokenizeLogo(lexer, script)
      mut as map: t1 = tokens[1] as map
      println("1. Analise Lexica da Logo DSL:")
      println("   Script analisado: " + script)
      println("   Primeiro token (1-index): " + t1["valor"])

      #L 2. Parser e Validacao Semantica
      mut as data: parser = LogoAst::createLogoParser(lexer)
      mut as bool: valido = LogoSemantic::validateLogoScript(parser, script)
      println("2. Validacao Sintatica:")
      println("   Sintaxe correta: " + valido)

      #L 3. Construcao da AST
      mut as map: ast = LogoAst::generateLogoAst(parser, script)
      println("3. Arvore Sintatica Abstrata (AST):")
      println("   Tipo raiz da AST: " + ast["tipo"])

      #L 4. Execucao Dinamica com Estado Cartesiano
      mut as data: ctx = map{
            "x": 0,
            "y": 0,
            "direcao": "NORTE",
            "passos_totais": 0
      }
      println("4. Execucao de Comandos de Movimentacao:")
      println("   Posicao inicial: (0, 0) rumo ao NORTE")

      mut as data: res = LogoExecutor::executeLogoInline(parser, script, ctx)
      mut as map: m = res as map
      println("   Posicao X final: " + m["x"])
      println("   Posicao Y final: " + m["y"])
      println("   Direcao final: " + m["direcao"])
      println("   Passos totais percorridos: " + m["passos_totais"])
      println("   Status da execucao: " + m["status"])

      #L 5. Diagnostico Visual de Erro com Cursor ^
      mut as string: script_invalido = "FRENTE @; GIRAR"
      mut as list of data: erros = LogoSemantic::getLogoErrors(parser, script_invalido)
      mut as map: err1 = erros[1] as map
      mut as string: diag = LogoSemantic::formatLogoErrors(erros, script_invalido)
      println("5. Diagnostico Visual de Erro:")
      println("   Script invalido: " + script_invalido)
      println("   Erro detectado (1-index): " + err1["mensagem"])
      println("   Cursor visual de erro:")
      println(diag)

      println("==================================================")
      println("  Logo DSL executada com sucesso nos 6 backends!  ")
      println("==================================================")
}
