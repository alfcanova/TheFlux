#L ============================================================================
#L Algoritmo: Photon Mapping
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaPhotonMapping) {
      println("==================================================")
      println("  SciAlgo: Photon Mapping")
      println("==================================================")

      mut as list of int64: dists_sq = [4, 9, 16, 25, 36]
      mut as int64: max_r_sq = 16
      mut as int64: gathered_photons = 0
      mut as int64: n = listLength(dists_sq)
      mut as int64: i = 1
      infinite (i <= n) {
            route {
                  dists_sq[i] <= max_r_sq ==> { gathered_photons = gathered_photons + 1 }
                  _ ==> {}
      }
            i = i + 1
      }

      println("1. Fotons coletados na esfera de raio R: " + gathered_photons)
      println("2. Photon Mapping concluido com sucesso.")
}
