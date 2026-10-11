#L ============================================================================
#L Algoritmo: Ray Casting
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaRayCasting) {
      println("==================================================")
      println("  SciAlgo: Ray Casting")
      println("==================================================")

      mut as int64: ray_dist_sq = 16
      mut as int64: radius_sq = 25
      mut as int64: hit = 0
      route {
            ray_dist_sq <= radius_sq ==> { hit = 1 }
            _ ==> {}
      }

      println("1. Intersecao raio-esfera detectada: " + hit)
      println("2. Ray Casting concluido com sucesso.")
}
