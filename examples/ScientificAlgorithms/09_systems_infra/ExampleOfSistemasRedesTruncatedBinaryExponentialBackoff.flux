#L ============================================================================
#L Algoritmo: Truncated Binary Exponential Backoff (TBEB - IEEE 802.3)
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(C) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesTruncatedBinaryExponentialBackoff) {
      println("==================================================")
      println("  SciAlgo: Truncated Binary Exponential Backoff   ")
      println("==================================================")

      #L Regras Formais do Padrao IEEE 802.3 Ethernet:
      #L 1. Para colisoes c = 1..10: k aleatorio em [0, 2^c - 1]
      #L 2. Para colisoes c = 11..15: truncado em [0, 2^10 - 1] = [0, 1023]
      #L 3. Na 16a colisao: aborta transmissao (Excessive Collision Error)
      mut as int64: max_exponent = 10
      mut as int64: max_collisions = 16

      println("1. Especificacoes IEEE 802.3 Ethernet:")
      println("   Teto de Truncamento do Expoente: " + max_exponent + " (Janela Maxima = 1023 slots)")
      println("   Limite Maximo de Tentativas: " + max_collisions + " colisões antes de abortar")

      mut as int64: c = 1
      mut as bool: aborted = false
      mut as int64: window_at_10 = 0
      mut as int64: window_at_15 = 0

      println("2. Simulando Evolucao da Janela de Contencao TBEB:")

      infinite (c <= max_collisions and (not aborted)) {
            #L Calcula expoente efetivo: min(c, 10)
            mut as int64: exp = c
            route {
                  exp > max_exponent ==> {
                        exp = max_exponent
                  }
                  _ ==> {}
            }

            #L Calcula tamanho da janela: 2^exp - 1
            mut as int64: window_size = 1
            mut as int64: p = 1
            infinite (p <= exp) {
                  window_size = window_size * 2
                  p = p + 1
            }
            window_size = window_size - 1

            route {
                  c == 10 ==> { window_at_10 = window_size }
                  c == 15 ==> { window_at_15 = window_size }
                  _ ==> {}
            }

            route {
                  c == max_collisions ==> {
                        println("   Colisão " + c + ": Limite maximo atingido! ABORTANDO transmissao (Excessive Collision Error).")
                        aborted = true
                  }
                  _ ==> {
                        mut as string: status_desc = "Crescimento Exponencial"
                        route {
                              c > max_exponent ==> {
                                    status_desc = "Truncado em 1023 slots"
                              }
                              _ ==> {}
                        }
                        println("   Colisão " + c + ": Expoente = " + exp + ", Janela = [0 .. " + window_size + "] slots (" + status_desc + ")")
                        c = c + 1
                  }
            }
      }

      println("3. Resumo da Execucao:")
      println("   Janela na 10a Colisao: " + window_at_10 + " slots")
      println("   Janela na 15a Colisao: " + window_at_15 + " slots")
      println("   Transmissao Abortada na 16a Colisao: " + aborted)

      #L Verificacoes de corretude formal da norma IEEE 802.3:
      #L 1. Janela aos 10 e aos 15 deve ser exatamente 1023 (truncamento ativo)
      #L 2. Aborto deve ser verdadeiro
      mut as bool: valid_tbeb = (window_at_10 == 1023) and (window_at_15 == 1023) and aborted
      println("4. Verificacao de Conformidade com Norma IEEE: " + valid_tbeb)

      println("Truncated Binary Exponential Backoff concluido com sucesso.")
}
