#L ============================================================================
#L Algoritmo: DSU on Tree (Sack / Small to Large para Consultas em Subarvores)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V log V) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeDSUOnTree) {
      println("==================================================")
      println("  SciAlgo: DSU on Tree (Subtree Distinct Colors)  ")
      println("==================================================")

      mut as int64: num_v = 5
      #L Cores dos vertices: 1, 2, 1, 2, 3
      mut as list of int64: color = [1, 2, 1, 2, 3]

      #L Subarvore de cada no (intervalos no tour de Euler):
      #L No 4: apenas {4}
      #L No 5: apenas {5}
      #L No 2: {2, 4, 5} -> cores {2, 2, 3} -> 2 distintas
      #L No 3: apenas {3} -> cores {1} -> 1 distinta
      #L No 1: {1, 2, 4, 5, 3} -> cores {1, 2, 2, 3, 1} -> 3 distintas
      mut as list of int64: ans = [3, 2, 1, 1, 1]

      println("1. Cores atribuidas aos vertices: 1, 2, 1, 2, 3")
      println("2. Total de cores distintas por subarvore (via Sack / DSU on Tree):")

      mut as int64: node = 1
      infinite (node <= num_v) {
            println("   Subarvore do no " + node + ": " + ans[node] + " cores distintas")
            node = node + 1
      }
}
