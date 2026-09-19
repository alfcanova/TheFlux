use RegexStdLib

program (ExampleOfUseRegexStdLib_RegexUtilityContract) {
      println("==================================================")
      println("  Exemplo: RegexUtilityContract (Utilidades Regex)")
      println("==================================================")

      #L 1. Escape de metacaracteres para busca literal segura (regexEscape)
      mut as string: texto_com_pontuacao = "arquivo.txt (versao 2.0) [backup]*"
      mut as string: padrao_escapado = regexEscape(texto_com_pontuacao)
      println("1. Escape de caracteres especiais de regex:")
      println("   Original: ", texto_com_pontuacao)
      println("   Escapado: ", padrao_escapado)

      mut as string: texto_alvo = "Status: arquivo.txt (versao 2.0) [backup]* confirmado"
      mut as bool: achou_literal = regexIsMatch(padrao_escapado, texto_alvo)
      println("   Busca do padrao escapado no alvo: ", achou_literal)

      #L 2. Validacao sintatica de expressoes regulares (regexIsValid)
      mut as string: pat_valido = "^[a-zA-Z0-9_]+@[a-z]+\\.[a-z]{2,}$"
      mut as string: pat_parenteses_aberto = "^(abc[0-9]+"
      mut as string: pat_colchete_aberto = "[0-9+abc"
      mut as string: pat_barra_solta = "abc\\"

      println("2. Validacao de sintaxe regex:")
      println("   Padrao valido:             ", regexIsValid(pat_valido))
      println("   Parenteses desbalanceados: ", regexIsValid(pat_parenteses_aberto))
      println("   Colchete desbalanceado:    ", regexIsValid(pat_colchete_aberto))
      println("   Barra invertida solta:     ", regexIsValid(pat_barra_solta))

      #L 3. Deteccao de padroes estritamente literais (regexIsPatternLiteral)
      mut as string: texto_puro = "palavra_chave_123"
      mut as string: texto_com_regex = "palavra.*chave"
      println("3. Deteccao de literal puro vs expressao regular:")
      println("   'palavra_chave_123' eh literal: ", regexIsPatternLiteral(texto_puro))
      println("   'palavra.*chave' eh literal:    ", regexIsPatternLiteral(texto_com_regex))

      #L 4. Correspondencia com modificadores / flags (regexMatchWithFlags)
      mut as string: frase = "THEFLUX PROGRAMMING LANGUAGE"
      mut as bool: match_sem_flag = regexIsMatch("theflux", frase)
      mut as bool: match_com_flag_i = regexMatchWithFlags("theflux", frase, "i")
      println("4. Modificador case-insensitive ('i'):")
      println("   Busca sem flag ('theflux'):    ", match_sem_flag)
      println("   Busca com flag 'i' ('theflux'):", match_com_flag_i)
}
