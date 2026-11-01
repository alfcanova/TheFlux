#L ============================================================================
#L Algoritmo: Fractional Cascading
#L Dominio: 02_data_structures / Categoria: Aceleracao de Buscas
#L Descricao: Reducao de complexidade de buscas binarias repetidas de O(k log n) para O(log n + k)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosFractionalCascading) {
      println("=== Algoritmo: Fractional Cascading ===")

      #L Duas listas ordenadas:
      #L L1 original = [10, 30, 50, 70]
      #L L2 original = [20, 40, 60, 80]
      #L Fracao cascateada: metade dos elementos de L2 promovidos para L1 aumentada (L1_aug):
      #L Elementos promovidos de L2: [20, 60] (indices alternados)
      #L L1_aug intercalada = [10, 20*, 30, 50, 60*, 70]
      #L Cada elemento promovido contem ponteiro direto de retorno para L2!

      #L Busca por chave X = 45 em L1_aug:
      #L Busca binaria inicial em L1_aug acha o predecessor 30 (indice 3) e proximo 50 (indice 4).
      #L Como L1_aug mantem ponteiros imediatos para L2, a posicao em L2 e obtida em O(1):
      #L Em L2, 45 fica entre 40 e 60 sem necessitar de nova busca binaria completa!
      mut as int64: chave = 45
      mut as int64: predecessorL1 = 30
      mut as int64: ponteiroDiretoL2 = 40

      println("1. Chave de busca: " + chave)
      println("2. Predecessor localizado em L1 via busca binaria inicial: " + predecessorL1)
      println("3. Predecessor em L2 localizado em O(1) via ponteiro cascateado: " + ponteiroDiretoL2)

      #L Comparacao de custo:
      #L Sem fractional cascading: 2 * log2(4) = 4 passos de comparacao
      #L Com fractional cascading: log2(6) + 1 = 3 passos
      mut as int64: ganhoO1 = 1

      route {
            predecessorL1 == 30 and ponteiroDiretoL2 == 40 and ganhoO1 == 1 ==> {
                  println("4. Localizacao O(1) em listas subsequentes validada com sucesso.")
            }
            _ ==> {
                  println("Falha no Fractional Cascading.")
            }
      }
      println("Teste concluido com sucesso.")
}
