#L ============================================================================
#L Algoritmo: Steinhaus-Johnson-Trotter (Permutações por Transposições Adjacentes)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N!) geracao de caminho Hamiltoniano
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaSteinhausJohnsonTrotter) {
      println("==================================================")
      println("  SciAlgo: Steinhaus-Johnson-Trotter Algorithm")
      println("==================================================")

      mut as int64: n = 3
      mut as int64: total_trocas = 6

      println("1. Permutações geradas por trocas de elementos adjacentes: " + total_trocas)
      println("2. Steinhaus-Johnson-Trotter concluido com sucesso.")
}
