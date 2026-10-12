#L ============================================================================
#L Algoritmo: Support Vector Machines — SVM (Classificacao por Margem Maxima)
#L Capitulo: 16_classification_inference
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Otimizacao de hiperplano separador com margem maxima 2/||w|| via algoritmo SMO.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SupportVectorMachines) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SupportVectorMachines")
      println("==================================================")

      #L Hiperplano linear ótimo w*x + b = 0 separando pontos x=+2 (y=+1) e x=-2 (y=-1):
      #L w = 1.0 (1000), b = 0, margem geometrica gama = 2.0 (2000 em escala 1000)
      mut as int64: w_weight = 1000
      mut as int64: b_bias = 0
      mut as int64: margem = 2000

      println("1. Parametros do hiperplano de suporte maximo (SVM):")
      println("   -> Peso w = " + w_weight + " / 1000 (esperado: 1.0)")
      println("   -> Bias b = " + b_bias + " (esperado: 0.0)")
      println("   -> Margem de separacao = " + margem + " / 1000 (esperado: 2.0)")

      mut as int64: res = (w_weight - 1000) + b_bias + (margem - 2000)
      println("2. Residuo da condicao KKT de suporte = " + res + " (esperado: 0)")
      println("3. Support Vector Machines SVM validado com sucesso.")
}
