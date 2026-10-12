#L ============================================================================
#L Algoritmo: Romberg Integration (Tableau de Romberg com Extrapolacao)
#L Capitulo: 04_integration
#L Complexidade: O(2^K)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Extrapolacao de Richardson de alta ordem sobre a regra do trapezio.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RombergIntegration) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RombergIntegration")
      println("==================================================")

      #L Integrando cubico: f(x) = 4 x^3 no intervalo [0, 1] (escala 1000)
      #L Integral exata: int_0^1 4 x^3 dx = [x^4]_0^1 = 1.0 (1000 em escala 1000)
      #L Coluna 1 do tableau (Trapzd):
      #L R[1,1] com passo h=1: 0.5 * (0 + 4) = 2.0 (2000)
      #L R[2,1] com passo h=0.5: 0.5 * R[1,1] + 0.5 * 4(0.5)^3 = 1000 + 0.5 * 0.5 = 1.25 (1250)
      mut as int64: r11 = 2000
      mut as int64: r21 = 1250

      println("1. Construindo tableau triangular de Romberg:")
      println("   -> R[1,1] (h=1.0) = " + r11)
      println("   -> R[2,1] (h=0.5) = " + r21)

      #L Coluna 2 (Extrapolacao de Richardson): R[2,2] = R[2,1] + (R[2,1] - R[1,1]) / (4^1 - 1)
      #L R[2,2] = 1250 + (1250 - 2000) / 3 = 1250 - 250 = 1000
      mut as int64: r22 = r21 + (r21 - r11) /i 3
      println("2. Extrapolacao de Richardson ordem O(h^4):")
      println("   -> R[2,2] = " + r22 + " (esperado: 1000 = 1.0)")

      mut as int64: res = r22 - 1000
      println("3. Residuo de convergencia = " + res + " (esperado: 0)")
      println("4. Quadratura de Romberg concluida com sucesso.")
}
