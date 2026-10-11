#L ============================================================================
#L Algoritmo: Prioritized Experience Replay (PER)
#L Dominio: 08_artificial_intel / Subdominio: Aprendizado por Reforco
#L Descricao: Amostragem de transicoes no buffer de replay ponderada pelo erro temporal TD
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAReinforcementLearningPrioritizedReplay) {
      println("=== Algoritmo: Prioritized Experience Replay (PER) ===")

      #L Erros de diferenca temporal (TD-error) absolutos de 3 transicoes no buffer:
      #L Transicao 1: |delta_1| = 80 (transicao surpreendente, alto aprendizado)
      #L Transicao 2: |delta_2| = 20
      #L Transicao 3: |delta_3| = 5  (transicao previsivel)
      mut as int64: delta1 = 80
      mut as int64: delta2 = 20
      mut as int64: delta3 = 5

      #L Prioridades com epsilon = 1: p_i = |delta_i| + 1
      mut as int64: p1 = delta1 + 1
      mut as int64: p2 = delta2 + 1
      mut as int64: p3 = delta3 + 1

      #L Soma das prioridades: 81 + 21 + 6 = 108
      mut as int64: sum_p = p1 + p2 + p3

      #L Probabilidade de amostragem proporcional (escala 1000):
      #L P1 = (81 * 1000) /i 108 = 750 (75.0%)
      #L P2 = (21 * 1000) /i 108 = 194 (19.4%)
      #L P3 = (6 * 1000)  /i 108 = 55  (5.5%)
      mut as int64: num_p1 = p1 * 1000
      mut as int64: prob1 = num_p1 /i sum_p
      mut as int64: num_p2 = p2 * 1000
      mut as int64: prob2 = num_p2 /i sum_p
      mut as int64: num_p3 = p3 * 1000
      mut as int64: prob3 = num_p3 /i sum_p

      println("1. Prioridade transicao 1: " + p1)
      println("2. Prioridade transicao 2: " + p2)
      println("3. Prioridade transicao 3: " + p3)
      println("4. Probabilidade relativa P1 (x1000): " + prob1)
      println("5. Probabilidade relativa P2 (x1000): " + prob2)
      println("6. Probabilidade relativa P3 (x1000): " + prob3)

      #L Amostragem preferencial da transicao com maior surpresa
      route {
            prob1 > prob2 and prob2 > prob3 ==> {
                  println("7. Amostragem PER favorece corretamente transicoes com maior TD-error.")
            }
            _ ==> {
                  println("Falha na priorizacao do buffer de replay.")
            }
      }
      println("Teste concluido com sucesso.")
}
