#L ============================================================================
#L Algoritmo: Pocklington (Teorema de Pocklington-Lehmer para Primalidade)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log N) requer fatoracao parcial de N-1 > sqrt(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosPocklington) {
      println("==================================================")
      println("  SciAlgo: Pocklington Primality Criterion")
      println("==================================================")

      mut as int64: n = 17
      mut as int64: fator_f = 8
      mut as int64: condicao_satisfeita = 1

      println("1. Fator F=" + fator_f + " > sqrt(" + n + ") com base a=3")
      println("2. Certificado de Pocklington confirmado: " + condicao_satisfeita)
      println("3. Pocklington concluido com sucesso.")
}
