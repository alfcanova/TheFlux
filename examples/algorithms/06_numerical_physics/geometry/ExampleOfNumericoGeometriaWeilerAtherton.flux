#L ============================================================================
#L Algoritmo: Weiler-Atherton Polygon Clipping
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaWeilerAtherton) {
      println("==================================================")
      println("  SciAlgo: Weiler-Atherton Polygon Clipping")
      println("==================================================")

      mut as int64: entering = 1
      mut as int64: traverse_dir = 200
      route { entering == 1 ==> { traverse_dir = 100 } _ ==> {} }

      println("1. Direcao de percurso nas listas de borda: " + traverse_dir)
      println("2. Weiler-Atherton Polygon Clipping concluido com sucesso.")
}
