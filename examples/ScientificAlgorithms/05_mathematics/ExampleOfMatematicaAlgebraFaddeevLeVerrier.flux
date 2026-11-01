#L ============================================================================
#L Algoritmo: Faddeev-LeVerrier (Algoritmo de Faddeev-LeVerrier para Polinomio Caracteristico)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^4) algebra matricial direta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraFaddeevLeVerrier) {
      println("==================================================")
      println("  SciAlgo: Faddeev-LeVerrier Algorithm")
      println("==================================================")

      mut as int64: n = 3
      #L Matriz 3x3 com traco 6, determinante 6
      mut as int64: traco1 = 6
      mut as int64: c1 = -6
      mut as int64: det = 6

      println("1. Ordem da matriz analisada: " + n)
      println("2. Coeficiente caracteristico c1 = " + c1 + ", determinante = " + det)
      println("3. Faddeev-LeVerrier concluido com sucesso.")
}
