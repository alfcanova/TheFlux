#L ============================================================================
#L Algoritmo: Karn's Algorithm (Estimacao de RTT e RTO em TCP - RFC 6298)
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(1) por medicao | O(N) tempo total
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesKarnAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Karn's Algorithm (TCP RTT/RTO Estimator)")
      println("==================================================")

      #L Variaveis do Algoritmo de Jacobson / Karn:
      #L srtt: Smoothed Round Trip Time (em milissegundos)
      #L rttvar: RTT Variation (desvio medio)
      #L rto: Retransmission Timeout (tempo limite de retransmissao)
      mut as int64: srtt = 100
      mut as int64: rttvar = 50
      mut as int64: rto = srtt + 4 * rttvar #L 100 + 200 = 300 ms

      println("1. Estado Inicial do TCP Estimator:")
      println("   SRTT inicial: " + srtt + " ms")
      println("   RTTVAR inicial: " + rttvar + " ms")
      println("   RTO inicial: " + rto + " ms")

      #L Eventos de Transmissao:
      #L Evento 1: Pacote 1 transmitido normalmente, RTT medido = 80 ms, retransmitido = false
      #L Evento 2: Pacote 2 sofre TIMEOUT, retransmitido = true, RTT ambíguo = 350 ms
      #L Evento 3: Pacote 3 transmitido normalmente, RTT medido = 90 ms, retransmitido = false
      mut as int64: num_events = 3
      mut as list of int64: measured_rtt = [80, 350, 90]
      mut as list of bool: is_retransmitted = [false, true, false]

      println("2. Processando Eventos de Transmissao e Regras de Karn:")

      mut as int64: ev = 1
      infinite (ev <= num_events) {
            mut as int64: sample_rtt = measured_rtt[ev]
            mut as bool: retx = is_retransmitted[ev]

            println("   Evento " + ev + ": Amostra RTT = " + sample_rtt + " ms (Retransmitido: " + retx + ")")

            route {
                  retx ==> {
                        #L Regra 1 de Karn: Ignora medicao de RTT para pacotes retransmitidos
                        #L Regra 2 de Karn: Backoff exponencial do RTO
                        rto = rto * 2
                        println("      [KARN BACKOFF] Medicao de RTT descartada (ambiguidade). RTO dobrado para: " + rto + " ms")
                  }
                  _ ==> {
                        #L Regra 3 de Karn: Pacote sem retransmissao atualiza SRTT, RTTVAR e RTO (Jacobson)
                        #L Atualizacao com fracoes aproximadas inteiras:
                        #L delta = |sample_rtt - srtt|
                        mut as int64: diff = sample_rtt - srtt
                        route { diff < 0 ==> { diff = -diff } _ ==> {} }

                        #L rttvar = (3 * rttvar + diff) / 4
                        rttvar = (3 * rttvar + diff) / 4
                        #L srtt = (7 * srtt + sample_rtt) / 8
                        srtt = (7 * srtt + sample_rtt) / 8

                        #L Recalcula RTO = srtt + 4 * rttvar
                        rto = srtt + 4 * rttvar
                        println("      [ATUALIZACAO NORMAL] SRTT atualizado = " + srtt + " ms, RTTVAR = " + rttvar + " ms, Novo RTO = " + rto + " ms")
                  }
            }

            ev = ev + 1
      }

      println("3. Estado Final Apos Aplicacao do Algoritmo de Karn:")
      println("   SRTT Final: " + srtt + " ms")
      println("   RTTVAR Final: " + rttvar + " ms")
      println("   RTO Final: " + rto + " ms")

      #L Validacao deterministica: RTO apos evento 3 deve ser > 0
      mut as bool: rto_valid = rto > 0 and rto < 1000
      println("4. Verificacao de RTO Estavel: " + rto_valid)

      println("Karn's Algorithm concluido com sucesso.")
}
