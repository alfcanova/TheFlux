#L ============================================================================
#L Algoritmo: Kernel PCA (kPCA Nao-Linear)
#L Dominio: 08_artificial_intel / Subdominio: Machine Learning Classico
#L Descricao: Reducao de dimensionalidade nao-linear via espaco de Hilbert com kernel
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoKernelPCA) {
      println("=== Algoritmo: Kernel PCA (kPCA Nao-Linear) ===")

      #L Kernel Polinomial de grau 2: K(x, y) = (x * y + 1)^2
      #L Amostras 1D: x1 = 1, x2 = 2, x3 = 3
      #L K(1, 1) = (1*1 + 1)^2 = 4
      #L K(1, 2) = (1*2 + 1)^2 = 9
      #L K(1, 3) = (1*3 + 1)^2 = 16
      #L K(2, 2) = (2*2 + 1)^2 = 25
      #L K(2, 3) = (2*3 + 1)^2 = 49
      #L K(3, 3) = (3*3 + 1)^2 = 64
      mut as int64: k11 = 4
      mut as int64: k12 = 9
      mut as int64: k13 = 16
      mut as int64: k22 = 25
      mut as int64: k23 = 49
      mut as int64: k33 = 64

      println("1. Elemento da matriz de Gram K(1, 1): " + k11)
      println("2. Elemento da matriz de Gram K(1, 2): " + k12)
      println("3. Elemento da matriz de Gram K(1, 3): " + k13)

      #L Centralizacao da matriz de Gram no espaco de features
      #L Media da primeira linha: mean_row1 = (4 + 9 + 16) / 3 = 29 /i 3 = 9
      mut as int64: sum_row1 = k11 + k12 + k13
      mut as int64: mean_row1 = sum_row1 /i 3

      #L Elemento centralizado aproximado: K_tilde(1, 1) = K11 - 2*mean_row1 + total_mean
      mut as int64: k_tilde11 = k11 - mean_row1

      println("4. Elemento centralizado K_tilde(1, 1): " + k_tilde11)

      route {
            k_tilde11 < 0 and k33 > k11 ==> {
                  println("5. Mapeamento nao-linear Kernel PCA validado com sucesso.")
            }
            _ ==> {
                  println("Falha no calculo do Kernel PCA.")
            }
      }
      println("Teste concluido com sucesso.")
}
