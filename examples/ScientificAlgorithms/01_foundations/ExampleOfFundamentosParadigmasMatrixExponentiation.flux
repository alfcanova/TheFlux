#L ============================================================================
#L Algoritmo: Matrix Exponentiation (Exponenciacao de Matrizes para Recorrencias)
#L Dominio: 01_foundations / Fundamentos e Paradigmas
#L Complexidade: O(m^3 * log n) tempo | O(m^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasMatrixExponentiation) {
      println("==================================================")
      println("  SciAlgo: Matrix Exponentiation Paradigm         ")
      println("==================================================")

      #L Calcula o 10o termo de Fibonacci F(10) via [[1,1],[1,0]]^(9)
      mut as int64: n = 10
      println("1. Alvo de Recorrencia: Fibonacci F(" + n + ")")

      #L Matriz identidade I 2x2: [a, b, c, d]
      mut as int64: res_a = 1
      mut as int64: res_b = 0
      mut as int64: res_c = 0
      mut as int64: res_d = 1

      #L Matriz base M = [[1, 1], [1, 0]]
      mut as int64: base_a = 1
      mut as int64: base_b = 1
      mut as int64: base_c = 1
      mut as int64: base_d = 0

      mut as int64: p = n - 1

      infinite (p > 0) {
            route {
                  p /r 2 == 1 ==> {
                        #L res = res * base
                        mut as int64: na = res_a * base_a + res_b * base_c
                        mut as int64: nb = res_a * base_b + res_b * base_d
                        mut as int64: nc = res_c * base_a + res_d * base_c
                        mut as int64: nd = res_c * base_b + res_d * base_d
                        res_a = na
                        res_b = nb
                        res_c = nc
                        res_d = nd
                  }
            }

            #L base = base * base
            mut as int64: ba = base_a * base_a + base_b * base_c
            mut as int64: bb = base_a * base_b + base_b * base_d
            mut as int64: bc = base_c * base_a + base_d * base_c
            mut as int64: bd = base_c * base_b + base_d * base_d
            base_a = ba
            base_b = bb
            base_c = bc
            base_d = bd

            p = p /i 2
      }

      #L F(10) = res_a * F(1) + res_b * F(0) = res_a * 1 + res_b * 0 = res_a
      mut as int64: fib10 = res_a
      println("2. F(10) Calculado via Exponenciacao de Matriz: " + fib10)
      mut as bool: ok = (fib10 == 55)
      println("3. Validacao (F(10) esperado == 55): " + ok)
      println("==================================================")
}
