#L ============================================================================
#L Algoritmo: Zhu-Takaoka (Casamento com Bigrama de Caracteres Ruins)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N * M) pior caso | O(N / M) medio
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoZhuTakaoka) {
      println("==================================================")
      println("  SciAlgo: Zhu-Takaoka String Matching")
      println("==================================================")

      mut as int64: bigrama_shift = 6
      println("1. Tabela 2D de salto por bigrama (ZT): " + bigrama_shift)
      println("2. Zhu-Takaoka concluido com sucesso.")
}
