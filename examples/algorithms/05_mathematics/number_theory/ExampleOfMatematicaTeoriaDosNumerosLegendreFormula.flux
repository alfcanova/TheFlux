#L ============================================================================
#L Algoritmo: Legendre Formula (Expoente do Primo P no Fatorial N!)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log_P N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosLegendreFormula) {
      println("==================================================")
      println("  SciAlgo: Legendre's Formula for v_p(n!)")
      println("==================================================")

      #L v_5(100!) = 100/5 + 100/25 = 20 + 4 = 24
      mut as int64: n = 100
      mut as int64: p = 5
      mut as int64: expoente = 0

      mut as int64: k = n /i p
      infinite (k > 0) {
            expoente = expoente + k
            k = k /i p
      }

      println("1. Expoente maximo de p=" + p + " que divide " + n + "! : " + expoente)
      println("2. Legendre Formula concluido com sucesso.")
}
