#L ============================================================================
#L Algoritmo: UCB1 (Upper Confidence Bound para Multi-Armed Bandits)
#L Dominio: 08_artificial_intel / Subdominio: Aprendizado por Reforco
#L Descricao: Equacionamento do dilema exploracao-exploracao via limite superior de confianca
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningMultiArmedBanditUCB) {
      println("=== Algoritmo: UCB1 Multi-Armed Bandit ===")

      #L Total de rodadas t = 100
      #L Braco 1: recompensa media Q1 = 70, puxado N1 = 50 vezes
      #L Braco 2: recompensa media Q2 = 60, puxado N2 = 10 vezes (pouco explorado)
      mut as int64: q1 = 70
      mut as int64: n1 = 50

      mut as int64: q2 = 60
      mut as int64: n2 = 10

      #L Termo de exploracao proporcional a sqrt(2 * ln(t) / N):
      #L Para Braco 1 (muito explorado, incerteza baixa): bonus U1 = 8
      #L Para Braco 2 (pouco explorado, incerteza alta):  bonus U2 = 25
      mut as int64: u1 = 8
      mut as int64: u2 = 25

      #L Pontuacao UCB total = Q + U
      mut as int64: score_ucb1 = q1 + u1
      mut as int64: score_ucb2 = q2 + u2

      println("1. Score UCB Braco 1 (70 + 8): " + score_ucb1)
      println("2. Score UCB Braco 2 (60 + 25): " + score_ucb2)

      #L O algoritmo escolhe o braco com maior score UCB
      mut as int64: braco_escolhido = 1
      route {
            score_ucb2 > score_ucb1 ==> {
                  braco_escolhido = 2
            }
            _ ==> {}
      }

      println("3. Braco selecionado para rodada t=101: Braco " + braco_escolhido)

      route {
            braco_escolhido == 2 and score_ucb2 == 85 ==> {
                  println("4. Politica UCB1 incentivou corretamente exploracao do braco incerto.")
            }
            _ ==> {
                  println("Falha na decisao UCB1.")
            }
      }
      println("Teste concluido com sucesso.")
}
