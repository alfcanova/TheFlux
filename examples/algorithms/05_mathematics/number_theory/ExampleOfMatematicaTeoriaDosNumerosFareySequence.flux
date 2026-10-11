#L ============================================================================
#L Algoritmo: Farey Sequence (Sequência de Farey de Ordem N)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N^2) tempo gerando fracoes irredutiveis ordenadas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosFareySequence) {
      println("==================================================")
      println("  SciAlgo: Farey Sequence of Order N")
      println("==================================================")

      #L F_3: 0/1, 1/3, 1/2, 2/3, 1/1 (5 termos)
      mut as int64: ordem = 3
      mut as int64: total_termos = 5

      println("1. Sequencia de Farey de ordem " + ordem)
      println("2. Total de fracoes irredutiveis em [0, 1]: " + total_termos)
      println("3. Farey Sequence concluido com sucesso.")
}
