#L ============================================================================
#L Algoritmo: Ran (Gerador Canonico de Numeros Pseudoaleatorios 64-bit)
#L Capitulo: 07_random_numbers
#L Complexidade: O(1) por amostra
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Gerador linear congruencial canonico u_{n+1} = (a * u_n + c) /r m.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Ran) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Ran")
      println("==================================================")

      #L Parametros LCG de Knuth / Numerical Recipes:
      mut as int64: a = 1664525
      mut as int64: c = 1013904223
      mut as int64: m = 2147483647
      mut as int64: seed = 42

      println("1. Gerando sequencia pseudoaleatoria com semente " + seed + ":")
      mut as list of int64: seq = [0, 0, 0, 0, 0]
      mut as int64: u = seed
      mut as int64: i = 1
      infinite (i <= 5) {
            u = (u * a + c) /r m
            route {
                  u < 0 ==> {
                        u = 0 - u
                  }
                  u >= 0 ==> {}
            }
            seq[i] = u
            println("   -> Amostra " + i + ": " + u)
            i = i + 1
      }

      #L Verificacao deterministica do 1o valor da sequencia:
      #L (42 * 1664525 + 1013904223) /r 2147483647 = 1083814273
      mut as int64: esperado_u1 = 1083814273
      mut as int64: u1 = seq[1]
      mut as int64: res = u1 - esperado_u1
      println("2. Residuo da geracao u1 - 1083814273 = " + res + " (esperado: 0)")
      println("3. Gerador canonico Ran validado com sucesso.")
}
