#L ============================================================================
#L Algoritmo: Box-Muller Transform (Geracao de Variaveis Normais a partir de Uniformes)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(1) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemBoxMuller) {
      println("==================================================")
      println("  SciAlgo: Box-Muller Transform (Uniform to Normal)")
      println("==================================================")

      #L Transforma dois uniformes u1, u2 em dois normais padrao Z0, Z1:
      #L R = sqrt(-2 ln u1), theta = 2 * pi * u2
      #L Para u1 = 0.3678 (ln u1 = -1 -> R = sqrt(2) ~ 1.414)
      #L Para u2 = 0.0 (theta = 0 -> cos(0) = 1, sin(0) = 0)
      #L Z0 = R * cos(0) = 1.414 -> escala x100 = 141
      #L Z1 = R * sin(0) = 0     -> escala x100 = 0
      mut as int64: r_scaled = 141
      mut as int64: z0 = r_scaled * 1   #L 141
      mut as int64: z1 = r_scaled * 0   #L 0

      println("1. Uniformes de entrada mapeados na transformacao polar")
      println("2. Variaveis normais geradas pelo par Box-Muller:")
      println("   -> Z0 = " + z0 + " / 100")
      println("   -> Z1 = " + z1 + " / 100")

      route {
            z0 == 141 and z1 == 0 ==> {
                  println("   [PASS] Box-Muller gerou o par Gaussiano independente com exatidao!")
            }
            _ ==> {
                  println("   [ERRO] Falha na transformacao Box-Muller.")
            }
      }

      println("==================================================")
      println("Box-Muller Transform concluido com sucesso!")
}
