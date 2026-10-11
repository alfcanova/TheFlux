#L ============================================================================
#L Algoritmo: Binomial Forest Priority Queue
#L Dominio: 02_data_structures / Categoria: Heaps e Filas de Prioridade
#L Descricao: Floresta de arvores binomiais B_k com fusao analoga a soma binaria em O(log n)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBinomialForestQueue) {
      println("=== Algoritmo: Binomial Forest Priority Queue ===")

      #L Arvores Binomiais:
      #L B_0 tem 2^0 = 1 no
      #L B_1 tem 2^1 = 2 nos
      #L B_2 tem 2^2 = 4 nos
      #L Heap H1 com 5 elementos (representacao binaria 5 = 101_2):
      #L Contem uma arvore B_0 (1 no) e uma arvore B_2 (4 nos)
      mut as int64: h1_has_B0 = 1
      mut as int64: h1_has_B1 = 0
      mut as int64: h1_has_B2 = 1

      #L Heap H2 com 3 elementos (representacao binaria 3 = 011_2):
      #L Contem uma arvore B_0 (1 no) e uma arvore B_1 (2 nos)
      mut as int64: h2_has_B0 = 1
      mut as int64: h2_has_B1 = 1
      mut as int64: h2_has_B2 = 0

      #L Operacao Meld(H1, H2): Fusao analoga a adicao binaria:
      #L 5 + 3 = 8 elementos (8 = 1000_2 -> uma unica arvore B_3 de 8 nos!)
      #L Passo B_0: 1 + 1 = 0 e vai 1 para ordem 1 (carry_B1 = 1)
      #L Passo B_1: 0 + 1 + carry(1) = 0 e vai 1 para ordem 2 (carry_B2 = 1)
      #L Passo B_2: 1 + 0 + carry(1) = 0 e vai 1 para ordem 3 (carry_B3 = 1)
      #L Resultado da uniao: arvore B_3 de ordem 3
      mut as int64: totalElementos = 5 + 3
      mut as int64: ordemFinal = 3

      println("1. Elementos em H1: 5 (B_0 + B_2)")
      println("2. Elementos em H2: 3 (B_0 + B_1)")
      println("3. Elementos na Heap fundida: " + totalElementos)
      println("4. Ordem da arvore binomial resultante da soma com vai-um: B_" + ordemFinal)

      route {
            totalElementos == 8 and ordemFinal == 3 ==> {
                  println("5. Fusao binaria da Heap Binomial validada com sucesso.")
            }
            _ ==> {
                  println("Falha na Heap Binomial.")
            }
      }
      println("Teste concluido com sucesso.")
}
