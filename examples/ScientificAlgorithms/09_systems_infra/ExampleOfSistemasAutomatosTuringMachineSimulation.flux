#L ============================================================================
#L Algoritmo: Turing Machine Simulation (Maquina de Turing Deterministica)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(Passos) tempo | O(Fita) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosTuringMachineSimulation) {
      println("==================================================")
      println("  SciAlgo: Deterministic Turing Machine Simulation")
      println("==================================================")

      #L Maquina de Turing: Incrementador Binario
      #L Tarefa: Soma 1 a um numero binario na fita ("1011" -> "1100")
      #L
      #L Estados:
      #L 1: q0 (busca final do numero para a direita)
      #L 2: q1 (adiciona 1 e propaga carry para a esquerda)
      #L 3: q2 (retorna cabecote ao inicio do numero)
      #L 4: q_accept (estado final de parada com sucesso)
      #L 5: q_reject (estado de rejeicao)
      #L
      #L Alfabeto da Fita Gamma:
      #L 0: '_' (blank / espaco em branco)
      #L 1: '0' (bit zero)
      #L 2: '1' (bit um)

      mut as int64: num_states = 5
      mut as int64: q_accept = 4
      mut as int64: q_reject = 5

      #L Fita linear de 14 celulas (1-indexed: 1..14)
      #L Posicoes 5..8 inicializadas com [2, 1, 2, 2] ("1 0 1 1")
      mut as list of int64: tape = [
            0, 0, 0, 0, 2, 1, 2, 2, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: head_pos = 5
      mut as int64: current_state = 1

      println("1. Configuracao Inicial da Maquina de Turing:")
      println("   Estados: {1: q0, 2: q1, 3: q2, 4: q_accept, 5: q_reject}")
      println("   Entrada na Fita: '1011' (decimal 11)")
      println("   Posicao Inicial do Cabecote: " + head_pos)

      mut as string: tape_init_str = ""
      mut as int64: idx = 1
      infinite (idx <= 12) {
            mut as int64: sym = tape[idx]
            mut as string: ch = "_"
            route {
                  sym == 1 ==> { ch = "0" }
                  sym == 2 ==> { ch = "1" }
                  _ ==> {}
            }
            tape_init_str = tape_init_str + ch + " "
            idx = idx + 1
      }
      println("   Fita: [ " + tape_init_str + "]")

      println("2. Executando Transicoes da Maquina de Turing...")

      mut as int64: step = 0
      mut as int64: max_steps = 30
      mut as bool: halted = false

      infinite ((not halted) and step < max_steps) {
            step = step + 1
            mut as int64: read_sym = tape[head_pos]
            mut as int64: next_state = current_state
            mut as int64: write_sym = read_sym
            mut as int64: move_dir = 0 #L -1: L, +1: R, 0: S

            #L Tabela de transicoes delta(current_state, read_sym):
            route {
                  #L Estado 1 (q0): avanca para direita sobre bits ate achar blank
                  current_state == 1 ==> {
                        route {
                              read_sym == 1 or read_sym == 2 ==> {
                                    write_sym = read_sym
                                    next_state = 1
                                    move_dir = 1 #L Direita
                              }
                              read_sym == 0 ==> {
                                    #L Achou o blank apos o numero, retrocede 1 celula para o LSB
                                    write_sym = 0
                                    next_state = 2
                                    move_dir = -1 #L Esquerda
                              }
                              _ ==> {}
                        }
                  }

                  #L Estado 2 (q1): adiciona 1 no bit atual
                  current_state == 2 ==> {
                        route {
                              read_sym == 2 ==> {
                                    #L Bit era '1': 1 + 1 = 0 com carry
                                    write_sym = 1 #L Escreve '0'
                                    next_state = 2 #L Continua em q1 para propagar carry
                                    move_dir = -1 #L Esquerda
                              }
                              read_sym == 1 ==> {
                                    #L Bit era '0': 0 + 1 = 1 sem carry
                                    write_sym = 2 #L Escreve '1'
                                    next_state = 3 #L Passa para q2 (voltar)
                                    move_dir = -1 #L Esquerda
                              }
                              read_sym == 0 ==> {
                                    #L Carry alcancou o blank a esquerda (ex: 111 + 1 = 1000)
                                    write_sym = 2 #L Escreve '1'
                                    next_state = 4 #L Aceita direto
                                    move_dir = 0  #L Parada
                              }
                              _ ==> {}
                        }
                  }

                  #L Estado 3 (q2): retrocede para esquerda ate achar blank anterior
                  current_state == 3 ==> {
                        route {
                              read_sym == 1 or read_sym == 2 ==> {
                                    write_sym = read_sym
                                    next_state = 3
                                    move_dir = -1 #L Esquerda
                              }
                              read_sym == 0 ==> {
                                    write_sym = 0
                                    next_state = 4 #L q_accept
                                    move_dir = 1  #L Posiciona no primeiro bit
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            #L Aplica escrita e movimento
            tape[head_pos] = write_sym
            head_pos = head_pos + move_dir
            current_state = next_state

            route {
                  current_state == q_accept or current_state == q_reject ==> {
                        halted = true
                  }
                  _ ==> {}
            }
      }

      println("3. Simulacao Concluida em " + step + " Passos:")
      println("   Estado Final: " + current_state + " (q_accept = " + q_accept + ")")
      println("   Cabecote Posicionado em: " + head_pos)

      #L Monta fita final resultante
      mut as string: tape_final_str = ""
      idx = 1
      infinite (idx <= 12) {
            mut as int64: sym = tape[idx]
            mut as string: ch = "_"
            route {
                  sym == 1 ==> { ch = "0" }
                  sym == 2 ==> { ch = "1" }
                  _ ==> {}
            }
            tape_final_str = tape_final_str + ch + " "
            idx = idx + 1
      }
      println("   Fita Resultante: [ " + tape_final_str + "]")

      #L Verificacao de corretude do incremento:
      #L Celulas 5..8 devem ser [2, 2, 1, 1] ("1 1 0 0" = 12 em decimal)
      mut as bool: correct = (tape[5] == 2) and (tape[6] == 2) and (tape[7] == 1) and (tape[8] == 1)
      println("4. Verificacao: '1011' + 1 = '1100' -> " + correct)

      println("Turing Machine Simulation concluida com sucesso.")
}
