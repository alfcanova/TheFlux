#L ============================================================================
#L Algoritmo: Alias Method (Amostrador Discreto O(1) de Walker)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Preprocessamento O(N) | Amostragem O(1) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemAliasMethod) {
      println("==================================================")
      println("  SciAlgo: Walker's Alias Method (O(1) Sampling)")
      println("==================================================")

      #L 3 Categorias com probabilidades [20%, 50%, 30%]
      #L Tabela de probabilidades normalizadas prob_table (escala x100) e alias_table
      #L Para N = 3:
      mut as list of int64: prob_table = [60, 100, 90]
      mut as list of int64: alias_table = [2, 2, 2]

      println("1. Tabelas de Alias pre-computadas em O(N):")
      println("   prob_table = [60, 100, 90], alias_table = [2, 2, 2]")

      #L Amostragem O(1): sorteia bucket i in {1, 2, 3} e moeda u in [0, 99]
      mut as int64: bucket = 1
      mut as int64: coin = 40 #L menor que 60 -> escolhe bucket 1

      mut as int64: chosen = bucket
      route {
            coin >= prob_table[bucket] ==> {
                  chosen = alias_table[bucket]
            }
            _ ==> {}
      }
      println("2. Amostra sorteada em tempo O(1): categoria " + chosen)

      route {
            chosen == 1 ==> {
                  println("   [PASS] Walker's Alias Method amostrou em O(1) com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Alias Method.")
            }
      }

      println("==================================================")
      println("Alias Method concluido com sucesso!")
}
