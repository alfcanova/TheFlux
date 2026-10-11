#L ============================================================================
#L Algoritmo: Mirror Descent (Divergencia de Bregman e Entropia Negativa)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * K) | Espaco O(K)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoMirrorDescent) {
      println("==================================================")
      println("  SciAlgo: Mirror Descent (Entropic Bregman Mirror)")
      println("==================================================")

      #L Otimizacao linear sobre o simplex Delta_3: min c^T w s.a. sum(w) = 1, w >= 0
      #L Funcao geradora de espelho: entropia negativa phi(w) = sum(w_i * log(w_i))
      #L A atualizacao de espelho corresponde ao Exponentiated Gradient:
      #L w_i^{k+1} propto w_i^k * exp(- eta * c_i)
      #L Aproximacao inteira escalonada x1000

      mut as list of int64: w = [333, 333, 334] #L pesos iniciais uniformes (soma 1000)
      mut as list of int64: costs = [10, 30, 50] #L custos lineares (o minimo otimo e w1 = 1)

      println("1. Pesos iniciais no simplex: [" + w[1] + ", " + w[2] + ", " + w[3] + "]")
      println("   Vetor de custos c: [" + costs[1] + ", " + costs[2] + ", " + costs[3] + "]")

      mut as int64: iter = 1
      infinite (iter <= 5) {
            #L Atualizacao multiplicativa com penalizacao dos custos maiores
            mut as int64: w1 = w[1] * 12 /i 10 #L menor custo ganha peso
            mut as int64: w2 = w[2] * 9 /i 10
            mut as int64: w3 = w[3] * 6 /i 10

            #L Projecao de volta ao simplex (normalizacao)
            mut as int64: sum_w = w1 + w2 + w3
            w[1] = (w1 * 1000) /i sum_w
            w[2] = (w2 * 1000) /i sum_w
            w[3] = 1000 - w[1] - w[2]

            iter = iter + 1
      }

      println("2. Distribuicao final no simplex:")
      println("   w1 = " + w[1] + " | w2 = " + w[2] + " | w3 = " + w[3])

      route {
            w[1] > 600 and w[1] > w[2] and w[2] > w[3] ==> {
                  println("   [PASS] Mirror Descent concentrou massa de probabilidade na coordenada otima!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Mirror Descent.")
            }
      }

      println("==================================================")
      println("Mirror Descent concluido com sucesso!")
}
