#L ============================================================================
#L Algoritmo: Euler Tour Technique (Achatamento de Arvores em Intervalos de Subarvore)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeEulerTourTechnique) {
      println("==================================================")
      println("  SciAlgo: Euler Tour Technique                   ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as list of int64: tin = [1, 2, 5, 3, 4]
      mut as list of int64: tout = [5, 4, 5, 3, 4]

      println("1. Intervalos de Subarvore [tin, tout]:")
      mut as int64: node = 1
      infinite (node <= num_v) {
            println("   No " + node + ": [" + tin[node] + ", " + tout[node] + "]")
            node = node + 1
      }

      println("2. Consultas de Ancestralidade / Inclusao de Subarvore:")
      #L Consulta 1: O vertice 4 esta na subarvore do vertice 2?
      mut as int64: u = 2
      mut as int64: v = 4
      mut as bool: in_sub = false
      route {
            tin[u] <= tin[v] and tout[v] <= tout[u] ==> {
                  in_sub = true
            }
            _ ==> {}
      }
      println("   No " + v + " pertence a subarvore de " + u + "? " + in_sub)

      #L Consulta 2: O vertice 3 esta na subarvore do vertice 2?
      u = 2
      v = 3
      in_sub = false
      route {
            tin[u] <= tin[v] and tout[v] <= tout[u] ==> {
                  in_sub = true
            }
            _ ==> {}
      }
      println("   No " + v + " pertence a subarvore de " + u + "? " + in_sub)
}
