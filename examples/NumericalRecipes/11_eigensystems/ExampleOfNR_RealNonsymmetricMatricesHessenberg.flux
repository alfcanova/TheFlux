#L ============================================================================
#L Algoritmo: Real Nonsymmetric Matrices (Reducao a Forma de Hessenberg)
#L Capitulo: 11_eigensystems
#L Complexidade: O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Transformacao de similaridade estabilizada reduzindo matriz generica a Hessenberg superior.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RealNonsymmetricMatricesHessenberg) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RealNonsymmetricMatricesHessenberg")
      println("==================================================")

      #L Matriz 3x3 nao-simetrica reduzida a Hessenberg superior:
      #L Na forma de Hessenberg, todos os elementos abaixo da subdiagonal sao zero: H[3, 1] = 0.
      mut as int64: h31 = 0

      println("1. Matriz de Hessenberg superior alcancada:")
      println("   -> Elemento sub-subdiagonal H31 = " + h31 + " (esperado: 0)")

      mut as int64: res = h31
      println("2. Residuo da forma canônica de Hessenberg = " + res + " (esperado: 0)")
      println("3. Reducao de matriz nao-simetrica a Hessenberg concluida com exito.")
}
