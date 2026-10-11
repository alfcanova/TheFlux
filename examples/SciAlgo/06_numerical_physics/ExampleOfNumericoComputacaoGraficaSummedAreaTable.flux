#L ============================================================================
#L Algoritmo: Summed Area Table (SAT)
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaSummedAreaTable) {
      println("==================================================")
      println("  SciAlgo: Summed Area Table (SAT)")
      println("==================================================")

      mut as list of int64: arr = [3, 1, 4, 1, 5, 9]
      mut as list of int64: sat = [3]
      mut as int64: n = listLength(arr)
      mut as int64: i = 2
      infinite (i <= n) {
            mut as int64: prev = sat[i - 1]
            sat = listPushBack(sat, prev + arr[i])
            i = i + 1
      }
      mut as int64: query_sum = sat[5] - sat[1]

      println("1. Soma de sub-regiao consultada via SAT O(1): " + query_sum)
      println("2. Summed Area Table (SAT) concluido com sucesso.")
}
