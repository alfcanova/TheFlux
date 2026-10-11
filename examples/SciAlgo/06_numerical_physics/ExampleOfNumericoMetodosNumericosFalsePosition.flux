#L ============================================================================
#L Algoritmo: False Position (Regula Falsi)
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosFalsePosition) {
      println("==================================================")
      println("  SciAlgo: False Position (Regula Falsi)")
      println("==================================================")

      mut as int64: a = 0
      mut as int64: b = 14
      mut as int64: root = 0
      mut as int64: iter = 0
      infinite (iter < 15 and a < b) {
            mut as int64: fa = a * a - 49
            mut as int64: fb = b * b - 49
            mut as int64: denom = fb - fa
            mut as int64: c = (a + b) /i 2
            route { denom != 0 ==> { c = b - (fb * (b - a)) /i denom } _ ==> {} }
            mut as int64: fc = c * c - 49
            route {
                  fc == 0 ==> {
                        root = c
                        a = b + 1
                  }
                  fc < 0 ==> {
                        a = c + 1
                        root = c
                  }
                  _ ==> {
                        b = c - 1
                        root = c
                  }
            }
            iter = iter + 1
      }

      println("1. Raiz encontrada por Regula Falsi: " + root)
      println("2. False Position (Regula Falsi) concluido com sucesso.")
}
