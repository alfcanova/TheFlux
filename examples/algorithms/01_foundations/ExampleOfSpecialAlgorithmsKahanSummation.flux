#L ============================================================================
#L Algoritmo: Kahan Summation (Soma Compensada de William Kahan 1965)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(N) tempo | O(1) espaco auxiliar com compensacao de erro
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSpecialAlgorithmsKahanSummation) {
      println("==================================================")
      println("  SciAlgo: Kahan Summation Algorithm")
      println("==================================================")

      #L Simulacao de soma com perda de precisao:
      #L Uma sequencia de 10 valores pequenos somados a um acumulador grande
      #L Cada item tem valor base 1000 mais um residuo fracionario truncado
      mut as list of int64: values = [1000000, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      mut as int64: n = listLength(values)

      #L 1. Soma direta ingênua
      mut as int64: naive_sum = 0
      mut as int64: i = 1
      infinite (i <= n) {
            naive_sum = naive_sum + values[i]
            i = i + 1
      }
      println("1. Soma direta acumulada: " + naive_sum)

      #L 2. Algoritmo de Soma Compensada de Kahan
      #L y = input - c
      #L t = sum + y
      #L c = (t - sum) - y
      #L sum = t
      mut as int64: kahan_sum = 0
      mut as int64: c = 0 #L Variavel de compensacao acumulada

      mut as int64: j = 1
      infinite (j <= n) {
            mut as int64: y = values[j] - c
            mut as int64: t = kahan_sum + y
            c = (t - kahan_sum) - y
            kahan_sum = t
            j = j + 1
      }

      println("2. Soma compensada de Kahan: " + kahan_sum)
      println("3. Residuo de compensacao final c: " + c)
      println("4. Validacao: " + (kahan_sum == 1000010 and c == 0))
      println("==================================================")
}
