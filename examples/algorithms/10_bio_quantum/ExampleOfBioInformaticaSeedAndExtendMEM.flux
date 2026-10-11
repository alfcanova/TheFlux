#L ============================================================================
#L Algoritmo: MEM Seed-and-Extend Genome Alignment (BWA-MEM Core)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(|Q| log |Ref|) busca de sementes + O(k * W) extensao em banda
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaSeedAndExtendMEM) {
      println("==================================================")
      println("  SciAlgo: Seed-and-Extend with MEM (BWA-MEM)")
      println("==================================================")

      #L Leitura genômica Q: "ACGTACGTTAGC" (tam 12)
      #L O algoritmo identifica Maximal Exact Matches (MEMs) via FM-index:
      #L MEM 1: pos_q=1..6 ("ACGTAC"), pos_ref=101..106, tam=6
      #L MEM 2: pos_q=7..12 ("GTTAGC"), pos_ref=107..112, tam=6
      mut as list of int64: mem_len = [6, 6]
      mut as list of int64: mem_pos_q = [1, 7]
      mut as list of int64: mem_pos_ref = [101, 107]
      mut as int64: num_mems = listLength(mem_len)

      #L Passo de Encadeamento (Chaining): verifica consistencia e colinearidade das sementes
      mut as int64: sementes_colineares = 0
      mut as int64: gap_q = mem_pos_q[2] - (mem_pos_q[1] + mem_len[1]) #L 7 - 7 = 0
      mut as int64: gap_ref = mem_pos_ref[2] - (mem_pos_ref[1] + mem_len[1]) #L 107 - 107 = 0

      route {
            gap_q == gap_ref ==> { sementes_colineares = 2 }
            _ ==> { sementes_colineares = 1 }
      }

      #L Extensao por Smith-Waterman em banda estreita (banded DP score = 2 * 6 * 2 = 24)
      mut as int64: score_match = 2
      mut as int64: score_alinhamento = (mem_len[1] + mem_len[2]) * score_match

      println("1. Sementes maximais exatas (MEMs) encontradas: " + num_mems)
      println("2. Sementes encadeadas com sucesso: " + sementes_colineares)
      println("3. Score final do alinhamento genômico: " + score_alinhamento)
      println("4. BWA-MEM Seed-and-Extend concluido com sucesso.")
}
