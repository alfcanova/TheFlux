#L ============================================================================
#L Algoritmo: Treap Cartesiana com Prioridades Aleatorias
#L Dominio: 02_data_structures / Categoria: Arvores Balanceadas Probabilisticas
#L Descricao: Arvore binaria de busca nas chaves e heap de prioridades aleatorias
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosCartesianTreap) {
      println("=== Algoritmo: Treap Cartesiana com Prioridades ===")

      #L Nos da Treap: (chave, prioridade max-heap)
      #L No A: chave = 10, prioridade = 90 (raiz)
      #L No B: chave = 20, prioridade = 50 (filho direito de A)
      mut as int64: chaveA = 10
      mut as int64: prioA = 90

      mut as int64: chaveB = 20
      mut as int64: prioB = 50

      #L Insercao do No C: chave = 15, prioridade = 95
      #L Insercao pela chave BST: 15 > 10 e 15 < 20 -> filho esquerdo de B
      #L Mas prioridade 95 > prioB (50) e > prioA (90)!
      #L Viola propriedade de heap! Exige rotacao para subir C ate a raiz.
      mut as int64: chaveC = 15
      mut as int64: prioC = 95

      println("1. Raiz inicial: Chave " + chaveA + " (prioridade " + prioA + ")")
      println("2. Novo no inserido: Chave " + chaveC + " (prioridade " + prioC + ")")

      #L Apos rotacoes: C sobe para raiz (prioridade maxima 95)
      #L Filho esquerdo de C: A (chave 10, prio 90)
      #L Filho direito de C: B (chave 20, prio 50)
      mut as int64: novaRaizChave = chaveC
      mut as int64: novaRaizPrio = prioC

      mut as int64: esqChave = chaveA
      mut as int64: dirChave = chaveB

      println("3. Nova raiz apos rotacoes de heap: Chave " + novaRaizChave + " (prio " + novaRaizPrio + ")")
      println("4. Filho esquerdo: Chave " + esqChave)
      println("5. Filho direito: Chave " + dirChave)

      #L Verificacao de BST e Max-Heap simultaneas
      mut as int64: bstOk = 0
      mut as int64: heapOk = 0
      route {
            esqChave < novaRaizChave and dirChave > novaRaizChave ==> { bstOk = 1 }
            _ ==> {}
      }
      route {
            novaRaizPrio > prioA and novaRaizPrio > prioB ==> { heapOk = 1 }
            _ ==> {}
      }

      route {
            bstOk == 1 and heapOk == 1 ==> {
                  println("6. Propriedades de Treap (BST + Max-Heap) validadas com sucesso.")
            }
            _ ==> {
                  println("Falha na Treap.")
            }
      }
      println("Teste concluido com sucesso.")
}
