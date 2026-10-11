#L ============================================================================
#L Algoritmo: Barnes-Hut Octree Algorithm
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaBarnesHut) {
      println("==================================================")
      println("  SciAlgo: Barnes-Hut Octree Algorithm")
      println("==================================================")

      mut as int64: node_size = 10
      mut as int64: distance = 50
      mut as int64: theta = (node_size * 100) /i distance
      mut as int64: can_approx = 0
      route { theta <= 50 ==> { can_approx = 1 } _ ==> {} }

      println("1. Criterio de abertura MAC de Barnes-Hut aprovado: " + can_approx)
      println("2. Barnes-Hut Octree Algorithm concluido com sucesso.")
}
