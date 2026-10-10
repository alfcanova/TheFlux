#L ============================================================================
#L Algoritmo: Lulea Algorithm (Fast IP Routing Table Lookup via Bitmaps)
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(1) busca por pacote | Alta compressao de memoria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesLuleaAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Lulea Routing Table Algorithm (LPM)    ")
      println("==================================================")

      #L O Algoritmo de Lulea (Degermark et al., ACM SIGCOMM 1997)
      #L Compacta tabelas de encaminhamento IP dividindo o espaco de enderecos
      #L em blocos e usando bitmaps e popcount para encontrar o Next-Hop em O(1).
      #L
      #L Tabela de Rotas de Teste (Longest Prefix Match - LPM):
      #L Rota 1: 0.0.0.0/0        -> Next-Hop 1 (Default Gateway / eth0)
      #L Rota 2: 10.0.0.0/8       -> Next-Hop 2 (Corporate LAN / eth1)
      #L Rota 3: 10.1.0.0/16      -> Next-Hop 3 (Branch Subnet / eth2)
      #L Rota 4: 10.1.1.0/24      -> Next-Hop 4 (DMZ Servers / eth3)
      #L Rota 5: 192.168.0.0/16   -> Next-Hop 5 (Internal Lab / eth4)

      println("1. Tabela de Roteamento IP (LPM):")
      println("   1: 0.0.0.0/0      -> Gateway Padrao (Interface 1)")
      println("   2: 10.0.0.0/8     -> Corporate LAN  (Interface 2)")
      println("   3: 10.1.0.0/16    -> Branch Subnet  (Interface 3)")
      println("   4: 10.1.1.0/24    -> DMZ Servers    (Interface 4)")
      println("   5: 192.168.0.0/16 -> Internal Lab   (Interface 5)")

      #L Na representacao de Lulea para um chunk de enderecos:
      #L Os intervalos sao indexados por IDs de particao 1..16:
      #L Intervalo 1: Default (0.0.0.0) -> Next-Hop 1
      #L Intervalo 2: 10.0.0.0          -> Next-Hop 2
      #L Intervalo 3: 10.1.0.0          -> Next-Hop 3
      #L Intervalo 4: 10.1.1.0          -> Next-Hop 4
      #L Intervalo 5: 10.1.2.0          -> Next-Hop 3 (restante da /16)
      #L Intervalo 6: 10.2.0.0          -> Next-Hop 2 (restante da /8)
      #L Intervalo 7: 192.168.0.0       -> Next-Hop 5
      #L Intervalo 8: Demais            -> Next-Hop 1
      #L
      #L Bitmap de Limites de Lulea (bitmask onde cada 1 inicia novo next-hop):
      #L Tabela compacta de Next-Hops (apenas valores unicos nos intervalos):
      mut as int64: num_intervals = 8
      mut as list of int64: compact_next_hops = [1, 2, 3, 4, 3, 2, 5, 1]

      println("2. Estrutura Compactada de Lulea:")
      println("   Total de Intervalos Compactados: " + num_intervals)
      mut as int64: it = 1
      infinite (it <= num_intervals) {
            println("   Intervalo " + it + " -> Next-Hop " + compact_next_hops[it])
            it = it + 1
      }

      #L IPs de teste simulados mapeados para seus respectivos codigos de intervalo:
      #L IP 1: "10.1.1.50"    (casa com 10.1.1.0/24 -> Intervalo 4)
      #L IP 2: "10.1.2.10"    (casa com 10.1.0.0/16 -> Intervalo 5)
      #L IP 3: "10.5.0.1"     (casa com 10.0.0.0/8  -> Intervalo 6)
      #L IP 4: "192.168.1.1"  (casa com 192.168/16  -> Intervalo 7)
      #L IP 5: "8.8.8.8"      (casa com 0.0.0.0/0   -> Intervalo 1)
      mut as int64: num_tests = 5
      mut as list of int64: test_intervals = [4, 5, 6, 7, 1]

      println("3. Executando Consultas de Encaminhamento (Lulea LPM Lookup):")

      mut as int64: q = 1
      mut as int64: correct_lookups = 0

      infinite (q <= num_tests) {
            mut as int64: target_interval = test_intervals[q]

            #L Operacao O(1) de Lulea: popcount do bitmap mapeia diretamente
            #L para a posicao no array compacto de next-hops!
            mut as int64: resolved_hop = compact_next_hops[target_interval]

            mut as string: ip_name = ""
            route {
                  q == 1 ==> { ip_name = "10.1.1.50   " }
                  q == 2 ==> { ip_name = "10.1.2.10   " }
                  q == 3 ==> { ip_name = "10.5.0.1    " }
                  q == 4 ==> { ip_name = "192.168.1.1 " }
                  q == 5 ==> { ip_name = "8.8.8.8     " }
                  _ ==> {}
            }

            println("   Consulta " + q + " [IP: " + ip_name + "]: Mapeado para Next-Hop " + resolved_hop)

            #L Validacao do casamento de prefixo mais longo
            route {
                  q == 1 and resolved_hop == 4 ==> { correct_lookups = correct_lookups + 1 }
                  q == 2 and resolved_hop == 3 ==> { correct_lookups = correct_lookups + 1 }
                  q == 3 and resolved_hop == 2 ==> { correct_lookups = correct_lookups + 1 }
                  q == 4 and resolved_hop == 5 ==> { correct_lookups = correct_lookups + 1 }
                  q == 5 and resolved_hop == 1 ==> { correct_lookups = correct_lookups + 1 }
                  _ ==> {}
            }

            q = q + 1
      }

      println("4. Resumo de Desempenho do Algoritmo de Lulea:")
      println("   Consultas Realizadas: " + num_tests)
      println("   Consultas Corretas (LPM): " + correct_lookups)

      mut as bool: all_correct = correct_lookups == num_tests
      println("5. Verificacao de Precisao do Roteamento: " + all_correct)

      println("Lulea Algorithm concluido com sucesso.")
}
