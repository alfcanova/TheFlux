use SimdStdLib

program (ExampleOfUseSimdStdLib_SimdMaskContract) {
      println("==================================================")
      println("  Exemplo: SimdMaskContract")
      println("==================================================")

      mut as list of data: mask = [1, 0, 1, 0]
      mut as list of data: a = [100.0, 200.0, 300.0, 400.0]
      mut as list of data: b = [1.0, 2.0, 3.0, 4.0]

      println("1. Select (F32 / F64 / Alias):")
      println("   F32: ", simdSelectF32(mask, a, b))
      println("   F64: ", simdSelectF64(mask, a, b))
      println("   Alias: ", simdSelect(mask, a, b))
}
