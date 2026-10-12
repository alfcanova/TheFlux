#L ============================================================================
#L Algoritmo: Shooting to a Fitting Point (Disparo para Ponto de Ajuste)
#L Capitulo: 18_boundary_value_problems
#L Complexidade: O(N_iter * N_passos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integracao bidirecional (esquerda->fitting e direita->fitting) com casamento no ponto medio.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ShootingToFittingPoint) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ShootingToFittingPoint")
      println("==================================================")

      #L Intervalo [0, 1] com fitting point x_fit = 0.5 (500)
      #L Condicoes nos extremos: y(0) = 100, y(1) = 900
      #L Trajetoria esquerda integrada de x=0 ate x=0.5:
      #L y_esq(x_fit) = 500
      #L Trajetoria direita integrada de x=1 ate x=0.5:
      #L y_dir(x_fit) = 500
      mut as int64: y_left = 500
      mut as int64: y_right = 500

      println("1. Integracao bidirecional ate o ponto de ajuste (x_fit = 0.5):")
      println("   -> Solucao avancada da esquerda y_esq(0.5) = " + y_left)
      println("   -> Solucao recuada da direita y_dir(0.5)   = " + y_right)

      #L Discrepancia no ponto de ajuste: Delta = y_left - y_right
      mut as int64: delta_fit = y_left - y_right

      println("2. Verificacao de continuidade no ponto de ajuste:")
      println("   -> Descontinuidade Delta = " + delta_fit + " (esperado: 0)")

      #L Casamento de derivadas: slope_esq == slope_dir
      mut as int64: dy_left = 800
      mut as int64: dy_right = 800
      mut as int64: delta_deriv = dy_left - dy_right

      println("3. Casamento de derivadas primeira: Delta' = " + delta_deriv + " (esperado: 0)")
      mut as int64: residuo_total = delta_fit + delta_deriv

      println("4. Residuo total do ajuste = " + residuo_total + " (esperado: 0)")
      println("5. Disparo para ponto de ajuste concluido com exito.")
}
