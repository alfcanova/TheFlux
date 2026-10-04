#L ============================================================================
#L Algoritmo: Principal Variation Search (PVS / NegaScout)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^(d/2)) assintotico com janelas nulas aceleradas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchPVS) {
      println("==================================================")
      println("  SciAlgo: Principal Variation Search (PVS / NegaScout)")
      println("==================================================")

      mut as int64: alpha = -9999
      mut as int64: beta = 9999

      #L Primeiro lance e considerado o candidato da Variacao Principal (PV)
      #L E avaliado com janela completa [alpha, beta]
      mut as int64: pv_move_score = 5
      route {
            pv_move_score > alpha ==> {
                  alpha = pv_move_score
            }
      }
      println("1. Lance PV (principal) avaliado com janela completa: score = " + pv_move_score)
      println("   Novo alpha de referencia: " + alpha)

      #L Movimentos subsequentes sao testados primeiro com janela nula estreita [alpha, alpha + 1]
      #L Lance 2 real valeria 4 (inferior a PV).
      #L A busca com janela nula [5, 6] retorna score <= alpha (falha baixa / scout cut)
      mut as int64: move2_real_val = 4
      mut as bool: null_window_success = false
      mut as bool: re_search_needed = false

      #L Testa com janela nula
      route {
            move2_real_val <= alpha ==> {
                  null_window_success = true
                  println("2. Lance 2 testado com janela nula [" + alpha + ", " + (alpha + 1) + "]: score <= alpha (" + move2_real_val + " <= " + alpha + ")")
                  println("   Sucesso: Lance 2 provado inferior rapidamente sem re-pesquisa!")
            }
            _ ==> {
                  re_search_needed = true
            }
      }

      println("3. Poda por janela nula confirmada: " + null_window_success)
      println("4. Re-pesquisa evitada: " + (not re_search_needed))
      println("5. Melhor lance confirmado como PV com valor: " + alpha)
      println("6. Validacao: " + (null_window_success and alpha == 5 and not re_search_needed))
      println("==================================================")
}
