#L ============================================================================
#L Algoritmo: OPTICS (Ordering Points To Identify the Clustering Structure)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoOPTICS) {
      println("=== Algoritmo: OPTICS Clustering ===")
      mut as int64: coreDist = 8
      mut as int64: euclideanDist = 12
      mut as int64: reachabilityDist = euclideanDist
      route {
            coreDist > euclideanDist ==> { reachabilityDist = coreDist }
            _ ==> {}
      }
      println("1. Distancia de alcance (reachability): " + reachabilityDist)
      println("Teste concluido com sucesso.")
}
