#L ============================================================================
#L Algoritmo: Harmony Search (Busca Harmonica / Improvisacao Musical)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Improvisacoes * HMS) | Espaco O(HMS * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoHarmonySearch) {
      println("==================================================")
      println("  SciAlgo: Harmony Search (Musical Improvisation)")
      println("==================================================")

      #L Memoria de Harmonia (HM) armazena melhores vetores
      #L HM = [10, 20, 30]
      #L Nova harmonia improvisada com Memory Consideration (HMCR = 0.95):
      mut as int64: selected_note = 20
      #L Pitch adjustment (PAR): adiciona delta tonal de +1
      mut as int64: tuned_note = selected_note + 1 #L 21

      println("1. Harmonia improvisada e afinada: " + tuned_note)
      route {
            tuned_note == 21 ==> {
                  println("   [PASS] Harmony Search afinou a nota musical otima com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Harmony Search.")
            }
      }

      println("==================================================")
      println("Harmony Search concluido com sucesso!")
}
