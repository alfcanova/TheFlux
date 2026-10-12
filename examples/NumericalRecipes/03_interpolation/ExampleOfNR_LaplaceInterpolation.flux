#L ============================================================================
#L Algoritmo: Laplace Interpolation (Preenchimento de Malha via Laplaciano Discreto)
#L Capitulo: 03_interpolation
#L Complexidade: O(N_iter * M * N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Solucao da equacao de Laplace nabla^2 u = 0 para preencher buracos em malha.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_LaplaceInterpolation) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_LaplaceInterpolation")
      println("==================================================")

      #L Grade 3x3 com contorno fixo e no central desconhecido (buraco a preencher):
      #L Contorno: Topo=1000, Fundo=1000, Esquerda=1000, Direita=1000
      #L Centro desconhecido u[2,2] inicializado com 0
      mut as int64: top   = 1000
      mut as int64: bottom= 1000
      mut as int64: left  = 1000
      mut as int64: right = 1000

      println("1. Executando relaxacao de Laplace nabla^2 u = 0:")
      #L u_centro = (top + bottom + left + right) / 4
      mut as int64: u_center = (top + bottom + left + right) /i 4

      println("2. Valor de preenchimento do no central:")
      println("   -> u_center = " + u_center + " (esperado: 1000)")

      mut as int64: res = u_center - 1000
      println("3. Residuo do operador Laplaciano discreto = " + res + " (esperado: 0)")
      println("4. Preenchimento de grade por interpolacao de Laplace concluido.")
}
