#L ============================================================================
#L Algoritmo: Sweep Line Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaSweepLine) {
      println("==================================================")
      println("  SciAlgo: Sweep Line Algorithm")
      println("==================================================")

      mut as list of int64: evs = [10, 20, 30, 40, 50]
      mut as int64: sweep_x = 25
      mut as int64: active_count = 0
      mut as int64: n = listLength(evs)
      mut as int64: i = 1
      infinite (i <= n) {
            route { evs[i] <= sweep_x ==> { active_count = active_count + 1 } _ ==> {} }
            i = i + 1
      }

      println("1. Segmentos ativos cruzados pela linha de varredura: " + active_count)
      println("2. Sweep Line Algorithm concluido com sucesso.")
}
