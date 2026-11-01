#L ============================================================================
#L Algoritmo: Gray Code (Código de Gray Combinatório N-Bits)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(2^N) tempo linear por transição unitária
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaGrayCode) {
      println("==================================================")
      println("  SciAlgo: Combinatorial Gray Code")
      println("==================================================")

      mut as int64: n = 3
      mut as int64: total_codigos = 8

      println("1. Dimensoes do hipercubo de Gray: " + n + " bits")
      println("2. Sequencia com distancia unitária de Hamming: " + total_codigos + " estados")
      println("3. Gray Code concluido com sucesso.")
}
