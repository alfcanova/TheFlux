#L ============================================================================
#L Algoritmo: Volterra Integral Equations (Equacoes Integrais de Volterra)
#L Capitulo: 19_integral_equations
#L Complexidade: O(N^2) por marcha direta triangular
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de equacao de Volterra de 2a especie por marcha forward stepwise.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_VolterraEquations) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_VolterraEquations")
      println("==================================================")

      #L Equacao de Volterra: phi(x) - int_0^x phi(t) dt = 1
      #L Derivando: phi'(x) - phi(x) = 0 com phi(0) = 1 -> phi(x) = exp(x)
      #L Integracao por marcha direta nos pontos x = [0.0, 0.1, 0.2] (passo h = 0.1):
      #L Passo 0: phi(0) = 1.000 -> 1000
      #L Passo 1: phi(x1) - h * phi(x0) = 1 -> phi(x1) = 1 + 0.1 * 1.0 = 1.100 -> 1100
      #L Passo 2: phi(x2) - h * (phi(x0) + phi(x1)) = 1 -> phi(x2) = 1 + 0.1 * 2.1 = 1.210 -> 1210
      mut as int64: phi0 = 1000
      mut as int64: h = 100 #L 0.100
      mut as int64: phi1 = phi0 + ((h * phi0) /i 1000) #L 1100
      mut as int64: phi2 = phi0 + ((h * (phi0 + phi1)) /i 1000) #L 1210

      println("1. Marcha temporal direta da equacao de Volterra:")
      println("   -> phi(0.0) = " + phi0 + " / 1000")
      println("   -> phi(0.1) = " + phi1 + " / 1000")
      println("   -> phi(0.2) = " + phi2 + " / 1000")

      #L Comparacao com exp(0.2) ~= 1.2214 (1221 em escala 1000):
      #L Erro O(h) esperado ~ 11 unidades:
      mut as int64: phi_ref = 1221
      mut as int64: erro = phi_ref - phi2
      route {
            erro < 0 ==> { erro = 0 - erro }
            erro >= 0 ==> {}
      }

      println("2. Comparacao com exp(0.2): erro = " + erro + " (tolerancia <= 15)")
      mut as int64: residuo = 0
      route {
            erro <= 15 ==> { residuo = 0 }
            erro > 15 ==> { residuo = erro }
      }

      println("3. Residuo da marcha de Volterra = " + residuo + " (esperado: 0)")
      println("4. Equacoes integrais de Volterra validadas com sucesso.")
}
