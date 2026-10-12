#L ============================================================================
#L Algoritmo: Searching an Ordered Table (Busca Binaria e Hunt em Tabela Ordenada)
#L Capitulo: 03_interpolation
#L Complexidade: O(log N) bissecao, O(1) hunt local
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Localizacao de intervalo de interpolacao em grade ordenada.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SearchingOrderedTable) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SearchingOrderedTable")
      println("==================================================")

      #L Tabela ordenada de 7 nos: xx = [10, 20, 30, 40, 50, 60, 70]
      mut as list of int64: xx = [10, 20, 30, 40, 50, 60, 70]
      mut as int64: n = 7
      mut as int64: x_query = 35

      println("1. Executando busca binaria de intervalo para x = " + x_query + ":")
      mut as int64: jl = 1
      mut as int64: ju = n

      infinite ((ju - jl) > 1) {
            mut as int64: jm = (ju + jl) /i 2
            route {
                  x_query >= xx[jm] ==> {
                        jl = jm
                  }
                  x_query < xx[jm] ==> {
                        ju = jm
                  }
            }
      }

      println("2. Intervalo delimitador localizado:")
      println("   -> Indice inferior jl = " + jl + " (xx[jl] = " + xx[jl] + ")")
      println("   -> Indice superior ju = " + ju + " (xx[ju] = " + xx[ju] + ")")

      #L Verificacao de intervalo: xx[jl] <= 35 < xx[ju] (30 <= 35 < 40)
      mut as int64: ok_range = 0
      route {
            x_query >= xx[jl] and x_query < xx[ju] ==> {
                  ok_range = 1
            }
      }
      println("3. Consistencia do intervalo = " + ok_range + " (esperado: 1)")
      println("4. Localizacao em tabela ordenada concluida com exito.")
}
