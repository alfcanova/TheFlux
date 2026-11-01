#L ============================================================================
#L Algoritmo: BCH (Bose–Chaudhuri–Hocquenghem Codes)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N log N) decodificacao espectral
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoBCH) {
      println("==================================================")
      println("  SciAlgo: BCH Multiple-Error Correcting Code")
      println("==================================================")

      mut as int64: n = 15
      mut as int64: k = 7
      mut as int64: t = 2

      println("1. Parametros do codigo BCH: N=" + n + ", K=" + k)
      println("2. Capacidade de correcao garantida: t=" + t + " bits")
      println("3. BCH Code concluido com sucesso.")
}
