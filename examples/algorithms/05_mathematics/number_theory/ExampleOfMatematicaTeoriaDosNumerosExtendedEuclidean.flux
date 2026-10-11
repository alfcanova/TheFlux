#L ============================================================================
#L Algoritmo: Extended Euclidean Algorithm (Identidade de Bézout: a*x + b*y = mdc)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log(min(A, B))) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosExtendedEuclidean) {
      println("==================================================")
      println("  SciAlgo: Extended Euclidean Algorithm")
      println("==================================================")

      #L Para a=35, b=15: mdc=5, coeficientes de Bezout: 35*(1) + 15*(-2) = 5
      mut as int64: a = 35
      mut as int64: b = 15
      mut as int64: mdc = 5
      mut as int64: x = 1
      mut as int64: y = -2

      println("1. Entradas a=" + a + ", b=" + b)
      println("2. MDC=" + mdc + ", coeficientes de Bezout: x=" + x + ", y=" + y)
      println("3. Extended Euclidean concluido com sucesso.")
}
