#L ============================================================================
#L Algoritmo: Shunting-Yard Algorithm (Edsger Dijkstra 1961)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(N) tempo linear de parsing | O(N) espaco de pilha
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSpecialAlgorithmsShuntingYard) {
      println("==================================================")
      println("  SciAlgo: Dijkstra's Shunting-Yard Algorithm")
      println("==================================================")

      #L Mapeamento de tokens:
      #L Numeros inteiros positivos: valores literais (3, 4, 2, 1, 5)
      #L Operadores representados por codigos negativos:
      #L   -1 = '+' (prec 1), -2 = '-' (prec 1)
      #L   -3 = '*' (prec 2), -4 = '/' (prec 2)
      #L   -5 = '(',          -6 = ')'
      #L Expressao infixa: 3 + 4 * 2 / ( 1 - 5 )
      mut as list of int64: infix_tokens = [3, -1, 4, -3, 2, -4, -5, 1, -2, 5, -6]
      println("1. Tokens da expressao infixa (3 + 4 * 2 / (1 - 5)):")
      println("   " + infix_tokens)

      mut as list of int64: rpn_output = []
      mut as list of int64: op_stack = []

      mut as int64: idx = 1
      infinite (idx <= listLength(infix_tokens)) {
            mut as int64: token = infix_tokens[idx]
            route {
                  token > 0 ==> {
                        #L Operando: envia diretamente para a fila de saida RPN
                        rpn_output = listPushBack(rpn_output, token)
                  }
                  token == -5 ==> {
                        #L Parentese abrindo '(': empilha
                        op_stack = listPushBack(op_stack, token)
                  }
                  token == -6 ==> {
                        #L Parentese fechando ')': desempilha operadores ate '('
                        infinite (listLength(op_stack) > 0) {
                              mut as int64: top_i = listLength(op_stack)
                              mut as int64: top_op = op_stack[top_i]

                              #L Desempilha
                              mut as list of int64: n_stk = []
                              mut as int64: si = 1
                              infinite (si < top_i) {
                                    n_stk = listPushBack(n_stk, op_stack[si])
                                    si = si + 1
                              }
                              op_stack = n_stk

                              route {
                                    top_op == -5 ==> {
                                          break #L Descarta o '(' correspondente
                                    }
                                    _ ==> {
                                          rpn_output = listPushBack(rpn_output, top_op)
                                    }
                              }
                        }
                  }
                  _ ==> {
                        #L Operador (+, -, *, /): checa precedencias
                        mut as int64: prec_curr = 1
                        route {
                              token == -3 or token == -4 ==> {
                                    prec_curr = 2
                              }
                        }

                        infinite (listLength(op_stack) > 0) {
                              mut as int64: t_i = listLength(op_stack)
                              mut as int64: top_token = op_stack[t_i]
                              route {
                                    top_token == -5 ==> {
                                          break
                                    }
                              }
                              mut as int64: prec_top = 1
                              route {
                                    top_token == -3 or top_token == -4 ==> {
                                          prec_top = 2
                                    }
                              }
                              route {
                                    prec_top >= prec_curr ==> {
                                          rpn_output = listPushBack(rpn_output, top_token)
                                          #L Desempilha top_token
                                          mut as list of int64: n_s2 = []
                                          mut as int64: si2 = 1
                                          infinite (si2 < t_i) {
                                                n_s2 = listPushBack(n_s2, op_stack[si2])
                                                si2 = si2 + 1
                                          }
                                          op_stack = n_s2
                                    }
                                    _ ==> {
                                          break
                                    }
                              }
                        }
                        op_stack = listPushBack(op_stack, token)
                  }
            }
            idx = idx + 1
      }

      #L Despeja operadores remanescentes da pilha para a saida
      infinite (listLength(op_stack) > 0) {
            mut as int64: last_i = listLength(op_stack)
            rpn_output = listPushBack(rpn_output, op_stack[last_i])
            mut as list of int64: n_s3 = []
            mut as int64: si3 = 1
            infinite (si3 < last_i) {
                  n_s3 = listPushBack(n_s3, op_stack[si3])
                  si3 = si3 + 1
            }
            op_stack = n_s3
      }

      println("2. Expressao em Notacao Polonesa Reversa (RPN / Pos-fixa):")
      println("   " + rpn_output)

      #L Avaliacao aritmetica da expressao RPN gerada com pilha
      #L RPN esperada: [3, 4, 2, -3, 1, 5, -2, -4, -1] -> resultado = 1
      mut as list of int64: eval_stack = []
      mut as int64: ei = 1
      infinite (ei <= listLength(rpn_output)) {
            mut as int64: item = rpn_output[ei]
            route {
                  item > 0 ==> {
                        eval_stack = listPushBack(eval_stack, item)
                  }
                  _ ==> {
                        #L Operador: desempilha 2 operandos
                        mut as int64: len_es = listLength(eval_stack)
                        mut as int64: op2 = eval_stack[len_es]
                        mut as int64: op1 = eval_stack[len_es - 1]

                        mut as list of int64: n_es = []
                        mut as int64: esi = 1
                        infinite (esi < len_es - 1) {
                              n_es = listPushBack(n_es, eval_stack[esi])
                              esi = esi + 1
                        }

                        mut as int64: res_op = 0
                        route {
                              item == -1 ==> { res_op = op1 + op2 }
                              item == -2 ==> { res_op = op1 - op2 }
                              item == -3 ==> { res_op = op1 * op2 }
                              item == -4 ==> { res_op = op1 /i op2 }
                        }
                        n_es = listPushBack(n_es, res_op)
                        eval_stack = n_es
                  }
            }
            ei = ei + 1
      }

      mut as int64: final_eval = eval_stack[1]
      println("3. Resultado da avaliacao RPN calculada: " + final_eval)
      println("4. Validacao: " + (final_eval == 1 and listLength(rpn_output) == 9))
      println("==================================================")
}
