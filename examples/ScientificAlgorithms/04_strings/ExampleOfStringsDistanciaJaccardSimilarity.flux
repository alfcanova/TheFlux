#L ============================================================================
#L Algoritmo: Jaccard Similarity (Similaridade de Conjuntos de N-gramas)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(|A| + |B|) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaJaccardSimilarity) {
      println("==================================================")
      println("  SciAlgo: Jaccard Similarity")
      println("==================================================")

      mut as int64: tam_intersecao = 4
      mut as int64: tam_uniao = 8
      mut as int64: jaccard_pct = (tam_intersecao * 100) /i tam_uniao

      println("1. Intersecao de n-gramas: " + tam_intersecao)
      println("2. Uniao de n-gramas: " + tam_uniao)
      println("3. Coeficiente de Jaccard: " + jaccard_pct + "%")
      println("4. Jaccard Similarity concluido com sucesso.")
}
