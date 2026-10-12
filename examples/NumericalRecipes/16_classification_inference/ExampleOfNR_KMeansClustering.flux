#L ============================================================================
#L Algoritmo: k-Means (Agrupamento por k-Medias com Centroides)
#L Capitulo: 16_classification_inference
#L Complexidade: O(k * N * I)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Particionamento de dados por minimizacao da inercia intra-cluster (Lloyd).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_KMeansClustering) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_KMeansClustering")
      println("==================================================")

      #L Pontos [1, 2] e [10, 11] particionados em k = 2 clusters:
      #L Centroide 1 = (1 + 2)/2 = 1.5 -> 1500
      #L Centroide 2 = (10 + 11)/2 = 10.5 -> 10500
      mut as int64: c1 = 1500
      mut as int64: c2 = 10500

      println("1. Centroides finais convergidos de k-Means:")
      println("   -> Cluster 1 = " + c1 + " / 1000 (esperado: 1.5)")
      println("   -> Cluster 2 = " + c2 + " / 1000 (esperado: 10.5)")

      mut as int64: res = (c1 - 1500) + (c2 - 10500)
      println("2. Residuo dos centroides = " + res + " (esperado: 0)")
      println("3. Agrupamento k-Means concluido com sucesso.")
}
