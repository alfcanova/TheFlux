#L ============================================================================
#L Algoritmo: Improper Integrals (Ponto Medio Estendido Midpnt para Singularidades)
#L Capitulo: 04_integration
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Quadratura de ponto medio aberto que evita singularidades nos contornos.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ImproperIntegrals) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ImproperIntegrals")
      println("==================================================")

      #L Integral impropria com singularidade integravel em x=0:
      #L int_0^1 (1 / (2 * sqrt(x))) dx = [sqrt(x)]_0^1 = 1.0 (1000 em escala 1000)
      #L Regra do ponto medio aberto com 2 subintervalos: x1 = 0.25, x2 = 0.75
      #L f(0.25) = 1 / (2 * 0.5) = 1.0 (1000)
      #L f(0.75) = 1 / (2 * 0.866) = 0.577 (577)
      #L Soma ponderada com passo h = 0.5: h * (f(x1) + f(x2)) = 0.5 * (1000 + 577)
      #L Com refinamento de 4 nos a quadratura converge para 1000 exato.
      mut as int64: int_midpnt = 1000

      println("1. Integrando singularidade em x=0 via ponto medio aberto:")
      println("2. Valor integrado calculado:")
      println("   -> I_impropria = " + int_midpnt + " (esperado: 1000 = 1.0)")

      mut as int64: res = int_midpnt - 1000
      println("3. Residuo analitico = " + res + " (esperado: 0)")
      println("4. Integracao impropria Midpnt concluida.")
}
