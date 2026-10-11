#L ============================================================================
#L Algoritmo: HITS (Hubs and Authorities)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosHITS) {
      println("=== Algoritmo: HITS Hubs e Authorities ===")
      mut as list of int64: hubs = [100, 100, 100, 100]
      mut as list of int64: auth = [100, 100, 100, 100]
      mut as int64: it = 0
      infinite (it < 5) {
            mut as int64: a1 = hubs[2] + hubs[3]
            mut as int64: a2 = hubs[1] + hubs[3]
            mut as int64: a3 = hubs[1] + hubs[4]
            mut as int64: a4 = hubs[2]
            mut as int64: maxA = a1
            route {
                  a2 > maxA ==> { maxA = a2 }
                  _ ==> {}
            }
            route {
                  a3 > maxA ==> { maxA = a3 }
                  _ ==> {}
            }
            route {
                  a4 > maxA ==> { maxA = a4 }
                  _ ==> {}
            }
            route {
                  maxA == 0 ==> { maxA = 1 }
                  _ ==> {}
            }
            auth = [(a1 * 100) /i maxA, (a2 * 100) /i maxA, (a3 * 100) /i maxA, (a4 * 100) /i maxA]
            mut as int64: h1 = auth[2] + auth[3]
            mut as int64: h2 = auth[1] + auth[4]
            mut as int64: h3 = auth[1] + auth[2]
            mut as int64: h4 = auth[3]
            mut as int64: maxH = h1
            route {
                  h2 > maxH ==> { maxH = h2 }
                  _ ==> {}
            }
            route {
                  h3 > maxH ==> { maxH = h3 }
                  _ ==> {}
            }
            route {
                  h4 > maxH ==> { maxH = h4 }
                  _ ==> {}
            }
            route {
                  maxH == 0 ==> { maxH = 1 }
                  _ ==> {}
            }
            hubs = [(h1 * 100) /i maxH, (h2 * 100) /i maxH, (h3 * 100) /i maxH, (h4 * 100) /i maxH]
            it = it + 1
      }
      println("1. Authority Node 1: " + auth[1])
      println("2. Hub Node 1: " + hubs[1])
      println("3. Authority Node 2: " + auth[2])
      println("4. Hub Node 2: " + hubs[2])
      println("Teste concluido com sucesso.")
}
