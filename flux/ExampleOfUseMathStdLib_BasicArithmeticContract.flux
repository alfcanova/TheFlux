#L Exemplo de Uso: BasicArithmeticContract (Aritmetica Basica Multi-Bit)
use MathStdLib as M

program (ExampleOfUseMathStdLib_BasicArithmeticContract) {
      print("==================================================")
      print("  Exemplo: BasicArithmeticContract (64, 32, 16)   ")
      print("==================================================")
      print("--- Adicao ---")
      print("add64(100, 25): " + ((add64(100, 25)).val as string))
      print("add32(100, 25): " + ((add32(100 as int32, 25 as int32)).val as string))
      print("add16(100, 25): " + ((add16(100 as int16, 25 as int16)).val as string))

      print("--- Subtracao ---")
      print("subtract64(100, 25): " + ((subtract64(100, 25)).val as string))
      print("subtract32(100, 25): " + ((subtract32(100 as int32, 25 as int32)).val as string))
      print("subtract16(100, 25): " + ((subtract16(100 as int16, 25 as int16)).val as string))

      print("--- Multiplicacao ---")
      print("multiply64(12, 12): " + ((multiply64(12, 12)).val as string))
      print("multiply32(12, 12): " + ((multiply32(12 as int32, 12 as int32)).val as string))
      print("multiply16(12, 12): " + ((multiply16(12 as int16, 12 as int16)).val as string))

      print("--- Resto da Divisao ---")
      print("remainder64(100, 7): " + ((remainder64(100, 7)).val as string))
      print("remainder32(100, 7): " + ((remainder32(100 as int32, 7 as int32)).val as string))
      print("remainder16(100, 7): " + ((remainder16(100 as int16, 7 as int16)).val as string))

      print("--- Divisao Inteira ---")
      print("divideInt64(100, 7): " + ((divideInt64(100, 7)).val as string))
      print("divideInt32(100, 7): " + ((divideInt32(100 as int32, 7 as int32)).val as string))
      print("divideInt16(100, 7): " + ((divideInt16(100 as int16, 7 as int16)).val as string))

      print("--- Divisao Flutuante ---")
      print("divideFloat64(100.0, 8.0): " + ((divideFloat64(100.0, 8.0)).val as string))
      print("divideFloat32(100.0, 8.0): " + ((divideFloat32(100.0 as float32, 8.0 as float32)).val as string))
      print("divideFloat16(100.0, 8.0): " + ((divideFloat16(100.0 as float16, 8.0 as float16)).val as string))

      print("--- Potencia & Raiz ---")
      print("power64(2.0, 10.0): " + ((power64(2.0, 10.0)).val as string))
      print("power32(2.0, 10.0): " + ((power32(2.0 as float32, 10.0 as float32)).val as string))
      print("power16(2.0, 10.0): " + ((power16(2.0 as float16, 10.0 as float16)).val as string))
      print("root64(3.0, 27.0): " + ((root64(3.0, 27.0)).val as string))
      print("root32(3.0, 27.0): " + ((root32(3.0 as float32, 27.0 as float32)).val as string))
      print("root16(3.0, 27.0): " + ((root16(3.0 as float16, 27.0 as float16)).val as string))

      print("--- Negacao ---")
      print("negate64(42): " + ((negate64(42)).val as string))
      print("negate32(42): " + ((negate32(42 as int32)).val as string))
      print("negate16(42): " + ((negate16(42 as int16)).val as string))
      print("==================================================")
}
