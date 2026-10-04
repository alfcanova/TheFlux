#L ============================================================================
#L Algoritmo: SMA* (Simplified Memory-Bounded A* de Stuart Russell 1992)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^d) com uso de memoria estritamente limitado O(M)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchSMAStar) {
      println("==================================================")
      println("  SciAlgo: SMA* (Simplified Memory-Bounded A*)")
      println("==================================================")

      #L Limite estrito de memoria: no maximo M = 3 nos na lista aberta
      mut as int64: mem_limit = 3

      #L Nos com seus valores f = g + h
      #L Inicialmente aberta tem [No 1 (f=10)]
      mut as list of int64: open_nodes = [1]
      mut as list of int64: open_f = [10]

      println("1. Capacidade maxima de memoria M: " + mem_limit + " nos")

      #L Expansao do No 1 gera 3 sucessores: No 2 (f=12), No 3 (f=14), No 4 (f=18)
      #L Aberta agora conteria 3 nos: atinge o limite mem_limit!
      open_nodes = [2, 3, 4]
      open_f = [12, 14, 18]
      println("2. Aberta atinge limite M=3: " + open_nodes + " com f: " + open_f)

      #L Expansao do No 2 gera o No 5 (objetivo com f=13)
      #L Aberta excederia o limite (teria 4 nos).
      #L O SMA* descarta o pior no da lista aberta (No 4 com f=18)
      mut as int64: dropped_node = 0
      mut as int64: backed_up_f = 0

      #L Localiza o no com pior (maior) f
      mut as int64: worst_idx = 1
      mut as int64: max_f = open_f[1]
      mut as int64: i = 2
      infinite (i <= listLength(open_f)) {
            route {
                  open_f[i] > max_f ==> {
                        max_f = open_f[i]
                        worst_idx = i
                  }
            }
            i = i + 1
      }

      dropped_node = open_nodes[worst_idx]
      backed_up_f = max_f
      println("3. Memoria cheia: descartando o pior no " + dropped_node + " (f=" + backed_up_f + ")")

      #L Substitui o no descartado pelo novo no gerado (No 5, objetivo)
      open_nodes[worst_idx] = 5
      open_f[worst_idx] = 13

      println("4. Nova lista aberta dentro da cota de memoria: " + open_nodes + " com f: " + open_f)

      #L Seleciona o melhor no (No 2 com f=12 ja expandido, proximo e No 5 com f=13)
      mut as bool: goal_reached = false
      mut as int64: chk = 1
      infinite (chk <= listLength(open_nodes)) {
            route {
                  open_nodes[chk] == 5 ==> {
                        goal_reached = true
                        break
                  }
            }
            chk = chk + 1
      }

      println("5. Objetivo presente na memoria limitada: " + goal_reached)
      println("6. Validacao: " + (goal_reached and dropped_node == 4 and backed_up_f == 18))
      println("==================================================")
}
