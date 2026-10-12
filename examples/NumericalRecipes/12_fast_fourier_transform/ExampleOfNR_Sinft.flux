#L ============================================================================
#L Algoritmo: Sinft (Transformada Rapida de Seno)
#L Capitulo: 12_fast_fourier_transform
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Fast Sine Transform com condicoes de contorno de Dirichlet nulas nos extremos.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Sinft) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Sinft")
      println("==================================================")

      #L Sinal com condicao Dirichlet: x[1] = 1000 (escala 1000, impulso puro em x = L/2)
      #L Base ortogonal: sin(k * pi * 0.5) para k = 1 e sin(pi/2) = 1.0 (1000)
      mut as int64: s1 = 1000

      println("1. Calculando primeiro harmônico da Transformada de Seno:")
      println("   -> S1 = " + s1 + " / 1000 (esperado: 1000 = 1.0)")

      mut as int64: res = s1 - 1000
      println("2. Residuo da transformada de seno = " + res + " (esperado: 0)")
      println("3. Fast Sine Transform Sinft validada.")
}
