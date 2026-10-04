#L ============================================================================
#L Algoritmo: Brent's Cycle Detection (Algoritmo do Teleferico de Brent)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(mu + lambda) tempo com 24-36% menos passos que Floyd
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSpecialAlgorithmsBrent) {
      println("==================================================")
      println("  SciAlgo: Brent's Cycle Detection Algorithm")
      println("==================================================")

      #L Mesma estrutura Rho: 1->2->3->4->5->6->7->8->4
      #L Cauda mu = 3, Ciclo lambda = 5
      mut as list of int64: next_node = [2, 3, 4, 5, 6, 7, 8, 4]

      #L Fase 1: Encontra o comprimento do ciclo (lambda)
      mut as int64: power = 1
      mut as int64: lambda_len = 1
      mut as int64: tortoise = 1
      mut as int64: hare = next_node[1]
      mut as int64: total_steps = 1

      infinite (tortoise != hare) {
            route {
                  power == lambda_len ==> {
                        #L Teletransporta a tartaruga para a posicao da lebre e dobra o limite de passos
                        tortoise = hare
                        power = power * 2
                        lambda_len = 0
                  }
            }
            hare = next_node[hare]
            lambda_len = lambda_len + 1
            total_steps = total_steps + 1
      }

      println("1. Periodo do ciclo (lambda) determinado diretamente: " + lambda_len)
      println("2. Passos totais executados na Fase 1: " + total_steps)

      #L Fase 2: Encontra o inicio da cauda (mu)
      #L Posiciona ptr1 na origem (1) e ptr2 a lambda passos da origem
      mut as int64: ptr1 = 1
      mut as int64: ptr2 = 1
      mut as int64: k = 1
      infinite (k <= lambda_len) {
            ptr2 = next_node[ptr2]
            k = k + 1
      }

      #L Avanca ambos em paralelo ate colidirem
      mut as int64: mu_tail = 0
      infinite (ptr1 != ptr2) {
            ptr1 = next_node[ptr1]
            ptr2 = next_node[ptr2]
            mu_tail = mu_tail + 1
      }

      println("3. No de inicio do ciclo: " + ptr1)
      println("4. Comprimento da cauda (mu): " + mu_tail)
      println("5. Validacao: " + (lambda_len == 5 and ptr1 == 4 and mu_tail == 3))
      println("==================================================")
}
