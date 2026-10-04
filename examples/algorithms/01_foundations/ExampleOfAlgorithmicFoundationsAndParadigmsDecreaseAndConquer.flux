#L ============================================================================
#L Algoritmo: Decrease and Conquer (Diminuicao e Conquista)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(log B) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsDecreaseAndConquer) {
      println("==================================================")
      println("  SciAlgo: Decrease and Conquer (Diminuicao e Conquista)")
      println("==================================================")

      #L Caso 1: Exponenciacao Binaria (Diminuicao por Fator Constante = 2)
      mut as int64: base = 3
      mut as int64: exp = 13
      println("1. Exponenciacao Rapida: " + base + "^" + exp)

      mut as int64: result_pow = 1
      mut as int64: current_base = base
      mut as int64: current_exp = exp
      mut as int64: pow_steps = 0

      infinite (current_exp > 0) {
            pow_steps = pow_steps + 1
            mut as int64: rem = current_exp /r 2
            route {
                  rem == 1 ==> {
                        result_pow = result_pow * current_base
                  }
                  _ ==> {
                  }
            }
            current_base = current_base * current_base
            current_exp = current_exp /i 2
      }
      println("2. Passos de reducao (O(log N)): " + pow_steps)
      println("3. Resultado 3^13: " + result_pow)

      #L Caso 2: Multiplicacao Camponesa Russa (Diminuicao por 2 e Dobra)
      mut as int64: a = 37
      mut as int64: b = 45
      println("4. Multiplicacao Russa: " + a + " * " + b)

      mut as int64: prod = 0
      mut as int64: ca = a
      mut as int64: cb = b
      mut as int64: mult_steps = 0

      infinite (ca > 0) {
            mult_steps = mult_steps + 1
            mut as int64: r_bit = ca /r 2
            route {
                  r_bit == 1 ==> {
                        prod = prod + cb
                  }
                  _ ==> {
                  }
            }
            ca = ca /i 2
            cb = cb * 2
      }
      println("5. Passos da multiplicacao camponesa: " + mult_steps)
      println("6. Produto obtido: " + prod)
      println("Concluido com Sucesso")
}
