#L ============================================================================
#L Algoritmo: Golden-Section Search
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosGoldenSectionSearch) {
      println("==================================================")
      println("  SciAlgo: Golden-Section Search")
      println("==================================================")

      mut as int64: l = 0
      mut as int64: r = 100
      infinite (r - l > 2) {
            mut as int64: m1 = l + (r - l) /i 3
            mut as int64: m2 = r - (r - l) /i 3
            mut as int64: f1 = (m1 - 42) * (m1 - 42)
            mut as int64: f2 = (m2 - 42) * (m2 - 42)
            route {
                  f1 < f2 ==> { r = m2 }
                  _ ==> { l = m1 }
            }
      }
      mut as int64: opt_x = (l + r) /i 2

      println("1. Minimo discreto encontrado pela busca aurea: " + opt_x)
      println("2. Golden-Section Search concluido com sucesso.")
}
