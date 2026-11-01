use RegexStdLib

program (ExampleOfUseRegexStdLib_RegexSearchContract) {
      println("==================================================")
      println("  Exemplo: RegexSearchContract (Busca e Varredura)")
      println("==================================================")

      mut as string: texto = "Pedido #4289 aprovado, itens: 10 unidades do produto A, 25 unidades do produto B"

      #L 1. Checagem de correspondencia parcial (regexIsMatch)
      mut as bool: tem_digito = regexIsMatch("[0-9]+", texto)
      mut as bool: comeca_com_pedido = regexIsMatch("^Pedido", texto)
      mut as bool: comeca_com_erro = regexIsMatch("^Erro", texto)
      println("1. Contem digitos numericos: ", tem_digito)
      println("   Comeca com 'Pedido': ", comeca_com_pedido)
      println("   Comeca com 'Erro': ", comeca_com_erro)

      #L 2. Checagem de correspondencia exata total (regexFullMatch)
      mut as bool: total_digitos = regexFullMatch("[0-9]+", "4289")
      mut as bool: total_misto = regexFullMatch("[0-9]+", "4289-X")
      println("2. '4289' eh estritamente numerico: ", total_digitos)
      println("   '4289-X' eh estritamente numerico: ", total_misto)

      #L 3. Localizacao da primeira ocorrencia (regexFind)
      mut as string: primeiro_numero = regexFind("[0-9]+", texto)
      println("3. Primeiro numero localizado: '", primeiro_numero, "'")

      #L 4. Extracao de todas as ocorrencias (regexFindAll)
      mut as list of data: todos_numeros = regexFindAll("[0-9]+", texto)
      println("4. Todos os numeros extraidos: ", todos_numeros)

      #L 5. Indice 1-based da primeira ocorrencia (regexFindIndex)
      mut as int64: idx_primeiro = regexFindIndex("[0-9]+", texto)
      println("5. Indice 1-based do primeiro numero: ", idx_primeiro)

      #L 6. Intervalo [inicio, fim] da primeira ocorrencia (regexFindSpan)
      mut as list of data: span_primeiro = regexFindSpan("[0-9]+", texto)
      println("6. Span do primeiro numero: [", span_primeiro[1], ", ", span_primeiro[2], "]")

      #L 7. Todos os intervalos de ocorrencias (regexFindAllSpans)
      mut as list of data: todos_spans = regexFindAllSpans("[0-9]+", texto)
      println("7. Todos os spans de numeros: ", todos_spans)

      #L 8. Contagem de ocorrencias sem alocar listas intermediarias (regexCount)
      mut as int64: total_itens = regexCount("[0-9]+", texto)
      println("8. Total de valores numericos encontrados: ", total_itens)
}
