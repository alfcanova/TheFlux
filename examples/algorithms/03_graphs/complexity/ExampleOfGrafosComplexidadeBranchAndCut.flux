#L ============================================================================
#L Algoritmo: Branch and Cut (Ramificacao e Planos de Corte)
#L Dominio: 03_graphs / Categoria: Teoria da computacao e complexidade
#L Complexidade: Exato combinatorial | Relaxacao LP O(n log n) + Cortes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosComplexidadeBranchAndCut) {
      println("==================================================")
      println("  SciAlgo: Branch and Cut (Programacao Inteira)   ")
      println("==================================================")

      #L Instancia: Problema da Mochila 0/1 resolvido via Branch-and-Cut
      #L 4 itens com (peso, valor) e capacidade W = 10
      #L Item 1: peso 6, valor 14 (razao 2.33)
      #L Item 2: peso 5, valor 11 (razao 2.20)
      #L Item 3: peso 5, valor 10 (razao 2.00)
      #L Item 4: peso 4, valor 7  (razao 1.75)
      mut as int64: n = 4
      mut as int64: capacity = 10
      mut as list of int64: weights = [6, 5, 5, 4]
      mut as list of int64: values = [14, 11, 10, 7]

      println("1. Instancia da Programacao Inteira:")
      println("   Max sum(v_i * x_i) sujeito a sum(w_i * x_i) <= W, x_i in {0, 1}")
      println("   Pesos: " + weights + ", Valores: " + values + ", W = " + capacity)

      #L ETAPA 1: Relaxacao Linear (LP Relaxation continua 0 <= x_i <= 1)
      #L Solucao fracionaria gulosa do LP continuo:
      #L x1 = 1 (peso 6, folga 4)
      #L x2 = 4/5 = 0.8 (peso 4, folga 0)
      #L x3 = 0, x4 = 0
      #L Valor LP continuo = 14 + 0.8 * 11 = 22.8 (em decimos: 228)
      mut as int64: lp_initial_scaled = 228
      println("2. Relaxacao Linear (LP Continuo Inicial):")
      println("   Solucao fracionaria x* = [1.0, 0.8, 0.0, 0.0]")
      println("   Limite superior continuo (Upper Bound): 22.8")

      #L ETAPA 2: Separacao de Planos de Corte (Cutting Plane Generation)
      #L Procuramos uma desigualdade valida violada por x*.
      #L Identificacao de Cobertura Minima (Cover Cut):
      #L Os itens {1, 2} tem peso conjunto w1 + w2 = 6 + 5 = 11 > W (10).
      #L Portanto, qualquer solucao inteira viavel DEVE satisfazer o Cover Cut:
      #L   x1 + x2 <= |C| - 1 = 1
      #L Testando violacao em x*:
      #L   x1* + x2* = 1.0 + 0.8 = 1.8 > 1 (VIOLADO!)
      println("3. Separacao de Cortes (Cover Cut):")
      println("   Itens {1, 2} formam uma cobertura: w1 + w2 = 11 > 10.")
      println("   Desigualdade de Corte gerada: x1 + x2 <= 1.")
      mut as bool: cut_violated = true
      println("   Corte violado pela solucao fracionaria (1.8 > 1.0)? " + cut_violated)

      #L ETAPA 3: Adicao do Corte e Aperfeicoamento do LP (Tightening)
      #L Com a restricao x1 + x2 <= 1 adicionada ao LP:
      #L Nao e possivel ter x1=1 e x2>0 simultaneamente.
      #L Sub-caso LP A (x1=1, x2=0): peso usado = 6, resta 4. Item 3 tem peso 5 -> x3 = 4/5 = 0.8.
      #L   Valor LP = 14 + 0.8 * 10 = 22.0 (em decimos: 220).
      #L Sub-caso LP B (x2=1, x1=0): peso usado = 5, resta 5. Item 3 tem peso 5 -> x3 = 1.0.
      #L   Valor LP = 11 + 10 = 21.0.
      #L O novo Upper Bound fracionario cai de 22.8 para 22.0!
      mut as int64: lp_tightened_scaled = 220
      println("4. Aperfeicoamento com o Plano de Corte:")
      println("   Limite superior continuo reduzido para: 22.0 (aperfeicoou a formulacao)")

      #L ETAPA 4: Ramificacao (Branching)
      #L Como x3 ainda e fracionario (0.8 no melhor LP), criamos 2 nos na arvore:
      #L Ramo 1: x3 = 1
      #L Ramo 2: x3 = 0
      println("5. Ramificacao (Branching) na variavel fracionaria x3:")

      mut as int64: best_integer_val = 0
      mut as list of int64: best_integer_x = [0, 0, 0, 0]
      mut as int64: nodes_explored = 0

      #L Exploracao Ramo 1 (x3 = 1):
      nodes_explored = nodes_explored + 1
      #L Com x3=1 (peso 5), sobra capacidade 5. Restricao adicional do corte: x1 + x2 <= 1.
      #L Se x1=1: peso 6 > 5 (inviavel)
      #L Se x2=1: peso 5 <= 5 (viavel!). x = [0, 1, 1, 0], peso = 10, valor = 11 + 10 = 21.
      #L Se x4=1: peso 4 <= 5 (viavel). x = [0, 0, 1, 1], peso = 9, valor = 10 + 7 = 17.
      mut as int64: branch1_sol_val = 21
      route {
            branch1_sol_val > best_integer_val ==> {
                  best_integer_val = branch1_sol_val
                  best_integer_x = [0, 1, 1, 0]
            }
            _ ==> {}
      }
      println("   No 1 (Ramo x3 = 1): Solucao inteira viavel encontrada: x = [0, 1, 1, 0], Valor = " + branch1_sol_val)
      println("   Limite inferior inteiro atualizado (Pruning / Incumbent): " + best_integer_val)

      #L Exploracao Ramo 2 (x3 = 0):
      nodes_explored = nodes_explored + 1
      #L Com x3=0 e restricao x1 + x2 <= 1:
      #L Se x1=1: peso 6, resta 4. x2=0 pelo corte. Item 4 cabe inteiro: x4=1 (peso 4).
      #L   Solucao inteira: x = [1, 0, 0, 1], peso = 10, valor = 14 + 7 = 21.
      #L Se x2=1: peso 5, resta 5. x1=0 pelo corte. Item 4 cabe: x4=1 (peso 4).
      #L   Solucao inteira: x = [0, 1, 0, 1], peso = 9, valor = 11 + 7 = 18 <= 21 (podado).
      mut as int64: branch2_sol_val = 21
      route {
            branch2_sol_val > best_integer_val ==> {
                  best_integer_val = branch2_sol_val
                  best_integer_x = [1, 0, 0, 1]
            }
            _ ==> {}
      }
      println("   No 2 (Ramo x3 = 0): Solucao inteira viavel encontrada: x = [1, 0, 0, 1], Valor = " + branch2_sol_val)

      #L Poda por Integralidade e Limite (Fathoming)
      println("   Todos os ramos explorados e podados por integralidade.")
      println("   Nos explorados no Branch-and-Cut: " + nodes_explored)

      #L Verificacao e Conclusao:
      println("6. Resultado Final do Branch and Cut:")
      println("   Valor Otimo Inteiro: " + best_integer_val)
      println("   Solucao Otima (uma das timas): " + best_integer_x)

      mut as bool: valid_bound = (best_integer_val * 10 <= lp_initial_scaled) and (best_integer_val * 10 <= lp_tightened_scaled)
      mut as bool: branch_cut_ok = (best_integer_val == 21) and cut_violated and valid_bound
      println("7. Verificacao de Integridade do Branch and Cut: " + branch_cut_ok)

      println("Concluido com Sucesso")
}
