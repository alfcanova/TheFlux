#L ============================================================================
#L Algoritmo: Label Propagation (Propagacao de Rotulos em Grafos)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosLabelPropagation) {
      println("=== Algoritmo: Label Propagation ===")
      mut as list of int64: labels = [1, 1, 0, 0]
      mut as int64: iter = 0
      infinite (iter < 3) {
            mut as int64: count1_n3 = 0
            mut as int64: count2_n3 = 0
            route {
                  labels[1] == 1 ==> { count1_n3 = count1_n3 + 1 }
                  _ ==> { count2_n3 = count2_n3 + 1 }
            }
            route {
                  labels[2] == 1 ==> { count1_n3 = count1_n3 + 1 }
                  _ ==> { count2_n3 = count2_n3 + 1 }
            }
            mut as int64: l3 = 1
            route {
                  count2_n3 > count1_n3 ==> { l3 = 2 }
                  _ ==> {}
            }
            labels = [labels[1], labels[2], l3, 2]
            iter = iter + 1
      }
      println("1. Rotulo Node 1: " + labels[1])
      println("2. Rotulo Node 2: " + labels[2])
      println("3. Rotulo Node 3: " + labels[3])
      println("4. Rotulo Node 4: " + labels[4])
      println("Teste concluido com sucesso.")
}
