#L ============================================================================
#L Algoritmo: Cross-Validation (K-Fold Cross Validation)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(K * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaCrossValidation) {
      println("==================================================")
      println("  SciAlgo: K-Fold Cross-Validation (MSE Evaluation)")
      println("==================================================")

      #L 4 Folds com erros quadraticos de validacao observados
      mut as list of int64: fold_mse = [12, 14, 11, 15]
      mut as int64: k_folds = listLength(fold_mse)

      mut as int64: total_mse = 0
      mut as int64: i = 1
      infinite (i <= k_folds) {
            total_mse = total_mse + fold_mse[i]
            println("   Fold " + i + " MSE: " + fold_mse[i])
            i = i + 1
      }
      mut as int64: avg_mse = total_mse /i k_folds

      println("1. Erro medio de validacao cruzada (CV-MSE): " + avg_mse)
      route {
            avg_mse == 13 ==> {
                  println("   [PASS] K-Fold Cross-Validation validou o modelo com exatidao!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no calculo do MSE de validacao.")
            }
      }

      println("==================================================")
      println("Cross-Validation concluido com sucesso!")
}
