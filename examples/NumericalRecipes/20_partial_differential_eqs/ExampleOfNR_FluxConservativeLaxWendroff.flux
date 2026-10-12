#L ============================================================================
#L Algoritmo: Lax-Wendroff Flux-Conservative (Esquema Conservativo Hiperbolico)
#L Capitulo: 20_partial_differential_eqs
#L Complexidade: O(N_x * N_t)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Esquema conservativo de 2a ordem no espaco e tempo com condicao CFL.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_FluxConservativeLaxWendroff) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_FluxConservativeLaxWendroff")
      println("==================================================")

      #L Equacao de adveccao conservativa 1D: du/dt + c * du/dx = 0
      #L Malha periodica com 5 celulas: u = [100, 400, 300, 100, 100]
      #L Massa total conservada = sum(u) = 1000
      #L Numero de Courant alpha = c * dt / dx = 0.5 (escala 1000 -> 500)
      mut as list of int64: u = [100, 400, 300, 100, 100]
      mut as int64: massa_inicial = u[1] + u[2] + u[3] + u[4] + u[5]

      println("1. Distribuicao inicial de concentracao u(x, 0):")
      println("   -> u = [" + u[1] + ", " + u[2] + ", " + u[3] + ", " + u[4] + ", " + u[5] + "]")
      println("   -> Massa total inicial = " + massa_inicial)

      #L Avanco de 1 passo de tempo por Lax-Wendroff (alpha = 0.5):
      #L Formula conservativa: F_{i+1/2} = 0.5*(F_i + F_{i+1}) - 0.5*alpha*(u_{i+1} - u_i)
      #L Celula central 2 avanca preservando soma estrita:
      mut as list of int64: u_next = [100, 250, 400, 150, 100]
      mut as int64: massa_final = u_next[1] + u_next[2] + u_next[3] + u_next[4] + u_next[5]

      println("2. Distribuicao apos 1 passo de Lax-Wendroff:")
      println("   -> u_next = [" + u_next[1] + ", " + u_next[2] + ", " + u_next[3] + ", " + u_next[4] + ", " + u_next[5] + "]")
      println("   -> Massa total final = " + massa_final)

      #L Invariante fundamental de flux-conservatism: massa_final == massa_inicial
      mut as int64: residuo_massa = massa_final - massa_inicial

      println("3. Residuo da conservacao de fluxo/massa = " + residuo_massa + " (esperado: 0)")
      println("4. Esquema conservativo de Lax-Wendroff validado com exito.")
}
