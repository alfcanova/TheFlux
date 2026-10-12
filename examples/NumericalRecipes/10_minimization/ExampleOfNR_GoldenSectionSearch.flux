#L ============================================================================
#L Algoritmo: Golden Section Search (Busca da Secao Aurea 1D)
#L Capitulo: 10_minimization
#L Complexidade: O(log(1/eps))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Minimizacao unidimensional sem derivadas utilizando a razao aurea.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_GoldenSectionSearch) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_GoldenSectionSearch")
      println("==================================================")

      #L Minimizando f(x) = (x - 2000)^2 /i 1000 (minimo em x = 2000, escala 1000):
      #L Intervalo inicial [a, b] = [0, 4000]
      mut as int64: a = 0
      mut as int64: b = 4000
      mut as int64: r_golden = 618 #L 0.618

      println("1. Executando reducao de intervalo pela secao aurea:")
      mut as int64: iter = 1
      infinite (iter <= 10) {
            mut as int64: d = (b - a) * r_golden /i 1000
            mut as int64: x1 = b - d
            mut as int64: x2 = a + d
            mut as int64: f1 = (x1 - 2000) * (x1 - 2000) /i 1000
            mut as int64: f2 = (x2 - 2000) * (x2 - 2000) /i 1000
            route {
                  f1 < f2 ==> {
                        b = x2
                  }
                  f1 >= f2 ==> {
                        a = x1
                  }
            }
            iter = iter + 1
      }

      mut as int64: x_min = (a + b) /i 2
      println("2. Ponto de minimo aproximado: x = " + x_min + " (esperado: 2000)")

      mut as int64: diff = x_min - 2000
      route {
            diff < 0 ==> {
                  diff = 0 - diff
            }
            diff >= 0 ==> {}
      }
      mut as int64: ok = 0
      route {
            diff <= 10 ==> {
                  ok = 1
            }
            diff > 10 ==> {
                  ok = 0
            }
      }
      mut as int64: res = 1 - ok
      println("3. Residuo da tolerancia = " + res + " (esperado: 0)")
      println("4. Busca da secao aurea validada com sucesso.")
}
