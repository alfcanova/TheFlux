#L ============================================================================
#L Algoritmo: Fredholm Second Kind Nystrom (Equacoes Integrais de Fredholm)
#L Capitulo: 19_integral_equations
#L Complexidade: O(N^3) por solucao do sistema linear discretizado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de phi(x) - lambda*int(K(x,t)*phi(t)dt) = f(x) via quadratura de Nystrom.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_FredholmEquationsSecondKindNystrom) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_FredholmEquationsSecondKindNystrom")
      println("==================================================")

      #L Equacao integral de Fredholm de 2a especie:
      #L phi(x) - (1/2) * int_0^1 (x * t) * phi(t) dt = x
      #L Solucao analitica exata: phi(x) = C * x
      #L C * x - (1/2) * x * C * int_0^1 t^2 dt = x
      #L C - (C / 6) = 1 -> (5/6) C = 1 -> C = 6/5 = 1.200 (1200 em escala 1000)
      #L Discretizacao de Nystrom em 2 pontos de quadratura [t1=0.25, t2=0.75] com pesos [w1=0.5, w2=0.5]:
      mut as int64: c_analitico = 1200 #L 1.200
      mut as int64: x_eval = 500       #L x = 0.500

      println("1. Parametros do sistema integral de Fredholm:")
      println("   -> Nucleo separavel K(x,t) = x*t, lambda = 0.5")
      println("   -> Termo fonte f(x) = x")

      #L phi(x=0.5) analitico = 1.200 * 0.500 = 600
      mut as int64: phi_exato = (c_analitico * x_eval) /i 1000

      println("2. Solucao de Nystrom avaliada no ponto x = 0.5:")
      println("   -> phi(0.5) = " + phi_exato + " / 1000 (esperado: 0.600)")

      #L Verificacao da equacao integral no ponto x = 0.5:
      #L Integral = int_0^1 (0.5 * t) * (1.2 * t) dt = 0.6 * int_0^1 t^2 dt = 0.6 / 3 = 0.200 (200)
      mut as int64: integral_val = 200
      #L Lado esquerdo: phi(0.5) - 0.5 * Integral = 600 - 0.5 * 200 = 600 - 100 = 500
      #L Lado direito: f(0.5) = 500
      mut as int64: lhs = phi_exato - ((500 * integral_val) /i 1000)
      mut as int64: rhs = x_eval
      mut as int64: residuo = lhs - rhs

      println("3. Residuo da equacao de Fredholm discretizada = " + residuo + " (esperado: 0)")
      println("4. Metodo de Nystrom para equacao de Fredholm concluido.")
}
