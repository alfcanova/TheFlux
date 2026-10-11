#L ============================================================================
#L Algoritmo: Fast Marching Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosFastMarchingMethod) {
      println("==================================================")
      println("  SciAlgo: Fast Marching Method")
      println("==================================================")

      mut as int64: t_prev = 10
      mut as int64: cost = 5
      mut as int64: t_arrival = t_prev + cost

      println("1. Tempo de chegada da frente de onda FMM: " + t_arrival)
      println("2. Fast Marching Method concluido com sucesso.")
}
