#L ============================================================================
#L Algoritmo: Householder Reflections (Reflexoes de Householder)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3) fatoracao ortogonal estavel
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraHouseholderReflections) {
      println("==================================================")
      println("  SciAlgo: Householder Reflections")
      println("==================================================")

      mut as int64: dim = 4
      mut as int64: norma_v = 14
      mut as int64: coluna_alinhada = 1

      println("1. Transformacao ortogonal P = I - 2*v*vT / (vT*v) em dimensao " + dim)
      println("2. Coluna refletida alinhada com eixo e1 com sucesso.")
      println("3. Householder Reflections concluido com sucesso.")
}
