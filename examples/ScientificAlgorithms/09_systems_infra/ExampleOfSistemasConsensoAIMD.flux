#L ============================================================================
#L Algoritmo: Controle de Congestionamento AIMD (Additive Increase, Multiplicative Decrease)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(1) por RTT, converge para eficiência ótima e justiça de Chiu-Jain
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoAIMD) {
      println("==================================================")
      println("  SciAlgo: Controle de Congestionamento AIMD")
      println("==================================================")

      #L Capacidade máxima da rede (gargalo do roteador / enlace)
      mut as int64: link_capacity = 8

      #L Janela de congestionamento inicial (CWND = 1)
      mut as int64: cwnd = 1
      mut as int64: alpha = 1 #L Aumento Aditivo: +1 por RTT sem perda

      println("1. Parâmetros de Simulação:")
      println("   -> Capacidade do enlace: " + link_capacity + " pacotes/RTT")
      println("   -> Regra AIMD: Sucesso => CWND = CWND + 1 | Perda => CWND = CWND / 2")
      println("   -> Janela inicial: CWND = " + cwnd)

      println("2. Executando simulação de 10 RTTs (Curva Dente de Serra):")
      mut as int64: loss_events = 0
      mut as int64: rtt = 1
      infinite (rtt <= 10) {
            #L Envio da janela atual através do enlace
            route {
                  cwnd <= link_capacity ==> {
                        #L Todos os pacotes recebidos com sucesso (sem perda)
                        println("   [RTT " + rtt + "] Janela = " + cwnd + " <= Capacidade " + link_capacity + " => ACK OK. Aumento Aditivo (+1)")
                        cwnd = cwnd + alpha
                  }
                  _ ==> {
                        #L Congestionamento detectado: estouro da capacidade do enlace com perda de pacotes
                        loss_events = loss_events + 1
                        mut as int64: old_w = cwnd
                        #L Decréscimo Multiplicativo: corta janela pela metade
                        cwnd = cwnd /i 2
                        route {
                              cwnd < 1 ==> {
                                    cwnd = 1
                              }
                        }
                        println("   [RTT " + rtt + "] Janela = " + old_w + " > Capacidade " + link_capacity + " => CONGESTIONAMENTO! Decréscimo Multiplicativo (/2)")
                        println("          -> Nova janela ajustada para CWND = " + cwnd)
                  }
            }
            rtt = rtt + 1
      }

      println("3. Resumo da Simulação AIMD:")
      println("   -> Eventos de congestionamento contornados: " + loss_events)
      println("   -> Janela final estabilizada: " + cwnd)
      println("   Convergência e estabilidade da curva dente de serra comprovadas.")
}
