#L ============================================================================
#L Algoritmo: Trial Division (Divisão por Tentativa até sqrt(N))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(sqrt(N)) tempo determinístico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosTrialDivision) {
      println("==================================================")
      println("  SciAlgo: Trial Division Primality & Factoring")
      println("==================================================")

      mut as int64: n = 37
      mut as int64: e_primo = 1

      mut as int64: d = 2
      infinite (d * d <= n) {
            route {
                  (n /r d) == 0 ==> { e_primo = 0 }
                  _ ==> {}
            }
            d = d + 1
      }

      println("1. Testando primalidade de " + n)
      println("2. Resultado primo: " + e_primo)
      println("3. Trial Division concluido com sucesso.")
}
