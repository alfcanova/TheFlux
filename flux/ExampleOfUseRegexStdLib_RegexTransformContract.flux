use RegexStdLib

program (ExampleOfUseRegexStdLib_RegexTransformContract) {
      println("==================================================")
      println("  Exemplo: RegexTransformContract (Substituicao e Divisao)")
      println("==================================================")

      mut as string: dados_originais = "registro: A10, lote: B20, setor: C30, serial: D40"

      #L 1. Substituicao total de todas as ocorrencias (regexReplace)
      mut as string: anonimizado = regexReplace("[A-Z][0-9]+", dados_originais, "[REDACTED]")
      println("1. Substituicao total: ")
      println("   Original:     ", dados_originais)
      println("   Anonimizado:  ", anonimizado)

      #L 2. Substituicao apenas da primeira ocorrencia (regexReplaceFirst)
      mut as string: apenas_primeiro = regexReplaceFirst("[A-Z][0-9]+", dados_originais, "[PRIMEIRO]")
      println("2. Substituicao da primeira ocorrencia: ")
      println("   Resultado:    ", apenas_primeiro)

      #L 3. Substituicao com limite maximo de ocorrencias (regexReplaceLimit)
      mut as string: apenas_dois = regexReplaceLimit("[A-Z][0-9]+", dados_originais, "[SUBST]", 2)
      println("3. Substituicao com limite maximo de 2: ")
      println("   Resultado:    ", apenas_dois)

      #L 4. Divisao de texto com delimitadores multiplos (regexSplit)
      mut as string: linha_csv = "Item Alpha,100;Item Beta,200;Item Gama,300"
      mut as list of data: registros = regexSplit("[,;]", linha_csv)
      println("4. Divisao completa por virgula ou ponto-e-virgula: ")
      println("   Entrada: ", linha_csv)
      println("   Partes:  ", registros)

      #L 5. Divisao com limite de partes resultantes (regexSplitLimit)
      mut as string: tags = "flux:lang:native:fast:engine"
      mut as list of data: tags_limitadas = regexSplitLimit(":", tags, 3)
      println("5. Divisao com limite maximo de 3 partes: ")
      println("   Entrada: ", tags)
      println("   Partes:  ", tags_limitadas)
}
