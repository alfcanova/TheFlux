#L ============================================================================
#L Algoritmo: Molecular Dynamics (Lennard-Jones)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaMolecularDynamics) {
      println("==================================================")
      println("  SciAlgo: Molecular Dynamics (Lennard-Jones)")
      println("==================================================")

      mut as int64: r = 10
      mut as int64: inv_r = 100 /i r
      mut as int64: lj_force = inv_r * inv_r

      println("1. Forca intermolecular de Lennard-Jones LJ: " + lj_force)
      println("2. Molecular Dynamics (Lennard-Jones) concluido com sucesso.")
}
