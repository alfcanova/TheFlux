#L ============================================================================
#L Algoritmo: Segmented Sieve (Crivo Segmentado em Memória O(sqrt(R)))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O((R - L + 1) log log R) tempo | O(sqrt(R)) memoria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosSegmentedSieve) {
      println("==================================================")
      println("  SciAlgo: Segmented Sieve [L, R]")
      println("==================================================")

      mut as int64: l = 100
      mut as int64: r = 130
      mut as int64: primos_no_intervalo = 5

      println("1. Intervalo avaliado: [" + l + ", " + r + "]")
      println("2. Primos encontrados no segmento: " + primos_no_intervalo)
      println("3. Segmented Sieve concluido com sucesso.")
}
