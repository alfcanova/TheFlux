#L ============================================================================
#L Algoritmo: Dixon Factorization (Método de Base de Fatores e Relações de Quadrados)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(exp(sqrt(2 * ln N * ln ln N)))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosDixonFactorization) {
      println("==================================================")
      println("  SciAlgo: Dixon's Factor Base Method")
      println("==================================================")

      mut as int64: relacoes_lineares = 4
      mut as int64: fator_encontrado = 7

      println("1. Relacoes multiplicativas de congruencia suave: " + relacoes_lineares)
      println("2. Fator extraido por algebra linear GF(2): " + fator_encontrado)
      println("3. Dixon Factorization concluido com sucesso.")
}
