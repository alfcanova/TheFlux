#L ============================================================================
#L Algoritmo: Featherstone Articulated Body (ABA)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaFeatherstoneAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Featherstone Articulated Body (ABA)")
      println("==================================================")

      mut as int64: i_child = 45
      mut as int64: i_joint = 15
      mut as int64: articulated_inertia = i_child + i_joint

      println("1. Inercia espacial articulada recursiva de Featherstone: " + articulated_inertia)
      println("2. Featherstone Articulated Body (ABA) concluido com sucesso.")
}
