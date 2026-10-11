#L ============================================================================
#L Algoritmo: Warnock Area Subdivision
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaWarnockAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Warnock Area Subdivision")
      println("==================================================")

      mut as int64: poly_count = 16
      mut as int64: max_depth = 3
      mut as int64: cur_depth = 0
      mut as int64: quads = 1
      infinite (cur_depth < max_depth and poly_count > 1) {
            quads = quads * 4
            poly_count = poly_count /i 2
            cur_depth = cur_depth + 1
      }

      println("1. Total de quadrantes subdivididos Warnock: " + quads)
      println("2. Warnock Area Subdivision concluido com sucesso.")
}
