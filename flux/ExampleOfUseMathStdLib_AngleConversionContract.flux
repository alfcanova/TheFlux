#L Exemplo de Uso: AngleConversionContract (6 Caminhos de Conversao em 64, 32 e 16 bits)
use MathStdLib as M

program (ExampleOfUseMathStdLib_AngleConversionContract) {
      print("==================================================")
      print("  Exemplo: AngleConversionContract (6 Caminhos)   ")
      print("==================================================")
      print("1. Graus -> Radianos:")
      print("degreesToRadians64(180.0): " + ((degreesToRadians64(180.0)).val as string))
      print("degreesToRadians32(180.0): " + ((degreesToRadians32(180.0 as float32)).val as string))
      print("degreesToRadians16(180.0): " + ((degreesToRadians16(180.0 as float16)).val as string))

      print("2. Grados -> Radianos:")
      print("gradiansToRadians64(200.0): " + ((gradiansToRadians64(200.0)).val as string))
      print("gradiansToRadians32(200.0): " + ((gradiansToRadians32(200.0 as float32)).val as string))
      print("gradiansToRadians16(200.0): " + ((gradiansToRadians16(200.0 as float16)).val as string))

      print("3. Radianos -> Graus:")
      print("radiansToDegrees64(PI64): " + ((radiansToDegrees64(PI64)).val as string))
      print("radiansToDegrees32(PI32): " + ((radiansToDegrees32(PI32)).val as string))
      print("radiansToDegrees16(PI16): " + ((radiansToDegrees16(PI16)).val as string))

      print("4. Grados -> Graus:")
      print("gradiansToDegrees64(200.0): " + ((gradiansToDegrees64(200.0)).val as string))
      print("gradiansToDegrees32(100.0): " + ((gradiansToDegrees32(100.0 as float32)).val as string))
      print("gradiansToDegrees16(100.0): " + ((gradiansToDegrees16(100.0 as float16)).val as string))

      print("5. Radianos -> Grados:")
      print("radiansToGradians64(PI64): " + ((radiansToGradians64(PI64)).val as string))
      print("radiansToGradians32(PI32): " + ((radiansToGradians32(PI32)).val as string))
      print("radiansToGradians16(PI16): " + ((radiansToGradians16(PI16)).val as string))

      print("6. Graus -> Grados:")
      print("degreesToGradians64(180.0): " + ((degreesToGradians64(180.0)).val as string))
      print("degreesToGradians32(90.0): " + ((degreesToGradians32(90.0 as float32)).val as string))
      print("degreesToGradians16(90.0): " + ((degreesToGradians16(90.0 as float16)).val as string))
      print("==================================================")
}
