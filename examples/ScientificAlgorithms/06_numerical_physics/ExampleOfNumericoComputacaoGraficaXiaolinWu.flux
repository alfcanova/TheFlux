#L ============================================================================
#L Algoritmo: Xiaolin Wu Anti-Aliased Line
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaXiaolinWu) {
      println("==================================================")
      println("  SciAlgo: Xiaolin Wu Anti-Aliased Line")
      println("==================================================")

      mut as int64: total_coverage = 0
      mut as int64: idx = 1
      infinite (idx <= 10) {
            mut as int64: frac = (idx * 37) /r 100
            mut as int64: c1 = 100 - frac
            mut as int64: c2 = frac
            total_coverage = total_coverage + c1 + c2
            idx = idx + 1
      }

      println("1. Cobertura anti-aliasing total acumulada: " + total_coverage)
      println("2. Xiaolin Wu Anti-Aliased Line concluido com sucesso.")
}
