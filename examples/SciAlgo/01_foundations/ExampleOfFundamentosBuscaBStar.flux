#L ============================================================================
#L Algoritmo: B* Search (Busca com Intervalos de Confianca de Berliner)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^d) com poda provada por intervalos [pessimista, otimista]
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaBStar) {
      println("==================================================")
      println("  SciAlgo: B* Search (Hans Berliner 1979)")
      println("==================================================")

      #L Inicialmente avalia dois ramos concorrentes da raiz:
      #L Ramo A: [pessimista=60, otimista=85]
      #L Ramo B: [pessimista=40, otimista=70]
      mut as int64: pes_A = 60
      mut as int64: oti_A = 85

      mut as int64: pes_B = 40
      mut as int64: oti_B = 70

      println("1. Intervalos iniciais:")
      println("   Ramo A: [" + pes_A + ", " + oti_A + "]")
      println("   Ramo B: [" + pes_B + ", " + oti_B + "]")

      #L Na estrategia de prova de B*, busca estreitar os intervalos dos melhores nos
      #L Apos expansao detalhada do Ramo A (filhos avaliados):
      pes_A = 75
      oti_A = 82
      println("2. Apos refinar Ramo A: [" + pes_A + ", " + oti_A + "]")

      #L Apos expansao do Ramo B:
      pes_B = 45
      oti_B = 68
      println("3. Apos refinar Ramo B: [" + pes_B + ", " + oti_B + "]")

      #L Condicao de parada B*: pes(melhor) >= oti(concorrentes)
      mut as bool: proven = false
      mut as int64: winner = 0

      route {
            pes_A >= oti_B ==> {
                  proven = true
                  winner = 1 #L Ramo A venceu comprovadamente
            }
            pes_B >= oti_A ==> {
                  proven = true
                  winner = 2 #L Ramo B venceu comprovadamente
            }
      }

      println("4. Prova matematica alcancada: " + proven)
      println("5. Ramo vencedor comprovado (1=A, 2=B): " + winner)
      println("6. Validacao: " + (proven and winner == 1))
      println("==================================================")
}
