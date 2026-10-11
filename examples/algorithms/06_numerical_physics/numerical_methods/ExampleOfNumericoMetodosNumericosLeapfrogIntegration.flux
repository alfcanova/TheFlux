#L ============================================================================
#L Algoritmo: Leapfrog Integration
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosLeapfrogIntegration) {
      println("==================================================")
      println("  SciAlgo: Leapfrog Integration")
      println("==================================================")

      mut as int64: pos = 50
      mut as int64: v_half = 10
      mut as int64: a = -2
      mut as int64: dt = 2
      mut as int64: v_next_half = v_half + a * dt
      mut as int64: pos_next = pos + v_next_half * dt

      println("1. Posicao atualizada por salto Leapfrog: " + pos_next)
      println("2. Leapfrog Integration concluido com sucesso.")
}
