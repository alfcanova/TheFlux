#L ============================================================================
#L Algoritmo: Painter's Algorithm
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaPaintersAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Painter's Algorithm")
      println("==================================================")

      mut as list of int64: depths = [50, 10, 90, 30, 70]
      mut as int64: n = listLength(depths)
      mut as int64: deepest = depths[1]
      mut as int64: i = 2
      infinite (i <= n) {
            route {
                  depths[i] > deepest ==> { deepest = depths[i] }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Poligono mais distante ordenado (Z-far): " + deepest)
      println("2. Painter's Algorithm concluido com sucesso.")
}
