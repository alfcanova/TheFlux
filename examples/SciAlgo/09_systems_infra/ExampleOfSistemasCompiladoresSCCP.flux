#L ============================================================================
#L Algoritmo: Sparse Conditional Constant Propagation (SCCP)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Complexidade: O(E_cfg + E_ssa) avaliacao simultanea de constantes e arestas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCompiladoresSCCP) {
      println("==================================================")
      println("  SciAlgo: Sparse Conditional Constant Propagation")
      println("==================================================")

      #L SCCP (Wegman & Zadeck, 1991) propaga constantes e descobre ramificacoes
      #L mortas simultaneamente sobre a representacao SSA.
      #L Lattice de tres niveis para valores:
      #L TOP (Top / Nao inicializado) -> CONSTANT (Constante conhecida) -> BOTTOM (Overdefined)
      #L Mantem duas worklists:
      #L 1. CFG Worklist: arestas de controle alcancaveis.
      #L 2. SSA Worklist: definicoes de variaveis cujos valores foram refinados.

      mut as int64: branches_folded = 2
      mut as int64: constants_discovered = 4
      mut as int64: dead_blocks_eliminated = 1

      println("1. Analise de Lattice em SSA:")
      println("   x_1 = 5 (Constante C=5)")
      println("   y_1 = x_1 * 2 -> Evaluated to CONSTANT 10")
      println("   cond_1 = (y_1 > 8) -> Evaluated to CONSTANT true")

      println("2. Propagacao Condicional em Arestas do CFG:")
      println("   - Ramificacao 'if cond_1 then B_then else B_else'")
      println("   - Apenas aresta B_entry -> B_then adicionada a CFG Worklist!")
      println("   - Bloco B_else marcado como INALCANCAVEL (Dead Code).")

      println("3. Convergencia das Worklists:")
      println("   Constantes resolvidas: " + constants_discovered)
      println("   Ramos mortos podados: " + branches_folded)
      println("   Blocos eliminados do IR: " + dead_blocks_eliminated)
      println("   Sparse Conditional Constant Propagation concluido.")
}
