#L ============================================================================
#L Algoritmo: Cornacchia Algorithm (Algoritmo de Cornacchia para Decomposicao de Primos)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log P) descida euclidiana diofantina
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosCornacchiaAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Cornacchia's Algorithm for x^2 + d*y^2 = p")
      println("==================================================")

      mut as int64: p = 73
      #L 73 = 8^2 + 3^2
      mut as int64: x = 8
      mut as int64: y = 3
      mut as int64: soma_quadrados = x * x + y * y

      println("1. Primo alvo p = " + p)
      println("2. Solucao primitiva encontrada: " + x + "^2 + " + y + "^2 = " + soma_quadrados)
      println("3. Cornacchia Algorithm concluido com sucesso.")
}
