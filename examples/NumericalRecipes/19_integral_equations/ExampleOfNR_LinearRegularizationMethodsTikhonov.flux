#L ============================================================================
#L Algoritmo: Regularizacao Linear de Tikhonov (Ridge Regression)
#L Capitulo: 19_integral_equations
#L Complexidade: O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Estabilizacao de sistemas mal-condicionados via penalizacao (G^T G + lambda^2 * I) m = G^T d.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_LinearRegularizationMethodsTikhonov) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_LinearRegularizationMethodsTikhonov")
      println("==================================================")

      #L Sistema mal-condicionado 1D: g * m = d com g = 10 (pequeno ganho), d = 100
      #L Sem regularizacao: m = 100 / 10 = 10
      #L Com parametro de regularizacao de Tikhonov lambda^2 = 15:
      #L (g^2 + lambda^2) * m = g * d
      #L (100 + 15) * m = 10 * 100 = 1000 -> 115 * m = 1000
      #L Multiplicando em escala 1000:
      mut as int64: g = 10
      mut as int64: d = 100
      mut as int64: lambda_sq = 15

      println("1. Parametros do problema mal-posto:")
      println("   -> Operador direto g = " + g + ", dado d = " + d)
      println("   -> Parametro de amortecimento lambda^2 = " + lambda_sq)

      #L Matriz normal regularizada: A_reg = g^2 + lambda^2 = 100 + 15 = 115
      mut as int64: a_reg = (g * g) + lambda_sq
      #L Lado direito: rhs = g * d = 1000
      mut as int64: rhs = g * d

      #L Solucao regularizada: m_reg = (1000 * 1000) / 115 = 8695 / 1000 ~= 8.695 -> 8695
      mut as int64: m_reg = (rhs * 1000) /i a_reg

      println("2. Solucao regularizada de Tikhonov:")
      println("   -> m_tikhonov = " + m_reg + " / 1000 (esperado: 8.695)")

      #L Verificacao da equacao normal: a_reg * m_reg ~= 115 * 8695 = 999925 ~= 1000000
      mut as int64: prod = a_reg * m_reg
      mut as int64: erro = 1000000 - prod
      route {
            erro < 0 ==> { erro = 0 - erro }
            erro >= 0 ==> {}
      }

      println("3. Residuo da equacao normal regularizada = " + erro + " (tolerancia <= 150)")
      mut as int64: residuo = 0
      route {
            erro <= 150 ==> { residuo = 0 }
            erro > 150 ==> { residuo = erro }
      }

      println("4. Residuo de Tikhonov = " + residuo + " (esperado: 0)")
      println("5. Regularizacao de Tikhonov concluida com sucesso.")
}
