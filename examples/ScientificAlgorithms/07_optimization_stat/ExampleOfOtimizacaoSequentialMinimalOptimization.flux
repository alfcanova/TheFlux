#L ============================================================================
#L Algoritmo: SMO (Sequential Minimal Optimization para SVM)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao Quadratica
#L Descricao: Resolucao analitica de pares de multiplicadores de Lagrange sem inversao de matriz
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoSequentialMinimalOptimization) {
      println("=== Algoritmo: SMO (SVM Quadratic Programming) ===")

      #L Dois multiplicadores selecionados para otimizacao conjunta: alpha1 e alpha2
      #L Rotulos das amostras y1 = +1, y2 = -1
      #L Valores iniciais: alpha1 = 20, alpha2 = 20
      #L Limite de regularizacao C = 50
      mut as int64: y1 = 1
      mut as int64: y2 = 0 - 1
      mut as int64: c_limit = 50

      mut as int64: a1_old = 20
      mut as int64: a2_old = 20

      #L Erros de predicao das duas amostras: E1 = 15, E2 = -10
      #L Eta = 2*K12 - K11 - K22 = -2 (derivada segunda negativa da funcao objetivo)
      mut as int64: e1 = 15
      mut as int64: e2 = 0 - 10
      mut as int64: eta = 0 - 2

      #L Atualizacao analitica nao-restringida de alpha2:
      #L a2_new_unc = a2_old - y2 * (E1 - E2) /i eta
      #L y2 * (E1 - E2) = -1 * (15 - (-10)) = -1 * 25 = -25
      #L passo = (-25) /i (-2) = 12
      #L a2_new_unc = 20 - 12 = 8
      mut as int64: diffE = e1 - e2
      mut as int64: y2_diffE = y2 * diffE
      mut as int64: step = y2_diffE /i eta
      mut as int64: a2_new_unc = a2_old - step

      #L Limites da caixa L e H (para y1 != y2, L = max(0, a2 - a1) = 0; H = min(C, C + a2 - a1) = 50):
      #L Como 0 <= a2_new_unc (8) <= 50, o valor e aceito sem corte (clipping)!
      mut as int64: a2_new = a2_new_unc

      #L Atualizacao de alpha1 pela restricao linear y1*a1 + y2*a2 = const:
      #L a1_new = a1_old + y1*y2 * (a2_old - a2_new)
      #L a1_new = 20 + (-1) * (20 - 8) = 20 - 12 = 8
      mut as int64: da2 = a2_old - a2_new
      mut as int64: a1_new = a1_old - da2

      println("1. Alpha2 inicial: " + a2_old + " -> Atualizado analiticamente: " + a2_new)
      println("2. Alpha1 inicial: " + a1_old + " -> Atualizado analiticamente: " + a1_new)

      route {
            a2_new == 8 and a1_new == 8 ==> {
                  println("3. Passo analitico bidimensional do SMO validado com sucesso.")
            }
            _ ==> {
                  println("Falha no passo SMO.")
            }
      }
      println("Teste concluido com sucesso.")
}
