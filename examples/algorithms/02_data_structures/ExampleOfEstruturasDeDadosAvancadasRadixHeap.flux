#L ============================================================================
#L Algoritmo: Radix Heap (Fila de Prioridade Monotonica Baseada em Baldes de Bits)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(1) amortizado por insercao | O(B) extracao de minimo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasRadixHeap) {
      println("==================================================")
      println("  SciAlgo: Radix Heap (Monotone Priority Queue)")
      println("==================================================")

      #L Radix Heap com 6 baldes [0..5] para inteiros pequenos (0..31)
      #L Balde 0: [0]
      #L Balde 1: [1]
      #L Balde 2: [2..3]
      #L Balde 3: [4..7]
      #L Balde 4: [8..15]
      #L Balde 5: [16..31]
      mut as list of int64: b0 = []
      mut as list of int64: b1 = []
      mut as list of int64: b2 = []
      mut as list of int64: b3 = []
      mut as list of int64: b4 = []
      mut as list of int64: b5 = []

      #L Chaves a inserir em sequencia monotonica >= 0
      mut as list of int64: keys = [10, 4, 1, 15, 2]
      mut as int64: n_keys = listLength(keys)

      println("1. Inserindo elementos: [10, 4, 1, 15, 2]:")
      mut as int64: i = 1
      infinite (i <= n_keys) {
            mut as int64: v = keys[i]
            route {
                  v == 0 ==> {
                        b0 = listPushBack(b0, v)
                  }
                  v == 1 ==> {
                        b1 = listPushBack(b1, v)
                  }
                  v >= 2 and v <= 3 ==> {
                        b2 = listPushBack(b2, v)
                  }
                  v >= 4 and v <= 7 ==> {
                        b3 = listPushBack(b3, v)
                  }
                  v >= 8 and v <= 15 ==> {
                        b4 = listPushBack(b4, v)
                  }
                  _ ==> {
                        b5 = listPushBack(b5, v)
                  }
            }
            println("   Item " + v + " inserido.")
            i = i + 1
      }

      #L Extracao monotonica dos 3 menores elementos
      println("2. Extraindo minimos:")
      mut as list of int64: extracted = []
      mut as int64: ext_count = 1

      infinite (ext_count <= 3) {
            mut as int64: cur_min_val = 999999
            mut as int64: from_b = -1
            mut as int64: from_pos = -1

            #L Varredura dos baldes
            mut as int64: bi = 1
            infinite (bi <= listLength(b0)) {
                  route {
                        b0[bi] < cur_min_val ==> {
                              cur_min_val = b0[bi]
                              from_b = 0
                              from_pos = bi
                        }
                        _ ==> {
                        }
                  }
                  bi = bi + 1
            }

            bi = 1
            infinite (bi <= listLength(b1)) {
                  route {
                        b1[bi] < cur_min_val ==> {
                              cur_min_val = b1[bi]
                              from_b = 1
                              from_pos = bi
                        }
                        _ ==> {
                        }
                  }
                  bi = bi + 1
            }

            bi = 1
            infinite (bi <= listLength(b2)) {
                  route {
                        b2[bi] < cur_min_val ==> {
                              cur_min_val = b2[bi]
                              from_b = 2
                              from_pos = bi
                        }
                        _ ==> {
                        }
                  }
                  bi = bi + 1
            }

            bi = 1
            infinite (bi <= listLength(b3)) {
                  route {
                        b3[bi] < cur_min_val ==> {
                              cur_min_val = b3[bi]
                              from_b = 3
                              from_pos = bi
                        }
                        _ ==> {
                        }
                  }
                  bi = bi + 1
            }

            bi = 1
            infinite (bi <= listLength(b4)) {
                  route {
                        b4[bi] < cur_min_val ==> {
                              cur_min_val = b4[bi]
                              from_b = 4
                              from_pos = bi
                        }
                        _ ==> {
                        }
                  }
                  bi = bi + 1
            }

            bi = 1
            infinite (bi <= listLength(b5)) {
                  route {
                        b5[bi] < cur_min_val ==> {
                              cur_min_val = b5[bi]
                              from_b = 5
                              from_pos = bi
                        }
                        _ ==> {
                        }
                  }
                  bi = bi + 1
            }

            extracted = listPushBack(extracted, cur_min_val)
            println("   Extraido #" + ext_count + ": " + cur_min_val + " (do bucket " + from_b + ")")

            #L Marca elemento extraido com sentinela para nao ser reprocessado
            route {
                  from_b == 0 ==> {
                        b0[from_pos] = 999999
                  }
                  from_b == 1 ==> {
                        b1[from_pos] = 999999
                  }
                  from_b == 2 ==> {
                        b2[from_pos] = 999999
                  }
                  from_b == 3 ==> {
                        b3[from_pos] = 999999
                  }
                  from_b == 4 ==> {
                        b4[from_pos] = 999999
                  }
                  from_b == 5 ==> {
                        b5[from_pos] = 999999
                  }
                  _ ==> {
                  }
            }

            ext_count = ext_count + 1
      }

      println("3. Tres primeiros minimos extraidos em ordem: " + extracted)
      mut as bool: valid = (extracted[1] == 1) and (extracted[2] == 2) and (extracted[3] == 4)
      println("4. Validacao: " + valid)
      println("==================================================")
}
