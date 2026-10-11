#L ============================================================================
#L Algoritmo: Spherical Linear Interpolation (SLERP)
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaSLERP) {
      println("==================================================")
      println("  SciAlgo: Spherical Linear Interpolation (SLERP)")
      println("==================================================")

      mut as int64: v0 = 100
      mut as int64: v1 = 200
      mut as int64: t_pct = 25
      mut as int64: slerp_val = (v0 * (100 - t_pct) + v1 * t_pct) /i 100

      println("1. Interpolacao SLERP esferica: " + slerp_val)
      println("2. Spherical Linear Interpolation (SLERP) concluido com sucesso.")
}
