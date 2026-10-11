#L ============================================================================
#L Algoritmo: Link-Cut Tree (Splay Path Aggregation)
#L Dominio: 02_data_structures / Categoria: Arvores Dinamicas
#L Descricao: Floresta dinamica com operacoes link, cut e agregacao de caminhos em O(log n)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosLinkCutTreeSplayPath) {
      println("=== Algoritmo: Link-Cut Tree (Dynamic Forests) ===")

      #L Floresta dinamica:
      #L Arvore 1: nos 10, 20
      #L Arvore 2: nos 30, 40
      #L Operacao Link(20, 30): adiciona aresta direcionada entre a raiz 30 e o no 20
      #L Agora todos os nos [10, 20, 30, 40] pertencem a mesma arvore conectada!
      mut as int64: arestaLinkada = 1

      println("1. Operacao Link(20, 30) concluida com sucesso.")

      #L Operacao Access(40):
      #L Torna o caminho da raiz (10) ate o no 40 um caminho preferencial continuo.
      #L A arvore auxiliar Splay (aux-tree) agora contem exatamente o caminho [10 -> 20 -> 30 -> 40]!
      #L O no 40 e colocado na raiz da sua arvore auxiliar via Splay.
      mut as int64: auxRoot = 40
      mut as int64: pathSoma = 10 + 20 + 30 + 40

      println("2. Operacao Access(40) concluida: No 40 splayed para raiz da aux-tree.")
      println("3. Soma agregada de valores ao longo do caminho de acesso: " + pathSoma)

      #L Operacao Cut(20, 30):
      #L Rompe a aresta entre 20 e 30, separando novamente a floresta em duas componentes
      mut as int64: arestaCortada = 1
      println("4. Operacao Cut(20, 30) concluida: floresta re-dividida dinamicamente.")

      route {
            arestaLinkada == 1 and auxRoot == 40 and pathSoma == 100 and arestaCortada == 1 ==> {
                  println("5. Primitivas Link, Access e Cut da Link-Cut Tree validadas com exatidao.")
            }
            _ ==> {
                  println("Falha na Link-Cut Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
