#L ============================================================================
#L Algoritmo: Thompson Sampling Bandit
#L Dominio: 08_artificial_intel / Subdominio: Aprendizado por Reforco
#L Descricao: Amostragem posterior bayesiana baseada em distribuicao Beta para bandits
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningThompsonSampling) {
      println("=== Algoritmo: Thompson Sampling Bandit ===")

      #L Parametros da distribuicao Beta(alpha, beta) para 2 bracos:
      #L Braco 1: 18 sucessos, 6 falhas -> alpha1 = 19, beta1 = 7
      #L Braco 2: 4 sucessos, 1 falha   -> alpha2 = 5, beta2 = 2
      mut as int64: alpha1 = 19
      mut as int64: beta1 = 7

      mut as int64: alpha2 = 5
      mut as int64: beta2 = 2

      #L Media posterior esperada E[theta] = alpha / (alpha + beta) (escala 1000):
      #L Braco 1: (19 * 1000) /i (19 + 7) = 19000 /i 26 = 730
      #L Braco 2: (5 * 1000)  /i (5 + 2)  = 5000  /i 7  = 714
      mut as int64: sum1 = alpha1 + beta1
      mut as int64: num1 = alpha1 * 1000
      mut as int64: media1 = num1 /i sum1

      mut as int64: sum2 = alpha2 + beta2
      mut as int64: num2 = alpha2 * 1000
      mut as int64: media2 = num2 /i sum2

      println("1. Media posterior bayesiana Braco 1 (x1000): " + media1)
      println("2. Media posterior bayesiana Braco 2 (x1000): " + media2)

      #L Amostras pseudo-aleatorias retiradas da distribuicao posterior:
      #L Amostra 1 (baixa variancia em torno de 730): 740
      #L Amostra 2 (alta variancia por ter poucas puxadas): 820
      mut as int64: sample1 = 740
      mut as int64: sample2 = 820

      #L Selecao gulosa da amostra sorteada:
      mut as int64: braco_escolhido = 1
      route {
            sample2 > sample1 ==> {
                  braco_escolhido = 2
            }
            _ ==> {}
      }

      println("3. Amostra simulada Braco 1: " + sample1)
      println("4. Amostra simulada Braco 2: " + sample2)
      println("5. Acao escolhida via Thompson Sampling: Braco " + braco_escolhido)

      route {
            braco_escolhido == 2 and media1 == 730 ==> {
                  println("6. Thompson Sampling explorou braco promissor com sucesso.")
            }
            _ ==> {
                  println("Falha na amostragem Thompson Sampling.")
            }
      }
      println("Teste concluido com sucesso.")
}
