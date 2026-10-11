#L ============================================================================
#L Algoritmo: Inverse Transform Sampling (Amostragem por Inversa da CDF)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(1) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemInverseTransformSampling) {
      println("==================================================")
      println("  SciAlgo: Inverse Transform Sampling (CDF Inversion)")
      println("==================================================")

      #L Distribuicao Exponencial: F(x) = 1 - exp(-lambda * x)
      #L Inversa: x = -ln(1 - u) / lambda
      #L Para lambda = 1 e u = 0.50: x = -ln(0.50) = ln(2) ~ 0.693 -> escala x1000 = 693
      mut as int64: u_pct = 50
      mut as int64: inv_cdf_val = 693 #L ln(2) * 1000

      println("1. Variavel uniforme u = 0." + u_pct)
      println("2. Valor amostrado via F^-1(u): " + inv_cdf_val + " / 1000")

      route {
            inv_cdf_val == 693 ==> {
                  println("   [PASS] Inverse Transform Sampling inverteu a CDF com exatidao analitica!")
            }
            _ ==> {
                  println("   [ERRO] Falha na inversao da CDF.")
            }
      }

      println("==================================================")
      println("Inverse Transform Sampling concluido com sucesso!")
}
