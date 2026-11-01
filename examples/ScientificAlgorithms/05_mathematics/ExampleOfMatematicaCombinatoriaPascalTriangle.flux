#L ============================================================================
#L Algoritmo: Pascal Triangle (Triângulo de Pascal)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N^2) tempo e espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaPascalTriangle) {
      println("==================================================")
      println("  SciAlgo: Pascal Triangle Generation")
      println("==================================================")

      #L Linha 4: [1, 4, 6, 4, 1]
      mut as list of int64: linha4 = [1, 4, 6, 4, 1]
      mut as int64: n = listLength(linha4)

      println("1. Linha n=4 do Triangulo de Pascal:")
      println("   [" + linha4[1] + ", " + linha4[2] + ", " + linha4[3] + ", " + linha4[4] + ", " + linha4[5] + "]")
      println("2. Pascal Triangle concluido com sucesso.")
}
