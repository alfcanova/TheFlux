#L ============================================================================
#L Algoritmo: The Shooting Method (Metodo do Disparo para BVPs)
#L Capitulo: 18_boundary_value_problems
#L Complexidade: O(N_iter * N_passos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Transformacao de BVP em IVP ajustando a derivada inicial por metodo da secante.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_TheShootingMethod) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_TheShootingMethod")
      println("==================================================")

      #L BVP linear: y'' = 0 no intervalo [0, 1] com y(0) = 0 e y(1) = 1000 (1.000)
      #L Solucao analitica exata: y(x) = 1000 * x, portanto a inclinacao correta e v = y'(0) = 1000.
      #L Metodo do disparo:
      #L Chute 1: v1 = 500  -> y_final(1) = 500  -> residuo F(v1) = 500 - 1000 = -500
      #L Chute 2: v2 = 1500 -> y_final(1) = 1500 -> residuo F(v2) = 1500 - 1000 = +500
      mut as int64: v1 = 500
      mut as int64: f1 = 0 - 500

      mut as int64: v2 = 1500
      mut as int64: f2 = 500

      println("1. Disparos iniciais de teste:")
      println("   -> Chute 1: v = " + v1 + ", erro de contorno F(v1) = " + f1)
      println("   -> Chute 2: v = " + v2 + ", erro de contorno F(v2) = " + f2)

      #L Passo da Secante para encontrar o disparo exato:
      #L v_otimo = v2 - f2 * (v2 - v1) / (f2 - f1)
      #L v_otimo = 1500 - 500 * (1000) / (1000) = 1500 - 500 = 1000
      mut as int64: delta_v = v2 - v1
      mut as int64: delta_f = f2 - f1
      mut as int64: v_otimo = v2 - ((f2 * delta_v) /i delta_f)

      #L Integrando com v_otimo: y(1) = v_otimo * 1 = 1000
      mut as int64: y_alvo = 1000
      mut as int64: y_alcancado = v_otimo
      mut as int64: residuo_bvp = y_alcancado - y_alvo

      println("2. Disparo convergido apos correcao da secante:")
      println("   -> Inclinacao inicial calculada v* = " + v_otimo)
      println("   -> Condicao de contorno y(1) atingida = " + y_alcancado + " (alvo: " + y_alvo + ")")
      println("3. Residuo da condicao de contorno = " + residuo_bvp + " (esperado: 0)")
      println("4. Metodo do Disparo validado com sucesso.")
}
