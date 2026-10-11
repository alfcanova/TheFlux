#L ============================================================================
#L Algoritmo: Modelador de Tráfego Leaky Bucket (Leaky Bucket Traffic Shaper)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(1) tempo por pacote, taxa constante de escoamento (leaking)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoLeakyBucket) {
      println("==================================================")
      println("  SciAlgo: Leaky Bucket Traffic Shaper")
      println("==================================================")

      mut as int64: capacity = 6   #L Capacidade máxima do buffer (C)
      mut as int64: leak_rate = 2  #L Taxa constante de escoamento por ciclo (L)
      mut as int64: water = 0      #L Volume atual de dados no balde

      println("1. Configuração: Capacidade C = " + capacity + ", Escoamento L = " + leak_rate + " unidades/ciclo")
      println("   Volume inicial = " + water)

      #L Padrão de rajadas de entrada nos ciclos 1 a 5:
      mut as list of int64: arrivals = [4, 5, 1, 0, 0]
      mut as int64: total_sent = 0
      mut as int64: total_dropped = 0

      println("2. Executando modelagem de tráfego com vazão constante:")
      mut as int64: cycle = 1
      infinite (cycle <= 5) {
            mut as int64: incoming = arrivals[cycle]
            println("   [Ciclo " + cycle + "] Chegada de " + incoming + " unidades de dados.")

            #L Verificação de overflow / transbordamento
            mut as int64: space = capacity - water
            route {
                  incoming <= space ==> {
                        water = water + incoming
                        println("      -> Pacote aceito no buffer (nível atual = " + water + "/" + capacity + ")")
                  }
                  _ ==> {
                        mut as int64: accepted = space
                        mut as int64: dropped = incoming - space
                        water = capacity
                        total_dropped = total_dropped + dropped
                        println("      -> Overflow! Aceitas " + accepted + " unidades, " + dropped + " unidades descartadas (Dropped)!")
                  }
            }

            #L Escoamento constante (Leak)
            mut as int64: leaked = 0
            route {
                  water >= leak_rate ==> {
                        leaked = leak_rate
                        water = water - leak_rate
                  }
                  _ ==> {
                        leaked = water
                        water = 0
                  }
            }
            total_sent = total_sent + leaked
            println("      -> Escoamento: " + leaked + " unidades transmitidas para a rede (restam " + water + " no buffer).")

            cycle = cycle + 1
      }

      println("3. Resumo da Modelagem Leaky Bucket:")
      println("   -> Total de unidades transmitidas com vazão suave: " + total_sent)
      println("   -> Total de unidades descartadas por congestionamento: " + total_dropped)
      println("   -> Nível final do buffer: " + water)
      println("   Taxa de transmissão suavizada com sucesso.")
}
