#L ============================================================================
#L Algoritmo: Illinois Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosIllinoisMethod) {
      println("==================================================")
      println("  SciAlgo: Illinois Method")
      println("==================================================")

      mut as int64: a = 1
      mut as int64: b = 20
      mut as int64: root = 0
      mut as int64: iter = 0
      infinite (iter < 10) {
            mut as int64: fa = a * a - 64
            mut as int64: fb = b * b - 64
            mut as int64: denom = fb - (fa /i 2)
            mut as int64: c = (a + b) /i 2
            route { denom != 0 ==> { c = (a * fb - b * (fa /i 2)) /i denom } _ ==> {} }
            route {
                  c * c == 64 ==> {
                        root = c
                        iter = 20
                  }
                  c * c < 64 ==> {
                        a = c
                        root = c
                  }
                  _ ==> {
                        b = c
                        root = c
                  }
            }
            iter = iter + 1
      }

      println("1. Raiz calculada pelo metodo de Illinois: " + root)
      println("2. Illinois Method concluido com sucesso.")
}
