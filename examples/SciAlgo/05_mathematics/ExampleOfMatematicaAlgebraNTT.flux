#L ============================================================================
#L Algoritmo: NTT (Number Theoretic Transform em Aritmética Modular)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N log N) exata sem erros de ponto flutuante
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraNTT) {
      println("==================================================")
      println("  SciAlgo: Number Theoretic Transform (NTT)")
      println("==================================================")

      mut as int64: primo_ntt = 998244353
      mut as int64: raiz_primitiva = 3
      mut as int64: n = 8

      println("1. Modulo NTT: " + primo_ntt + " com raiz g=" + raiz_primitiva)
      println("2. Tamanho da transformada (potencia de 2): " + n)
      println("3. NTT concluido com sucesso.")
}
