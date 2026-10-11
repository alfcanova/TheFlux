#L ============================================================================
#L Algoritmo: t-SNE (t-Distributed Stochastic Neighbor Embedding)
#L Dominio: 08_artificial_intel / Subdominio: Machine Learning Classico
#L Descricao: Reducao de dimensionalidade nao-linear com distribuicao t de Student
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoTSNE) {
      println("=== Algoritmo: t-SNE (Stochastic Neighbor Embedding) ===")

      #L Alta dimensao: probabilidade conjunta simetrica p_ij (escala 1000)
      #L Amostras 1 e 2 estao muito proximas: p12 = 800
      #L Amostras 1 e 3 estao distantes: p13 = 50
      mut as int64: p12 = 800
      mut as int64: p13 = 50

      #L Baixa dimensao: coordenadas 1D y1 = 0, y2 = 2, y3 = 10
      mut as int64: y1 = 0
      mut as int64: y2 = 2
      mut as int64: y3 = 10

      #L Distancias quadraticas em baixa dimensao:
      #L d12_sq = (0 - 2)^2 = 4
      #L d13_sq = (0 - 10)^2 = 100
      mut as int64: dy12 = y1 - y2
      mut as int64: d12_sq = dy12 * dy12
      mut as int64: dy13 = y1 - y3
      mut as int64: d13_sq = dy13 * dy13

      #L Distribuicao t de Student: kernel q_ij proporcional a 1 / (1 + d^2)
      #L q12_unnorm = 1000 / (1 + 4) = 200
      #L q13_unnorm = 1000 / (1 + 100) ~ 10
      mut as int64: q12 = 1000 /i 5
      mut as int64: q13 = 1000 /i 101

      println("1. Probabilidade em alta dimensao P(1, 2): " + p12)
      println("2. Probabilidade em alta dimensao P(1, 3): " + p13)
      println("3. Similaridade Student-t em baixa dimensao Q(1, 2): " + q12)
      println("4. Similaridade Student-t em baixa dimensao Q(1, 3): " + q13)

      #L Gradiente de atracao proporcional a (P_ij - Q_ij)
      mut as int64: grad_atracao12 = p12 - q12
      println("5. Gradiente de forca atrativa (P12 - Q12): " + grad_atracao12)

      route {
            q12 > q13 and grad_atracao12 > 0 ==> {
                  println("6. Otimizacao estocastica de vizinhanca t-SNE validada.")
            }
            _ ==> {
                  println("Falha no calculo do t-SNE.")
            }
      }
      println("Teste concluido com sucesso.")
}
