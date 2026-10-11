#L ============================================================================
#L Algoritmo: Exponential Backoff (Adiamento Exponencial de Retransmissoes)
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(k) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesExponentialBackoff) {
      println("==================================================")
      println("  SciAlgo: Exponential Backoff Algorithm          ")
      println("==================================================")

      #L Parametros do Backoff Exponencial:
      #L base_delay: atraso inicial em milissegundos
      #L max_delay: teto maximo de espera (cap)
      #L max_retries: numero maximo de tentativas
      mut as int64: base_delay = 100
      mut as int64: max_delay = 1600
      mut as int64: max_retries = 6

      println("1. Parametros do Algoritmo:")
      println("   Base Delay: " + base_delay + " ms")
      println("   Max Delay (Cap): " + max_delay + " ms")
      println("   Max Retries: " + max_retries)

      #L Simulacao de chamada de rede com falha transitoria:
      #L O servico falha nas 4 primeiras tentativas e responde com sucesso na 5a tentativa.
      mut as int64: attempt = 1
      mut as int64: success_attempt = 5
      mut as bool: resolved = false
      mut as int64: total_waited_ms = 0

      println("2. Executando Tentativas de Transmissao:")

      infinite (attempt <= max_retries and (not resolved)) {
            route {
                  attempt == success_attempt ==> {
                        println("   Tentativa " + attempt + ": SUCESSO! Conexao estabelecida.")
                        resolved = true
                  }
                  _ ==> {
                        #L Calcula atraso exponencial: delay = base_delay * 2^(attempt - 1)
                        mut as int64: current_delay = base_delay
                        mut as int64: p = 1
                        infinite (p < attempt) {
                              current_delay = current_delay * 2
                              p = p + 1
                        }

                        #L Aplica o teto (truncation/cap)
                        route {
                              current_delay > max_delay ==> {
                                    current_delay = max_delay
                              }
                              _ ==> {}
                        }

                        total_waited_ms = total_waited_ms + current_delay
                        println("   Tentativa " + attempt + ": FALHA. Aplicando Backoff de " + current_delay + " ms (Total acumulado: " + total_waited_ms + " ms)")
                        attempt = attempt + 1
                  }
            }
      }

      println("3. Resumo da Execucao do Exponential Backoff:")
      println("   Tentativa Final Bem-Sucedida: " + attempt)
      println("   Tempo Total em Espera: " + total_waited_ms + " ms")

      #L Validacao:
      #L Tentativa 1 falha: delay = 100 ms
      #L Tentativa 2 falha: delay = 200 ms
      #L Tentativa 3 falha: delay = 400 ms
      #L Tentativa 4 falha: delay = 800 ms
      #L Total esperado = 100 + 200 + 400 + 800 = 1500 ms
      mut as bool: correct_backoff = total_waited_ms == 1500 and resolved
      println("4. Verificacao de Corretude do Backoff: " + correct_backoff)

      println("Exponential Backoff concluido com sucesso.")
}
