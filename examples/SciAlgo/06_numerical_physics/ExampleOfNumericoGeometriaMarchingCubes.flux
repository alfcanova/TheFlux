#L ============================================================================
#L Algoritmo: Marching Cubes Isosurface
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaMarchingCubes) {
      println("==================================================")
      println("  SciAlgo: Marching Cubes Isosurface")
      println("==================================================")

      mut as list of int64: corners = [10, 5, 20, 15, 0, 25, 12, 30]
      mut as int64: iso = 10
      mut as int64: cube_index = 0
      mut as int64: power = 1
      mut as int64: i = 1
      infinite (i <= 8) {
            route { corners[i] > iso ==> { cube_index = cube_index + power } _ ==> {} }
            power = power * 2
            i = i + 1
      }

      println("1. Indice de configuracao da tabela Marching Cubes: " + cube_index)
      println("2. Marching Cubes Isosurface concluido com sucesso.")
}
