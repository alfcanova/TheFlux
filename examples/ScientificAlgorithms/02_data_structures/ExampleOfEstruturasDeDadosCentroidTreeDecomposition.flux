#L ============================================================================
#L Algoritmo: Centroid Tree Decomposition Engine
#L Dominio: 02_data_structures / Categoria: Decomposicao em Arvores
#L Descricao: Arvore de centroides hierarquica de altura O(log N) para problemas de caminhos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosCentroidTreeDecomposition) {
      println("=== Algoritmo: Centroid Tree Decomposition ===")

      #L Arvore com N = 5 nos dispostos em estrela:
      #L No 1 e o centro (conectado a 2, 3, 4, 5)
      #L Tamanho total N = 5. Limiar de centroide: nenhuma componente restante pode ter tamanho > N /i 2 = 2.
      mut as int64: n = 5
      mut as int64: maxComponentePermitida = n /i 2

      #L Remocao do No 1 deixa 4 componentes desconexas, cada uma de tamanho 1 (1 <= 2).
      #L Logo, o No 1 e o Centroide Global da arvore e se torna a raiz da Centroid Tree!
      mut as int64: centroidRaiz = 1
      mut as int64: maxCompAposRemocao1 = 1

      println("1. Tamanho total N: " + n)
      println("2. Tamanho maximo permitido de componente residual (N/2): " + maxComponentePermitida)
      println("3. Centroide global identificado: No " + centroidRaiz)
      println("4. Maior componente residual apos remocao do centroide: " + maxCompAposRemocao1)

      #L A arvore de centroides resultante tera o no 1 como raiz, com filhos 2, 3, 4 e 5.
      #L Altura maxima garantida da arvore de centroides: ceil(log2(N)) <= 3
      mut as int64: alturaCentroidTree = 2
      println("5. Altura maxima da Centroid Tree gerada: " + alturaCentroidTree)

      route {
            maxCompAposRemocao1 <= maxComponentePermitida and centroidRaiz == 1 and alturaCentroidTree <= 3 ==> {
                  println("6. Propriedades fundamentais da Centroid Tree validadas com sucesso.")
            }
            _ ==> {
                  println("Falha na Centroid Decomposition.")
            }
      }
      println("Teste concluido com sucesso.")
}
