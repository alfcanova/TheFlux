#L ============================================================================
#L Algoritmo: Nagle's Algorithm (Controle de Congestionamento TCP - RFC 896)
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(N) tempo | O(1) espaco de estado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesNagleAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Nagle's Algorithm (TCP Packet Batching)")
      println("==================================================")

      #L Parametros da Conexao TCP:
      #L MSS = Maximum Segment Size (tamanho maximo de segmento em bytes)
      mut as int64: mss = 100

      #L Estado da conexao TCP:
      #L buffer_len: bytes acumulados no buffer de saida da aplicacao
      #L unacked_packets: numero de pacotes enviados ainda sem confirmacao (ACK)
      mut as int64: buffer_len = 0
      mut as int64: unacked_packets = 0
      mut as int64: total_packets_sent = 0
      mut as int64: total_bytes_sent = 0

      println("1. Parametros TCP:")
      println("   MSS (Maximum Segment Size): " + mss + " bytes")
      println("   Regra de Nagle: Envia se buffer >= MSS OU unacked == 0; caso contrario, bufferiza.")

      #L Carga de trabalho de escrita da aplicacao (pequenas mensagens sucessivas):
      #L Escreve: 35 bytes, 40 bytes, 50 bytes, 30 bytes, 70 bytes (5 escritas)
      mut as int64: num_writes = 5
      mut as list of int64: write_sizes = [35, 40, 50, 30, 70]

      println("2. Simulando Escritas da Aplicacao e Coalescencia:")

      mut as int64: i = 1
      infinite (i <= num_writes) {
            mut as int64: chunk = write_sizes[i]
            buffer_len = buffer_len + chunk
            println("   Escrita " + i + ": +" + chunk + " bytes (Buffer atual = " + buffer_len + " bytes)")

            #L Avaliacao da Regra de Nagle:
            #L Condicao 1: buffer_len >= mss -> Envia segmento completo de tamanho MSS
            #L Condicao 2: unacked_packets == 0 -> Envia dados menores imediatamente
            #L Condicao 3: unacked_packets > 0 e buffer_len < mss -> Retem no buffer aguardando ACK
            mut as bool: sent = false
            route {
                  buffer_len >= mss ==> {
                        total_packets_sent = total_packets_sent + 1
                        total_bytes_sent = total_bytes_sent + mss
                        buffer_len = buffer_len - mss
                        unacked_packets = unacked_packets + 1
                        println("      [ENVIO] Segmento completo enviado: " + mss + " bytes (Buffer restante = " + buffer_len + ")")
                        sent = true
                  }
                  unacked_packets == 0 and buffer_len > 0 ==> {
                        total_packets_sent = total_packets_sent + 1
                        total_bytes_sent = total_bytes_sent + buffer_len
                        println("      [ENVIO] Pequeno pacote enviado (sem pacotes pendentes): " + buffer_len + " bytes")
                        buffer_len = 0
                        unacked_packets = unacked_packets + 1
                        sent = true
                  }
                  _ ==> {
                        println("      [BUFFERIZADO] Pacote retido pelo Nagle (aguardando ACK do anterior)")
                  }
            }

            #L Simulacao de chegada de ACK no meio da transferencia (na iteracao 3)
            route {
                  i == 3 and unacked_packets > 0 ==> {
                        println("      [REDE] ACK recebido! Pacotes nao confirmados reduzidos para 0.")
                        unacked_packets = 0
                        #L A chegada do ACK desbloqueia o envio dos dados acumulados
                        route {
                              buffer_len > 0 ==> {
                                    total_packets_sent = total_packets_sent + 1
                                    total_bytes_sent = total_bytes_sent + buffer_len
                                    println("      [ENVIO DESBLOQUEADO] Buffer acumulado enviado apos ACK: " + buffer_len + " bytes")
                                    buffer_len = 0
                                    unacked_packets = unacked_packets + 1
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            i = i + 1
      }

      #L Esvaziamento final do buffer apos ultimo ACK
      route {
            buffer_len > 0 ==> {
                  total_packets_sent = total_packets_sent + 1
                  total_bytes_sent = total_bytes_sent + buffer_len
                  println("   Flush Final: " + buffer_len + " bytes enviados")
                  buffer_len = 0
            }
            _ ==> {}
      }

      println("3. Estatisticas Finais do Nagle:")
      println("   Total de Pacotes Enviados: " + total_packets_sent)
      println("   Total de Bytes Transferidos: " + total_bytes_sent)

      #L Validacao: total de bytes transferidos deve ser 35 + 40 + 50 + 30 + 70 = 225 bytes
      mut as bool: correct_bytes = total_bytes_sent == 225
      println("4. Verificacao de Integridade de Dados: " + correct_bytes)

      println("Nagle's Algorithm concluido com sucesso.")
}
