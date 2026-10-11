#L ============================================================================
#L Algoritmo: Finite Volume Conservation
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaFiniteVolume) {
      println("==================================================")
      println("  SciAlgo: Finite Volume Conservation")
      println("==================================================")

      mut as int64: mass_in = 10 * 5
      mut as int64: mass_out = 8 * 6
      mut as int64: net_mass = mass_in - mass_out

      println("1. Balanco de conservacao de massa em volume de controle: " + net_mass)
      println("2. Finite Volume Conservation concluido com sucesso.")
}
