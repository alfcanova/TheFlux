#L Exemplo de Uso: SpecialFunctionsContract (Especiais, IEEE & Estatistica)
use MathStdLib as M

program (ExampleOfUseMathStdLib_SpecialFunctionsContract) {
      println("==================================================")
      println("  Exemplo: SpecialFunctionsContract (64, 32, 16)  ")
      println("==================================================")

      #L 1. Funcao de Erro (erf, erfc, erfinv)
      println("1. Funcao de Erro:")
      println("   errorFunction: " + errorFunction64(1.0) + ", " + errorFunction32(1.0 as float32) + ", " + errorFunction16(1.0 as float16))
      println("   erfc: " + erfc64(1.0) + ", " + erfc32(1.0 as float32) + ", " + erfc16(1.0 as float16))
      println("   erfinv: " + erfinv64(0.5) + ", " + erfinv32(0.5 as float32) + ", " + erfinv16(0.5 as float16))

      #L 2. Funcoes Gamma, LogGamma, Digamma, Beta e LogBeta
      println("2. Gamma e Beta:")
      println("   gamma: " + gammaFunction64(5.0) + ", " + gammaFunction32(5.0 as float32) + ", " + gammaFunction16(5.0 as float16))
      println("   logGamma: " + logGamma64(5.0) + ", " + logGamma32(5.0 as float32) + ", " + logGamma16(5.0 as float16))
      println("   digamma: " + digamma64(2.0) + ", " + digamma32(2.0 as float32) + ", " + digamma16(2.0 as float16))
      println("   beta: " + beta64(2.0, 3.0) + ", " + beta32(2.0 as float32, 3.0 as float32) + ", " + beta16(2.0 as float16, 3.0 as float16))
      println("   logBeta: " + logBeta64(2.0, 3.0) + ", " + logBeta32(2.0 as float32, 3.0 as float32) + ", " + logBeta16(2.0 as float16, 3.0 as float16))

      #L 3. Distribuicao Normal e Sigmoide
      println("3. Normal e Sigmoide:")
      println("   sigmoid: " + sigmoid64(0.0) + ", " + sigmoid32(0.0 as float32) + ", " + sigmoid16(0.0 as float16))
      println("   normalCdf: " + normalCdf64(0.0) + ", " + normalCdf32(0.0 as float32) + ", " + normalCdf16(0.0 as float16))

      #L 4. Funcoes de Bessel J0 e J1
      println("4. Bessel J0 e J1:")
      println("   besselJ0: " + besselJ0_64(0.0) + ", " + besselJ0_32(0.0 as float32) + ", " + besselJ0_16(0.0 as float16))
      println("   besselJ1: " + besselJ1_64(0.0) + ", " + besselJ1_32(0.0 as float32) + ", " + besselJ1_16(0.0 as float16))

      #L 5. Operacoes IEEE 754 e Ponto Flutuante
      println("5. IEEE 754:")
      println("   ulp: " + ulp64(1.0) + ", " + ulp32(1.0 as float32) + ", " + ulp16(1.0 as float16))
      println("   fract: " + fract64(3.14159) + ", " + fract32(3.14159 as float32) + ", " + fract16(3.14159 as float16))
      println("   wrapAngle: " + wrapAngle64(7.0) + ", " + wrapAngle32(7.0 as float32) + ", " + wrapAngle16(7.0 as float16))
      println("   fdim: " + fdim64(4.0, 1.0) + ", " + fdim32(4.0 as float32, 1.0 as float32) + ", " + fdim16(4.0 as float16, 1.0 as float16))
      println("   signbit: " + signbit64(-5.0) + ", " + signbit32(-5.0 as float32) + ", " + signbit16(-5.0 as float16))
      println("   nextRepresentable: " + nextRepresentable64(1.0, 2.0) + ", " + nextRepresentable32(1.0 as float32, 2.0 as float32) + ", " + nextRepresentable16(1.0 as float16, 2.0 as float16))
      println("   ldexp: " + ldexp64(1.5, 3) + ", " + ldexp32(1.5 as float32, 3) + ", " + ldexp16(1.5 as float16, 3))
      println("   isCloseTo: " + isCloseTo64(1.0, 1.0001) + ", " + isCloseTo32(1.0 as float32, 1.001 as float32) + ", " + isCloseTo16(1.0 as float16, 1.01 as float16))
      println("   copySign: " + copySign64(5.0, -1.0) + ", " + copySign32(5.0 as float32, -1.0 as float32) + ", " + copySign16(5.0 as float16, -1.0 as float16))
      println("   fusedMultiplyAdd: " + fusedMultiplyAdd64(2.0, 3.0, 4.0) + ", " + fusedMultiplyAdd32(2.0 as float32, 3.0 as float32, 4.0 as float32) + ", " + fusedMultiplyAdd16(2.0 as float16, 3.0 as float16, 4.0 as float16))

      #L 6. Interpolacao e Mapeamento
      println("6. Interpolacao:")
      println("   smoothstep: " + smoothstep64(0.0, 10.0, 5.0) + ", " + smoothstep32(0.0 as float32, 10.0 as float32, 5.0 as float32) + ", " + smoothstep16(0.0 as float16, 10.0 as float16, 5.0 as float16))
      println("   smootherstep: " + smootherstep64(0.0, 10.0, 5.0) + ", " + smootherstep32(0.0 as float32, 10.0 as float32, 5.0 as float32) + ", " + smootherstep16(0.0 as float16, 10.0 as float16, 5.0 as float16))
      println("   mapRange: " + mapRange64(5.0, 0.0, 10.0, 100.0, 200.0) + ", " + mapRange32(5.0 as float32, 0.0 as float32, 10.0 as float32, 100.0 as float32, 200.0 as float32) + ", " + mapRange16(5.0 as float16, 0.0 as float16, 10.0 as float16, 100.0 as float16, 200.0 as float16))
      println("   inverseLinearInterpolation: " + inverseLinearInterpolation64(0.0, 10.0, 5.0) + ", " + inverseLinearInterpolation32(0.0 as float32, 10.0 as float32, 5.0 as float32) + ", " + inverseLinearInterpolation16(0.0 as float16, 10.0 as float16, 5.0 as float16))
}
