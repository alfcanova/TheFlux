#L ============================================================================
#L Algoritmo: Karatsuba Multiplication (Divisao e Conquista)
#L Dominio: 01_foundations / Algoritmos Especiais
#L Complexidade: O(n^1.585) tempo | O(log n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisKaratsuba) {
      println("==================================================")
      println("  SciAlgo: Karatsuba Multiplication               ")
      println("==================================================")

      mut as int64: x = 1234
      mut as int64: y = 5678
      println("1. Multiplicandos: x = " + x + " | y = " + y)

      #L Decomposicao na base m = 100
      mut as int64: m = 100
      mut as int64: x1 = x /i m
      mut as int64: x0 = x /r m
      mut as int64: y1 = y /i m
      mut as int64: y0 = y /r m

      #L As 3 multiplicacoes de Karatsuba
      mut as int64: z2 = x1 * y1
      mut as int64: z0 = x0 * y0
      mut as int64: z1 = (x1 + x0) * (y1 + y0) - z2 - z0

      #L Recombinacao: z2 * m^2 + z1 * m + z0
      mut as int64: produto_karatsuba = z2 * (m * m) + z1 * m + z0
      mut as int64: produto_direto = x * y

      println("2. Subprodutos: z2=" + z2 + ", z1=" + z1 + ", z0=" + z0)
      println("3. Produto Karatsuba: " + produto_karatsuba)
      println("4. Produto Direto:    " + produto_direto)

      mut as bool: ok = (produto_karatsuba == produto_direto and produto_karatsuba == 7006652)
      println("5. Validacao (7006652): " + ok)
      println("==================================================")
}
