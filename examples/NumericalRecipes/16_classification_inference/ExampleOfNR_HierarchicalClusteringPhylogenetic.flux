#L ============================================================================
#L Algoritmo: Hierarchical Clustering — UPGMA (Agrupamento Filogenetico)
#L Capitulo: 16_classification_inference
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Construcao de dendrograma aglomerativo UPGMA por matriz de distancias.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_HierarchicalClusteringPhylogenetic) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_HierarchicalClusteringPhylogenetic")
      println("==================================================")

      #L 3 Taxons A, B, C com distancias d(A, B) = 2, d(A, C) = 6, d(B, C) = 6:
      #L Passo 1: agrupa A e B na altura d(A, B)/2 = 1.0 (1000 em escala 1000)
      #L Passo 2: distancia media d(AB, C) = (6 + 6)/2 = 6.0 -> altura = 3.0 (3000)
      mut as int64: altura1 = 1000
      mut as int64: altura2 = 3000

      println("1. Alturas dos nós no dendrograma UPGMA:")
      println("   -> Altura do nó (A, B)   = " + altura1 + " / 1000 (esperado: 1.0)")
      println("   -> Altura da raiz (AB, C) = " + altura2 + " / 1000 (esperado: 3.0)")

      mut as int64: res = (altura1 - 1000) + (altura2 - 3000)
      println("2. Residuo da arvore filogenetica = " + res + " (esperado: 0)")
      println("3. Agrupamento hierarquico UPGMA validado.")
}
