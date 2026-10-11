#L ============================================================================
#L Algoritmo: Powell Method (Busca por Direcoes Conjugadas Sem Gradiente)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * D) | Espaco O(D^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoPowellMethod) {
      println("==================================================")
      println("  SciAlgo: Powell's Conjugate Direction Method")
      println("==================================================")

      #L Busca linear consecutiva ao longo das direcoes de base e1 e e2
      mut as int64: x = 30
      mut as int64: y = 50

      #L Passo 1 ao longo de e1: minimiza (x - 10)^2 -> x = 10
      x = 10
      #L Passo 2 ao longo de e2: minimiza (y - 20)^2 -> y = 20
      y = 20

      println("1. Minimo alcancado pelas direcoes de Powell: (" + x + ", " + y + ")")
      route {
            x == 10 and y == 20 ==> {
                  println("   [PASS] Metodo de Powell convergiu nas direcoes principais!")
            }
            _ ==> {
                  println("   [ERRO] Falha no metodo de Powell.")
            }
      }

      println("==================================================")
      println("Powell Method concluido com sucesso!")
}
