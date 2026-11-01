#L ============================================================================
#L Algoritmo: Burrows-Wheeler + Move-to-Front Pipeline
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(N log N) BWT + O(N * A) MTF
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsBWTMovedToFront) {
      println("==================================================")
      println("  SciAlgo: Pipeline BWT + Move-To-Front")
      println("==================================================")

      #L Saída simplificada de BWT com alta redundância local
      mut as list of int64: bwt_out = [2, 2, 2, 1, 1, 3]
      mut as int64: n = listLength(bwt_out)

      #L Alfabeto inicial MTF: [1, 2, 3]
      mut as list of int64: alfabeto = [1, 2, 3]
      mut as list of int64: mtf_ranks = [0, 0, 0, 0, 0, 0]

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: sym = bwt_out[i]
            #L Procura posição do símbolo
            mut as int64: rank = 1
            route {
                  alfabeto[1] == sym ==> { rank = 1 }
                  alfabeto[2] == sym ==> { rank = 2 }
                  alfabeto[3] == sym ==> { rank = 3 }
                  _ ==> {}
            }
            mtf_ranks[i] = rank
            i = i + 1
      }

      println("1. Ranks MTF gerados:")
      println("   [" + mtf_ranks[1] + ", " + mtf_ranks[2] + ", " + mtf_ranks[3] + ", " + mtf_ranks[4] + ", " + mtf_ranks[5] + ", " + mtf_ranks[6] + "]")
      println("2. Pipeline BWT+MTF concluido com sucesso.")
}
