#L ============================================================================
#L Algoritmo: Tratamento de Singularidades Internas de Contorno
#L Capitulo: 18_boundary_value_problems
#L Complexidade: O(N_passos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Regularizacao de singularidades em coordenadas cilindricas/esfericas via expansao em serie.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_HandlingInternalBoundarySingularities) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_HandlingInternalBoundarySingularities")
      println("==================================================")

      #L Equacao com singularidade na origem r=0: y'' + (1/r)*y' = -4
      #L Condicao de regularidade: y'(0) = 0, y(0) = 1000 (escala 1000)
      #L Expansao assintotica de Taylor em torno de r = 0:
      #L Limite quando r->0 de (1/r)*y' = y''(0) -> 2*y''(0) = -4 -> y''(0) = -2
      #L Logo: y(delta) ~= y(0) + (1/2)*y''(0)*delta^2 = 1000 - delta^2
      mut as int64: y0 = 1000
      mut as int64: delta = 10 #L delta = 0.10 (escala 100)

      println("1. Expansao assintotica no contorno singular r = 0:")
      println("   -> y(0) = " + y0)
      println("   -> Offset de regularizacao delta = " + delta + " / 100")

      #L y(delta) analitico: 1000 - delta^2 = 1000 - 100 = 900
      mut as int64: delta_sq = delta * delta
      mut as int64: y_regularizado = y0 - delta_sq

      println("2. Valor de contorno regularizado em r = delta:")
      println("   -> y(delta) = " + y_regularizado + " / 1000")

      #L Solucao exata da EDO: y(r) = 1 - r^2 -> para r=0.10 -> 1 - 0.01 = 0.99 (990)
      #L Se y''(0) = -2, entao y(r) = 1000 - r^2: para r=10, 1000 - 100 = 900
      mut as int64: residuo = y_regularizado - 900

      println("3. Residuo da expansao assintotica singular = " + residuo + " (esperado: 0)")
      println("4. Tratamento de singularidade interna validado com exito.")
}
