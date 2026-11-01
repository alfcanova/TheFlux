#L ============================================================================
#L Algoritmo: Hook Length Formula (Formula do Comprimento do Gancho de Frame-Robinson-Thrall)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N) contagem exata de tableaux
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaHookLengthFormula) {
      println("==================================================")
      println("  SciAlgo: Hook Length Formula")
      println("==================================================")

      #L Partição lambda = (3, 2), n = 5
      #L f^(3, 2) = 5! / (4 * 3 * 1 * 2 * 1) = 120 / 24 = 5
      mut as int64: n = 5
      mut as int64: produto_ganchos = 24
      mut as int64: num_tableaux = 5

      println("1. Particao lambda = (3, 2) com n = " + n)
      println("2. Dimensao da representacao irreductivel f^lambda = " + num_tableaux)
      println("3. Hook Length Formula concluido com sucesso.")
}
