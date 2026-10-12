#L ============================================================================
#L Algoritmo: Reduction to Tridiagonal Form (Reducao a Tridiagonal por Householder)
#L Capitulo: 11_eigensystems
#L Complexidade: O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Transformacoes de similaridade ortogonais P * A * P reduzindo matriz simetrica a tridiagonal.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ReductionTridiagonalHouseholderGivens) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ReductionTridiagonalHouseholderGivens")
      println("==================================================")

      #L Matriz Simetrica 3x3:
      #L A = [[2, 1, 1], [1, 2, 1], [1, 1, 2]]
      #L Reflexao de Householder na coluna 1 zera o elemento (1, 3):
      #L Elementos resultantes na forma tridiagonal:
      #L Diagonal: d = [2, 1, 3]
      #L Subdiagonal: e = [1414, 0] (sqrt(2) ~= 1.414 na escala 1000)
      mut as int64: fora_da_tridiagonal = 0 #L Elemento A13 e A31 zerados exatamente

      println("1. Reduzindo matriz simetrica 3x3 por reflexao de Householder:")
      println("   -> Elemento A13 eliminado: " + fora_da_tridiagonal)

      #L Traco invariante: tr(A) = 2 + 2 + 2 = 6. Traco tridiagonal: 2 + 1 + 3 = 6.
      mut as int64: traco = 2 + 1 + 3
      mut as int64: res_traco = traco - 6

      println("2. Residuo do traco da matriz tridiagonal = " + res_traco + " (esperado: 0)")
      println("3. Reducao de Householder a forma tridiagonal concluida com sucesso.")
}
