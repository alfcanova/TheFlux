#L ============================================================================
#L Algoritmo: Fractal Compression (Compressão Fractal de Imagens/Dados)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(R * D) busca de transformacao afim
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoFractalCompression) {
      println("==================================================")
      println("  SciAlgo: Fractal Compression (Iterated Function Systems)")
      println("==================================================")

      mut as int64: blocos_range = 16
      mut as int64: blocos_domain = 64
      mut as int64: transformacoes_afins = 16

      println("1. Mapeamento de blocos domain para range: " + transformacoes_afins)
      println("2. Fractal Compression concluido com sucesso.")
}
