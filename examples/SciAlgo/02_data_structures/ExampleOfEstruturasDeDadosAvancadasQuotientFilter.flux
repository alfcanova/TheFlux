#L ============================================================================
#L Algoritmo: Quotient Filter (Filtro Probabilistico Compacto Baseado em Hash)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(1) insercao e consulta amortizada | Espaco compacto O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasQuotientFilter) {
      println("==================================================")
      println("  SciAlgo: Quotient Filter (Compact Probabilistic)")
      println("==================================================")

      #L Tabela com capacidade 32 slots
      mut as int64: cap = 32
      mut as list of int64: occupied = [
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as list of int64: remainders = [
            -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1
      ]

      mut as list of int64: keys = [42, 87, 15, 99, 128, 256]
      mut as int64: num_keys = listLength(keys)
      println("1. Inserindo chaves no Quotient Filter:")
      mut as int64: i = 1
      infinite (i <= num_keys) {
            mut as int64: k = keys[i]
            mut as int64: h = (k * 265443) /r 1000003
            route {
                  h < 0 ==> {
                        h = 0 - h
                  }
                  _ ==> {
                  }
            }
            mut as int64: q = (h /i 100) /r cap
            mut as int64: r = h /r 100

            #L Sondagem linear a partir de q (1-based: q + 1)
            mut as int64: slot = q + 1
            mut as bool: inserted = false
            mut as int64: step = 0
            infinite (step < cap and not inserted) {
                  route {
                        occupied[slot] == 0 ==> {
                              occupied[slot] = 1
                              remainders[slot] = r
                              inserted = true
                        }
                        _ ==> {
                              slot = (slot /r cap) + 1
                        }
                  }
                  step = step + 1
            }
            println("   Chave " + k + " -> Quociente: " + q + ", Resto: " + r)
            i = i + 1
      }

      println("2. Consultando presenca das chaves:")
      mut as bool: all_found = true
      i = 1
      infinite (i <= num_keys) {
            mut as int64: k = keys[i]
            mut as int64: h = (k * 265443) /r 1000003
            route {
                  h < 0 ==> {
                        h = 0 - h
                  }
                  _ ==> {
                  }
            }
            mut as int64: q = (h /i 100) /r cap
            mut as int64: r = h /r 100

            mut as int64: slot = q + 1
            mut as bool: found = false
            mut as int64: step = 0
            infinite (step < cap and not found) {
                  route {
                        occupied[slot] == 1 and remainders[slot] == r ==> {
                              found = true
                        }
                        _ ==> {
                              slot = (slot /r cap) + 1
                        }
                  }
                  step = step + 1
            }

            println("   Contem chave " + k + ": " + found)
            route {
                  not found ==> {
                        all_found = false
                  }
                  _ ==> {
                  }
            }
            i = i + 1
      }

      println("3. Consultando chave inexistente (999):")
      mut as int64: h_abs = (999 * 265443) /r 1000003
      route {
            h_abs < 0 ==> {
                  h_abs = 0 - h_abs
            }
            _ ==> {
            }
      }
      mut as int64: q_abs = (h_abs /i 100) /r cap
      mut as int64: r_abs = h_abs /r 100
      mut as int64: slot_abs = q_abs + 1
      mut as bool: found_abs = false
      mut as int64: step_abs = 0
      infinite (step_abs < cap and not found_abs) {
            route {
                  occupied[slot_abs] == 1 and remainders[slot_abs] == r_abs ==> {
                        found_abs = true
                  }
                  _ ==> {
                        slot_abs = (slot_abs /r cap) + 1
                  }
            }
            step_abs = step_abs + 1
      }
      println("   Contem chave 999: " + found_abs)

      mut as bool: valid = all_found and not found_abs
      println("4. Validacao: " + valid)
      println("==================================================")
}
