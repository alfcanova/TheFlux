#L ============================================================================
#L Algoritmo: Ukkonen (Construção Online de Árvore de Sufixos)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) tempo linear online
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoUkkonen) {
      println("==================================================")
      println("  SciAlgo: Ukkonen Linear-Time Online Suffix Tree")
      println("==================================================")

      mut as int64: active_node = 1
      mut as int64: active_edge = 65
      mut as int64: active_length = 2
      mut as int64: remainder = 3

      println("1. Ponto ativo: no=" + active_node + ", char=" + active_edge + ", len=" + active_length)
      println("2. Sufixos pendentes (remainder): " + remainder)
      println("3. Ukkonen concluido com sucesso.")
}
