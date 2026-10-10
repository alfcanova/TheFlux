#L ============================================================================
#L Algoritmo: Cristian's Clock Synchronization Algorithm (1989)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(1) por medicao de RTT | Precisao limitada a +/- RTT/2
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoCristianAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Cristian's Clock Synchronization")
      println("==================================================")

      #L O algoritmo de Cristian sincroniza o relogio de um cliente com um
      #L servidor de tempo confiavel (Time Server / UTC).
      #L Medicoes:
      #L - T0: momento local do envio da solicitacao
      #L - Tserver: timestamp retornado pelo servidor
      #L - T1: momento local da recepcao da resposta
      #L - RTT = T1 - T0
      #L - Estimativa do tempo atual: T_sync = Tserver + (RTT /i 2)
      #L - Margem de erro: +/- (RTT /i 2)

      mut as int64: num_probes = 3

      #L Historico de 3 sondagens (probes):
      #L T0, Tserver, T1
      mut as list of int64: t0_list = [100, 200, 300]
      mut as list of int64: tserver_list = [540, 620, 750]
      mut as list of int64: t1_list = [180, 240, 390]

      println("1. Sondagens Realizadas pelo Cliente:")
      mut as int64: min_rtt = 999999
      mut as int64: best_probe = 0

      mut as int64: p = 1
      infinite (p <= num_probes) {
            mut as int64: t0 = t0_list[p]
            mut as int64: tsrv = tserver_list[p]
            mut as int64: t1 = t1_list[p]
            mut as int64: rtt = t1 - t0
            mut as int64: err = rtt /i 2

            println("   Sondagem " + p + ": T0=" + t0 + ", Tserver=" + tsrv + ", T1=" + t1 + " | RTT = " + rtt + " ms (erro +/- " + err + " ms)")

            #L Escolhe a sondagem com menor RTT para minimizar o erro
            route {
                  rtt < min_rtt ==> {
                        min_rtt = rtt
                        best_probe = p
                  }
                  _ ==> {}
            }
            p = p + 1
      }

      println("==================================================")
      println("2. [Selecao da Melhor Medicao]")
      println("   Sondagem escolhida: #" + best_probe + " com menor RTT = " + min_rtt + " ms")

      mut as int64: best_t0 = t0_list[best_probe]
      mut as int64: best_tsrv = tserver_list[best_probe]
      mut as int64: best_t1 = t1_list[best_probe]

      #L Calculo de sincronizacao
      mut as int64: rtt_half = min_rtt /i 2
      mut as int64: synced_time = best_tsrv + rtt_half
      mut as int64: adjustment = synced_time - best_t1

      println("3. [Ajuste do Relogio Local]")
      println("   Tempo Local na Recepcao (T1): " + best_t1 + " ms")
      println("   Tempo Estimado do Servidor:   " + synced_time + " ms")
      println("   Offset de Correcao (Delta):   " + adjustment + " ms")
      println("   Margem de Precisao Garantida: +/- " + rtt_half + " ms")

      mut as int64: new_local_clock = best_t1 + adjustment
      println("4. Relogio Local Ajustado: " + new_local_clock + " ms (Sincronizado!)")
      println("==================================================")
}
