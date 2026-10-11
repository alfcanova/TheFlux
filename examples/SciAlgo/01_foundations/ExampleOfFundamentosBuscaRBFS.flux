#L ============================================================================
#L Algoritmo: RBFS (Recursive Best-First Search de Richard Korf 1993)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^d) tempo | O(d) espaco linear de memoria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaRBFS) {
      println("==================================================")
      println("  SciAlgo: Recursive Best-First Search (RBFS)")
      println("==================================================")

      #L Raiz 1 tem dois filhos:
      #L Filho 2: f = 12
      #L Filho 3: f = 15
      mut as int64: f_child2 = 12
      mut as int64: f_child3 = 15

      #L O melhor no e 2; o limite f_limit e o segundo melhor: f(3) = 15
      mut as int64: current_best = 2
      mut as int64: f_limit = f_child3

      println("1. Explorando no " + current_best + " (f=" + f_child2 + ") com f_limit = " + f_limit)

      #L Aprofundamento no No 2: gera netos com f = 16 e f = 18
      #L O melhor novo valor no No 2 e 16
      mut as int64: new_f_best_in_2 = 16
      println("2. Expansao do No 2 revelou novo menor f = " + new_f_best_in_2)

      #L RBFS detecta que new_f (16) ultrapassou o f_limit (15)
      mut as bool: backtrack_triggered = false
      route {
            new_f_best_in_2 > f_limit ==> {
                  backtrack_triggered = true
                  #L Atualiza o valor f retropropagado do No 2 para 16
                  f_child2 = new_f_best_in_2
                  println("3. Backtrack acionado: f(2) retropropagado para " + f_child2)
            }
      }

      #L Agora o No 3 (f=15) torna-se o novo melhor caminho global
      route {
            f_child3 < f_child2 ==> {
                  current_best = 3
                  f_limit = f_child2 #L Novo limite passa a ser 16
            }
      }

      println("4. Nova ramificacao selecionada: No " + current_best + " (f=" + f_child3 + ") com novo limite f_limit=" + f_limit)

      #L O No 3 encontra o objetivo
      mut as bool: goal_reached = (current_best == 3)

      println("5. Objetivo alcancado pela alternancia otima: " + goal_reached)
      println("6. Validacao: " + (backtrack_triggered and goal_reached and f_child2 == 16))
      println("==================================================")
}
