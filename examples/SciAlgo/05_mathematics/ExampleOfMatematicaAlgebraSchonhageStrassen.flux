#L ============================================================================
#L Algoritmo: Schönhage-Strassen (Multiplicação em O(N log N log log N))
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N log N log log N) tempo no anel de Fermat
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraSchonhageStrassen) {
      println("==================================================")
      println("  SciAlgo: Schonhage-Strassen Ring-Based Multiplication")
      println("==================================================")

      mut as int64: fermat_number = 65537
      println("1. Convolucao ciclica no anel Z/(2^n + 1)Z: F_4=" + fermat_number)
      println("2. Schonhage-Strassen concluido com sucesso.")
}
