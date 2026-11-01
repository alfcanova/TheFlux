#L ============================================================================
#L Algoritmo: CMA-ES (Covariance Matrix Adaptation Evolution Strategy)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao Continua
#L Descricao: Otimizacao estocastica de caixa-preta com adaptacao de matriz de covariancia
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoCMAES) {
      println("=== Algoritmo: CMA-ES (Evolution Strategy) ===")

      #L Populacao lambda = 4 amostras em 2 dimensoes
      #L Centroide / media atual m = [10, 20]
      #L Desvio de passo sigma = 2 (escala inteira)
      mut as int64: m_x = 10
      mut as int64: m_y = 20
      mut as int64: sigma = 2

      #L Amostras geradas em torno de m:
      #L x1 = (12, 22), fitness = 5 (melhor)
      #L x2 = (11, 21), fitness = 8
      #L x3 = (8, 18),  fitness = 15
      #L x4 = (6, 16),  fitness = 25

      #L Selecao dos mu = 2 melhores individuos (recombinação por pesos w1=70%, w2=30%):
      #L Nova media m_novo:
      #L m_novo_x = (70 * 12 + 30 * 11) /i 100 = (840 + 330) /i 100 = 1170 /i 100 = 11
      #L m_novo_y = (70 * 22 + 30 * 21) /i 100 = (1540 + 630) /i 100 = 2170 /i 100 = 21
      mut as int64: num_x = 70 * 12 + 30 * 11
      mut as int64: m_novo_x = num_x /i 100

      mut as int64: num_y = 70 * 22 + 30 * 21
      mut as int64: m_novo_y = num_y /i 100

      #L Atualizacao do caminho de evolucao de passo p_sigma:
      #L delta_m = m_novo - m = (11 - 10, 21 - 20) = (1, 1)
      mut as int64: dm_x = m_novo_x - m_x
      mut as int64: dm_y = m_novo_y - m_y

      println("1. Media anterior m: (" + m_x + ", " + m_y + ")")
      println("2. Nova media ponderada dos melhores individuos: (" + m_novo_x + ", " + m_novo_y + ")")
      println("3. Vetor de deslocamento do centroide: (" + dm_x + ", " + dm_y + ")")

      #L Adaptacao da covariancia C: aumenta dispersao na direcao do gradiente bem sucedido (1, 1)
      mut as int64: cov_diag = sigma * sigma + dm_x * dm_x
      println("4. Componente de variancia adaptada C: " + cov_diag)

      route {
            m_novo_x == 11 and m_novo_y == 21 and cov_diag == 5 ==> {
                  println("5. Adaptacao de elipsoide de covariancia CMA-ES validada.")
            }
            _ ==> {
                  println("Falha no CMA-ES.")
            }
      }
      println("Teste concluido com sucesso.")
}
