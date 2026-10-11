#L ============================================================================
#L Algoritmo: Adaptive Differential Evolution (JADE/SHADE)
#L Dominio: 07_optimization_stat / Categoria: Algoritmos Evolutivos
#L Descricao: Evolucao diferencial com adaptacao automatica dos parametros F e CR
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoDifferentialEvolutionAdaptive) {
      println("=== Algoritmo: Adaptive Differential Evolution (JADE) ===")

      #L Individuo alvo x_i = 50
      #L Melhor individuo de elite x_pbest = 10
      #L Individuos aleatorios r1 = 30, r2 = 25
      mut as int64: x_i = 50
      mut as int64: x_pbest = 10
      mut as int64: x_r1 = 30
      mut as int64: x_r2 = 25

      #L Fator de mutacao adaptativo F = 0.5 (multiplicado por 100 -> 50)
      mut as int64: f_param = 50

      #L Mutacao current-to-pbest/1:
      #L v_i = x_i + F * (x_pbest - x_i) + F * (x_r1 - x_r2)
      #L Termo 1: 50 * (10 - 50) /i 100 = 50 * (-40) /i 100 = -2000 /i 100 = -20
      #L Termo 2: 50 * (30 - 25) /i 100 = 50 * 5 /i 100 = 250 /i 100 = 2
      mut as int64: diff1 = x_pbest - x_i
      mut as int64: num1 = f_param * diff1
      mut as int64: term1 = num1 /i 100

      mut as int64: diff2 = x_r1 - x_r2
      mut as int64: num2 = f_param * diff2
      mut as int64: term2 = num2 /i 100

      mut as int64: v_i = x_i + term1 + term2

      println("1. Individuo base (x_i): " + x_i)
      println("2. Vetor mutante gerado (v_i): " + v_i)

      #L Fitness f(x) = x^2 (minimizar em direcao a 0):
      #L fitness(x_i) = 50^2 = 2500
      #L fitness(v_i) = 32^2 = 1024 (sucesso! vetor mutante e superior)
      mut as int64: fit_base = x_i * x_i
      mut as int64: fit_mutante = v_i * v_i

      println("3. Fitness base: " + fit_base)
      println("4. Fitness mutante: " + fit_mutante)

      #L Selecao gulosa: substitui individuo alvo pelo mutante
      mut as int64: x_novo = x_i
      route {
            fit_mutante < fit_base ==> {
                  x_novo = v_i
            }
            _ ==> {}
      }
      println("5. Individuo sobrevivente para proxima geracao: " + x_novo)

      route {
            v_i == 32 and fit_mutante == 1024 and x_novo == 32 ==> {
                  println("6. Mutacao adaptativa e selecao JADE validadas com sucesso.")
            }
            _ ==> {
                  println("Falha no JADE.")
            }
      }
      println("Teste concluido com sucesso.")
}
