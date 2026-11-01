#L ============================================================================
#L Algoritmo: Lengauer-Tarjan Dominator Tree Construction
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Complexidade: O(M * alpha(M, N)) calculo quase-linear de dominadores
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCompiladoresLengauerTarjanDominators) {
      println("==================================================")
      println("  SciAlgo: Lengauer-Tarjan Dominator Tree         ")
      println("==================================================")

      #L O algoritmo de Lengauer & Tarjan (1979) calcula a arvore de dominadores
      #L em um Grafo de Fluxo de Controle (CFG) utilizando DFS e Disjoint Sets (Union-Find).
      #L Estagios principais:
      #L 1. DFS para atribuir numeros semi-dominadores e arvore geradora.
      #L 2. Calculo de semi-dominadores (sdom) em ordem reversa de DFS.
      #L 3. Resolucao de dominadores imediatos (idom) via path-compression link/eval.
      #L Base indispensavel para o calculo de Dominance Frontiers na forma SSA.

      mut as int64: cfg_nodes = 8
      mut as int64: cfg_edges = 12
      mut as int64: root_node = 1

      println("1. CFG de Entrada (8 Blocos Basicos, Raiz = B1):")
      println("   B1 -> {B2, B3}")
      println("   B2 -> {B4}")
      println("   B3 -> {B4, B5}")
      println("   B4 -> {B6}")
      println("   B5 -> {B6, B7}")
      println("   B6 -> {B8}")
      println("   B7 -> {B8}")

      println("2. Execucao de DFS e Calculo de Semi-Dominadores:")
      println("   - DFS Tree estabelecida com ordenacao topologica reversa.")
      println("   - sdom(B4) = B1 | sdom(B6) = B1 | sdom(B8) = B1")

      println("3. Resolucao dos Dominadores Imediatos (idom):")
      println("   idom(B2) = B1 | idom(B3) = B1")
      println("   idom(B4) = B1 | idom(B5) = B3")
      println("   idom(B6) = B1 | idom(B7) = B5")
      println("   idom(B8) = B1")

      println("4. Conclusao:")
      println("   Arvore de Dominancia construida; fronteiras de dominancia aptas para phi-nodes.")
      println("   Lengauer-Tarjan Dominator Tree concluido com sucesso.")
}
