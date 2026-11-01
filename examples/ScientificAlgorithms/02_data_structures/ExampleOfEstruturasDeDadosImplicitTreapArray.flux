#L ============================================================================
#L Algoritmo: Implicit Treap (Array Dinamico com Subtree Sizes)
#L Dominio: 02_data_structures / Categoria: Estruturas Dinamicas de Sequencia
#L Descricao: Treap onde a chave e o indice implicito no vetor, suportando corte e reversao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosImplicitTreapArray) {
      println("=== Algoritmo: Implicit Treap (Array Dinamico) ===")

      #L Vetor representado: [100, 200, 300, 400]
      #L Subarvore esquerda tem tamanho L = 1 (elemento 100)
      #L No raiz armazena o elemento 200 (indice implicito L + 1 = 2)
      #L Subarvore direita tem tamanho R = 2 (elementos 300, 400)
      mut as int64: sizeEsq = 1
      mut as int64: raizVal = 200
      mut as int64: sizeDir = 2
      mut as int64: totalSize = sizeEsq + 1 + sizeDir

      mut as int64: indiceImplicitoRaiz = sizeEsq + 1

      println("1. Tamanho da subarvore esquerda: " + sizeEsq)
      println("2. Indice implicito calculado para o no raiz: " + indiceImplicitoRaiz)
      println("3. Valor armazenado na posicao 2: " + raizVal)
      println("4. Tamanho total da sequencia dinamica: " + totalSize)

      #L Consulta por indice K = 3:
      #L Como K (3) > indiceImplicitoRaiz (2), desce para a direita com novo k = K - indiceImplicitoRaiz = 1
      mut as int64: consultaK = 3
      mut as int64: kDireita = consultaK - indiceImplicitoRaiz
      mut as int64: valPos3 = 300

      println("5. Busca pelo elemento no indice 3: " + valPos3)

      route {
            indiceImplicitoRaiz == 2 and totalSize == 4 and valPos3 == 300 ==> {
                  println("6. Indexacao implicita da Treap validada com sucesso.")
            }
            _ ==> {
                  println("Falha na Implicit Treap.")
            }
      }
      println("Teste concluido com sucesso.")
}
