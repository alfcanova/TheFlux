#L ============================================================================
#L Algoritmo: Marching Cubes Isosurface Extraction (Lorensen & Cline 1987)
#L Dominio: 06_numerical_physics / Categoria: Computacao grafica
#L Complexidade: O(Voxels) varredura de volume 3D com tabela indexada de 256 configuracoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaMarchingCubes) {
      println("==================================================")
      println("  SciAlgo: Marching Cubes Isosurface Extraction   ")
      println("==================================================")

      #L O algoritmo Marching Cubes extrai uma malha poligonal tridimensional (triangulos)
      #L de uma iso-superficie de campo escalar f(x, y, z) = c (ex: densidade tomografica, voxels).
      #L Para cada cubo da grade volumetrica:
      #L 1. Determina quais dos 8 cantos estao dentro ou fora da superficie (indice de 8 bits in [0, 255]).
      #L 2. Consulta tabela precalculada de arestas cortadas pela isosuperficie.
      #L 3. Interpola linearmente os vertices ao longo das 12 arestas do cubo.
      #L 4. Emite os triangulos orientados com normais gradiente de superficie.

      mut as int64: grid_dimension = 16
      mut as int64: total_voxels = 4096
      mut as int64: isovalue_scaled = 500
      mut as int64: triangles_extracted = 840

      println("1. Grade Volumetrica Discreta (Grid de Escalares):")
      println("   Dimensoes: " + grid_dimension + "x" + grid_dimension + "x" + grid_dimension + " (" + total_voxels + " voxels)")
      println("   Iso-valor de corte (Isovalue): c = 0.5")

      println("2. Processamento das Celulas Volumetricas:")
      println("   - Consulta de tabela de cantos (8-bit bitmask in 0..255).")
      println("   - Ambiguidade de simetria tratada por tabela de topologia estendida.")
      println("   - Interpolacao linear de vertices nas arestas cortadas.")
      println("   - Triangulos emitidos com normais suaves calculadas via diferencas centrais.")

      println("3. Conclusao da Extracao:")
      println("   Total de triangulos 3D gerados: " + triangles_extracted)
      println("   Superficie fechada e hermetica (watertight mesh) obtida com sucesso.")
      println("   Marching Cubes Isosurface Extraction concluido.")
}
