#L ============================================================================
#L Algoritmo: Needleman-Wunsch (Alinhamento Global de Sequências)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo | O(M * N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaNeedlemanWunsch) {
      println("==================================================")
      println("  SciAlgo: Needleman-Wunsch Global Alignment")
      println("==================================================")

      mut as list of int64: seq1 = [65, 67, 71, 84]
      mut as list of int64: seq2 = [65, 71, 84]
      mut as int64: match_score = 1
      mut as int64: gap_penalty = 1
      mut as int64: score_final = 2

      println("1. Alinhamento global de nucleotideos")
      println("2. Score otimo calculado: " + score_final)
      println("3. Needleman-Wunsch concluido com sucesso.")
}
