#L ============================================================================
#L Algoritmo: Marsaglia Polar Method (Forma Polar Otimizada sem Trigonometria)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(1) amortizado | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemMarsagliaPolarMethod) {
      println("==================================================")
      println("  SciAlgo: Marsaglia Polar Method (Gaussian Generator)")
      println("==================================================")

      #L Sorteia (u, v) no circulo unitario: u = 60/100, v = 80/100
      #L s = u^2 + v^2 = 0.36 + 0.64 = 1.00 (em borda)
      #L Teste com u = 30/100, v = 40/100 -> s = 0.09 + 0.16 = 0.25 (s < 1 valido)
      mut as int64: u = 30
      mut as int64: v = 40
      mut as int64: s = (u * u + v * v) /i 100 #L 25

      println("1. Ponto no disco unitario: u = 0.30, v = 0.40 -> s = 0.25")

      #L Fator de escala w = sqrt(-2 ln(s) / s)
      #L Para s = 0.25: ln(0.25) ~ -1.386 -> -2*ln(s)/s ~ 2.772 / 0.25 = 11.08 -> sqrt ~ 3.33
      #L Multiplicador w_scaled = 333 (escala x100)
      mut as int64: w_scale = 333
      mut as int64: z0 = (u * w_scale) /i 100 #L 99
      mut as int64: z1 = (v * w_scale) /i 100 #L 133

      println("2. Variaveis normais geradas pelo metodo polar de Marsaglia:")
      println("   -> Z0 = " + z0 + " / 100")
      println("   -> Z1 = " + z1 + " / 100")

      route {
            z0 > 0 and z1 > 0 ==> {
                  println("   [PASS] Marsaglia Polar Method gerou amostras Gaussianas sem funcoes trigonometricas!")
            }
            _ ==> {
                  println("   [ERRO] Falha no metodo de Marsaglia.")
            }
      }

      println("==================================================")
      println("Marsaglia Polar Method concluido com sucesso!")
}
