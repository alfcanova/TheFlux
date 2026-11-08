#L ==============================================================================
#L TheFlux Tool: fluxlsp (v1.0.0)
#L Servidor de Linguagem (Language Server Protocol) e Suporte a IDEs
#L Compativel com Visual Studio Code (JSON-RPC 2.0 / stdio) e Notepad++ (--xml)
#L ==============================================================================

function (lspPrintBanner) () as int64 {
      print("==============================================================================")
      print("       TheFlux Language Server Protocol & IDE Support (v1.0.0)")
      print("       Servidor LSP Nativo para VS Code e Gerador Notepad++ UDL 2.1")
      print("==============================================================================")
      emit(nice, 0, "ok")
}

function (lspPrintHelp) () as int64 {
      print("fluxlsp - Servidor LSP e Utilitario de Integracao com IDEs TheFlux (v1.0.0)")
      print("")
      print("Sintaxe:")
      print("  fluxlsp [opcoes]")
      print("")
      print("Modos de Operacao:")
      print("  fluxlsp                       Inicia o servidor LSP (JSON-RPC 2.0) via stdio")
      print("  fluxlsp --xml [caminho]       Gera arquivo XML UDL 2.1 compativel com Notepad++")
      print("  fluxlsp -h, --help            Exibe este manual de ajuda")
      print("  fluxlsp -v, --version         Exibe a versao do utilitario")
      print("")
      print("Recursos do Servidor LSP (VS Code):")
      print("  - Diagnosticos em tempo real (publishDiagnostics: sintaxe, indentacao 6-espacos, linter)")
      print("  - Documentacao rica ao passar o mouse (textDocument/hover)")
      print("  - Autocompletar inteligente com snippets semanticos (textDocument/completion)")
      print("  - Navegacao para definicao (textDocument/definition)")
      print("  - Formatacao canonica automatica (textDocument/formatting)")
      print("  - Contorno de simbolos e breadcrumbs (textDocument/documentSymbol)")
      print("")
      print("Exemplos:")
      print("  fluxlsp")
      print("  fluxlsp --xml")
      print("  fluxlsp --xml theflux_notepadpp.xml")
      emit(nice, 0, "ok")
}

function (lspPrintVersion) () as int64 {
      print("fluxlsp version 1.0.0 (TheFlux Language Server Protocol & IDE Support)")
      emit(nice, 0, "ok")
}

function (lspTrimBoth) (as string: s) as string {
      mut as int64: n = stdCollectionLength(s)
      mut as int64: start_idx = 1
      infinite {
            route {
                  start_idx > n ==> { break }
                  _ ==> {
                        mut as string: ch = s[start_idx]
                        route {
                              ch == " " or ch == "\t" or ch == "\r" or ch == "\n" ==> {
                                    start_idx = start_idx + 1
                              }
                              _ ==> { break }
                        }
                  }
            }
      }
      mut as int64: end_idx = n
      infinite {
            route {
                  end_idx < start_idx ==> { break }
                  _ ==> {
                        mut as string: ch2 = s[end_idx]
                        route {
                              ch2 == " " or ch2 == "\t" or ch2 == "\r" or ch2 == "\n" ==> {
                                    end_idx = end_idx - 1
                              }
                              _ ==> { break }
                        }
                  }
            }
      }
      route {
            start_idx > end_idx ==> { emit(nice, "", "ok") }
            _ ==> { emit(nice, s[start_idx..end_idx], "ok") }
      }
}

function (lspIsDigit) (as string: ch) as bool {
      route {
            ch == "0" or ch == "1" or ch == "2" or ch == "3" or ch == "4" or ch == "5" or ch == "6" or ch == "7" or ch == "8" or ch == "9" ==> {
                  emit(nice, true, "ok")
            }
            _ ==> {
                  emit(nice, false, "ok")
            }
      }
}

function (lspDigitValue) (as string: ch) as int64 {
      route {
            ch == "1" ==> { emit(nice, 1, "ok") }
            ch == "2" ==> { emit(nice, 2, "ok") }
            ch == "3" ==> { emit(nice, 3, "ok") }
            ch == "4" ==> { emit(nice, 4, "ok") }
            ch == "5" ==> { emit(nice, 5, "ok") }
            ch == "6" ==> { emit(nice, 6, "ok") }
            ch == "7" ==> { emit(nice, 7, "ok") }
            ch == "8" ==> { emit(nice, 8, "ok") }
            ch == "9" ==> { emit(nice, 9, "ok") }
            _ ==> { emit(nice, 0, "ok") }
      }
}

function (lspIsWordChar) (as string: ch) as bool {
      mut as string: valid = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_:"
      mut as int64: vlen = stdCollectionLength(valid)
      mut as int64: vi = 1
      infinite {
            route {
                  vi > vlen ==> { break }
                  valid[vi] == ch ==> { emit(nice, true, "ok") }
                  _ ==> { vi = vi + 1 }
            }
      }
      emit(nice, false, "ok")
}

function (lspEscapeJson) (as string: s) as string {
      mut as int64: slen = stdCollectionLength(s)
      mut as string: out = ""
      mut as int64: i = 1
      infinite {
            route {
                  i > slen ==> { break }
                  _ ==> {
                        mut as string: ch = s[i]
                        route {
                              ch == "\\" ==> { out = out + "\\\\" }
                              ch == "\"" ==> { out = out + "\\\"" }
                              ch == "\n" ==> { out = out + "\\n" }
                              ch == "\r" ==> { out = out + "\\r" }
                              ch == "\t" ==> { out = out + "\\t" }
                              _ ==> { out = out + ch }
                        }
                        i = i + 1
                  }
            }
      }
      emit(nice, out, "ok")
}

