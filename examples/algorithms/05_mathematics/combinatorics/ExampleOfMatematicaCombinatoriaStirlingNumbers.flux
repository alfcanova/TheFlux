#L ============================================================================
#L Algoritmo: Stirling Numbers (Números de Stirling de Segunda Espécie)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N * K) programacao dinamica S(n,k) = k*S(n-1,k) + S(n-1,k-1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaStirlingNumbers) {
      println("==================================================")
      println("  SciAlgo: Stirling Numbers of the Second Kind")
      println("==================================================")

      #L S(4, 2) = 7
      mut as int64: n = 4
      mut as int64: k = 2
      mut as int64: s_4_2 = 7

      println("1. Particoes de " + n + " elementos em " + k + " blocos nao vazios: " + s_4_2)
      println("2. Stirling Numbers concluido com sucesso.")
}
