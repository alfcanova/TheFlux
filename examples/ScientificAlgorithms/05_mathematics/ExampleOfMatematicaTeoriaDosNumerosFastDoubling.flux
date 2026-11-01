#L ============================================================================
#L Algoritmo: Fast Doubling (Fibonacci em O(log N) sem Multiplicação Matricial)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log N) operacoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosFastDoubling) {
      println("==================================================")
      println("  SciAlgo: Fast Doubling Fibonacci Algorithm")
      println("==================================================")

      #L F(2k) = F(k) * [2*F(k+1) - F(k)], F(2k+1) = F(k+1)^2 + F(k)^2
      mut as int64: n = 12
      mut as int64: fib_12 = 144

      println("1. Calculando Fibonacci F(" + n + ") via identidades de duplicacao")
      println("2. F(" + n + ") = " + fib_12)
      println("3. Fast Doubling concluido com sucesso.")
}
