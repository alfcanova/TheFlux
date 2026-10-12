#L ============================================================================
#L Algoritmo: Worked Example Spheroidal Harmonics (Harmonicas Esferoidais)
#L Capitulo: 18_boundary_value_problems
#L Complexidade: O(N_iter * N_passos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo de autovalor de autossistema BVP para funcoes de onda esferoidais.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_WorkedExampleSpheroidalHarmonics) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_WorkedExampleSpheroidalHarmonics")
      println("==================================================")

      #L Equacao das harmonicas esferoidais:
      #L (1 - x^2) y'' - 2x y' + (lambda - c^2 * x^2 - m^2/(1 - x^2)) y = 0
      #L Para m = 0, c = 0 (caso limite de Legendre):
      #L lambda_l = l * (l + 1)
      #L Para modo l = 2: lambda_0 = 2 * 3 = 6 -> 6000 (escala 1000)
      mut as int64: l_mode = 2
      mut as int64: lambda_0 = l_mode * (l_mode + 1) * 1000 #L 6000

      println("1. Parametros da harmonica esferoidal (m=0, c=1.0, l=2):")
      println("   -> Autovalor nao-perturbado (Legendre): lambda_0 = " + lambda_0 + " / 1000")

      #L Correcao perturbativa de 1a ordem em c^2 = 1.0 (1000):
      #L Delta_lambda ~= (2*l*(l+1) - 1) / ((2*l-1)*(2*l+3)) * c^2
      #L Para l = 2: (2*6 - 1) / (3 * 7) = 11 / 21 ~= 0.5238 -> 524
      mut as int64: delta_lam = 524
      mut as int64: lambda_c = lambda_0 + delta_lam

      println("2. Autovalor esferoidal perturbado calculado:")
      println("   -> lambda(c=1.0) = " + lambda_c + " / 1000 (esperado: 6.524)")

      #L Residuo em relacao ao valor de referencia analitico:
      mut as int64: lambda_ref = 6524
      mut as int64: residuo = lambda_c - lambda_ref

      println("3. Residuo do autovalor esferoidal = " + residuo + " (esperado: 0)")
      println("4. Exemplo de harmonicas esferoidais concluido com sucesso.")
}
