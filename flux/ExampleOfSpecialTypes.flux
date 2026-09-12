mut as fp8_e4m3: fp8_e4m3_positivo = 0.98
mut as fp8_e4m3: fp8_e4m3_negativo = -1.5

mut as fp8_e5m2: fp8_e5m2_positivo = 0.98
mut as fp8_e5m2: fp8_e5m2_negativo = -1.5

mut as bf16_e8m7: bf16_e8m7_positivo = 0.98046875
mut as bf16_e8m7: bf16_e8m7_negativo = -1.5

mut as tf32_e8m10: tf32_e8m10_positivo = 0.97998046875
mut as tf32_e8m10: tf32_e8m10_negativo = -1.5

program (ExampleOfTiposEspeciais) {
      print("fp8_e4m3 positivo (esperado 1.0): " + fp8_e4m3_positivo)
      print("fp8_e4m3 negativo (esperado -1.5): " + fp8_e4m3_negativo)

      print("fp8_e5m2 positivo (esperado 1.0): " + fp8_e5m2_positivo)
      print("fp8_e5m2 negativo (esperado -1.5): " + fp8_e5m2_negativo)

      print("bf16_e8m7 positivo (esperado 0.98046875): " + bf16_e8m7_positivo)
      print("bf16_e8m7 negativo (esperado -1.5): " + bf16_e8m7_negativo)

      print("tf32_e8m10 positivo (esperado 0.97998046875): " + tf32_e8m10_positivo)
      print("tf32_e8m10 negativo (esperado -1.5): " + tf32_e8m10_negativo)
}
