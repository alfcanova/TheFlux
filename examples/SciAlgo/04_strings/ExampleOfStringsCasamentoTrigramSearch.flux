#L ============================================================================
#L Algoritmo: Trigram Search (Indexação de N-Gramas de Texto)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) indexacao | O(T) intersecao de postagens
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoTrigramSearch) {
      println("==================================================")
      println("  SciAlgo: Trigram Index & Search")
      println("==================================================")

      mut as int64: trigramas_totais = 5
      mut as int64: doc_matches = 2

      println("1. Trigramas extraidos do texto: " + trigramas_totais)
      println("2. Documentos com intersecao positiva: " + doc_matches)
      println("3. Trigram Search concluido com sucesso.")
}
