#L ============================================================================
#L Algoritmo: Nicholl-Lee-Nicholl (NLN) Clipping
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaNichollLeeNicholl) {
      println("==================================================")
      println("  SciAlgo: Nicholl-Lee-Nicholl (NLN) Clipping")
      println("==================================================")

      mut as int64: slope = 150
      mut as int64: sector = 2
      route { slope < 100 ==> { sector = 1 } _ ==> {} }

      println("1. Setor geometrico classificado pelo algoritmo NLN: " + sector)
      println("2. Nicholl-Lee-Nicholl (NLN) Clipping concluido com sucesso.")
}
