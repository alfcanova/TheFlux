#L Exemplo de Uso: ExponentialLogContract (Exponenciais & Logaritmos)
use MathStdLib as M

program (ExampleOfUseMathStdLib_ExponentialLogContract) {
      print("==================================================")
      print("  Exemplo: ExponentialLogContract (64, 32, 16)    ")
      print("==================================================")
      print("--- Potencia Flutuante ---")
      print("powerFloat64(2.0, 10.0): " + ((powerFloat64(2.0, 10.0)).val as string))
      print("powerFloat32(3.0, 3.0): " + ((powerFloat32(3.0 as float32, 3.0 as float32)).val as string))
      print("powerFloat16(2.0, 5.0): " + ((powerFloat16(2.0 as float16, 5.0 as float16)).val as string))

      print("--- Exponencial Natural (exp) ---")
      print("exp64(1.0): " + ((exp64(1.0)).val as string))
      print("exp32(1.0): " + ((exp32(1.0 as float32)).val as string))
      print("exp16(1.0): " + ((exp16(1.0 as float16)).val as string))

      print("--- Logaritmo Natural (ln / log) ---")
      print("log64(2.718281828459045): " + ((log64(2.718281828459045)).val as string))
      print("log32(E32): " + ((log32(E32)).val as string))
      print("log16(E16): " + ((log16(E16)).val as string))

      print("--- Logaritmo Base 2 (log2) ---")
      print("log2_64(1024.0): " + ((log2_64(1024.0)).val as string))
      print("log2_32(256.0): " + ((log2_32(256.0 as float32)).val as string))
      print("log2_16(64.0): " + ((log2_16(64.0 as float16)).val as string))

      print("--- Logaritmo Base 10 (log10) ---")
      print("log10_64(1000.0): " + ((log10_64(1000.0)).val as string))
      print("log10_32(100.0): " + ((log10_32(100.0 as float32)).val as string))
      print("log10_16(10.0): " + ((log10_16(10.0 as float16)).val as string))

      print("--- Exponencial & Logaritmo de Alta Precisao (expm1 & log1p) ---")
      print("expm164(1.0e-5): " + ((expm164(1.0e-5)).val as string))
      print("expm132(1.0e-3): " + ((expm132(1.0e-3 as float32)).val as string))
      print("expm116(1.0e-2): " + ((expm116(1.0e-2 as float16)).val as string))
      print("log1p64(1.0e-5): " + ((log1p64(1.0e-5)).val as string))
      print("log1p32(1.0e-3): " + ((log1p32(1.0e-3 as float32)).val as string))
      print("log1p16(1.0e-2): " + ((log1p16(1.0e-2 as float16)).val as string))

      print("--- Exponenciais Base 2 & Base 10 ---")
      print("exp2_64(10.0): " + ((exp2_64(10.0)).val as string))
      print("exp2_32(8.0): " + ((exp2_32(8.0 as float32)).val as string))
      print("exp2_16(4.0): " + ((exp2_16(4.0 as float16)).val as string))
      print("exp10_64(3.0): " + ((exp10_64(3.0)).val as string))
      print("exp10_32(2.0): " + ((exp10_32(2.0 as float32)).val as string))
      print("exp10_16(1.0): " + ((exp10_16(1.0 as float16)).val as string))

      print("--- Funcoes Especiais de IA (Softplus & LogAddExp) ---")
      print("softplus64(0.0): " + ((softplus64(0.0)).val as string))
      print("softplus32(0.0): " + ((softplus32(0.0 as float32)).val as string))
      print("softplus16(0.0): " + ((softplus16(0.0 as float16)).val as string))
      print("logAddExp64(10.0, 10.0): " + ((logAddExp64(10.0, 10.0)).val as string))
      print("logAddExp32(5.0, 5.0): " + ((logAddExp32(5.0 as float32, 5.0 as float32)).val as string))
      print("logAddExp16(2.0, 2.0): " + ((logAddExp16(2.0 as float16, 2.0 as float16)).val as string))
      print("==================================================")
}
