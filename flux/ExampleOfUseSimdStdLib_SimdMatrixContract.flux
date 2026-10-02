use SimdStdLib

program (ExampleOfUseSimdStdLib_SimdMatrixContract) {
      println("==================================================")
      println("  Exemplo: SimdMatrixContract")
      println("==================================================")

      mut as map: m1 = map{
            "ndim": 2,
            "shape": [2, 2],
            "strides": [2, 1],
            "offset": 1,
            "data": [1.0, 2.0, 3.0, 4.0]
      }
      mut as map: m2 = map{
            "ndim": 2,
            "shape": [2, 2],
            "strides": [2, 1],
            "offset": 1,
            "data": [5.0, 6.0, 7.0, 8.0]
      }

      println("1. Matrix Multiplication 2D (F32 / F64 / Alias):")
      mut as map: res_f32 = simdMatrixMul2DF32(m1, m2)
      println("   F32 Data: ", res_f32["data"])

      mut as map: res_f64 = simdMatrixMul2DF64(m1, m2)
      println("   F64 Data: ", res_f64["data"])

      mut as map: res_alias = simdMatrixMul2D(m1, m2)
      println("   Alias Data: ", res_alias["data"])
}
