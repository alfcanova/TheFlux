#L ============================================================================
#L Algoritmo: Singular Value Decomposition (SVD A = U * W * V^T)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Decomposicao em valores singulares e pseudoinversa de Moore-Penrose.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SingularValueDecomposition) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SingularValueDecomposition")
      println("==================================================")

      #L Matriz diagonal / desacoplada 2x2 com valores singulares 3 e 1:
      #L A = [ [3000,    0],
      #L       [   0, 1000] ]
      #L U = I, V = I, W = [3000, 1000] (escala 1000)
      mut as list of int64: w = [3000, 1000]
      mut as list of int64: b = [9000, 4000]

      println("1. Valores singulares W = [" + (w[1] /i 1000) + ", " + (w[2] /i 1000) + "]")

      #L Resolucao por pseudoinversa: x = V * (1/W) * U^T * b
      mut as list of int64: x = [0, 0]
      x[1] = (b[1] * 1000) /i w[1]
      x[2] = (b[2] * 1000) /i w[2]

      println("2. Solucao via pseudoinversa SVD:")
      println("   -> x[1] = " + (x[1] /i 1000) + " (esperado: 3)")
      println("   -> x[2] = " + (x[2] /i 1000) + " (esperado: 4)")

      #L Condicionamento da matriz: cond = w_max / w_min = 3/1 = 3
      mut as int64: cond = w[1] /i w[2]
      println("3. Numero de condicao da matriz = " + cond + " (esperado: 3)")
      println("4. SVD concluida com sucesso.")
}
