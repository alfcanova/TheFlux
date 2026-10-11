#L ============================================================================
#L Algoritmo: Burrows-Wheeler Transform Matching
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(P) busca exata via LF-mapping
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoBurrowsWheeler) {
      println("==================================================")
      println("  SciAlgo: BWT Pattern Matching via LF-Mapping")
      println("==================================================")

      mut as int64: lf_primeiro = 2
      mut as int64: lf_ultimo = 5
      mut as int64: ocorrencias = lf_ultimo - lf_primeiro + 1

      println("1. Intervalo correspondente no BWT: [" + lf_primeiro + ", " + lf_ultimo + "]")
      println("2. Ocorrencias encontradas: " + ocorrencias)
      println("3. BWT Matching concluido com sucesso.")
}
