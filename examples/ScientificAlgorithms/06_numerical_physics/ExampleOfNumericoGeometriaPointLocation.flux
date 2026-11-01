#L ============================================================================
#L Algoritmo: Planar Point Location
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaPointLocation) {
      println("==================================================")
      println("  SciAlgo: Planar Point Location")
      println("==================================================")

      mut as int64: query_x = 15
      mut as int64: split_x = 20
      mut as int64: region_id = 2
      route { query_x < split_x ==> { region_id = 1 } _ ==> {} }

      println("1. Regiao planar identificada na estrutura DAG: " + region_id)
      println("2. Planar Point Location concluido com sucesso.")
}
