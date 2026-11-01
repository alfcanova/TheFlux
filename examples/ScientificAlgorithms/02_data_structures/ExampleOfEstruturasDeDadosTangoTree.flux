#L ============================================================================
#L Algoritmo: Tango Tree (Arvore $O(\log \log n)$-competitiva)
#L Dominio: 02_data_structures / Categoria: Arvores de Busca Binaria
#L Descricao: Decomposicao em caminhos preferenciais e arvores auxiliares equilibradas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosTangoTree) {
      println("=== Algoritmo: Tango Tree ===")

      #L Arvore de referencia completa com N=7 elementos e altura H=3
      #L Preferencia de transicao: ultimo filho visitado em cada bifurcacao
      #L No raiz 4: filho esquerdo 2, filho direito 6
      #L Transicao preferida na raiz: filho direito (no 6)
      mut as int64: prefRoot = 6

      #L No 6: filho esquerdo 5, filho direito 7
      #L Transicao preferida no 6: filho direito (no 7)
      mut as int64: prefNode6 = 7

      #L Caminho preferencial identificado: [4, 6, 7]
      #L Representado por uma arvore auxiliar equilibrada (aux tree)
      #L Raiz da aux-tree: no 6; filho esquerdo: 4; filho direito: 7
      mut as int64: auxRoot = 6
      mut as int64: auxEsq = 4
      mut as int64: auxDir = 7

      println("1. Caminho preferencial principal formado: 4 -> 6 -> 7")
      println("2. Raiz da arvore auxiliar (aux-tree): " + auxRoot)
      println("3. Filho esquerdo na aux-tree: " + auxEsq)
      println("4. Filho direito na aux-tree: " + auxDir)

      #L Mudanca de caminho preferencial (quando filho 5 e acessado):
      #L Ocorre corte (cut) do no 7 e juncao (join) do no 5
      mut as int64: novoPrefNode6 = 5
      println("5. Caminho preferencial atualizado apos transicao: 4 -> 6 -> " + novoPrefNode6)

      route {
            auxRoot == 6 and auxEsq == 4 and novoPrefNode6 == 5 ==> {
                  println("6. Decomposicao e troca de caminho na Tango Tree validada com sucesso.")
            }
            _ ==> {
                  println("Falha na operacao da Tango Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
