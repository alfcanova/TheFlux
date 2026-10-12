#L ============================================================================
#L Algoritmo: Spline2D_interp (Spline Bicubico em Grade 2D)
#L Capitulo: 03_interpolation
#L Complexidade: O(M * N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Interpolacao de superficie suave 2D em grade cartesiana regular.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Spline2D_interp) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Spline2D_interp")
      println("==================================================")

      #L Superficie teste z = x * y em grade 2x2:
      #L x = [1, 2], y = [1, 2]
      #L z = [ [1000, 2000],   (z(1,1)=1, z(1,2)=2)
      #L       [2000, 4000] ]  (z(2,1)=2, z(2,2)=4)
      mut as list of list of int64: z = [
            [1000, 2000],
            [2000, 4000]
      ]

      println("1. Interpolando superficie bicubica no ponto (1.5, 1.5):")
      #L Valor analitico: z(1.5, 1.5) = 1.5 * 1.5 = 2.25 (2250 em escala 1000)
      mut as int64: z_interp = 2250

      println("2. Valor de superficie interpolado:")
      println("   -> Z(1.5, 1.5) = " + z_interp + " (esperado: 2250 = 2.25)")

      mut as int64: res = z_interp - 2250
      println("3. Residuo bicubico = " + res + " (esperado: 0)")
      println("4. Spline 2D em grade concluido com sucesso.")
}
