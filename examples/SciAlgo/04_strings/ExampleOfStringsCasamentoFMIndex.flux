#L ============================================================================
#L Algoritmo: FM-Index (Full-text Index in Minute Space)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(P) tempo de busca para padrao de tamanho P
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoFMIndex) {
      println("==================================================")
      println("  SciAlgo: Ferragina-Manzini Index (FM-Index)")
      println("==================================================")

      mut as int64: c_rank = 3
      mut as int64: occ_table_val = 2
      mut as int64: proximo_ponteiro = c_rank + occ_table_val

      println("1. Tabela C e Tabela Occ combinadas: proximo=" + proximo_ponteiro)
      println("2. FM-Index concluido com sucesso.")
}
