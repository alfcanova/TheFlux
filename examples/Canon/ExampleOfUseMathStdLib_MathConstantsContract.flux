#L Exemplo de Uso: MathConstantsContract (Constantes Matematicas Multi-Bit)
use MathStdLib as M

program (ExampleOfUseMathStdLib_MathConstantsContract) {
      println("==================================================")
      println("  Exemplo: MathConstantsContract (64, 32, 16 bits)")
      println("==================================================")

      #L 1. Pi, E, Tau
      println("1. Pi, E, Tau:")
      println("   pi64: " + pi64())
      println("   pi32: " + pi32())
      println("   pi16: " + pi16())
      println("   e64: " + e64())
      println("   e32: " + e32())
      println("   e16: " + e16())
      println("   tau64: " + tau64())
      println("   tau32: " + tau32())
      println("   tau16: " + tau16())

      #L 2. Raizes e Inversas
      println("2. Raizes e Inversas:")
      println("   sqrt2: " + sqrt2_64() + ", " + sqrt2_32() + ", " + sqrt2_16())
      println("   sqrt3: " + sqrt3_64() + ", " + sqrt3_32() + ", " + sqrt3_16())
      println("   invSqrt2: " + invSqrt2_64() + ", " + invSqrt2_32() + ", " + invSqrt2_16())
      println("   invSqrt3: " + invSqrt3_64() + ", " + invSqrt3_32() + ", " + invSqrt3_16())

      #L 3. Logaritmos Constantes
      println("3. Logaritmos:")
      println("   ln2: " + ln2_64() + ", " + ln2_32() + ", " + ln2_16())
      println("   ln10: " + ln10_64() + ", " + ln10_32() + ", " + ln10_16())
      println("   log2e: " + log2e64() + ", " + log2e32() + ", " + log2e16())
      println("   log10e: " + log10e64() + ", " + log10e32() + ", " + log10e16())

      #L 4. Fracoes de Pi, Inversa de Pi e Proporcao Aurea (Phi)
      println("4. Geometria e Aurea:")
      println("   pi_2: " + pi_2_64() + ", " + pi_2_32() + ", " + pi_2_16())
      println("   pi_4: " + pi_4_64() + ", " + pi_4_32() + ", " + pi_4_16())
      println("   invPi: " + invPi64() + ", " + invPi32() + ", " + invPi16())
      println("   phi: " + phi64() + ", " + phi32() + ", " + phi16())
}
