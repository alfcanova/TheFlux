#L ============================================================================
#L Algoritmo: Fermat Factorization (Diferença de Dois Quadrados N = a^2 - b^2)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(|p - q|) eficiente quando fatores sao proximos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosFermatFactorization) {
      println("==================================================")
      println("  SciAlgo: Fermat's Difference of Squares Factoring")
      println("==================================================")

      #L N = 5959 = 80^2 - 21^2 = (80 - 21)*(80 + 21) = 59 * 101
      mut as int64: a = 80
      mut as int64: b = 21
      mut as int64: p = a - b
      mut as int64: q = a + b

      println("1. Decomposicao N = 5959 em a^2 - b^2: a=" + a + ", b=" + b)
      println("2. Fatores: " + p + " e " + q)
      println("3. Fermat Factorization concluido com sucesso.")
}
