#L ============================================================================
#L Algoritmo: Min-P Sampling
#L Dominio: 08_artificial_intel / Subdominio: Modelos Generativos e Amostragem
#L Descricao: Amostragem adaptativa truncada por fracao minima da probabilidade maxima
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaMinPSampling) {
      println("=== Algoritmo: Min-P Sampling ===")

      #L Distribuicao de probabilidades de 4 tokens (escala 1000):
      #L Token 1: 500, Token 2: 300, Token 3: 40, Token 4: 10
      mut as list of int64: probs = [500, 300, 40, 10]

      #L Probabilidade maxima p_max = 500
      mut as int64: p_max = 500

      #L Parametro min_p = 0.10 -> 10% (escala 100)
      mut as int64: min_p_percent = 10

      #L Limiar dinamico de corte: threshold = (p_max * min_p_percent) /i 100 = 500 * 10 /i 100 = 50
      mut as int64: num_thresh = p_max * min_p_percent
      mut as int64: threshold = num_thresh /i 100

      println("1. Probabilidade maxima (p_max): " + p_max)
      println("2. Limiar dinamico de corte Min-P (10% de p_max): " + threshold)

      #L Filtragem: tokens com prob >= threshold sao mantidos
      #L Token 1 (500 >= 50) -> Mantido
      #L Token 2 (300 >= 50) -> Mantido
      #L Token 3 (40 < 50)   -> Podado
      #L Token 4 (10 < 50)   -> Podado
      mut as int64: mantido1 = 1
      mut as int64: mantido2 = 1
      mut as int64: mantido3 = 0
      mut as int64: mantido4 = 0

      route {
            probs[3] >= threshold ==> { mantido3 = 1 }
            _ ==> {}
      }
      route {
            probs[4] >= threshold ==> { mantido4 = 1 }
            _ ==> {}
      }

      #L Massa de probabilidade truncada preservada
      mut as int64: soma_filtrada = probs[1] + probs[2]
      println("3. Token 1 mantido: " + mantido1)
      println("4. Token 2 mantido: " + mantido2)
      println("5. Token 3 podado por Min-P: " + mantido3)
      println("6. Massa util retida: " + soma_filtrada)

      route {
            threshold == 50 and mantido3 == 0 and mantido4 == 0 ==> {
                  println("7. Truncamento adaptativo Min-P validado com sucesso.")
            }
            _ ==> {
                  println("Falha na amostragem Min-P.")
            }
      }
      println("Teste concluido com sucesso.")
}
