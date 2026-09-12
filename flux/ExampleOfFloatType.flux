program (ExampleOfFloatType) {
      print("=== FloatType: floats IEEE 754 ===")
      mut as float16: meia_precisao = -1.5
      mut as float32: simples = -32.25
      mut as float64: dupla = -64.125
      print(meia_precisao)
      print(simples)
      print(dupla)

      print("=== FloatType: especiais para ML/AI ===")
      mut as fp8_e4m3: fp8_1 = 0.98
      mut as fp8_e5m2: fp8_2 = 0.98
      mut as bf16_e8m7: bf16_val = 0.98046875
      mut as tf32_e8m10: tf32_val = 0.97998046875
      print(fp8_1)
      print(fp8_2)
      print(bf16_val)
      print(tf32_val)
}