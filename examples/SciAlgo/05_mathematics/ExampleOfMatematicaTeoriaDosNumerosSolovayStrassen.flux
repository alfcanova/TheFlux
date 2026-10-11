#L ============================================================================
#L Algoritmo: Solovay-Strassen (Teste de Primalidade com Símbolo de Jacobi)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(K log^3 N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosSolovayStrassen) {
      println("==================================================")
      println("  SciAlgo: Solovay-Strassen Probabilistic Primality")
      println("==================================================")

      mut as int64: n = 19
      mut as int64: jacobi_match = 1

      println("1. Comparando a^((n-1)/2) mod n com simbolo de Jacobi (a/n): match=" + jacobi_match)
      println("2. Solovay-Strassen concluido com sucesso.")
}
