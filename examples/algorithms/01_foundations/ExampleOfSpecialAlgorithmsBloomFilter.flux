#L ============================================================================
#L Algoritmo: Bloom Filter (Filtro de Bloom Probabilistico)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(k) insercao e consulta | Zero falsos-negativos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSpecialAlgorithmsBloomFilter) {
      println("==================================================")
      println("  SciAlgo: Bloom Filter")
      println("==================================================")

      mut as int64: m = 16 #L Vetor de 16 bits
      mut as list of int64: bits = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      #L Elementos inseridos no conjunto: 101, 202, 303
      mut as list of int64: inserted = [101, 202, 303]

      #L Insercao: calcula 3 funcoes hash para cada item e liga os bits
      mut as int64: i = 1
      infinite (i <= listLength(inserted)) {
            mut as int64: val = inserted[i]
            mut as int64: h1 = ((val * 17 + 3) /r m) + 1
            mut as int64: h2 = ((val * 31 + 7) /r m) + 1
            mut as int64: h3 = ((val * 53 + 13) /r m) + 1

            bits[h1] = 1
            bits[h2] = 1
            bits[h3] = 1
            i = i + 1
      }

      println("1. Vetor de bits apos insercao de [101, 202, 303]:")
      println("   " + bits)

      #L Consulta 1: Item inserido (202) deve obrigatoriamente acusar PRESENTE (zero falso negativo)
      mut as int64: q_pos = 202
      mut as int64: qh1 = ((q_pos * 17 + 3) /r m) + 1
      mut as int64: qh2 = ((q_pos * 31 + 7) /r m) + 1
      mut as int64: qh3 = ((q_pos * 53 + 13) /r m) + 1
      mut as bool: match_present = (bits[qh1] == 1 and bits[qh2] == 1 and bits[qh3] == 1)
      println("2. Consulta para 202 (inserido): possivelmente presente = " + match_present)

      #L Consulta 2: Item nunca inserido (999) com pelo menos um bit zerado (rejeicao definitiva)
      mut as int64: q_neg = 999
      mut as int64: nh1 = ((q_neg * 17 + 3) /r m) + 1
      mut as int64: nh2 = ((q_neg * 31 + 7) /r m) + 1
      mut as int64: nh3 = ((q_neg * 53 + 13) /r m) + 1
      mut as bool: definitely_absent = (bits[nh1] == 0 or bits[nh2] == 0 or bits[nh3] == 0)
      println("3. Consulta para 999 (ausente): com certeza ausente = " + definitely_absent)

      println("4. Validacao: " + (match_present and definitely_absent))
      println("==================================================")
}
