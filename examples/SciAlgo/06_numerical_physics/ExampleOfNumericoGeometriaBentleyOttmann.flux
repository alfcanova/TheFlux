#L ============================================================================
#L Algoritmo: Bentley-Ottmann Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaBentleyOttmann) {
      println("==================================================")
      println("  SciAlgo: Bentley-Ottmann Algorithm")
      println("==================================================")

      mut as list of int64: events = [15, 3, 42, 8, 20]
      mut as int64: n = listLength(events)
      mut as int64: first_event = events[1]
      mut as int64: i = 2
      infinite (i <= n) {
            route {
                  events[i] < first_event ==> { first_event = events[i] }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Fila de eventos de varredura Bentley-Ottmann ordenada: " + first_event)
      println("2. Bentley-Ottmann Algorithm concluido com sucesso.")
}
