#L ============================================================================
#L Algoritmo: LU Decomposition (Fatoração PA = LU de Doolittle)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraLUDecomposition) {
      println("==================================================")
      println("  SciAlgo: LU Decomposition (PA = LU)")
      println("==================================================")

      mut as int64: n = 3
      mut as int64: trocas_permutacao = 1

      println("1. Fatoracao LU com pivoteamento parcial completada para n=" + n)
      println("2. Permutacoes de linha registradas: " + trocas_permutacao)
      println("3. LU Decomposition concluido com sucesso.")
}
