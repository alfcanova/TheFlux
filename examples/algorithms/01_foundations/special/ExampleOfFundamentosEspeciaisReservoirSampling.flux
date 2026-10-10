#L ============================================================================
#L Algoritmo: Reservoir Sampling (Amostragem em Reservatorio de Knuth)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(N) tempo em streaming com memoria estrita O(K)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisReservoirSampling) {
      println("==================================================")
      println("  SciAlgo: Reservoir Sampling (Algorithm R)")
      println("==================================================")

      #L Fluxo de dados (streaming) de 10 elementos
      mut as list of int64: stream = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
      mut as int64: n = listLength(stream)
      mut as int64: k = 3 #L Tamanho do reservatorio desejado

      println("1. Tamanho da amostra K: " + k + " de um fluxo de N = " + n + " itens")

      #L Inicializa o reservatorio com os primeiros K itens do fluxo
      mut as list of int64: reservoir = []
      mut as int64: idx = 1
      infinite (idx <= k) {
            reservoir = listPushBack(reservoir, stream[idx])
            idx = idx + 1
      }
      println("2. Reservatorio inicial com os primeiros K itens: " + reservoir)

      #L Processa os itens restantes (k + 1 ate n)
      #L Gerador LCG deterministico para reproducibilidade
      mut as int64: seed = 123456
      mut as int64: replacements = 0

      mut as int64: i = k + 1
      infinite (i <= n) {
            #L Gera j pseudo-aleatorio entre 1 e i
            seed = (1664525 * seed + 1013904223) /r 2147483647
            route { seed < 0 ==> { seed = seed * -1 } }
            mut as int64: j = (seed /r i) + 1

            #L Se j <= k, o item entra no reservatorio substituindo o elemento j
            route {
                  j <= k ==> {
                        replacements = replacements + 1
                        reservoir[j] = stream[i]
                  }
            }
            i = i + 1
      }

      println("3. Reservatorio final sorteado: " + reservoir)
      println("4. Substituicoes executadas ao longo do stream: " + replacements)
      println("5. Validacao: " + (listLength(reservoir) == k and replacements > 0))
      println("==================================================")
}
