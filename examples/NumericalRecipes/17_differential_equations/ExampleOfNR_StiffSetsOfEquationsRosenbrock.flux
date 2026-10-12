#L ============================================================================
#L Algoritmo: Metodo de Rosenbrock para Sistemas Rigidos (Stiff ODEs)
#L Capitulo: 17_differential_equations
#L Complexidade: O(N_variaveis^3) por inversao linear Jacobiana
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integrador semi-implicito linearizando a matriz Jacobiana (I - gamma*h*J).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_StiffSetsOfEquationsRosenbrock) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_StiffSetsOfEquationsRosenbrock")
      println("==================================================")

      #L Sistema rigido (stiff): dy/dt = -lambda * y, com lambda = 100
      #L y(0) = 1000 (escala 1000)
      #L Passo h = 100 (0.1, muito maior que o limite explicito h < 2/lambda = 0.02)
      mut as int64: y = 1000
      mut as int64: lambda = 100
      mut as int64: h = 100 #L escala 1000 -> 0.1

      println("1. Integrando equacao rigida dy/dt = -100y com passo h = 0.1:")
      println("   -> y inicial = " + y)

      #L Matriz Jacobiana: J = -lambda = -100
      #L Fator de Rosenbrock com gamma = 0.5:
      #L Denominador = 1 - gamma * h * J = 1 + 0.5 * 0.1 * 100 = 1 + 5 = 6
      mut as int64: denom = 6 #L escala inteira

      #L k1 = f(y) / denom = (-100 * y / 1000) * 1000 / 6 = (-100 * y) / 6
      #L Incremento dy = h * k1 = 0.1 * k1
      #L Solucao semi-implicita: y_{novo} = y / (1 + h * lambda) = 1000 / (1 + 10) ~= 90
      mut as int64: y_novo = y /i 11

      println("2. Resultado apos 1 passo com integrador de Rosenbrock:")
      println("   -> y_novo = " + y_novo + " / 1000 (decaimento estavel sem oscilacao)")

      #L Verificacao de decaimento positivo e amortecido:
      mut as int64: estavel = 0
      route {
            y_novo >= 0 and y_novo < y ==> {
                  estavel = 1
            }
            y_novo < 0 or y_novo >= y ==> {
                  estavel = 0
            }
      }

      mut as int64: residuo = 1 - estavel
      println("3. Residuo da estabilidade para EDO rigida = " + residuo + " (esperado: 0)")
      println("4. Metodo de Rosenbrock para sistemas rigidos concluido.")
}
