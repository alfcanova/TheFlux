#L Exemplo de Uso: RootsAndRoundingContract (Raizes & Arredondamento)
use MathStdLib as M

program (ExampleOfUseMathStdLib_RootsAndRoundingContract) {
      print("==================================================")
      print("  Exemplo: RootsAndRoundingContract (64, 32, 16)  ")
      print("==================================================")
      print("--- Raiz Quadrada ---")
      print("squareRoot64(2.0): " + ((squareRoot64(2.0)).val as string))
      print("squareRoot32(2.0): " + ((squareRoot32(2.0 as float32)).val as string))
      print("squareRoot16(2.0): " + ((squareRoot16(2.0 as float16)).val as string))

      print("--- Raiz Quadrada Inteira ---")
      print("integerSquareRoot64(1000): " + ((integerSquareRoot64(1000)).val as string))
      print("integerSquareRoot32(1000): " + ((integerSquareRoot32(1000 as int32)).val as string))
      print("integerSquareRoot16(1000): " + ((integerSquareRoot16(1000 as int16)).val as string))

      print("--- Raiz Cubica ---")
      print("cubeRoot64(27.0): " + ((cubeRoot64(27.0)).val as string))
      print("cubeRoot32(-27.0): " + ((cubeRoot32(-27.0 as float32)).val as string))
      print("cubeRoot16(27.0): " + ((cubeRoot16(27.0 as float16)).val as string))

      print("--- Piso (Floor) ---")
      print("floor64(3.7): " + ((floor64(3.7)).val as string))
      print("floor32(3.7): " + ((floor32(3.7 as float32)).val as string))
      print("floor16(3.7): " + ((floor16(3.7 as float16)).val as string))

      print("--- Teto (Ceil) ---")
      print("ceil64(3.2): " + ((ceil64(3.2)).val as string))
      print("ceil32(3.2): " + ((ceil32(3.2 as float32)).val as string))
      print("ceil16(3.2): " + ((ceil16(3.2 as float16)).val as string))

      print("--- Arredondamento (Round) ---")
      print("round64(3.5): " + ((round64(3.5)).val as string))
      print("round32(3.5): " + ((round32(3.5 as float32)).val as string))
      print("round16(3.5): " + ((round16(3.5 as float16)).val as string))

      print("--- Arredondamento para Inteiro ---")
      print("roundToInt64(4.9): " + ((roundToInt64(4.9)).val as string))
      print("roundToInt32(4.9): " + ((roundToInt32(4.9 as float32)).val as string))
      print("roundToInt16(4.9): " + ((roundToInt16(4.9 as float16)).val as string))

      print("--- Truncamento (Truncate) ---")
      print("truncate64(-3.9): " + ((truncate64(-3.9)).val as string))
      print("truncate32(3.9): " + ((truncate32(3.9 as float32)).val as string))
      print("truncate16(-3.9): " + ((truncate16(-3.9 as float16)).val as string))
      print("==================================================")
}
