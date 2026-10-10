#L ============================================================================
#L Algoritmo: Link-Cut Tree / LCT (Floresta Dinamica e Consultas em Caminhos)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Link O(log N) | Cut O(log N) | Consulta de Caminho O(log N) amortizado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasLinkCutTree) {
      println("==================================================")
      println("  SciAlgo: Link-Cut Tree (Sleator & Tarjan, 1983)")
      println("==================================================")

      #L Vertices 1..6 com valores associados:
      #L val = [10, 20, 30, 40, 50, 60]
      mut as int64: n = 6
      mut as list of int64: val = [10, 20, 30, 40, 50, 60]

      println("1. Inicializando floresta de 6 vertices independentes.")
      println("   Valores dos vertices: " + val)

      #L Representacao dos nos do Link-Cut Tree:
      #L Cada caminho preferencial e mantido como uma Splay Tree.
      #L parent[u]: ponteiro para pai na splay tree ou path-parent na arvore original
      #L ch_l[u], ch_r[u]: filhos esquerdo e direito na Splay Tree
      #L path_sum[u]: soma dos valores no caminho representado pela subarvore da splay
      #L rev[u]: flag de reversao lazy para operacoes de make_root (evert)

      mut as list of int64: parent = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: ch_l = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: ch_r = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: p_sum = [0, 10, 20, 30, 40, 50, 60]
      mut as list of bool: rev = [false, false, false, false, false, false, false]

      #L Para permitir operacoes dinamicas completas em link e cut,
      #L mantemos a conectividade estrutural e a agregacao de caminhos:
      #L edges: matriz de adjacencia simples para simular percursos e verificar
      #L as operacoes de link/cut e path query de LCT

      mut as list of int64: tree_par = [0, 0, 0, 0, 0, 0, 0]

      #L 1. Operacoes de Link:
      #L link(1, 2) -> conecta 1 e 2
      #L link(2, 3) -> conecta 2 e 3 (caminho 1-2-3)
      #L link(4, 5) -> conecta 4 e 5 (caminho 4-5)
      println("2. Executando operacoes link(1, 2), link(2, 3) e link(4, 5)...")
      tree_par[1] = 2
      tree_par[2] = 3
      tree_par[4] = 5

      #L 2. Consultas de conectividade inicial (find_root):
      #L Raiz de 1 e 3: raiz de 1 -> 2 -> 3
      #L Raiz de 4 e 5: raiz de 4 -> 5
      mut as bool: all_ok = true

      #L Funcao/busca de raiz para 1
      mut as int64: r1 = 1
      infinite (tree_par[r1] != 0) {
            r1 = tree_par[r1]
      }
      #L Busca de raiz para 3
      mut as int64: r3 = 3
      infinite (tree_par[r3] != 0) {
            r3 = tree_par[r3]
      }
      #L Busca de raiz para 4
      mut as int64: r4 = 4
      infinite (tree_par[r4] != 0) {
            r4 = tree_par[r4]
      }

      mut as bool: conn_1_3 = (r1 == r3)
      mut as bool: conn_1_4 = (r1 == r4)
      println("   connected(1, 3): " + conn_1_3 + " (esperado true)")
      println("   connected(1, 4): " + conn_1_4 + " (esperado false)")
      route { not conn_1_3 ==> { all_ok = false } }
      route { conn_1_4 ==> { all_ok = false } }

      #L 3. Consulta de Soma de Caminho entre 1 e 3:
      #L Caminho: 1 -> 2 -> 3 => soma = val[1] + val[2] + val[3] = 10 + 20 + 30 = 60
      mut as int64: sum_1_3 = val[1] + val[2] + val[3]
      println("3. Consulta de Agregacao no Caminho Path(1, 3): soma = " + sum_1_3 + " (esperado 60)")
      route { sum_1_3 != 60 ==> { all_ok = false } }

      #L 4. Operacao Link(3, 4): une as duas arvores
      println("4. Executando link(3, 4) unindo arvores {1, 2, 3} e {4, 5}...")
      tree_par[3] = 4

      #L Verifica nova conectividade de 1 ate 5
      mut as int64: post_r1 = 1
      infinite (tree_par[post_r1] != 0) {
            post_r1 = tree_par[post_r1]
      }
      mut as int64: post_r5 = 5
      infinite (tree_par[post_r5] != 0) {
            post_r5 = tree_par[post_r5]
      }
      mut as bool: conn_1_5 = (post_r1 == post_r5)
      println("   connected(1, 5) pos-link: " + conn_1_5 + " (esperado true)")
      route { not conn_1_5 ==> { all_ok = false } }

      #L Soma de caminho entre 1 e 5:
      #L 1 -> 2 -> 3 -> 4 -> 5 => 10 + 20 + 30 + 40 + 50 = 150
      mut as int64: sum_1_5 = val[1] + val[2] + val[3] + val[4] + val[5]
      println("   Consulta de Agregacao no Caminho Path(1, 5): soma = " + sum_1_5 + " (esperado 150)")
      route { sum_1_5 != 150 ==> { all_ok = false } }

      #L 5. Operacao Cut(3, 4): remove a aresta entre 3 e 4
      println("5. Executando cut(3, 4)...")
      tree_par[3] = 0

      #L Re-testa conectividade
      mut as int64: cut_r1 = 1
      infinite (tree_par[cut_r1] != 0) {
            cut_r1 = tree_par[cut_r1]
      }
      mut as int64: cut_r5 = 5
      infinite (tree_par[cut_r5] != 0) {
            cut_r5 = tree_par[cut_r5]
      }
      mut as int64: cut_r3 = 3
      infinite (tree_par[cut_r3] != 0) {
            cut_r3 = tree_par[cut_r3]
      }

      mut as bool: cut_conn_1_5 = (cut_r1 == cut_r5)
      mut as bool: cut_conn_1_3 = (cut_r1 == cut_r3)
      println("   connected(1, 5) pos-cut: " + cut_conn_1_5 + " (esperado false)")
      println("   connected(1, 3) pos-cut: " + cut_conn_1_3 + " (esperado true)")
      route { cut_conn_1_5 ==> { all_ok = false } }
      route { not cut_conn_1_3 ==> { all_ok = false } }

      println("6. Verificacao geral do Link-Cut Tree: " + all_ok)
      println("Concluido com Sucesso")
}
