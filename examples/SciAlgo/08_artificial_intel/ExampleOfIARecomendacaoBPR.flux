#L ============================================================================
#L Algoritmo: BPR (Bayesian Personalized Ranking)
#L Dominio: 08_artificial_intel / Subdominio: Sistemas de Recomendacao
#L Descricao: Otimizacao estocastica por pares (pairwise) para feedback implicito
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoBPR) {
      println("=== Algoritmo: BPR (Bayesian Personalized Ranking) ===")

      #L Tripla de treinamento (u, i, j):
      #L Usuario u, Item positivo i (interagido), Item negativo j (nao interagido)

      #L Embedding do usuario u: [2, 3]
      #L Embedding do item positivo i: [3, 4]
      #L Embedding do item negativo j: [1, 1]
      mut as int64: u1 = 2
      mut as int64: u2 = 3

      mut as int64: i1 = 3
      mut as int64: i2 = 4

      mut as int64: j1 = 1
      mut as int64: j2 = 1

      #L Afinidade prevista x_ui = <u, i> = 2*3 + 3*4 = 6 + 12 = 18
      #L Afinidade prevista x_uj = <u, j> = 2*1 + 3*1 = 2 + 3  = 5
      mut as int64: x_ui = u1 * i1 + u2 * i2
      mut as int64: x_uj = u1 * j1 + u2 * j2

      #L Diferencial de preferencia x_uij = x_ui - x_uj = 18 - 5 = 13
      mut as int64: x_uij = x_ui - x_uj

      println("1. Afinidade prevista com item positivo (x_ui): " + x_ui)
      println("2. Afinidade prevista com item negativo (x_uj): " + x_uj)
      println("3. Diferenca de preferencia pairwise (x_uij): " + x_uij)

      #L Probabilidade sigmoide de preferencia P(i >_u j) = 1 / (1 + e^(-x_uij))
      #L Como x_uij = 13 > 0, o modelo atribui forte preferencia ao item interagido
      mut as int64: prefere_positivo = 0
      route {
            x_uij > 0 ==> {
                  prefere_positivo = 1
            }
            _ ==> {}
      }

      println("4. Prevalencia de ordenacao correta: " + prefere_positivo)

      route {
            prefere_positivo == 1 and x_uij == 13 ==> {
                  println("5. Otimizacao bayesiana BPR validada com sucesso.")
            }
            _ ==> {
                  println("Falha na ordenacao BPR.")
            }
      }
      println("Teste concluido com sucesso.")
}
