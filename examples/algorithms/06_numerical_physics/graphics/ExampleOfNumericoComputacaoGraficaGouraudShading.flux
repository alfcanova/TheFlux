#L ============================================================================
#L Algoritmo: Gouraud Shading
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaGouraudShading) {
      println("==================================================")
      println("  SciAlgo: Gouraud Shading")
      println("==================================================")

      mut as int64: i0 = 50
      mut as int64: i1 = 250
      mut as int64: t_pct = 50
      mut as int64: interp_intensity = i0 + ((i1 - i0) * t_pct) /i 100

      println("1. Intensidade interpolada por Gouraud: " + interp_intensity)
      println("2. Gouraud Shading concluido com sucesso.")
}