function (lspExtractJsonString) (as string: json, as string: key) as string {
      mut as int64: jlen = stdCollectionLength(json)
      mut as string: pat = "\"" + key + "\""
      mut as int64: plen = stdCollectionLength(pat)
      mut as int64: i = 1
      infinite {
            route {
                  i + plen > jlen ==> { break }
                  _ ==> {
                        route {
                              json[i..(i + plen - 1)] == pat ==> {
                                    mut as int64: k = i + plen
                                    mut as bool: in_val = false
                                    mut as string: val = ""
                                    mut as bool: esc = false
                                    infinite {
                                          route {
                                                k > jlen ==> { break }
                                                _ ==> {
                                                      mut as string: c = json[k]
                                                      route {
                                                            not in_val ==> {
                                                                  route {
                                                                        c == "\"" ==> { in_val = true }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            in_val ==> {
                                                                  route {
                                                                        esc ==> {
                                                                              route {
                                                                                    c == "n" ==> { val = val + "\n" }
                                                                                    c == "r" ==> { val = val + "\r" }
                                                                                    c == "t" ==> { val = val + "\t" }
                                                                                    _ ==> { val = val + c }
                                                                              }
                                                                              esc = false
                                                                        }
                                                                        c == "\\" ==> { esc = true }
                                                                        c == "\"" ==> { emit(nice, val, "ok") }
                                                                        _ ==> { val = val + c }
                                                                  }
                                                            }
                                                      }
                                                      k = k + 1
                                                }
                                          }
                                    }
                                    emit(nice, val, "ok")
                              }
                              _ ==> { i = i + 1 }
                        }
                  }
            }
      }
      emit(nice, "", "ok")
}

function (lspExtractJsonInt) (as string: json, as string: key) as int64 {
      mut as int64: jlen = stdCollectionLength(json)
      mut as string: pat = "\"" + key + "\""
      mut as int64: plen = stdCollectionLength(pat)
      mut as int64: i = 1
      infinite {
            route {
                  i + plen > jlen ==> { break }
                  _ ==> {
                        route {
                              json[i..(i + plen - 1)] == pat ==> {
                                    mut as int64: k = i + plen
                                    mut as bool: found_digit = false
                                    mut as int64: val = 0
                                    mut as bool: is_neg = false
                                    infinite {
                                          route {
                                                k > jlen ==> { break }
                                                _ ==> {
                                                      mut as string: c = json[k]
                                                      route {
                                                            not found_digit ==> {
                                                                  route {
                                                                        c == "-" ==> { is_neg = true }
                                                                        lspIsDigit(c) ==> {
                                                                              found_digit = true
                                                                              val = lspDigitValue(c)
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            found_digit ==> {
                                                                  route {
                                                                        lspIsDigit(c) ==> {
                                                                              val = val * 10 + lspDigitValue(c)
                                                                        }
                                                                        _ ==> {
                                                                              route { is_neg ==> { val = 0 - val } _ ==> {} }
                                                                              emit(nice, val, "ok")
                                                                        }
                                                                  }
                                                            }
                                                      }
                                                      k = k + 1
                                                }
                                          }
                                    }
                                    route { is_neg ==> { val = 0 - val } _ ==> {} }
                                    emit(nice, val, "ok")
                              }
                              _ ==> { i = i + 1 }
                        }
                  }
            }
      }
      emit(nice, 0, "ok")
}

function (lspExtractHeaderContentLength) (as string: line) as int64 {
      mut as int64: llen = stdCollectionLength(line)
      mut as int64: i = 1
      mut as int64: val = 0
      mut as bool: found = false
      infinite {
            route {
                  i > llen ==> { break }
                  _ ==> {
                        mut as string: ch = line[i]
                        route {
                              lspIsDigit(ch) ==> {
                                    found = true
                                    val = val * 10 + lspDigitValue(ch)
                              }
                              found ==> { break }
                              _ ==> {}
                        }
                        i = i + 1
                  }
            }
      }
      emit(nice, val, "ok")
}

function (lspSendMessage) (as string: payload) as int64 {
      mut as int64: clen = stdCollectionLength(payload)
      print("Content-Length: " + clen)
      print("")
      print(payload)
      emit(nice, 0, "ok")
}

function (lspSendResponse) (as string: id_str, as string: result_json) as int64 {
      mut as string: res = "{\"jsonrpc\":\"2.0\",\"id\":" + id_str + ",\"result\":" + result_json + "}"
      lspSendMessage(res)
      emit(nice, 0, "ok")
}

function (lspSendNotification) (as string: method, as string: params_json) as int64 {
      mut as string: notif = "{\"jsonrpc\":\"2.0\",\"method\":\"" + method + "\",\"params\":" + params_json + "}"
      lspSendMessage(notif)
      emit(nice, 0, "ok")
}

function (lspSplitLines) (as string: text) as list of string {
      mut as list of string: lines = []
      mut as int64: tlen = stdCollectionLength(text)
      mut as string: line = ""
      mut as int64: i = 1
      infinite {
            route {
                  i > tlen ==> {
                        lines = stdListPushBack(lines, line)
                        break
                  }
                  _ ==> {
                        mut as string: ch = text[i]
                        route {
                              ch == "\n" ==> {
                                    lines = stdListPushBack(lines, line)
                                    line = ""
                              }
                              ch == "\r" ==> {}
                              _ ==> {
                                    line = line + ch
                              }
                        }
                        i = i + 1
                  }
            }
      }
      emit(nice, lines, "ok")
}

function (lspComputeDiagnostics) (as string: text) as string {
      mut as list of string: lines = lspSplitLines(text)
      mut as int64: n_lines = stdCollectionLength(lines)
      mut as list of string: diag_items = []

      mut as int64: open_braces = 0
      mut as int64: close_braces = 0

      mut as int64: li = 1
      infinite {
            route {
                  li > n_lines ==> { break }
                  _ ==> {
                        mut as string: line = "" + lines[li]
                        mut as int64: llen = stdCollectionLength(line)
                        mut as string: tr = lspTrimBoth(line)
                        mut as int64: trlen = stdCollectionLength(tr)

                        #L Conta chaves fora de strings
                        mut as int64: ci = 1
                        mut as bool: in_str = false
                        mut as bool: esc_c = false
                        infinite {
                              route {
                                    ci > llen ==> { break }
                                    _ ==> {
                                          mut as string: c = line[ci]
                                          route {
                                                esc_c ==> { esc_c = false }
                                                c == "\\" ==> { esc_c = true }
                                                c == "\"" ==> { in_str = not in_str }
                                                not in_str ==> {
                                                      route {
                                                            c == "{" ==> { open_braces = open_braces + 1 }
                                                            c == "}" ==> { close_braces = close_braces + 1 }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          ci = ci + 1
                                    }
                              }
                        }

                        route {
                              trlen > 0 ==> {
                                    #L 1. Checagem de Indentacao Canônica (Multiplos de 6 espacos)
                                    mut as int64: sp = 0
                                    mut as int64: si = 1
                                    infinite {
                                          route {
                                                si > llen ==> { break }
                                                _ ==> {
                                                      mut as string: sch = line[si]
                                                      route {
                                                            sch == " " ==> { sp = sp + 1 }
                                                            _ ==> { break }
                                                      }
                                                      si = si + 1
                                                }
                                          }
                                    }
                                    route {
                                          sp % 6 != 0 ==> {
                                                mut as int64: lidx = li - 1
                                                mut as string: d = "{\"range\":{\"start\":{\"line\":" + lidx + ",\"character\":0},\"end\":{\"line\":" + lidx + ",\"character\":" + sp + "}},\"severity\":2,\"code\":\"LSP_INDENT\",\"source\":\"fluxlsp\",\"message\":\"Indentacao canônica: use multiplos de 6 espacos (encontrado: " + sp + " espacos)\"}"
                                                diag_items = stdListPushBack(diag_items, d)
                                          }
                                          _ ==> {}
                                    }

                                    #L 2. Checagem de Caractere TAB Proibido
                                    mut as int64: ti = 1
                                    infinite {
                                          route {
                                                ti > llen ==> { break }
                                                _ ==> {
                                                      route {
                                                            line[ti] == "\t" ==> {
                                                                  mut as int64: lidx2 = li - 1
                                                                  mut as int64: cidx = ti - 1
                                                                  mut as string: d2 = "{\"range\":{\"start\":{\"line\":" + lidx2 + ",\"character\":" + cidx + "},\"end\":{\"line\":" + lidx2 + ",\"character\":" + ti + "}},\"severity\":1,\"code\":\"LSP_NO_TAB\",\"source\":\"fluxlsp\",\"message\":\"Caractere TAB proibido; utilize 6 espacos\"}"
                                                                  diag_items = stdListPushBack(diag_items, d2)
                                                                  break
                                                            }
                                                            _ ==> {}
                                                      }
                                                      ti = ti + 1
                                                }
                                          }
                                    }

                                    #L 3. Checagem de Comentario Legado '#'
                                    route {
                                          tr[1] == "#" ==> {
                                                mut as bool: valid_comment = false
                                                route {
                                                      trlen >= 2 ==> {
                                                            mut as string: c2 = tr[2]
                                                            route {
                                                                  c2 == "L" or c2 == "B" or c2 == "D" ==> { valid_comment = true }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                                route {
                                                      not valid_comment ==> {
                                                            mut as int64: lidx3 = li - 1
                                                            mut as string: d3 = "{\"range\":{\"start\":{\"line\":" + lidx3 + ",\"character\":0},\"end\":{\"line\":" + lidx3 + ",\"character\":" + llen + "}},\"severity\":2,\"code\":\"LSP_COMMENT_STYLE\",\"source\":\"fluxlsp\",\"message\":\"Comentario legado '#' detectado; prefira '#L' para linha, '#B...B#' para bloco ou '#D...D#' para docstrings\"}"
                                                            diag_items = stdListPushBack(diag_items, d3)
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }

                                    #L 4. Checagem de Ponto-e-virgula ';' Redundante
                                    route {
                                          tr[trlen] == ";" ==> {
                                                mut as int64: lidx4 = li - 1
                                                mut as int64: sc_end = llen
                                                mut as int64: sc_start = llen - 1
                                                mut as string: d4 = "{\"range\":{\"start\":{\"line\":" + lidx4 + ",\"character\":" + sc_start + "},\"end\":{\"line\":" + lidx4 + ",\"character\":" + sc_end + "}},\"severity\":2,\"code\":\"LSP_NO_SEMICOLON\",\"source\":\"fluxlsp\",\"message\":\"Ponto-e-virgula ';' redundante; TheFlux dispensa terminadores de instrucao\"}"
                                                diag_items = stdListPushBack(diag_items, d4)
                                          }
                                          _ ==> {}
                                    }

                                    #L 5. Checagem de Divisao por Zero Literal
                                    mut as int64: zi = 1
                                    infinite {
                                          route {
                                                zi + 3 > llen ==> { break }
                                                _ ==> {
                                                      mut as string: sub4 = line[zi..(zi + 3)]
                                                      route {
                                                            sub4 == "/i 0" or sub4 == "/r 0" or sub4 == "/f 0" ==> {
                                                                  mut as int64: lidx5 = li - 1
                                                                  mut as int64: z_end = zi + 3
                                                                  mut as string: d5 = "{\"range\":{\"start\":{\"line\":" + lidx5 + ",\"character\":" + (zi - 1) + "},\"end\":{\"line\":" + lidx5 + ",\"character\":" + z_end + "}},\"severity\":1,\"code\":\"LSP_DIV_ZERO\",\"source\":\"fluxlsp\",\"message\":\"Divisao ou resto por zero literal detectado\"}"
                                                                  diag_items = stdListPushBack(diag_items, d5)
                                                            }
                                                            _ ==> {}
                                                      }
                                                      zi = zi + 1
                                                }
                                          }
                                    }
                              }
                              _ ==> {}
                        }
                        li = li + 1
                  }
            }
      }

      #L 6. Checagem de Chaves Desbalanceadas
      route {
            open_braces != close_braces ==> {
                  mut as int64: last_idx = n_lines - 1
                  route { last_idx < 0 ==> { last_idx = 0 } _ ==> {} }
                  mut as string: db = "{\"range\":{\"start\":{\"line\":" + last_idx + ",\"character\":0},\"end\":{\"line\":" + last_idx + ",\"character\":1}},\"severity\":1,\"code\":\"LSP_UNBALANCED_BRACES\",\"source\":\"fluxlsp\",\"message\":\"Chaves desbalanceadas: " + open_braces + " abertura(s) '{' vs " + close_braces + " fechamento(s) '}'\"}"
                  diag_items = stdListPushBack(diag_items, db)
            }
            _ ==> {}
      }

      mut as string: out = "["
      mut as int64: nd = stdCollectionLength(diag_items)
      mut as int64: k = 1
      infinite {
            route {
                  k > nd ==> { break }
                  _ ==> {
                        out = out + diag_items[k]
                        route {
                              k < nd ==> { out = out + "," }
                              _ ==> {}
                        }
                        k = k + 1
                  }
            }
      }
      out = out + "]"
      emit(nice, out, "ok")
}

function (lspGetHoverDoc) (as string: word) as string {
      mut as string: doc = ""
      route {
            word == "contract" ==> {
                  doc = "### Contract (Contrato)\nDefine a assinatura formal e publica de operacoes sem implementacao de codigo.\n\nExemplo:\n```flux\ncontract (CalculadoraContract) {\n      op somar (as int64: a, as int64: b) as int64\n}\n```"
            }
            word == "agent" ==> {
                  doc = "### Agent (Agente)\nImplementa formalmente um contrato semantico com logica de execucao.\n\nExemplo:\n```flux\nagent (CalculadoraAgent) impl CalculadoraContract {\n      op somar (as int64: a, as int64: b) as int64 ==> {\n            emit(nice, a + b, \"ok\")\n      }\n}\n```"
            }
            word == "impl" ==> {
                  doc = "### Impl (Implementacao)\nClausula vinculativa que conecta um Agente ao Contrato que ele implementa formalmente."
            }
            word == "op" ==> {
                  doc = "### Operation (Operacao)\nUnidade fundamental de execucao de um agente ou contrato, finalizada via sinal `emit`."
            }
            word == "route" ==> {
                  doc = "### Route (Roteamento de Condicoes)\nEstrutura de controle de fluxo condicional pattern-matching do TheFlux.\n\nExemplo:\n```flux\nroute {\n      x > 0 ==> { print(\"positivo\") }\n      x < 0 ==> { print(\"negativo\") }\n      _ ==> { print(\"zero\") }\n}\n```"
            }
            word == "==>" ==> {
                  doc = "### Operador de Fluxo (Flow Arrow `==>`)\nConecta uma guarda ou condicao ao seu respectivo bloco de execucao em rotas e operacoes."
            }
            word == "infinite" ==> {
                  doc = "### Loop Infinito (infinite)\nEstrutura de repeticao universal do TheFlux. Requer condicao de saida com `break` ou `emit`.\n\nExemplo:\n```flux\ninfinite {\n      route {\n            i > 10 ==> { break }\n            _ ==> { i = i + 1 }\n      }\n}\n```"
            }
            word == "emit" ==> {
                  doc = "### Emit (Emissao de Sinais)\nFinaliza a operacao ou funcao despachando o resultado pelo canal especificado (`nice` ou `fail`).\n\nExemplo:\n```flux\nemit(nice, resultado, \"ok\")\nemit(fail, 100, \"falha\")\n```"
            }
            word == "nice" ==> {
                  doc = "### Canal de Sucesso (`nice`)\nCanal de resultado positivo para operacoes concluidas com exito."
            }
            word == "fail" ==> {
                  doc = "### Canal de Falha (`fail`)\nCanal de resultado de excecao ou erro semantico."
            }
            word == "mut" ==> {
                  doc = "### Mutavel (`mut`)\nDeclara uma variavel cujo valor pode ser modificado ao longo do escopo."
            }
            word == "imut" ==> {
                  doc = "### Imutavel (`imut`)\nDeclara uma constante cujo valor e fixado na inicializacao e nunca pode ser reatribuido."
            }
            word == "/i" ==> {
                  doc = "### Divisao Inteira (`/i`)\nOperador canonico TheFlux para divisao inteira (ex: `7 /i 2 = 3`). Previne conversoes implicitas indesejadas."
            }
            word == "/r" ==> {
                  doc = "### Resto de Divisao (`/r`)\nOperador canonico TheFlux para resto/modulo de divisao inteira (ex: `7 /r 2 = 1`)."
            }
            word == "/f" ==> {
                  doc = "### Divisao Float (`/f`)\nOperador canonico TheFlux para divisao de numeros em ponto flutuante."
            }
            word == "tensor" ==> {
                  doc = "### Tensor N-Dimensional (`tensor`)\nTipo nativo multidimensional de alto desempenho para algebra linear e IA (ex: `tensor[3,3] of float64`)."
            }
            word == "stdIoReadFile" ==> {
                  doc = "### stdIoReadFile (path: string) -> string\nLe todo o conteudo de um arquivo em disco de forma nativa e síncrona."
            }
            word == "stdIoWriteFile" ==> {
                  doc = "### stdIoWriteFile (path: string, content: string) -> int64\nEscreve conteudo integralmente em arquivo em disco de forma atomica."
            }
            word == "stdDatetimeNow" ==> {
                  doc = "### stdDatetimeNow () -> int64\nRetorna a data e hora atual em nanossegundos desde o Unix Epoch (1970-01-01)."
            }
            word == "stdOsExec" ==> {
                  doc = "### stdOsExec (cmd: string) -> int64\nExecuta um comando no sistema operacional e retorna o codigo de saida (exit code)."
            }
            _ ==> {}
      }
      emit(nice, doc, "ok")
}

function (lspGetCompletionList) () as string {
      mut as string: out = "{\"isIncomplete\":false,\"items\":["
      #L Palavras-chave fundamentais
      out = out + "{\"label\":\"contract\",\"kind\":14,\"detail\":\"Contrato TheFlux\",\"insertText\":\"contract (${1:Nome}) {\\n      op ${2:operacao} (as ${3:string}: ${4:param}) as ${5:string}\\n}\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"agent\",\"kind\":14,\"detail\":\"Agente TheFlux\",\"insertText\":\"agent (${1:Nome}) impl ${2:Contrato} {\\n      op ${3:operacao} (as ${4:string}: ${5:param}) as ${6:string} ==> {\\n            emit(nice, ${7:resultado}, \\\"ok\\\")\\n      }\\n}\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"route\",\"kind\":14,\"detail\":\"Roteamento Pattern-Matching\",\"insertText\":\"route {\\n      ${1:condicao} ==> {\\n            ${2}\\n      }\\n      _ ==> {}\\n}\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"infinite\",\"kind\":14,\"detail\":\"Loop Infinito Universal\",\"insertText\":\"infinite {\\n      route {\\n            ${1:condicao} ==> { break }\\n            _ ==> {\\n                  ${2}\\n            }\\n      }\\n}\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"mut\",\"kind\":14,\"detail\":\"Variavel Mutavel\",\"insertText\":\"mut as ${1:string}: ${2:nome} = ${3:valor}\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"imut\",\"kind\":14,\"detail\":\"Constante Imutavel\",\"insertText\":\"imut as ${1:int64}: ${2:NOME} = ${3:10}\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"emit\",\"kind\":14,\"detail\":\"Emissao de Sinal de Retorno\",\"insertText\":\"emit(nice, ${1:resultado}, \\\"ok\\\")\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"program\",\"kind\":14,\"detail\":\"Ponto de Entrada\",\"insertText\":\"program (${1:Main}) {\\n      ${2}\\n}\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"function\",\"kind\":14,\"detail\":\"Funcao Autonoma\",\"insertText\":\"function (${1:nome}) (as ${2:tipo}: ${3:arg}) as ${4:tipo} {\\n      ${5}\\n      emit(nice, ${6:ret}, \\\"ok\\\")\\n}\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"op\",\"kind\":14,\"detail\":\"Operacao de Agente\"},"
      out = out + "{\"label\":\"impl\",\"kind\":14,\"detail\":\"Clausula de Implementacao\"},"
      out = out + "{\"label\":\"nice\",\"kind\":14,\"detail\":\"Canal de Sucesso\"},"
      out = out + "{\"label\":\"fail\",\"kind\":14,\"detail\":\"Canal de Falha\"},"
      out = out + "{\"label\":\"as\",\"kind\":14,\"detail\":\"Conector de Tipo\"},"
      out = out + "{\"label\":\"of\",\"kind\":14,\"detail\":\"Conector de Colecao\"},"
      out = out + "{\"label\":\"print\",\"kind\":3,\"detail\":\"Funcao de Saida de Texto\",\"insertText\":\"print(\\\"${1:texto}\\\")\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"input\",\"kind\":3,\"detail\":\"Funcao de Entrada Interativa\",\"insertText\":\"input(\\\"${1:prompt}: \\\")\",\"insertTextFormat\":2},"
      out = out + "{\"label\":\"int64\",\"kind\":7,\"detail\":\"Inteiro 64-bit com sinal\"},"
      out = out + "{\"label\":\"float64\",\"kind\":7,\"detail\":\"Ponto Flutuante 64-bit IEEE 754\"},"
      out = out + "{\"label\":\"string\",\"kind\":7,\"detail\":\"Cadeia de Caracteres UTF-8\"},"
      out = out + "{\"label\":\"bool\",\"kind\":7,\"detail\":\"Booleano (true/false)\"},"
      out = out + "{\"label\":\"datetime\",\"kind\":7,\"detail\":\"Data e Hora Nativa ISO-8601\"},"
      out = out + "{\"label\":\"complex128\",\"kind\":7,\"detail\":\"Numero Complexo 128-bit\"},"
      out = out + "{\"label\":\"tensor\",\"kind\":7,\"detail\":\"Tensor Multidimensional\"},"
      out = out + "{\"label\":\"list\",\"kind\":7,\"detail\":\"Lista Homogenea Sequencial\"},"
      out = out + "{\"label\":\"map\",\"kind\":7,\"detail\":\"Tabela Hash Associativa\"},"
      out = out + "{\"label\":\"set\",\"kind\":7,\"detail\":\"Conjunto de Elementos Unicos\"},"
      out = out + "{\"label\":\"stdIoReadFile\",\"kind\":3,\"detail\":\"Leitura de Arquivo\"},"
      out = out + "{\"label\":\"stdIoWriteFile\",\"kind\":3,\"detail\":\"Escrita de Arquivo\"},"
      out = out + "{\"label\":\"stdDatetimeNow\",\"kind\":3,\"detail\":\"Timestamp Atual Nanossegundos\"}"
      out = out + "]}"
      emit(nice, out, "ok")
}

function (lspFindDefinition) (as string: text, as string: symbol, as string: uri) as string {
      route {
            symbol == "" ==> { emit(nice, "null", "ok") }
            _ ==> {}
      }
      mut as list of string: lines = lspSplitLines(text)
      mut as int64: n_lines = stdCollectionLength(lines)
      mut as int64: li = 1
      infinite {
            route {
                  li > n_lines ==> { break }
                  _ ==> {
                        mut as string: line = "" + lines[li]
                        mut as string: tr = lspTrimBoth(line)
                        mut as int64: trlen = stdCollectionLength(tr)
                        mut as bool: match_def = false
                        mut as int64: c_start = 0

                        #L Busca padroes de definicao
                        mut as string: pat1 = "(" + symbol + ")"
                        mut as string: pat2 = "op " + symbol
                        mut as string: pat3 = ":" + symbol + " "
                        mut as string: pat4 = ":" + symbol + "="
                        mut as string: pat5 = " " + symbol + " "
                        mut as string: pat6 = " " + symbol + "="

                        mut as int64: p1_len = stdCollectionLength(pat1)
                        mut as int64: p2_len = stdCollectionLength(pat2)

                        mut as int64: ci = 1
                        infinite {
                              route {
                                    ci > trlen ==> { break }
                                    _ ==> {
                                          route {
                                                ci + p1_len - 1 <= trlen and tr[ci..(ci + p1_len - 1)] == pat1 ==> {
                                                      match_def = true
                                                      c_start = ci
                                                      break
                                                }
                                                ci + p2_len - 1 <= trlen and tr[ci..(ci + p2_len - 1)] == pat2 ==> {
                                                      match_def = true
                                                      c_start = ci
                                                      break
                                                }
                                                _ ==> {}
                                          }
                                          ci = ci + 1
                                    }
                              }
                        }

                        route {
                              match_def ==> {
                                    mut as int64: lidx = li - 1
                                    mut as int64: c_end = c_start + stdCollectionLength(symbol)
                                    mut as string: loc = "{\"uri\":\"" + uri + "\",\"range\":{\"start\":{\"line\":" + lidx + ",\"character\":" + c_start + "},\"end\":{\"line\":" + lidx + ",\"character\":" + c_end + "}}}"
                                    emit(nice, loc, "ok")
                              }
                              _ ==> {}
                        }
                        li = li + 1
                  }
            }
      }
      emit(nice, "null", "ok")
}

function (lspFormatDocument) (as string: text) as string {
      mut as list of string: lines = lspSplitLines(text)
      mut as int64: n_lines = stdCollectionLength(lines)
      mut as string: formatted = ""
      mut as int64: li = 1
      infinite {
            route {
                  li > n_lines ==> { break }
                  _ ==> {
                        mut as string: line = "" + lines[li]
                        #L 1. Substitui tabs por 6 espacos
                        mut as string: no_tabs = ""
                        mut as int64: llen = stdCollectionLength(line)
                        mut as int64: ti = 1
                        infinite {
                              route {
                                    ti > llen ==> { break }
                                    _ ==> {
                                          mut as string: ch = line[ti]
                                          route {
                                                ch == "\t" ==> { no_tabs = no_tabs + "      " }
                                                _ ==> { no_tabs = no_tabs + ch }
                                          }
                                          ti = ti + 1
                                    }
                              }
                        }

                        #L 2. Remove espacos excedentes a direita
                        mut as int64: nlen = stdCollectionLength(no_tabs)
                        mut as int64: end_pos = nlen
                        infinite {
                              route {
                                    end_pos < 1 ==> { break }
                                    _ ==> {
                                          mut as string: ech = no_tabs[end_pos]
                                          route {
                                                ech == " " or ech == "\r" ==> { end_pos = end_pos - 1 }
                                                _ ==> { break }
                                          }
                                    }
                              }
                        }

                        mut as string: clean_line = ""
                        route {
                              end_pos >= 1 ==> { clean_line = no_tabs[1..end_pos] }
                              _ ==> {}
                        }

                        #L 3. Converte comentario legado '#' para '#L'
                        mut as string: tr = lspTrimBoth(clean_line)
                        mut as int64: trlen = stdCollectionLength(tr)
                        route {
                              trlen >= 1 and tr[1] == "#" ==> {
                                    mut as bool: needs_l = true
                                    route {
                                          trlen >= 2 ==> {
                                                mut as string: c2 = tr[2]
                                                route {
                                                      c2 == "L" or c2 == "B" or c2 == "D" ==> { needs_l = false }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          needs_l ==> {
                                                #L Injeta L apos #
                                                mut as int64: h_pos = 1
                                                infinite {
                                                      route {
                                                            h_pos > stdCollectionLength(clean_line) ==> { break }
                                                            clean_line[h_pos] == "#" ==> {
                                                                  clean_line = clean_line[1..h_pos] + "L" + clean_line[(h_pos + 1)..stdCollectionLength(clean_line)]
                                                                  break
                                                            }
                                                            _ ==> { h_pos = h_pos + 1 }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }

                        formatted = formatted + clean_line + "\n"
                        li = li + 1
                  }
            }
      }
      emit(nice, formatted, "ok")
}

function (lspGetDocumentSymbols) (as string: text) as string {
      mut as list of string: lines = lspSplitLines(text)
      mut as int64: n_lines = stdCollectionLength(lines)
      mut as list of string: sym_items = []
      mut as int64: li = 1
      infinite {
            route {
                  li > n_lines ==> { break }
                  _ ==> {
                        mut as string: line = "" + lines[li]
                        mut as string: tr = lspTrimBoth(line)
                        mut as int64: trlen = stdCollectionLength(tr)
                        mut as string: sym_name = ""
                        mut as int64: sym_kind = 0

                        route {
                              trlen >= 8 and tr[1..8] == "program " ==> {
                                    sym_kind = 12
                                    #L Extrai nome entre parenteses
                                    mut as int64: p1 = 9
                                    mut as int64: p2 = trlen
                                    route {
                                          tr[p1] == "(" ==> {
                                                p1 = p1 + 1
                                                mut as int64: fi = p1
                                                infinite {
                                                      route {
                                                            fi > trlen ==> { break }
                                                            tr[fi] == ")" ==> { p2 = fi - 1; break }
                                                            _ ==> { fi = fi + 1 }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route { p1 <= p2 ==> { sym_name = tr[p1..p2] } _ ==> {} }
                              }
                              trlen >= 9 and tr[1..9] == "contract " ==> {
                                    sym_kind = 11
                                    mut as int64: c1 = 10
                                    mut as int64: c2 = trlen
                                    route {
                                          tr[c1] == "(" ==> {
                                                c1 = c1 + 1
                                                mut as int64: cfi = c1
                                                infinite {
                                                      route {
                                                            cfi > trlen ==> { break }
                                                            tr[cfi] == ")" ==> { c2 = cfi - 1; break }
                                                            _ ==> { cfi = cfi + 1 }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route { c1 <= c2 ==> { sym_name = tr[c1..c2] } _ ==> {} }
                              }
                              trlen >= 6 and tr[1..6] == "agent " ==> {
                                    sym_kind = 5
                                    mut as int64: a1 = 7
                                    mut as int64: a2 = trlen
                                    route {
                                          tr[a1] == "(" ==> {
                                                a1 = a1 + 1
                                                mut as int64: afi = a1
                                                infinite {
                                                      route {
                                                            afi > trlen ==> { break }
                                                            tr[afi] == ")" ==> { a2 = afi - 1; break }
                                                            _ ==> { afi = afi + 1 }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route { a1 <= a2 ==> { sym_name = tr[a1..a2] } _ ==> {} }
                              }
                              trlen >= 9 and tr[1..9] == "function " ==> {
                                    sym_kind = 12
                                    mut as int64: f1 = 10
                                    mut as int64: f2 = trlen
                                    route {
                                          tr[f1] == "(" ==> {
                                                f1 = f1 + 1
                                                mut as int64: ffi = f1
                                                infinite {
                                                      route {
                                                            ffi > trlen ==> { break }
                                                            tr[ffi] == ")" ==> { f2 = ffi - 1; break }
                                                            _ ==> { ffi = ffi + 1 }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route { f1 <= f2 ==> { sym_name = tr[f1..f2] } _ ==> {} }
                              }
                              trlen >= 7 and tr[1..7] == "struct " ==> {
                                    sym_kind = 23
                                    mut as int64: s1 = 8
                                    mut as int64: s2 = trlen
                                    route {
                                          tr[s1] == "(" ==> {
                                                s1 = s1 + 1
                                                mut as int64: sfi = s1
                                                infinite {
                                                      route {
                                                            sfi > trlen ==> { break }
                                                            tr[sfi] == ")" ==> { s2 = sfi - 1; break }
                                                            _ ==> { sfi = sfi + 1 }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route { s1 <= s2 ==> { sym_name = tr[s1..s2] } _ ==> {} }
                              }
                              trlen >= 3 and tr[1..3] == "op " ==> {
                                    sym_kind = 6
                                    mut as int64: o1 = 4
                                    mut as int64: oi = o1
                                    infinite {
                                          route {
                                                oi > trlen ==> { break }
                                                tr[oi] == " " or tr[oi] == "(" ==> { break }
                                                _ ==> { oi = oi + 1 }
                                          }
                                    }
                                    route { o1 < oi ==> { sym_name = tr[o1..(oi - 1)] } _ ==> {} }
                              }
                              _ ==> {}
                        }

                        route {
                              sym_name != "" ==> {
                                    mut as int64: lidx = li - 1
                                    mut as string: item = "{\"name\":\"" + sym_name + "\",\"kind\":" + sym_kind + ",\"range\":{\"start\":{\"line\":" + lidx + ",\"character\":0},\"end\":{\"line\":" + lidx + ",\"character\":" + stdCollectionLength(line) + "}},\"selectionRange\":{\"start\":{\"line\":" + lidx + ",\"character\":0},\"end\":{\"line\":" + lidx + ",\"character\":" + stdCollectionLength(line) + "}}}"
                                    sym_items = stdListPushBack(sym_items, item)
                              }
                              _ ==> {}
                        }
                        li = li + 1
                  }
            }
      }

      mut as string: out = "["
      mut as int64: ns = stdCollectionLength(sym_items)
      mut as int64: si = 1
      infinite {
            route {
                  si > ns ==> { break }
                  _ ==> {
                        out = out + sym_items[si]
                        route { si < ns ==> { out = out + "," } _ ==> {} }
                        si = si + 1
                  }
            }
      }
      out = out + "]"
      emit(nice, out, "ok")
}

function (lspExtractWordAt) (as string: line_text, as int64: char_idx) as string {
      mut as int64: llen = stdCollectionLength(line_text)
      route {
            llen == 0 ==> { emit(nice, "", "ok") }
            _ ==> {}
      }
      mut as int64: col = char_idx + 1
      route {
            col > llen ==> { col = llen }
            col < 1 ==> { col = 1 }
            _ ==> {}
      }

      #L Checa se o cursor esta sobre operadores especiais de 2 a 3 chars
      route {
            col + 2 <= llen and line_text[col..(col + 2)] == "==>" ==> { emit(nice, "==>", "ok") }
            col >= 2 and col + 1 <= llen and line_text[(col - 1)..(col + 1)] == "==>" ==> { emit(nice, "==>", "ok") }
            col >= 3 and line_text[(col - 2)..col] == "==>" ==> { emit(nice, "==>", "ok") }
            col + 1 <= llen and (line_text[col..(col + 1)] == "/i" or line_text[col..(col + 1)] == "/r" or line_text[col..(col + 1)] == "/f" or line_text[col..(col + 1)] == "::") ==> {
                  emit(nice, line_text[col..(col + 1)], "ok")
            }
            col >= 2 and (line_text[(col - 1)..col] == "/i" or line_text[(col - 1)..col] == "/r" or line_text[(col - 1)..col] == "/f" or line_text[(col - 1)..col] == "::") ==> {
                  emit(nice, line_text[(col - 1)..col], "ok")
            }
            _ ==> {}
      }

      route {
            not lspIsWordChar(line_text[col]) ==> {
                  route {
                        col > 1 and lspIsWordChar(line_text[col - 1]) ==> { col = col - 1 }
                        _ ==> { emit(nice, "", "ok") }
                  }
            }
            _ ==> {}
      }

      mut as int64: left = col
      infinite {
            route {
                  left <= 1 ==> { break }
                  _ ==> {
                        route {
                              lspIsWordChar(line_text[left - 1]) ==> { left = left - 1 }
                              _ ==> { break }
                        }
                  }
            }
      }

      mut as int64: right = col
      infinite {
            route {
                  right >= llen ==> { break }
                  _ ==> {
                        route {
                              lspIsWordChar(line_text[right + 1]) ==> { right = right + 1 }
                              _ ==> { break }
                        }
                  }
            }
      }

      emit(nice, line_text[left..right], "ok")
}

function (lspGenerateNotepadPlusPlusXml) () as string {
      mut as string: xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n"
      xml = xml + "<NotepadPlus>\n"
      xml = xml + "    <UserLang name=\"TheFlux\" ext=\"flux fdsl\" udlVersion=\"2.1\">\n"
      xml = xml + "        <Settings>\n"
      xml = xml + "            <GlobalCaseIgnored>no</GlobalCaseIgnored>\n"
      xml = xml + "            <TreatAsSymbol>yes</TreatAsSymbol>\n"
      xml = xml + "            <Prefix words1=\"no\" words2=\"no\" words3=\"no\" words4=\"no\" />\n"
      xml = xml + "        </Settings>\n"
      xml = xml + "        <KeywordLists>\n"
      xml = xml + "            <Keywords name=\"Comments\">00#L 01#B 02B# 03#D 04D#</Keywords>\n"
      xml = xml + "            <Keywords name=\"Numbers\" />\n"
      xml = xml + "            <Keywords name=\"Words1\">program contract agent impl function op struct enum use</Keywords>\n"
      xml = xml + "            <Keywords name=\"Words2\">route match infinite break continue emit nice fail return</Keywords>\n"
      xml = xml + "            <Keywords name=\"Words3\">mut imut as of in keep borrow borrow_mut copy move</Keywords>\n"
      xml = xml + "            <Keywords name=\"Words4\">int64 int32 int16 int8 uint64 uint32 uint16 uint8 float64 float32 string bool char datetime complex128 tensor list map set data void</Keywords>\n"
      xml = xml + "            <Keywords name=\"Words5\">and or not unsafe comptime async await spawn spy</Keywords>\n"
      xml = xml + "            <Keywords name=\"Words6\">print input println</Keywords>\n"
      xml = xml + "            <Keywords name=\"Words7\">true false null nil _</Keywords>\n"
      xml = xml + "            <Keywords name=\"Words8\">==&gt; -&gt; :: /i /r /f %</Keywords>\n"
      xml = xml + "            <Keywords name=\"Delimiters\">00&quot; 01&quot; 02&apos; 03&apos;</Keywords>\n"
      xml = xml + "            <Keywords name=\"Operators1\">==&gt; /i /r /f % + - * / &amp; | ^ ~ ! = &lt; &gt; == != &lt;= &gt;= :: ..</Keywords>\n"
      xml = xml + "            <Keywords name=\"Operators2\">( ) [ ] { } , ; : .</Keywords>\n"
      xml = xml + "        </KeywordLists>\n"
      xml = xml + "        <Styles>\n"
      xml = xml + "            <WordsStyle name=\"DEFAULT\" styleID=\"11\" fgColor=\"E0E6ED\" bgColor=\"1E1E1E\" fontName=\"\" fontStyle=\"0\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"COMMENTS\" styleID=\"1\" fgColor=\"7F848E\" bgColor=\"1C2026\" fontName=\"\" fontStyle=\"2\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"LINE COMMENT\" styleID=\"2\" fgColor=\"7F848E\" bgColor=\"1C2026\" fontName=\"\" fontStyle=\"2\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"NUMBERS\" styleID=\"4\" fgColor=\"F78C6C\" bgColor=\"35211B\" fontName=\"\" fontStyle=\"0\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"STRINGS\" styleID=\"6\" fgColor=\"C3E88D\" bgColor=\"21331B\" fontName=\"\" fontStyle=\"0\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"DELIMITERS\" styleID=\"14\" fgColor=\"C3E88D\" bgColor=\"21331B\" fontName=\"\" fontStyle=\"0\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"OPERATORS\" styleID=\"10\" fgColor=\"00FFFF\" bgColor=\"0A333A\" fontName=\"\" fontStyle=\"1\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"WORDS1\" styleID=\"5\" fgColor=\"C792EA\" bgColor=\"2E1C38\" fontName=\"\" fontStyle=\"1\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"WORDS2\" styleID=\"6\" fgColor=\"FFCB6B\" bgColor=\"382F18\" fontName=\"\" fontStyle=\"1\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"WORDS3\" styleID=\"7\" fgColor=\"FF6B6B\" bgColor=\"3B1A1E\" fontName=\"\" fontStyle=\"1\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"WORDS4\" styleID=\"8\" fgColor=\"82AAFF\" bgColor=\"1A2744\" fontName=\"\" fontStyle=\"0\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"WORDS5\" styleID=\"9\" fgColor=\"E06C75\" bgColor=\"351D24\" fontName=\"\" fontStyle=\"0\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"WORDS6\" styleID=\"12\" fgColor=\"80CBC4\" bgColor=\"1B3230\" fontName=\"\" fontStyle=\"1\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"WORDS7\" styleID=\"13\" fgColor=\"D19A66\" bgColor=\"30241A\" fontName=\"\" fontStyle=\"1\" fontSize=\"\" />\n"
      xml = xml + "            <WordsStyle name=\"WORDS8\" styleID=\"15\" fgColor=\"00FFFF\" bgColor=\"0A333A\" fontName=\"\" fontStyle=\"1\" fontSize=\"\" />\n"
      xml = xml + "        </Styles>\n"
      xml = xml + "    </UserLang>\n"
      xml = xml + "</NotepadPlus>\n"
      emit(nice, xml, "ok")
}

function (lspWriteXml) (as string: target_path) as int64 {
      mut as string: dest = target_path
      route {
            dest == "" ==> { dest = "theflux_npp.xml" }
            _ ==> {}
      }
      mut as string: content = lspGenerateNotepadPlusPlusXml()
      stdIoWriteFile(dest, content)
      print("[OK] Definicao de linguagem Notepad++ (UDL 2.1) gerada com sucesso em: " + dest)
      emit(nice, 0, "ok")
}

function (lspGetInitializeCapabilities) () as string {
      mut as string: cap = "{\"capabilities\":{\"textDocumentSync\":1,\"hoverProvider\":true,\"completionProvider\":{\"resolveProvider\":false,\"triggerCharacters\":[\".\",\":\",\"#\"]},\"definitionProvider\":true,\"documentFormattingProvider\":true,\"documentSymbolProvider\":true}"
      cap = cap + ",\"serverInfo\":{\"name\":\"fluxlsp\",\"version\":\"1.0.0\"}}"
      emit(nice, cap, "ok")
}

function (lspServerLoop) () as int64 {
      #L Tabela de documentos em memoria: uri -> conteudo
      mut as map: docs = map{}

      mut as int64: eof_counter = 0

      infinite {
            #L 1. Leitura do Cabecalho Content-Length
            mut as string: h_line = input("")
            mut as string: cl_tr = lspTrimBoth(h_line)
            mut as int64: clen = lspExtractHeaderContentLength(cl_tr)

            route {
                  clen <= 0 ==> {
                        eof_counter = eof_counter + 1
                        route {
                              eof_counter > 5 ==> {
                                    #L Fim do fluxo de entrada (stdin fechado pelo cliente)
                                    break
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {
                        eof_counter = 0
                        #L Le a linha em branco separadora de cabecalho
                        mut as string: sep = input("")

                        #L Leitura do Corpo da Mensagem JSON
                        mut as string: payload = input("")
                        mut as string: method = lspExtractJsonString(payload, "method")
                        mut as string: id_str = "" + lspExtractJsonInt(payload, "id")

                        route {
                              method == "initialize" ==> {
                                    lspSendResponse(id_str, lspGetInitializeCapabilities())
                              }
                              method == "initialized" ==> {
                                    #L Notificacao de confirmacao: sem resposta
                              }
                              method == "textDocument/didOpen" ==> {
                                    mut as string: uri = lspExtractJsonString(payload, "uri")
                                    mut as string: doc_text = lspExtractJsonString(payload, "text")
                                    docs[uri] = doc_text
                                    mut as string: diags = lspComputeDiagnostics(doc_text)
                                    lspSendNotification("textDocument/publishDiagnostics", "{\"uri\":\"" + uri + "\",\"diagnostics\":" + diags + "}")
                              }
                              method == "textDocument/didChange" ==> {
                                    mut as string: uri2 = lspExtractJsonString(payload, "uri")
                                    mut as string: new_text = lspExtractJsonString(payload, "text")
                                    docs[uri2] = new_text
                                    mut as string: diags2 = lspComputeDiagnostics(new_text)
                                    lspSendNotification("textDocument/publishDiagnostics", "{\"uri\":\"" + uri2 + "\",\"diagnostics\":" + diags2 + "}")
                              }
                              method == "textDocument/didSave" ==> {
                                    mut as string: uri3 = lspExtractJsonString(payload, "uri")
                                    route {
                                          stdMapContainsKey(docs, uri3) ==> {
                                                mut as string: st = "" + docs[uri3]
                                                mut as string: diags3 = lspComputeDiagnostics(st)
                                                lspSendNotification("textDocument/publishDiagnostics", "{\"uri\":\"" + uri3 + "\",\"diagnostics\":" + diags3 + "}")
                                          }
                                          _ ==> {}
                                    }
                              }
                              method == "textDocument/didClose" ==> {
                                    mut as string: uri4 = lspExtractJsonString(payload, "uri")
                                    #L Limpa os diagnosticos ao fechar
                                    lspSendNotification("textDocument/publishDiagnostics", "{\"uri\":\"" + uri4 + "\",\"diagnostics\":[]}")
                              }
                              method == "textDocument/hover" ==> {
                                    mut as string: uri5 = lspExtractJsonString(payload, "uri")
                                    mut as int64: line_idx = lspExtractJsonInt(payload, "line")
                                    mut as int64: char_idx = lspExtractJsonInt(payload, "character")
                                    mut as string: h_doc = ""
                                    route {
                                          stdMapContainsKey(docs, uri5) ==> {
                                                mut as string: body_txt = "" + docs[uri5]
                                                mut as list of string: doc_lines = lspSplitLines(body_txt)
                                                route {
                                                      line_idx + 1 <= stdCollectionLength(doc_lines) ==> {
                                                            mut as string: target_line = doc_lines[line_idx + 1]
                                                            mut as string: word = lspExtractWordAt(target_line, char_idx)
                                                            h_doc = lspGetHoverDoc(word)
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          h_doc != "" ==> {
                                                mut as string: esc_doc = lspEscapeJson(h_doc)
                                                lspSendResponse(id_str, "{\"contents\":{\"kind\":\"markdown\",\"value\":\"" + esc_doc + "\"}}")
                                          }
                                          _ ==> {
                                                lspSendResponse(id_str, "null")
                                          }
                                    }
                              }
                              method == "textDocument/completion" ==> {
                                    mut as string: comp_json = lspGetCompletionList()
                                    lspSendResponse(id_str, comp_json)
                              }
                              method == "textDocument/definition" ==> {
                                    mut as string: uri6 = lspExtractJsonString(payload, "uri")
                                    mut as int64: d_line = lspExtractJsonInt(payload, "line")
                                    mut as int64: d_char = lspExtractJsonInt(payload, "character")
                                    mut as string: def_loc = "null"
                                    route {
                                          stdMapContainsKey(docs, uri6) ==> {
                                                mut as string: body_txt2 = "" + docs[uri6]
                                                mut as list of string: d_lines = lspSplitLines(body_txt2)
                                                route {
                                                      d_line + 1 <= stdCollectionLength(d_lines) ==> {
                                                            mut as string: tline = d_lines[d_line + 1]
                                                            mut as string: word2 = lspExtractWordAt(tline, d_char)
                                                            def_loc = lspFindDefinition(body_txt2, word2, uri6)
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    lspSendResponse(id_str, def_loc)
                              }
                              method == "textDocument/formatting" ==> {
                                    mut as string: uri7 = lspExtractJsonString(payload, "uri")
                                    route {
                                          stdMapContainsKey(docs, uri7) ==> {
                                                mut as string: orig = "" + docs[uri7]
                                                mut as string: fmt = lspFormatDocument(orig)
                                                docs[uri7] = fmt
                                                mut as list of string: flines = lspSplitLines(orig)
                                                mut as int64: last_line = stdCollectionLength(flines) - 1
                                                route { last_line < 0 ==> { last_line = 0 } _ ==> {} }
                                                mut as string: esc_fmt = lspEscapeJson(fmt)
                                                mut as string: edits = "[{\"range\":{\"start\":{\"line\":0,\"character\":0},\"end\":{\"line\":" + last_line + ",\"character\":9999}},\"newText\":\"" + esc_fmt + "\"}]"
                                                lspSendResponse(id_str, edits)
                                          }
                                          _ ==> {
                                                lspSendResponse(id_str, "[]")
                                          }
                                    }
                              }
                              method == "textDocument/documentSymbol" ==> {
                                    mut as string: uri8 = lspExtractJsonString(payload, "uri")
                                    mut as string: syms = "[]"
                                    route {
                                          stdMapContainsKey(docs, uri8) ==> {
                                                mut as string: body_txt3 = "" + docs[uri8]
                                                syms = lspGetDocumentSymbols(body_txt3)
                                          }
                                          _ ==> {}
                                    }
                                    lspSendResponse(id_str, syms)
                              }
                              method == "shutdown" ==> {
                                    lspSendResponse(id_str, "null")
                              }
                              method == "exit" ==> {
                                    stdOsExit(0)
                              }
                              _ ==> {
                                    #L Resposta padrao nula para chamadas nao tratadas
                                    route {
                                          id_str != "0" ==> {
                                                lspSendResponse(id_str, "null")
                                          }
                                          _ ==> {}
                                    }
                              }
                        }
                  }
            }
      }
      emit(nice, 0, "ok")
}

program (FluxLsp) {
      mut as list of string: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)

      mut as bool: flag_help = false
      mut as bool: flag_version = false
      mut as bool: flag_xml = false
      mut as string: xml_dest = "theflux_npp.xml"

      mut as int64: i = 1
      route {
            n_args >= 2 and ("" + args[2]) == "--" ==> {
                  i = 3
            }
            _ ==> {}
      }

      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: arg = "" + args[i]
                        route {
                              arg == "--" ==> {}
                              arg == "help" or arg == "-h" or arg == "--h" or arg == "--help" or arg == "-help" ==> {
                                    flag_help = true
                              }
                              arg == "version" or arg == "-v" or arg == "--v" or arg == "--version" or arg == "-version" ==> {
                                    flag_version = true
                              }
                              arg == "--xml" or arg == "-xml" ==> {
                                    flag_xml = true
                                    i = i + 1
                                    route {
                                          i <= n_args ==> {
                                                mut as string: nxt = "" + args[i]
                                                route {
                                                      nxt[1] != "-" ==> { xml_dest = nxt }
                                                      _ ==> { i = i - 1 }
                                                }
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }
            }
      }

      route {
            flag_help ==> {
                  lspPrintHelp()
                  stdOsExit(0)
            }
            flag_version ==> {
                  lspPrintVersion()
                  stdOsExit(0)
            }
            flag_xml ==> {
                  lspWriteXml(xml_dest)
                  stdOsExit(0)
            }
            _ ==> {
                  #L Servidor de Linguagem (Language Server Protocol) padrao via stdio
                  lspServerLoop()
                  stdOsExit(0)
            }
      }
}
