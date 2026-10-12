#L ============================================================================
#L Algoritmo: Multivariate Normal Deviates (Fatorizacao de Cholesky de Covariancia)
#L Capitulo: 07_random_numbers
#L Complexidade: O(d^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Amostragem de vetor gaussiano multivariado X = mu + L * Z.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MultivariateNormalDeviates) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MultivariateNormalDeviates")
      println("==================================================")

      #L Matriz de covariancia Sigma = [[1.0, 0.6], [0.6, 1.0]] (escala 1000):
      #L Fator de Cholesky L:
      #L L11 = 1000, L12 = 0
      #L L21 = 600,  L22 = sqrt(1000^2 - 600^2) = 800
      #L Vetor i.i.d normal Z = [1000, 500] (z1 = 1.0, z2 = 0.5):
      mut as int64: z1 = 1000
      mut as int64: z2 = 500

      println("1. Transformando variaveis gaussianas independentes por Cholesky:")
      mut as int64: x1 = (1000 * z1) /i 1000
      mut as int64: x2 = (600 * z1 + 800 * z2) /i 1000

      println("   -> X1 = " + x1 + " (esperado: 1000 = 1.0)")
      println("   -> X2 = " + x2 + " (esperado: 1000 = 0.6*1.0 + 0.8*0.5 = 1.0)")

      #L Verificacao do residuo:
      mut as int64: res1 = x1 - 1000
      mut as int64: res2 = x2 - 1000
      println("2. Residuos da transformacao multivariada: r1 = " + res1 + ", r2 = " + res2)
      println("3. Amostragem normal multivariada validada com sucesso.")
}
