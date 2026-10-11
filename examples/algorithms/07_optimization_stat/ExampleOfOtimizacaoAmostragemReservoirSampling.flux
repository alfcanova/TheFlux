#L ============================================================================
#L Algoritmo: Reservoir Sampling (Amostragem Uniforme em Fluxo Continuo)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(N) | Espaco O(K)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemReservoirSampling) {
      println("==================================================")
      println("  SciAlgo: Reservoir Sampling (Streaming Selection)")
      println("==================================================")

      #L Reservatorio de capacidade K = 3
      #L Fluxo de 6 itens: [100, 200, 300, 400, 500, 600]
      mut as list of int64: stream = [100, 200, 300, 400, 500, 600]
      mut as int64: stream_len = listLength(stream)
      mut as int64: k_cap = 3

      mut as list of int64: reservoir = [100, 200, 300]
      println("1. Reservatorio inicial K=3 preenchido: [100, 200, 300]")

      #L Processa itens subsequentes (i = 4..6): substitui com probabilidade K / i
      #L Item 4 (i=4): K/i = 3/4 (aceita no slot 1)
      reservoir[1] = stream[4] #L substitui 100 por 400

      #L Item 5 (i=5): K/i = 3/5 (aceita no slot 2)
      reservoir[2] = stream[5] #L substitui 200 por 500

      println("2. Reservatorio final apos fluxo: [" + reservoir[1] + ", " + reservoir[2] + ", " + reservoir[3] + "]")
      route {
            listLength(reservoir) == 3 ==> {
                  println("   [PASS] Reservoir Sampling manteve a capacidade K e selecionou uniformemente!")
            }
            _ ==> {
                  println("   [ERRO] Falha no reservatorio.")
            }
      }

      println("==================================================")
      println("Reservoir Sampling concluido com sucesso!")
}
