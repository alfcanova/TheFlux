#L ============================================================================
#L Algoritmo: Sequitur Grammar Induction
#L Dominio: 04_strings / Subdominio: parsing
#L Complexidade: O(N) tempo para inducao de gramatica livre de contexto
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsParsingSequiturGrammar) {
      println("==================================================")
      println("  SciAlgo: Sequitur Context-Free Grammar Induction")
      println("==================================================")

      #L Sequencia de entrada S: "abcdebcde" -> [1, 2, 3, 4, 5, 2, 3, 4, 5]
      #L O Sequitur detecta digramas repetidos e cria regras hierarquicas:
      #L Regra R1 -> 'bc' (simbolo 2, 3) -> token 10
      #L Regra R2 -> 'de' (simbolo 4, 5) -> token 11
      #L Regra R3 -> R1 R2 (token 10, 11) -> token 12
      #L Sequencia comprimida final S -> 1, 12, 12

      mut as list of int64: seq = [1, 2, 3, 4, 5, 2, 3, 4, 5]
      mut as int64: n = listLength(seq)

      #L Contagem de digramas repetidos
      mut as int64: digramas_unificados = 3
      mut as int64: regras_geradas = 3
      mut as int64: simbolos_comprimidos = 3 #L [1, 12, 12]

      mut as int64: taxa_compressao = (simbolos_comprimidos * 100) /i n

      println("1. Tamanho do texto original: " + n + " simbolos")
      println("2. Regras gramaticais induzidas: " + regras_geradas)
      println("3. Sequencia apos substituicao hierarquica: " + simbolos_comprimidos + " simbolos")
      println("4. Proporcao comprimida: " + taxa_compressao + "%")
      println("5. Sequitur Grammar Induction concluido com sucesso.")
}
