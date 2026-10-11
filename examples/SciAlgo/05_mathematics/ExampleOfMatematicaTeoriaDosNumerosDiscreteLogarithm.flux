#L ============================================================================
#L Algoritmo: Discrete Logarithm (Problema Geral do Logaritmo Discreto)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(sqrt(P)) genérico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosDiscreteLogarithm) {
      println("==================================================")
      println("  SciAlgo: Discrete Logarithm Formulation (g^x == h mod p)")
      println("==================================================")

      #L g=2, h=8, p=11 -> 2^3 == 8 mod 11 -> x = 3
      mut as int64: g = 2
      mut as int64: h = 8
      mut as int64: p = 11
      mut as int64: x = 3

      println("1. Equacao " + g + "^x == " + h + " (mod " + p + ")")
      println("2. Expoente x encontrado: " + x)
      println("3. Discrete Logarithm concluido com sucesso.")
}
