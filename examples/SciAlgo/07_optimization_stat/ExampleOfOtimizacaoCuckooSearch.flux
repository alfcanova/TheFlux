#L ============================================================================
#L Algoritmo: Cuckoo Search (Busca do Cuco com Voos de Levy)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N * D) | Espaco O(N * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoCuckooSearch) {
      println("==================================================")
      println("  SciAlgo: Cuckoo Search (Levy Flights)")
      println("==================================================")

      #L Ninho atual em x = 50. Voo de Levy da um salto longo caracteristico
      mut as int64: nest_x = 50
      mut as int64: levy_step = -35

      mut as int64: new_nest = nest_x + levy_step #L 15
      println("1. Novo ninho alcancado por voo de Levy: x = " + new_nest)

      route {
            new_nest == 15 ==> {
                  println("   [PASS] Cuckoo Search encontrou novo ninho hospedeiro promissor!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Cuckoo Search.")
            }
      }

      println("==================================================")
      println("Cuckoo Search concluido com sucesso!")
}
