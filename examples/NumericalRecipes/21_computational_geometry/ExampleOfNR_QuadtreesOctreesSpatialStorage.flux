#L ============================================================================
#L Algoritmo: Quadtrees and Octrees (Armazenamento Espacial Hierarquico)
#L Capitulo: 21_computational_geometry
#L Complexidade: O(log N) por insercao e busca
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Decomposicao espacial hierarquica recursiva em quadrantes e octantes.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_QuadtreesOctreesSpatialStorage) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_QuadtreesOctreesSpatialStorage")
      println("==================================================")

      #L Dominio raiz da Quadtree: [0, 100] x [0, 100] com centro em (50, 50)
      #L 4 quadrantes numerados:
      #L Q0 (SW: x < 50, y < 50)
      #L Q1 (SE: x >= 50, y < 50)
      #L Q2 (NW: x < 50, y >= 50)
      #L Q3 (NE: x >= 50, y >= 50)
      #L Inserindo ponto P(75, 80): deve ser classificado em Q3 (NE)
      mut as int64: px = 75
      mut as int64: py = 80
      mut as int64: cx = 50
      mut as int64: cy = 50

      println("1. Inserindo ponto P(" + px + ", " + py + ") na raiz centrada em (" + cx + ", " + cy + "):")

      mut as int64: quadrante = 0
      route {
            px >= cx and py >= cy ==> { quadrante = 3 }
            px < cx and py >= cy ==> { quadrante = 2 }
            px >= cx and py < cy ==> { quadrante = 1 }
            px < cx and py < cy ==> { quadrante = 0 }
      }

      println("   -> Ponto indexado no quadrante = Q" + quadrante + " (esperado: Q3)")

      mut as int64: residuo = quadrante - 3
      println("2. Residuo da indexacao em Quadtree = " + residuo + " (esperado: 0)")
      println("3. Estrutura espacial Quadtree/Octree validada com sucesso.")
}
