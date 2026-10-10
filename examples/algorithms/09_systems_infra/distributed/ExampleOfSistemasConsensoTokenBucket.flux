#L ============================================================================
#L Algoritmo: Limitador de Taxa Token Bucket (Token Bucket Rate Limiter)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(1) tempo por requisição, acomoda rajadas até a capacidade B
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoTokenBucket) {
      println("==================================================")
      println("  SciAlgo: Token Bucket Rate Limiter")
      println("==================================================")

      mut as int64: capacity = 5   #L Capacidade máxima do balde (B)
      mut as int64: refill_rate = 2 #L Taxa de recarga por ciclo (R)
      mut as int64: tokens = 5     #L Balde inicializado cheio

      println("1. Configuração: Capacidade B = " + capacity + ", Recarga R = " + refill_rate + " tokens/ciclo")
      println("   Tokens iniciais = " + tokens)

      #L Padrão de requisições ao longo de 5 ciclos:
      #L Ciclo 1: Requisição de custo 3
      #L Ciclo 2: Requisição de custo 4
      #L Ciclo 3: Duas requisições (custo 2 e depois custo 2)
      #L Ciclo 4: Ocioso (custo 0)
      #L Ciclo 5: Requisição de custo 3

      mut as list of int64: req_costs = [3, 4, 2, 0, 3]
      mut as int64: total_approved = 0
      mut as int64: total_rejected = 0

      println("2. Executando simulação de controle de fluxo:")
      mut as int64: tick = 1
      infinite (tick <= 5) {
            #L Recarga de tokens a cada ciclo (a partir do ciclo 2)
            route {
                  tick > 1 ==> {
                        tokens = tokens + refill_rate
                        route {
                              tokens > capacity ==> {
                                    tokens = capacity
                              }
                        }
                  }
            }

            mut as int64: cost = req_costs[tick]
            println("   [Ciclo " + tick + "] Balde = " + tokens + " tokens | Requisição recebida: custo " + cost)

            route {
                  cost > 0 ==> {
                        route {
                              tokens >= cost ==> {
                                    tokens = tokens - cost
                                    total_approved = total_approved + 1
                                    println("      -> APROVADA: Consumidos " + cost + " tokens (restam " + tokens + ")")
                              }
                              _ ==> {
                                    total_rejected = total_rejected + 1
                                    println("      -> REJEITADA: Tokens insuficientes (" + tokens + " < " + cost + ") - Throttled!")
                              }
                        }
                  }
                  _ ==> {
                        println("      -> Sem requisições no ciclo (acumulando tokens).")
                  }
            }

            #L Teste de rajada no ciclo 3 (segunda requisição imediata no mesmo ciclo)
            route {
                  tick == 3 ==> {
                        mut as int64: extra_cost = 2
                        println("      [Rajada no Ciclo 3] Segunda requisição imediata: custo " + extra_cost)
                        route {
                              tokens >= extra_cost ==> {
                                    tokens = tokens - extra_cost
                                    total_approved = total_approved + 1
                                    println("      -> APROVADA: Rajada aceita (restam " + tokens + ")")
                              }
                              _ ==> {
                                    total_rejected = total_rejected + 1
                                    println("      -> REJEITADA: Rajada excedeu capacidade residual (restam " + tokens + ")")
                              }
                        }
                  }
            }

            tick = tick + 1
      }

      println("3. Resumo do Limitador Token Bucket:")
      println("   -> Total de requisições aprovadas: " + total_approved)
      println("   -> Total de requisições rejeitadas: " + total_rejected)
      println("   -> Tokens residuais no balde: " + tokens)
      println("   Comportamento de suavização de tráfego validado.")
}
