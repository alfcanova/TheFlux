#L ============================================================================
#L Algoritmo: Roaring Bitmap (Bitmap Comprimido Hibrido Array/Bitset)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log C) por operacao de container | Espaco altamente comprimido
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasRoaringBitmap) {
      println("==================================================")
      println("  SciAlgo: Roaring Bitmap (Compressed Hybrid Set)")
      println("==================================================")

      #L Chunks divididos por 65536
      #L Bitmap A: contem valores [10, 50, 65540] (65540 = chunk 1, val 4)
      #L Bitmap B: contem valores [50, 70, 65540]
      mut as list of int64: a_chunks = [0, 0, 1]
      mut as list of int64: a_values = [10, 50, 4]

      mut as list of int64: b_chunks = [0, 0, 1]
      mut as list of int64: b_values = [50, 70, 4]

      mut as int64: n_a = listLength(a_chunks)
      mut as int64: n_b = listLength(b_chunks)

      println("1. Inseridos elementos no Roaring Bitmap A: [10, 50, 65540]")
      println("   Inseridos elementos no Roaring Bitmap B: [50, 70, 65540]")

      #L Intersecao A & B
      println("2. Calculando Intersecao (A AND B):")
      mut as list of int64: inter_chunks = []
      mut as list of int64: inter_values = []
      mut as int64: ia = 1
      infinite (ia <= n_a) {
            mut as int64: ca = a_chunks[ia]
            mut as int64: va = a_values[ia]

            mut as int64: ib = 1
            mut as bool: found = false
            infinite (ib <= n_b and not found) {
                  route {
                        (b_chunks[ib] == ca) and (b_values[ib] == va) ==> {
                              found = true
                        }
                        _ ==> {
                        }
                  }
                  ib = ib + 1
            }

            route {
                  found ==> {
                        inter_chunks = listPushBack(inter_chunks, ca)
                        inter_values = listPushBack(inter_values, va)
                  }
                  _ ==> {
                  }
            }
            ia = ia + 1
      }

      mut as int64: inter_card = listLength(inter_values)
      println("   Cardinalidade da Intersecao: " + inter_card)
      mut as int64: ii = 1
      infinite (ii <= inter_card) {
            mut as int64: raw_val = inter_chunks[ii] * 65536 + inter_values[ii]
            println("   Item presente em A AND B: " + raw_val)
            ii = ii + 1
      }

      #L Consulta de pertinencia (Contains 65540 em A)
      println("3. Consultando pertinencia de 65540 e 999 em A:")
      mut as int64: target_chunk = 65540 /i 65536
      mut as int64: target_val = 65540 /r 65536
      mut as bool: a_has_65540 = false
      ia = 1
      infinite (ia <= n_a and not a_has_65540) {
            route {
                  (a_chunks[ia] == target_chunk) and (a_values[ia] == target_val) ==> {
                        a_has_65540 = true
                  }
                  _ ==> {
                  }
            }
            ia = ia + 1
      }
      println("   A contem 65540: " + a_has_65540)

      mut as int64: abs_chunk = 999 /i 65536
      mut as int64: abs_val = 999 /r 65536
      mut as bool: a_has_999 = false
      ia = 1
      infinite (ia <= n_a and not a_has_999) {
            route {
                  (a_chunks[ia] == abs_chunk) and (a_values[ia] == abs_val) ==> {
                        a_has_999 = true
                  }
                  _ ==> {
                  }
            }
            ia = ia + 1
      }
      println("   A contem 999: " + a_has_999)

      mut as bool: valid = (inter_card == 2) and a_has_65540 and (not a_has_999)
      println("4. Validacao: " + valid)
      println("==================================================")
}
