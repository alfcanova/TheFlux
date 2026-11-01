#L ============================================================================
#L Algoritmo: Josephus Problem (Problema de Josefo O(N) e O(log N))
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N) tempo linear recursivo J(n, k) = (J(n-1, k) + k) % n
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaJosephusProblem) {
      println("==================================================")
      println("  SciAlgo: Josephus Elimination Problem")
      println("==================================================")

      mut as int64: n = 7
      mut as int64: k = 3

      mut as int64: g = 0
      mut as int64: i = 2
      infinite (i <= n) {
            g = (g + k) /r i
            i = i + 1
      }
      mut as int64: sobrevivente = g + 1

      println("1. Pessoas n=" + n + " com passo k=" + k)
      println("2. Posicao do sobrevivente (1-based): " + sobrevivente)
      println("3. Josephus Problem concluido com sucesso.")
}
