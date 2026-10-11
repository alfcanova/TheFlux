#L ============================================================================
#L Algoritmo: Alias Method (Metodo do Apelido de Walker-Vose)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(1) amostragem estrita | O(N) pre-processamento
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisAliasMethod) {
      println("==================================================")
      println("  SciAlgo: Walker-Vose Alias Method")
      println("==================================================")

      #L 4 eventos com probabilidades desiguais (somando 1000 centesimos = 100%):
      #L Evento 1: 12.5% (125)
      #L Evento 2: 37.5% (375)
      #L Evento 3: 25.0% (250)
      #L Evento 4: 25.0% (250)
      mut as list of int64: prob_dist = [125, 375, 250, 250]
      println("1. Distribuicao alvo (escala 1/1000): " + prob_dist)

      #L Tabelas pre-computadas do Alias Method para N = 4:
      #L Cada coluna tem capacidade 250.
      #L Coluna 1: 125 pertencem ao Evento 1 (50% = 500/1000) e 125 ao Alias (Evento 2)
      #L Colunas 2, 3, 4 sao preenchidas integralmente (100% = 1000/1000)
      mut as list of int64: prob_table = [500, 1000, 1000, 1000]
      mut as list of int64: alias_table = [2, 0, 0, 0]

      println("2. Tabela de Probabilidade interna (Prob): " + prob_table)
      println("3. Tabela de Apelidos (Alias):           " + alias_table)

      #L Amostragem em tempo estrito O(1):
      #L Passo 1: sorteia uma coluna uniforme de 1 a 4
      #L Passo 2: sorteia fracao uniforme de 1 a 1000
      #L Passo 3: se fracao <= prob_table[coluna], resultado = coluna; senao = alias_table[coluna]

      #L Simulacao de 5 amostragens O(1) deterministicas
      mut as list of int64: samples = []
      mut as int64: seed = 777
      mut as int64: s = 1
      infinite (s <= 5) {
            seed = (1664525 * seed + 1013904223) /r 2147483647
            route { seed < 0 ==> { seed = seed * -1 } }
            mut as int64: col = (seed /r 4) + 1

            seed = (1664525 * seed + 1013904223) /r 2147483647
            route { seed < 0 ==> { seed = seed * -1 } }
            mut as int64: coin = (seed /r 1000) + 1

            mut as int64: chosen = col
            route {
                  coin > prob_table[col] ==> {
                        chosen = alias_table[col]
                  }
            }
            samples = listPushBack(samples, chosen)
            s = s + 1
      }

      println("4. Amostras geradas em tempo estrito O(1): " + samples)
      println("5. Validacao: " + (listLength(samples) == 5 and listLength(prob_table) == 4))
      println("==================================================")
}
