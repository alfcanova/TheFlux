#L ============================================================================
#L Algoritmo: GAT (Graph Attention Network)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosGraphAttentionNetwork) {
      println("=== Algoritmo: Graph Attention Network ===")
      mut as int64: score1 = 30
      mut as int64: score2 = 70
      mut as int64: sumExp = 100
      mut as int64: alpha1 = (score1 * 100) /i sumExp
      mut as int64: alpha2 = (score2 * 100) /i sumExp
      mut as int64: feat1 = 10
      mut as int64: feat2 = 50
      mut as int64: hOut = (alpha1 * feat1 + alpha2 * feat2) /i 100
      println("1. Coeficiente de atencao alfa 1: " + alpha1)
      println("2. Coeficiente de atencao alfa 2: " + alpha2)
      println("3. Saida agregada por atencao: " + hOut)
      println("Teste concluido com sucesso.")
}
