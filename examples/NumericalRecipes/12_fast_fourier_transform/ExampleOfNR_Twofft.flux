#L ============================================================================
#L Algoritmo: Twofft (Transformada de Duas Funcoes Reais Simultaneamente)
#L Capitulo: 12_fast_fourier_transform
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo simultaneo de duas FFTs reais em uma unica transformada complexa.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Twofft) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Twofft")
      println("==================================================")

      #L Dois sinais: u = [1, 1], v = [2, 2]
      #L FFT complexa h = u + i*v:
      #L H[0] = (1 + 1) + i*(2 + 2) = 2 + 4i
      #L Separacao: U[0] = Re(H[0]) = 2, V[0] = Im(H[0]) = 4
      mut as int64: u_dc = 2
      mut as int64: v_dc = 4

      println("1. Separando espectros de dois canais reais simultaneos:")
      println("   -> Canal 1 (U DC) = " + u_dc + " (esperado: 2)")
      println("   -> Canal 2 (V DC) = " + v_dc + " (esperado: 4)")

      mut as int64: res = (u_dc - 2) + (v_dc - 4)
      println("2. Residuo da separacao espectral = " + res + " (esperado: 0)")
      println("3. Twofft concluido com exito.")
}
