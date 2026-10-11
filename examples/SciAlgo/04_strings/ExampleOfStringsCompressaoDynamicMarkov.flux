#L ============================================================================
#L Algoritmo: Dynamic Markov Compression (DMC)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) tempo com clonagem adaptativa de estados
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoDynamicMarkov) {
      println("==================================================")
      println("  SciAlgo: Dynamic Markov Compression (DMC)")
      println("==================================================")

      #L DMC comeca com automato finito inicial (2 estados)
      #L Transicoes de cada estado para bit 0 e bit 1 com contadores de frequencia
      mut as int64: num_estados = 2
      mut as int64: limiar_clonagem = 8 #L Limiar de visitas para clonar um estado

      #L Contadores de transicao do estado 1
      mut as int64: cont_0 = 12
      mut as int64: cont_1 = 3
      mut as int64: total_visitas = cont_0 + cont_1

      #L Verificacao de criterio de clonagem de estado
      mut as int64: clonado = 0
      route {
            total_visitas >= limiar_clonagem ==> {
                  num_estados = num_estados + 1
                  clonado = 1
            }
            _ ==> {}
      }

      #L Probabilidade estimada do proximo bit 0 no estado
      mut as int64: prob_bit_0 = (cont_0 * 100) /i total_visitas

      println("1. Estados iniciais: 2, limiar de clonagem: " + limiar_clonagem)
      println("2. Total de transicoes observadas no estado 1: " + total_visitas)
      println("3. Estado clonado com sucesso: " + clonado + " (total de estados: " + num_estados + ")")
      println("4. Probabilidade prevista para bit 0: " + prob_bit_0 + "%")
      println("5. DMC concluido com sucesso.")
}
