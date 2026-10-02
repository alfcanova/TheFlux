use SimdStdLib

program (ExampleOfUseSimdStdLib_SimdVectorReductionContract) {
      println("==================================================")
      println("  Exemplo: SimdVectorReductionContract")
      println("==================================================")

      mut as list of data: a = [1.0, 2.0, 3.0, 4.0]
      mut as list of data: b = [10.0, 20.0, 30.0, 40.0]

      println("1. Dot Product (F32 / F64 / Alias):")
      println("   F32: ", simdDotProductF32(a, b))
      println("   F64: ", simdDotProductF64(a, b))
      println("   Alias: ", simdDotProduct(a, b))

      println("2. Vector Sum (F32 / F64 / Alias):")
      println("   F32: ", simdVectorSumF32(a))
      println("   F64: ", simdVectorSumF64(a))
      println("   Alias: ", simdVectorSum(a))

      println("3. Vector Clamp (F32 / F64 / Alias):")
      println("   F32: ", simdVectorClampF32([-5.0, 2.5, 12.0], 0.0, 10.0))
      println("   F64: ", simdVectorClampF64([-5.0, 2.5, 12.0], 0.0, 10.0))
      println("   Alias: ", simdVectorClamp([-5.0, 2.5, 12.0], 0.0, 10.0))
}
