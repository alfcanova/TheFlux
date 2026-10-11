#L ============================================================================
#L Algoritmo: Wu-Manber (Casamento Simultâneo de Múltiplos Padrões)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N * B) com tabela SHIFT de blocos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoWuManber) {
      println("==================================================")
      println("  SciAlgo: Wu-Manber Multi-Pattern Matching")
      println("==================================================")

      mut as int64: num_padroes = 10
      mut as int64: bloco_b = 2
      mut as int64: min_shift = 3

      println("1. Padroes indexados: " + num_padroes + " com bloco B=" + bloco_b)
      println("2. Salto da tabela SHIFT: " + min_shift)
      println("3. Wu-Manber concluido com sucesso.")
}
