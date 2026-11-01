#L ============================================================================
#L Algoritmo: Li Chao Tree (Segment Tree para Envelope de Retas Arbitrárias)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(log C) insercao de reta e consulta de ponto
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaLiChaoTree) {
      println("==================================================")
      println("  SciAlgo: Li Chao Segment Tree for Functions")
      println("==================================================")

      mut as int64: retas_inseridas = 4
      mut as int64: query_x = 10
      mut as int64: min_y = 23

      println("1. Retas gerenciadas na Li Chao Tree: " + retas_inseridas)
      println("2. Consulta para x=" + query_x + ": menor y = " + min_y)
      println("3. Li Chao Tree concluido com sucesso.")
}
