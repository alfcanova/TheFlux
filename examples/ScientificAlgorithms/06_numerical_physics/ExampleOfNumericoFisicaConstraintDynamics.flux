#L ============================================================================
#L Algoritmo: Lagrangian Constraint Dynamics
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaConstraintDynamics) {
      println("==================================================")
      println("  SciAlgo: Lagrangian Constraint Dynamics")
      println("==================================================")

      mut as int64: lambda_mult = 5
      mut as int64: jacobian = 12
      mut as int64: constraint_force = lambda_mult * jacobian

      println("1. Forca de restricao de vinculo holonomo calculada: " + constraint_force)
      println("2. Lagrangian Constraint Dynamics concluido com sucesso.")
}
