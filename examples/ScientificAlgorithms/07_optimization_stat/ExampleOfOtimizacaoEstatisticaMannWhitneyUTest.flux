#L ============================================================================
#L Algoritmo: Mann-Whitney U Test (Wilcoxon Rank-Sum)
#L Dominio: 07_optimization_stat / Categoria: Estatistica Nao-Parametrica
#L Descricao: Teste de diferenca de medianas para duas amostras independentes via soma de postos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaMannWhitneyUTest) {
      println("=== Algoritmo: Mann-Whitney U Test ===")

      #L Duas amostras de tamanho n1 = 3 e n2 = 3:
      #L Grupo 1: [2, 4, 7]
      #L Grupo 2: [1, 3, 5]
      #L Amostras combinadas e ordenadas conjuntamente com seus postos (ranks 1 a 6):
      #L 1 (Grupo 2, posto 1)
      #L 2 (Grupo 1, posto 2)
      #L 3 (Grupo 2, posto 3)
      #L 4 (Grupo 1, posto 4)
      #L 5 (Grupo 2, posto 5)
      #L 7 (Grupo 1, posto 6)
      mut as int64: n1 = 3
      mut as int64: n2 = 3

      #L Soma dos postos do Grupo 1: R1 = 2 + 4 + 6 = 12
      #L Soma dos postos do Grupo 2: R2 = 1 + 3 + 5 = 9
      mut as int64: r1 = 2 + 4 + 6
      mut as int64: r2 = 1 + 3 + 5

      #L Calculo da estatistica U1 = R1 - n1*(n1 + 1)/2:
      #L n1 * (n1 + 1) /i 2 = 3 * 4 /i 2 = 6
      #L U1 = 12 - 6 = 6
      mut as int64: correction1 = (n1 * (n1 + 1)) /i 2
      mut as int64: u1 = r1 - correction1

      #L Calculo da estatistica U2 = n1 * n2 - U1 = 3 * 3 - 6 = 9 - 6 = 3
      mut as int64: prod_n = n1 * n2
      mut as int64: u2 = prod_n - u1

      #L Estatistica do teste U = min(U1, U2) = min(6, 3) = 3
      mut as int64: u_stat = u1
      route {
            u2 < u1 ==> {
                  u_stat = u2
            }
            _ ==> {}
      }

      println("1. Soma de postos do Grupo 1 (R1): " + r1)
      println("2. Soma de postos do Grupo 2 (R2): " + r2)
      println("3. Estatistica U1 calculada: " + u1)
      println("4. Estatistica U2 calculada: " + u2)
      println("5. Estatistica final U de Mann-Whitney (min): " + u_stat)

      route {
            r1 == 12 and r2 == 9 and u1 == 6 and u2 == 3 and u_stat == 3 ==> {
                  println("6. Teste de postos de Mann-Whitney validado com precisao.")
            }
            _ ==> {
                  println("Falha no teste Mann-Whitney.")
            }
      }
      println("Teste concluido com sucesso.")
}
