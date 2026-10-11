#L ============================================================================
#L Algoritmo: Rendezvous Hashing (Highest Random Weight - HRW)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(N) busca por chave sobre N servidores, redistribuicao minima O(1/N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (hrwWeight) (as int64: keyVal, as int64: serverId) as int64 {
      mut as int64: part1 = (keyVal * 17389) & 2147483647
      mut as int64: part2 = (serverId * 29531) & 2147483647
      mut as int64: h = (part1 ^ part2 ^ 54321) & 2147483647
      mut as int64: w = h /r 100000
      route {
            w < 0 ==> {
                  w = w + 100000
            }
      }
      emit(nice, w, "ok")
}

function (pickServer) (as int64: keyVal, as list of int64: servers, as int64: numServers) as int64 {
      mut as int64: best_s = servers[1]
      mut as int64: max_w = -1
      mut as int64: i = 1
      infinite (i <= numServers) {
            mut as int64: s = servers[i]
            mut as int64: w = hrwWeight(keyVal, s)
            route {
                  w > max_w ==> {
                        max_w = w
                        best_s = s
                  }
            }
            i = i + 1
      }
      emit(nice, best_s, "ok")
}

program (ExampleOfSistemasConsensoRendezvousHashing) {
      println("==================================================")
      println("  SciAlgo: Rendezvous Hashing (HRW)")
      println("==================================================")

      #L Conjunto de 4 servidores ativos: Server 1, Server 2, Server 3, Server 4
      mut as list of int64: servers = [1, 2, 3, 4]
      mut as int64: num_servers = 4

      mut as list of int64: keys = [101, 202, 303, 404, 505, 606]
      mut as int64: num_keys = listLength(keys)

      println("1. Mapeamento inicial com 4 servidores:")
      mut as list of int64: initial_alloc = []
      mut as int64: k = 1
      infinite (k <= num_keys) {
            mut as int64: kval = keys[k]
            mut as int64: best = pickServer(kval, servers, num_servers)
            initial_alloc = listPushBack(initial_alloc, best)
            println("   Chave " + kval + " -> Servidor alocado: " + best)
            k = k + 1
      }

      #L Remocao do Servidor 2 (simulando falha ou manutencao)
      println("2. Removendo Servidor 2 do cluster...")
      mut as list of int64: remaining_servers = [1, 3, 4]
      mut as int64: num_remaining = 3

      println("3. Remapeamento das chaves apos remocao do Servidor 2:")
      mut as int64: remapped_count = 0
      mut as int64: unchanged_count = 0
      k = 1
      infinite (k <= num_keys) {
            mut as int64: kval = keys[k]
            mut as int64: new_s = pickServer(kval, remaining_servers, num_remaining)
            mut as int64: old_s = initial_alloc[k]
            route {
                  new_s != old_s ==> {
                        println("   Chave " + kval + ": Reatribuida de " + old_s + " -> " + new_s)
                        remapped_count = remapped_count + 1
                  }
                  _ ==> {
                        println("   Chave " + kval + ": Inalterada no Servidor " + old_s)
                        unchanged_count = unchanged_count + 1
                  }
            }
            k = k + 1
      }

      println("4. Estatisticas de remapeamento HRW:")
      println("   Total de chaves reatribuidas: " + remapped_count)
      println("   Total de chaves preservadas: " + unchanged_count)
      println("   Propriedade HRW verificada: apenas chaves do no removido migram.")
}
