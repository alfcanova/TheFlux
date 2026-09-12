#L Exemplo de Uso: FloatElementaryContract (Elementares & Interpolacao)
use MathStdLib as M

program (ExampleOfUseMathStdLib_FloatElementaryContract) {
      print("==================================================")
      print("  Exemplo: FloatElementaryContract (64, 32, 16)   ")
      print("==================================================")
      print("--- Modulo Absoluto Inteiro ---")
      print("absolute64(-42): " + ((absolute64(-42)).val as string))
      print("absolute32(-42): " + ((absolute32(-42 as int32)).val as string))
      print("absolute16(-42): " + ((absolute16(-42 as int16)).val as string))

      print("--- Modulo Absoluto Flutuante ---")
      print("absoluteFloat64(-3.14159): " + ((absoluteFloat64(-3.14159)).val as string))
      print("absoluteFloat32(-3.14159): " + ((absoluteFloat32(-3.14159 as float32)).val as string))
      print("absoluteFloat16(-3.14159): " + ((absoluteFloat16(-3.14159 as float16)).val as string))

      print("--- Sinal ---")
      print("signal64(-55.5): " + ((signal64(-55.5)).val as string))
      print("signal32(55.5): " + ((signal32(55.5 as float32)).val as string))
      print("signal16(-10.0): " + ((signal16(-10.0 as float16)).val as string))

      print("--- Minimo & Maximo Inteiro ---")
      print("minimum64(10, 20): " + ((minimum64(10, 20)).val as string))
      print("minimum32(10, 20): " + ((minimum32(10 as int32, 20 as int32)).val as string))
      print("minimum16(10, 20): " + ((minimum16(10 as int16, 20 as int16)).val as string))
      print("maximum64(10, 20): " + ((maximum64(10, 20)).val as string))
      print("maximum32(10, 20): " + ((maximum32(10 as int32, 20 as int32)).val as string))
      print("maximum16(10, 20): " + ((maximum16(10 as int16, 20 as int16)).val as string))

      print("--- Minimo & Maximo Flutuante ---")
      print("minimumFloat64(3.14, 2.71): " + ((minimumFloat64(3.14, 2.71)).val as string))
      print("minimumFloat32(3.14, 2.71): " + ((minimumFloat32(3.14 as float32, 2.71 as float32)).val as string))
      print("minimumFloat16(3.14, 2.71): " + ((minimumFloat16(3.14 as float16, 2.71 as float16)).val as string))
      print("maximumFloat64(3.14, 2.71): " + ((maximumFloat64(3.14, 2.71)).val as string))
      print("maximumFloat32(3.14, 2.71): " + ((maximumFloat32(3.14 as float32, 2.71 as float32)).val as string))
      print("maximumFloat16(3.14, 2.71): " + ((maximumFloat16(3.14 as float16, 2.71 as float16)).val as string))

      print("--- Limitacao (Constrain / Clamp) ---")
      print("constrain64(15.0, 0.0, 10.0): " + ((constrain64(15.0, 0.0, 10.0)).val as string))
      print("constrain32(15.0, 0.0, 10.0): " + ((constrain32(15.0 as float32, 0.0 as float32, 10.0 as float32)).val as string))
      print("constrain16(15.0, 0.0, 10.0): " + ((constrain16(15.0 as float16, 0.0 as float16, 10.0 as float16)).val as string))

      print("--- Interpolacao Linear (Lerp) ---")
      print("linearInterpolation64(0.0, 100.0, 0.25): " + ((linearInterpolation64(0.0, 100.0, 0.25)).val as string))
      print("linearInterpolation32(0.0, 100.0, 0.75): " + ((linearInterpolation32(0.0 as float32, 100.0 as float32, 0.75 as float32)).val as string))
      print("linearInterpolation16(0.0, 100.0, 0.5): " + ((linearInterpolation16(0.0 as float16, 100.0 as float16, 0.5 as float16)).val as string))
      print("==================================================")
}
