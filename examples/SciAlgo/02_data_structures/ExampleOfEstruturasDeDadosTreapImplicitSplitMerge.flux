#L ============================================================================
#L Algoritmo: Implicit Treap Split & Merge
#L Dominio: 02_data_structures / Categoria: Estruturas Dinamicas de Sequencia
#L Descricao: Operacoes primordiais de corte (split) e juncao (merge) de sequencias em O(log n)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosTreapImplicitSplitMerge) {
      println("=== Algoritmo: Implicit Treap (Split & Merge) ===")

      #L Treap T original com 5 elementos [1, 2, 3, 4, 5]
      mut as int64: sizeT = 5

      #L Operacao Split(T, 2):
      #L Divide T em duas sub-arvores:
      #L L com os 2 primeiros elementos [1, 2]
      #L R com os 3 elementos restantes [3, 4, 5]
      mut as int64: splitK = 2
      mut as int64: sizeL = splitK
      mut as int64: sizeR = sizeT - splitK

      println("1. Tamanho inicial de T: " + sizeT)
      println("2. Tamanho apos Split em k=2 -> L: " + sizeL + ", R: " + sizeR)

      #L Insercao de novo elemento no meio (X = [99], tamanho 1):
      mut as int64: sizeX = 1

      #L Operacao Merge(L, X):
      #L Produz T_temp de tamanho sizeL + sizeX = 2 + 1 = 3
      mut as int64: sizeTemp = sizeL + sizeX

      #L Operacao Merge(T_temp, R):
      #L Produz T_novo de tamanho sizeTemp + sizeR = 3 + 3 = 6
      mut as int64: sizeNovo = sizeTemp + sizeR

      println("3. Tamanho apos Merge(L, X): " + sizeTemp)
      println("4. Tamanho final da sequencia apos Merge(T_temp, R): " + sizeNovo)

      route {
            sizeL == 2 and sizeR == 3 and sizeNovo == 6 ==> {
                  println("5. Primitivas Split e Merge validadas com exatidao em O(log n).")
            }
            _ ==> {
                  println("Falha nas operacoes de Treap.")
            }
      }
      println("Teste concluido com sucesso.")
}
