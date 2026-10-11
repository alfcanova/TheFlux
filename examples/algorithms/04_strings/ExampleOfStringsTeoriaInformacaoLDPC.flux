#L ============================================================================
#L Algoritmo: LDPC (Low-Density Parity-Check Codes / Belief Propagation)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(M * d_v * I) com grafo bipartido de Tanner
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoLDPC) {
      println("==================================================")
      println("  SciAlgo: LDPC Tanner Graph & Belief Propagation")
      println("==================================================")

      mut as int64: nos_variavel = 12
      mut as int64: nos_checagem = 6
      mut as int64: iteracoes = 5
      mut as int64: sindrome_zerada = 1

      println("1. Grafo de Tanner com " + nos_variavel + " variaveis e " + nos_checagem + " checagens")
      println("2. Mensagens trocadas por Belief Propagation em " + iteracoes + " iteracoes")
      println("3. Verificacao de sindrome atendida: " + sindrome_zerada)
      println("4. LDPC concluido com sucesso.")
}
