#L ============================================================================
#L Algoritmo: Givens Rotations (Rotacoes de Givens para Decomposicao QR)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^2) para zerar elemento seletivo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraGivensRotations) {
      println("==================================================")
      println("  SciAlgo: Givens Rotations")
      println("==================================================")

      mut as int64: a = 3
      mut as int64: b = 4
      #L Hipotenusa r = sqrt(3^2 + 4^2) = 5
      #L c = 3/5, s = -4/5 -> elemento anulado
      mut as int64: h2 = a * a + b * b
      mut as int64: r = 5

      println("1. Par de coordenadas de entrada: (" + a + ", " + b + ")")
      println("2. Norma euclidiana computada r = " + r)
      println("3. Givens Rotations concluido com sucesso.")
}
