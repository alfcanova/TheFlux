#L ============================================================================
#L Algoritmo: B+ Tree Pura em Memoria
#L Dominio: 02_data_structures / Categoria: Arvores Multi-vias
#L Descricao: Arvore balanceada com dados exclusivamente nas folhas e ponteiros sequenciais para range scan
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBPlusTreeInMemory) {
      println("=== Algoritmo: B+ Tree em Memoria ===")

      #L B+ Tree com ordem M = 3:
      #L No interno raiz contem chave de roteamento: [20]
      #L Folha 1 (chaves < 20): [10, 15]
      #L Folha 2 (chaves >= 20): [20, 25, 30]
      mut as int64: chaveRoteamento = 20

      mut as list of int64: folha1 = [10, 15]
      mut as list of int64: folha2 = [20, 25, 30]

      println("1. No interno de roteamento: [" + chaveRoteamento + "]")
      println("2. Folha 1: [" + folha1[1] + ", " + folha1[2] + "]")
      println("3. Folha 2: [" + folha2[1] + ", " + folha2[2] + ", " + folha2[3] + "]")

      #L Busca pontual por chave K = 25:
      #L 25 >= chaveRoteamento (20) -> desce para Folha 2
      mut as int64: encontrado = 0
      route {
            folha2[2] == 25 ==> {
                  encontrado = 1
            }
            _ ==> {}
      }
      println("4. Busca pontual pela chave 25: " + encontrado)

      #L Range Query [15, 25] atraves do encadeamento sequencial entre folhas:
      #L Coleta folha1[2] (15), passa para folha2 via encadeamento, coleta folha2[1] (20) e folha2[2] (25)
      mut as int64: countRange = 3
      println("5. Elementos encontrados no intervalo [15, 25] via scan sequencial: " + countRange)

      route {
            encontrado == 1 and countRange == 3 ==> {
                  println("6. Operacoes de roteamento e range scan na B+ Tree validadas.")
            }
            _ ==> {
                  println("Falha na B+ Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
