use SimdStdLib

program (ExampleOfUseSimdStdLib_SimdVectorArithmeticContract) {
      println("==================================================")
      println("  Exemplo: SimdVectorArithmeticContract")
      println("==================================================")

      mut as list of data: a = [1.0, 2.0, 3.0, 4.0]
      mut as list of data: b = [10.0, 20.0, 30.0, 40.0]

      println("1. Vector Add (F32 / F64 / Alias):")
      println("   F32: ", simdVectorAddF32(a, b))
      println("   F64: ", simdVectorAddF64(a, b))
      println("   Alias: ", simdVectorAdd(a, b))

      println("2. Vector Sub (F32 / F64 / Alias):")
      println("   F32: ", simdVectorSubF32(b, a))
      println("   F64: ", simdVectorSubF64(b, a))
      println("   Alias: ", simdVectorSub(b, a))

      println("3. Vector Mul (F32 / F64 / Alias):")
      println("   F32: ", simdVectorMulF32(a, b))
      println("   F64: ", simdVectorMulF64(a, b))
      println("   Alias: ", simdVectorMul(a, b))

      println("4. Vector Div (F32 / F64 / Alias):")
      println("   F32: ", simdVectorDivF32(b, a))
      println("   F64: ", simdVectorDivF64(b, a))
      println("   Alias: ", simdVectorDiv(b, a))
}
