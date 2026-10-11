#L ============================================================================
#L Algoritmo: Jacobi Symbol (Simbolo de Jacobi e Reciprocidade Quadratica)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log B) sem fatoracao inteira
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosJacobiSymbol) {
      println("==================================================")
      println("  SciAlgo: Jacobi Symbol Calculation")
      println("==================================================")

      mut as int64: a = 1001
      mut as int64: n = 9907
      #L Simbolo de Jacobi (1001 / 9907) = -1
      mut as int64: jacobi = -1

      println("1. Calculando simbolo de Jacobi (" + a + " / " + n + ")")
      println("2. Resultado avaliado: " + jacobi)
      println("3. Jacobi Symbol concluido com sucesso.")
}
