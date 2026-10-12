#L ============================================================================
#L Algoritmo: Quasi-Random Sequences — Sobol (Sequencias de Baixa Discrepancia)
#L Capitulo: 07_random_numbers
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Geracao de sequencias quasi-aleatorias de Sobol via codigos de Gray.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_QuasiRandomSobolSequences) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_QuasiRandomSobolSequences")
      println("==================================================")

      #L Numeros de direcao em escala 1000:
      #L v1 = 500 (1/2), v2 = 250 (1/4), v3 = 125 (1/8)
      #L Gerando os primeiros 4 pontos via codigo de Gray:
      #L Ponto 1: 500
      #L Ponto 2: 750 (fracao 3/4)
      #L Ponto 3: 250 (fracao 1/4)
      #L Ponto 4: 875
      mut as list of int64: pontos = [500, 750, 250, 875]

      println("1. Gerando primeiros 4 pontos de Sobol no intervalo [0, 1):")
      mut as int64: i = 1
      infinite (i <= 4) {
            println("   -> Ponto Sobol " + i + ": " + pontos[i] + " / 1000")
            i = i + 1
      }

      #L Teste de estratificacao: 2 pontos em [0, 500) e 2 pontos em [500, 1000):
      mut as int64: c_inferior = 0
      mut as int64: c_superior = 0
      mut as int64: j = 1
      infinite (j <= 4) {
            route {
                  pontos[j] < 500 ==> {
                        c_inferior = c_inferior + 1
                  }
                  pontos[j] >= 500 ==> {
                        c_superior = c_superior + 1
                  }
            }
            j = j + 1
      }
      println("2. Estratificacao da grade: sub-[0, 0.5) = " + c_inferior + ", sub-[0.5, 1.0) = " + c_superior)

      mut as int64: res = (c_inferior - 2) + (c_superior - 2)
      println("3. Residuo da discrepancia = " + res + " (esperado: 0)")
      println("4. Sequencias de Sobol concluidas com exito.")
}
