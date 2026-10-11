#L ============================================================================
#L Algoritmo: BIRCH (Balanced Iterative Reducing and Clustering using Hierarchies)
#L Dominio: 08_artificial_intel / Subdominio: Machine Learning Classico
#L Descricao: Clustering com Clustering Feature (CF) vector (N, LS, SS)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoBirch) {
      println("=== Algoritmo: BIRCH Clustering (CF-Tree) ===")

      #L Clustering Feature CF = (N, LS_x, LS_y, SS)
      #L Insercao de pontos no cluster 1: (2, 4) e (4, 6)
      mut as int64: n = 2
      mut as int64: ls_x = 2 + 4
      mut as int64: ls_y = 4 + 6
      mut as int64: ss = 2 * 2 + 4 * 4 + 4 * 4 + 6 * 6

      #L Calculo do centroide: (LS / N)
      mut as int64: centroid_x = ls_x /i n
      mut as int64: centroid_y = ls_y /i n

      println("1. Numero de pontos (N): " + n)
      println("2. Linear Sum X (LS_X): " + ls_x)
      println("3. Linear Sum Y (LS_Y): " + ls_y)
      println("4. Square Sum (SS): " + ss)
      println("5. Centroide calculado: (" + centroid_x + ", " + centroid_y + ")")

      #L Insercao incremental de um novo ponto (6, 8)
      n = n + 1
      ls_x = ls_x + 6
      ls_y = ls_y + 8
      ss = ss + 6 * 6 + 8 * 8
      mut as int64: novo_centroid_x = ls_x /i n
      mut as int64: novo_centroid_y = ls_y /i n

      println("6. Centroide apos insercao incremental: (" + novo_centroid_x + ", " + novo_centroid_y + ")")

      route {
            novo_centroid_x == 4 and novo_centroid_y == 6 ==> {
                  println("7. Atualizacao CF de BIRCH validada com sucesso.")
            }
            _ ==> {
                  println("Falha na computacao BIRCH.")
            }
      }
      println("Teste concluido com sucesso.")
}
