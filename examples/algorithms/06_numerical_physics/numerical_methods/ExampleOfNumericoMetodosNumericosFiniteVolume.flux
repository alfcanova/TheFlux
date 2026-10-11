#L ============================================================================
#L Algoritmo: Finite Volume Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosFiniteVolume) {
      println("==================================================")
      println("  SciAlgo: Finite Volume Method")
      println("==================================================")

      mut as int64: flux_in = 100
      mut as int64: flux_out = 40
      mut as int64: cell_vol = 2
      mut as int64: net_flux = (flux_in - flux_out) /i cell_vol

      println("1. Balanco de conservacao de fluxo FVM: " + net_flux)
      println("2. Finite Volume Method concluido com sucesso.")
}
