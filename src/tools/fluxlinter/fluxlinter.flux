#L ==============================================================================
#L TheFlux Tool: fluxlinter (v0.9.9)
#L Utilitario de Analise Estatica e Linter Canônico para TheFlux
#L Inspirado na arquitetura do Clippy do ecossistema Rust (rustc)
#L ==============================================================================

function (linterPrintHelp) () as int64 {
      print("fluxlinter - Utilitario de Analise Estatica e Linter TheFlux (v0.9.9)")
      print("Inspirado no Clippy do rustc: analise estatica profunda, AST e sugestoes")
      print("")
      print("Sintaxe:")
      print("  fluxlinter [flags] [caminho ...]")
      print("")
      print("Modos de Operacao:")
      print("  fluxlinter .\\*              Inspeciona arquivos .flux e .fdsl no diretorio atual")
      print("  fluxlinter .\\* -r           Inspeciona recursivamente a partir do diretorio atual")
      print("  fluxlinter <Nome>           Inspeciona arquivo especifico ou pasta/projeto <Nome>")
      print("  fluxlinter -l, --list       Lista todos os lints registrados e suas categorias")
      print("  fluxlinter -e, --explain L  Exibe explicacao detalhada e exemplos do lint L")
      print("  fluxlinter help | -h        Exibe este manual de ajuda")
      print("  fluxlinter version | -v     Exibe a versao do utilitario")
      print("")
      print("Controle de Severidade (Estilo Clippy, aceitam '-' ou '--'):")
      print("  -W, --warn <lint|cat>     Trata o lint ou categoria como warning (alerta sem abortar)")
      print("  -D, --deny <lint|cat>     Trata o lint ou categoria como erro (exit code 1 se disparado)")
      print("  -A, --allow <lint|cat>    Silencia / ignora o lint ou categoria")
      print("  -F, --forbid <lint|cat>   Trata o lint como proibicao irrevogavel")
      print("")
      print("Acoes de Correcao e Saida (aceitam '-' ou '--'):")
      print("  -f, --fix                 Aplica correcoes automaticas seguras diretamente no disco")
      print("  -d, --diff                Exibe diff unificado com as correcoes propostas sem alterar disco")
      print("  -r, --recursive           Percorre subdiretorios recursivamente")
      print("  -l, --list, --list-lints  Lista todos os lints disponiveis")
      print("  -e, --explain <lint>      Exibe documentacao completa do lint especificado")
      print("  -v, --version             Exibe a versao (fluxlinter version 0.9.9)")
      print("  -h, --help                Exibe esta mensagem de ajuda")
      print("")
      print("Categorias Disponiveis:")
      print("  correctness               Bugs e anti-patterns quase certamente incorretos (default: deny)")
      print("  suspicious                Construcoes suspeitas ou provaveis enganos (default: warn)")
      print("  style                     Padroes fora das convencoes canonicas TheFlux (default: warn)")
      print("  complexity                Codigo prolixo que pode ser simplificado (default: warn)")
      print("  clippy::all               Atalho para todos os lints cadastrados")
      print("")
      print("Exemplos:")
      print("  fluxlinter examples\\Canon\\ExampleOfRoute.flux")
      print("  fluxlinter -D fluxlinter::unreachable_route_arm src\\* -r")
      print("  fluxlinter -f examples\\demo.flux")
      print("  fluxlinter -d -r src\\tools")
      print("  fluxlinter --explain fluxlinter::redundant_mut")
      emit(nice, 0, "ok")
}

function (linterPrintVersion) () as int64 {
      print("fluxlinter version 0.9.9")
      emit(nice, 0, "ok")
}

function (linterPrintList) () as int64 {
      print("Lints Registrados no fluxlinter (v0.9.9):")
      print("")
      print("Nome do Lint                               Categoria     Padrao   Descricao")
      print("-----------------------------------------  ------------  -------  ---------------------------------------")
      print("fluxlinter::division_by_zero               correctness   deny     Divisao inteira ou resto por literal zero")
      print("fluxlinter::unreachable_route_arm          correctness   deny     Ramo de rota posicionado apos coringa '_'")
      print("fluxlinter::empty_infinite_loop            correctness   deny     Loop infinite sem condicao de saida (break/emit)")
      print("fluxlinter::self_assignment                suspicious    warn     Atribuicao redundante a mesma variavel (x = x)")
      print("fluxlinter::tautological_comparison        suspicious    warn     Comparacao identica sempre verdadeira/falsa (a == a)")
      print("fluxlinter::missing_operation_emit         suspicious    warn     Operacao de agente sem caminho de saida via emit")
      print("fluxlinter::redundant_mut                  style         warn     Variavel mut nunca modificada (prefira imut)")
      print("fluxlinter::legacy_comment                 style         warn     Comentario legado '#' em vez de '#L'")
      print("fluxlinter::naming_convention              style         warn     Contrato/Agente fora de PascalCase")
      print("fluxlinter::collapsible_route              complexity    warn     Rota booleana redutivel a expressao direta")
      print("fluxlinter::superfluous_guard_parens       complexity    warn     Parenteses redundantes em guarda de rota: (c) ==>")
      print("")
      print("Total: 11 lints registrados.")
      emit(nice, 0, "ok")
}

function (linterExplain) (as string: lint_name) as int64 {
      route {
            lint_name == "fluxlinter::division_by_zero" or lint_name == "division_by_zero" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::division_by_zero")
                  print("Categoria: correctness | Nivel Padrao: deny")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Operacoes de divisao inteira (/i) ou resto (/r) onde o divisor e o literal 0.")
                  print("")
                  print("Por que isso e ruim:")
                  print("  Divisao por zero em TheFlux resulta em erro semantico ou de execucao imediato")
                  print("  (fail:div_zero), interrompendo o fluxo normal de execucao.")
                  print("")
                  print("Exemplo Incorreto:")
                  print("  mut as int64: q = 10 /i 0")
                  print("")
                  print("Exemplo Correto:")
                  print("  mut as int64: divisor = 2")
                  print("  mut as int64: q = 10 /i divisor")
                  emit(nice, 0, "ok")
            }
            lint_name == "fluxlinter::unreachable_route_arm" or lint_name == "unreachable_route_arm" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::unreachable_route_arm")
                  print("Categoria: correctness | Nivel Padrao: deny")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Clausulas em bloco route declaradas apos o padrao coringa '_ ==> { ... }'.")
                  print("")
                  print("Por que isso e ruim:")
                  print("  O padrao coringa '_' captura incondicionalmente qualquer caso remanescente.")
                  print("  Qualquer ramo subsequente e codigo morto inalcancavel.")
                  print("")
                  print("Exemplo Incorreto:")
                  print("  route {")
                  print("        x > 0 ==> { print(\"positivo\") }")
                  print("        _ ==> { print(\"padrao\") }")
                  print("        x == 0 ==> { print(\"zero\") }  #L NUNCA SERA EXECUTADO!")
                  print("  }")
                  print("")
                  print("Exemplo Correto:")
                  print("  route {")
                  print("        x > 0 ==> { print(\"positivo\") }")
                  print("        x == 0 ==> { print(\"zero\") }")
                  print("        _ ==> { print(\"padrao\") }")
                  print("  }")
                  emit(nice, 0, "ok")
            }
            lint_name == "fluxlinter::empty_infinite_loop" or lint_name == "empty_infinite_loop" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::empty_infinite_loop")
                  print("Categoria: correctness | Nivel Padrao: deny")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Blocos 'infinite { ... }' que nao possuem nenhum mecanismo de saida")
                  print("  (break, emit, return ou chamada de interrupcao de processo).")
                  print("")
                  print("Por que isso e ruim:")
                  print("  Um loop sem caminho de saida causara travamento permanente do processo com")
                  print("  consumo descontrolado de 100% de CPU.")
                  emit(nice, 0, "ok")
            }
            lint_name == "fluxlinter::self_assignment" or lint_name == "self_assignment" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::self_assignment")
                  print("Categoria: suspicious | Nivel Padrao: warn")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Atribuicoes redundantes onde a variavel destino recebe o seu proprio valor.")
                  print("")
                  print("Exemplo Incorreto:")
                  print("  total = total")
                  print("")
                  print("Sugestao:")
                  print("  Remova a linha redundante ou corrija o identificador pretendido.")
                  emit(nice, 0, "ok")
            }
            lint_name == "fluxlinter::tautological_comparison" or lint_name == "tautological_comparison" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::tautological_comparison")
                  print("Categoria: suspicious | Nivel Padrao: warn")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Comparacao de um identificador consigo mesmo (a == a ou b != b).")
                  print("")
                  print("Por que isso e ruim:")
                  print("  A expressao sempre avaliara para true (ou false), geralmente indicando erro")
                  print("  de digitacao ao comparar duas variaveis distintas.")
                  emit(nice, 0, "ok")
            }
            lint_name == "fluxlinter::missing_operation_emit" or lint_name == "missing_operation_emit" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::missing_operation_emit")
                  print("Categoria: suspicious | Nivel Padrao: warn")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Operacoes de agentes em TheFlux ('op Nome (...) ==> { ... }') que nao possuem")
                  print("  nenhuma clausula emit(...) em seu corpo.")
                  print("")
                  print("Por que isso e ruim:")
                  print("  No paradigma de agentes de TheFlux, operacoes devem emitir um resultado")
                  print("  monadico tipado (nice/fail) para satisfazer o contrato com o chamador.")
                  emit(nice, 0, "ok")
            }
            lint_name == "fluxlinter::redundant_mut" or lint_name == "redundant_mut" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::redundant_mut")
                  print("Categoria: style | Nivel Padrao: warn (Suporta --fix)")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Variaveis declaradas com 'mut as tipo: nome = valor' cujo valor nunca sofre")
                  print("  nenhuma reatribuicao no restante de seu escopo.")
                  print("")
                  print("Por que isso e ruim:")
                  print("  TheFlux prioriza a imutabilidade por padrao para maior seguranca de concorrencia")
                  print("  e clareza semantica. Declare 'imut' se a variavel nao precisa sofrer mutacoes.")
                  print("")
                  print("Exemplo Incorreto:")
                  print("  mut as int64: pi = 314")
                  print("  print(pi)")
                  print("")
                  print("Correcao Automatica (--fix):")
                  print("  imut as int64: pi = 314")
                  emit(nice, 0, "ok")
            }
            lint_name == "fluxlinter::legacy_comment" or lint_name == "legacy_comment" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::legacy_comment")
                  print("Categoria: style | Nivel Padrao: warn (Suporta --fix)")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Uso de comentario de linha legado no estilo '# texto' em vez de '#L texto'.")
                  print("")
                  print("Correcao Automatica (--fix):")
                  print("  Substitui automaticamente '# ' por '#L ' no inicio do comentario.")
                  emit(nice, 0, "ok")
            }
            lint_name == "fluxlinter::naming_convention" or lint_name == "naming_convention" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::naming_convention")
                  print("Categoria: style | Nivel Padrao: warn")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Declaracoes de 'agent' ou 'contract' cujos identificadores nao iniciam com letra")
                  print("  maiuscula (violacao de PascalCase).")
                  emit(nice, 0, "ok")
            }
            lint_name == "fluxlinter::collapsible_route" or lint_name == "collapsible_route" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::collapsible_route")
                  print("Categoria: complexity | Nivel Padrao: warn")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Rotas booleanas que apenas retornam emit(nice, true, ...) / emit(nice, false, ...).")
                  print("")
                  print("Sugestao:")
                  print("  Reduza diretamente para emit(nice, condicao, \"ok\").")
                  emit(nice, 0, "ok")
            }
            lint_name == "fluxlinter::superfluous_guard_parens" or lint_name == "superfluous_guard_parens" ==> {
                  print("==============================================================================")
                  print("Lint: fluxlinter::superfluous_guard_parens")
                  print("Categoria: complexity | Nivel Padrao: warn (Suporta --fix)")
                  print("==============================================================================")
                  print("O que detecta:")
                  print("  Parenteses externos supérfluos cercando a expressao de uma guarda de rota:")
                  print("  '(condicao) ==> { ... }'.")
                  print("")
                  print("Correcao Automatica (--fix):")
                  print("  Remove os parenteses externos: 'condicao ==> { ... }'.")
                  emit(nice, 0, "ok")
            }
            _ ==> {
                  print("fluxlinter: lint desconhecido '" + lint_name + "'. Use --list-lints para ver os lints registrados.")
                  emit(nice, 2, "ok")
            }
      }
}

function (linterTrimRight) (as string: s) as string {
      mut as int64: n = stdCollectionLength(s)
      infinite {
            route {
                  n < 1 ==> { break }
                  _ ==> {
                        mut as string: ch = s[n]
                        route {
                              ch == " " or ch == "\t" or ch == "\r" or ch == "\n" ==> {
                                    n = n - 1
                              }
                              _ ==> { break }
                        }
                  }
            }
      }
      route {
            n < 1 ==> { emit(nice, "", "ok") }
            _ ==> { emit(nice, s[1..n], "ok") }
      }
}

function (linterTrimBoth) (as string: s) as string {
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

function (linterHasFluxExt) (as string: path) as bool {
      mut as int64: n = stdCollectionLength(path)
      route {
            n >= 6 ==> {
                  mut as string: ext5 = path[(n - 4)..n]
                  route {
                        ext5 == ".flux" or ext5 == ".fdsl" ==> {
                              emit(nice, true, "ok")
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }
      emit(nice, false, "ok")
}

function (linterIsIgnoredDir) (as string: name) as bool {
      mut as string: dd = "." + "."
      route {
            name == "." or name == dd or name == ".git" or name == ".agent" or name == "node_modules" or name == "__pycache__" ==> {
                  emit(nice, true, "ok")
            }
            _ ==> {
                  emit(nice, false, "ok")
            }
      }
}

function (linterCharRank) (as string: ch) as int64 {
      mut as string: tbl = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
      mut as int64: tlen = stdCollectionLength(tbl)
      mut as int64: idx = 1
      infinite {
            route {
                  idx > tlen ==> { break }
                  tbl[idx] == ch ==> { emit(nice, idx + 31, "ok") }
                  _ ==> { idx = idx + 1 }
            }
      }
      emit(nice, 255, "ok")
}

function (linterStringLess) (as string: a, as string: b) as bool {
      mut as int64: la = stdCollectionLength(a)
      mut as int64: lb = stdCollectionLength(b)
      mut as int64: i = 1
      infinite {
            route {
                  i > la or i > lb ==> { break }
                  _ ==> {
                        mut as string: ca = a[i]
                        mut as string: cb = b[i]
                        route {
                              ca != cb ==> {
                                    emit(nice, linterCharRank(ca) < linterCharRank(cb), "ok")
                              }
                              _ ==> { i = i + 1 }
                        }
                  }
            }
      }
      emit(nice, la < lb, "ok")
}

function (linterSortStrings) (as list of string: items) as list of string {
      mut as int64: n = stdCollectionLength(items)
      mut as list of string: sorted = []
      mut as map: used = map{}
      mut as int64: step = 1
      infinite {
            route {
                  step > n ==> { break }
                  _ ==> {
                        mut as int64: best_idx = 0
                        mut as string: best_val = ""
                        mut as int64: j = 1
                        infinite {
                              route {
                                    j > n ==> { break }
                                    _ ==> {
                                          mut as string: kstr = "" + j
                                          route {
                                                not stdMapContainsKey(used, kstr) ==> {
                                                      mut as string: cand = "" + items[j]
                                                      route {
                                                            best_idx == 0 or linterStringLess(cand, best_val) ==> {
                                                                  best_idx = j
                                                                  best_val = cand
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          j = j + 1
                                    }
                              }
                        }
                        route {
                              best_idx > 0 ==> {
                                    mut as string: bkey = "" + best_idx
                                    used[bkey] = true
                                    sorted = stdListPushBack(sorted, best_val)
                              }
                              _ ==> {}
                        }
                        step = step + 1
                  }
            }
      }
      emit(nice, sorted, "ok")
}

function (linterMatchWildcard) (as string: name, as string: pat) as bool {
      route {
            pat == "" or pat == "*" or pat == "*.*" ==> {
                  emit(nice, linterHasFluxExt(name), "ok")
            }
            _ ==> {}
      }
      mut as int64: plen = stdCollectionLength(pat)
      mut as int64: nlen = stdCollectionLength(name)
      mut as int64: star_pos = 0
      mut as int64: i = 1
      infinite {
            route {
                  i > plen ==> { break }
                  pat[i] == "*" ==> {
                        star_pos = i
                        break
                  }
                  _ ==> { i = i + 1 }
            }
      }

      route {
            star_pos == 0 ==> {
                  emit(nice, name == pat, "ok")
            }
            _ ==> {
                  mut as string: pref = ""
                  route {
                        star_pos > 1 ==> { pref = pat[1..(star_pos - 1)] }
                        _ ==> {}
                  }
                  mut as string: suff = ""
                  route {
                        star_pos < plen ==> { suff = pat[(star_pos + 1)..plen] }
                        _ ==> {}
                  }
                  mut as int64: pref_len = stdCollectionLength(pref)
                  mut as int64: suf_len = stdCollectionLength(suff)
                  route {
                        nlen < (pref_len + suf_len) ==> { emit(nice, false, "ok") }
                        _ ==> {}
                  }
                  route {
                        pref_len > 0 ==> {
                              route {
                                    name[1..pref_len] != pref ==> { emit(nice, false, "ok") }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  route {
                        suf_len > 0 ==> {
                              route {
                                    name[(nlen - suf_len + 1)..nlen] != suff ==> { emit(nice, false, "ok") }
                                    _ ==> {}
                              }
                        }
                        _ ==> {
                              route {
                                    not linterHasFluxExt(name) ==> { emit(nice, false, "ok") }
                                    _ ==> {}
                              }
                        }
                  }
                  emit(nice, true, "ok")
            }
      }
}

function (linterJoinDirEntry) (as string: dir_path, as string: ent) as string {
      route {
            dir_path == "" or dir_path == "." or dir_path == ".\\" or dir_path == "./" ==> {
                  emit(nice, ent, "ok")
            }
            _ ==> {
                  mut as int64: dlen = stdCollectionLength(dir_path)
                  mut as string: last_ch = dir_path[dlen]
                  mut as string: sep = "\\"
                  mut as int64: k = 1
                  infinite {
                        route {
                              k > dlen ==> { break }
                              dir_path[k] == "/" ==> {
                                    sep = "/"
                                    break
                              }
                              dir_path[k] == "\\" ==> {
                                    sep = "\\"
                                    break
                              }
                              _ ==> { k = k + 1 }
                        }
                  }
                  route {
                        last_ch == "/" or last_ch == "\\" ==> {
                              emit(nice, dir_path + ent, "ok")
                        }
                        _ ==> {
                              emit(nice, dir_path + sep + ent, "ok")
                        }
                  }
            }
      }
}

function (linterCollectDir) (as string: dir_path, as string: pattern, as bool: recursive, as list of string: acc) as list of string {
      mut as list of string: out = acc
      mut as list of string: raw_entries = stdIoListDir(dir_path)
      mut as list of string: entries = linterSortStrings(raw_entries)
      mut as int64: n = stdCollectionLength(entries)
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        mut as string: ent = "" + entries[i]
                        mut as string: full_p = linterJoinDirEntry(dir_path, ent)
                        route {
                              stdIoDirExists(full_p) ==> {
                                    route {
                                          recursive and (not linterIsIgnoredDir(ent)) ==> {
                                                out = linterCollectDir(full_p, pattern, true, out)
                                          }
                                          _ ==> {}
                                    }
                              }
                              stdIoFileExists(full_p) ==> {
                                    route {
                                          linterMatchWildcard(ent, pattern) ==> {
                                                out = stdListPushBack(out, full_p)
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
      emit(nice, out, "ok")
}

function (linterResolveTarget) (as string: target, as bool: recursive, as list of string: acc) as map {
      mut as map: res = map{}
      res["ok"] = true
      res["error"] = ""
      mut as list of string: files = acc
      mut as int64: tlen = stdCollectionLength(target)

      route {
            target == "." or target == ".\\" or target == "./" or target == "*" or target == ".\\*" or target == "./*" ==> {
                  files = linterCollectDir(".", "*", recursive, files)
                  res["args"] = files
                  emit(nice, res, "ok")
            }
            _ ==> {}
      }

      mut as bool: has_star = false
      mut as int64: last_sep = 0
      mut as int64: i = 1
      infinite {
            route {
                  i > tlen ==> { break }
                  _ ==> {
                        mut as string: ch = target[i]
                        route {
                              ch == "*" ==> { has_star = true }
                              ch == "/" or ch == "\\" ==> { last_sep = i }
                              _ ==> {}
                        }
                        i = i + 1
                  }
            }
      }

      route {
            has_star ==> {
                  mut as string: base_dir = "."
                  mut as string: pat = target
                  route {
                        last_sep > 1 ==> {
                              base_dir = target[1..(last_sep - 1)]
                        }
                        _ ==> {}
                  }
                  route {
                        last_sep > 0 and last_sep < tlen ==> {
                              pat = target[(last_sep + 1)..tlen]
                        }
                        last_sep == tlen ==> {
                              pat = "*"
                        }
                        _ ==> {}
                  }
                  route {
                        not stdIoDirExists(base_dir) ==> {
                              res["ok"] = false
                              res["error"] = "fluxlinter: diretorio nao encontrado: " + base_dir
                              res["args"] = files
                              emit(nice, res, "ok")
                        }
                        _ ==> {
                              files = linterCollectDir(base_dir, pat, recursive, files)
                              res["args"] = files
                              emit(nice, res, "ok")
                        }
                  }
            }
            stdIoFileExists(target) and (not stdIoDirExists(target)) ==> {
                  files = stdListPushBack(files, target)
                  res["args"] = files
                  emit(nice, res, "ok")
            }
            stdIoDirExists(target) ==> {
                  files = linterCollectDir(target, "*", recursive, files)
                  res["args"] = files
                  emit(nice, res, "ok")
            }
            stdIoDirExists("src\\" + target) ==> {
                  files = linterCollectDir("src\\" + target, "*", recursive, files)
                  res["args"] = files
                  emit(nice, res, "ok")
            }
            stdIoDirExists("examples\\" + target) ==> {
                  files = linterCollectDir("examples\\" + target, "*", recursive, files)
                  res["args"] = files
                  emit(nice, res, "ok")
            }
            _ ==> {
                  res["ok"] = false
                  res["error"] = "fluxlinter: caminho nao encontrado: " + target
                  res["args"] = files
                  emit(nice, res, "ok")
            }
      }
}

function (linterSplitLines) (as string: text) as list of string {
      mut as list of string: lines = []
      mut as int64: n = stdCollectionLength(text)
      route {
            n == 0 ==> { emit(nice, lines, "ok") }
            _ ==> {}
      }
      mut as int64: line_start = 1
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        mut as string: ch = text[i]
                        route {
                              ch == "\n" ==> {
                                    mut as int64: lend = i - 1
                                    route {
                                          lend >= line_start and text[lend] == "\r" ==> {
                                                lend = lend - 1
                                          }
                                          _ ==> {}
                                    }
                                    mut as string: line_s = ""
                                    route {
                                          lend >= line_start ==> {
                                                line_s = text[line_start..lend]
                                          }
                                          _ ==> {}
                                    }
                                    lines = stdListPushBack(lines, line_s)
                                    line_start = i + 1
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }
            }
      }
      route {
            line_start <= n ==> {
                  mut as int64: lend2 = n
                  route {
                        lend2 >= line_start and text[lend2] == "\r" ==> {
                              lend2 = lend2 - 1
                        }
                        _ ==> {}
                  }
                  mut as string: last_s = ""
                  route {
                        lend2 >= line_start ==> {
                              last_s = text[line_start..lend2]
                        }
                        _ ==> {}
                  }
                  lines = stdListPushBack(lines, last_s)
            }
            _ ==> {}
      }
      emit(nice, lines, "ok")
}

function (linterEndsWithNewline) (as string: text) as bool {
      mut as int64: n = stdCollectionLength(text)
      route {
            n == 0 ==> { emit(nice, false, "ok") }
            text[n] == "\n" ==> { emit(nice, true, "ok") }
            _ ==> { emit(nice, false, "ok") }
      }
}

function (linterGenerateDiff) (as string: orig_src, as string: fmt_src, as string: file_path) as string {
      mut as list of string: a_lines = linterSplitLines(orig_src)
      mut as list of string: b_lines = linterSplitLines(fmt_src)
      mut as int64: na = stdCollectionLength(a_lines)
      mut as int64: nb = stdCollectionLength(b_lines)
      mut as bool: a_nl = linterEndsWithNewline(orig_src)
      mut as bool: b_nl = linterEndsWithNewline(fmt_src)

      mut as int64: pref = 0
      infinite {
            route {
                  pref + 1 > na or pref + 1 > nb ==> { break }
                  ("" + a_lines[pref + 1]) != ("" + b_lines[pref + 1]) ==> { break }
                  (pref + 1 == na or pref + 1 == nb) and (a_nl != b_nl) ==> { break }
                  _ ==> { pref = pref + 1 }
            }
      }

      mut as int64: suff = 0
      route {
            a_nl == b_nl ==> {
                  infinite {
                        route {
                              (na - suff) <= pref or (nb - suff) <= pref ==> { break }
                              ("" + a_lines[na - suff]) != ("" + b_lines[nb - suff]) ==> { break }
                              _ ==> { suff = suff + 1 }
                        }
                  }
            }
            _ ==> {}
      }

      mut as int64: ctx_start = pref - 2
      route { ctx_start < 1 ==> { ctx_start = 1 } _ ==> {} }
      mut as int64: a_end = na - suff
      mut as int64: b_end = nb - suff
      mut as int64: ctx_after = 3
      route { suff < ctx_after ==> { ctx_after = suff } _ ==> {} }

      mut as int64: old_count = (a_end - ctx_start + 1) + ctx_after
      mut as int64: new_count = (b_end - ctx_start + 1) + ctx_after
      route { na == 0 ==> { old_count = 0 } _ ==> {} }
      route { nb == 0 ==> { new_count = 0 } _ ==> {} }

      mut as string: diff = "--- a/" + file_path + "\n"
      diff = diff + "+++ b/" + file_path + "\n"
      diff = diff + "@@ -" + ctx_start + "," + old_count + " +" + ctx_start + "," + new_count + " @@\n"

      mut as int64: ci = ctx_start
      infinite {
            route {
                  ci > pref ==> { break }
                  _ ==> {
                        diff = diff + " " + a_lines[ci] + "\n"
                        ci = ci + 1
                  }
            }
      }

      mut as int64: ai = pref + 1
      mut as int64: bi = pref + 1
      mut as string: rem_buf = ""
      mut as string: add_buf = ""
      infinite {
            route {
                  ai > a_end and bi > b_end ==> { break }
                  ai <= a_end and bi <= b_end and ("" + a_lines[ai]) == ("" + b_lines[bi]) and (not ((ai == na or bi == nb) and (a_nl != b_nl))) ==> {
                        diff = diff + rem_buf + add_buf
                        rem_buf = ""
                        add_buf = ""
                        diff = diff + " " + a_lines[ai] + "\n"
                        ai = ai + 1
                        bi = bi + 1
                  }
                  ai <= a_end and (bi + 1 <= b_end) and ("" + a_lines[ai]) == ("" + b_lines[bi + 1]) ==> {
                        add_buf = add_buf + "+" + b_lines[bi] + "\n"
                        bi = bi + 1
                  }
                  bi <= b_end and (ai + 1 <= a_end) and ("" + a_lines[ai + 1]) == ("" + b_lines[bi]) ==> {
                        rem_buf = rem_buf + "-" + a_lines[ai] + "\n"
                        route {
                              ai == na and (not a_nl) ==> {
                                    rem_buf = rem_buf + "\\ No newline at end of file\n"
                              }
                              _ ==> {}
                        }
                        ai = ai + 1
                  }
                  _ ==> {
                        route {
                              ai <= a_end ==> {
                                    rem_buf = rem_buf + "-" + a_lines[ai] + "\n"
                                    route {
                                          ai == na and (not a_nl) ==> {
                                                rem_buf = rem_buf + "\\ No newline at end of file\n"
                                          }
                                          _ ==> {}
                                    }
                                    ai = ai + 1
                              }
                              _ ==> {}
                        }
                        route {
                              bi <= b_end ==> {
                                    add_buf = add_buf + "+" + b_lines[bi] + "\n"
                                    bi = bi + 1
                              }
                              _ ==> {}
                        }
                  }
            }
      }
      diff = diff + rem_buf + add_buf

      mut as int64: k = 1
      infinite {
            route {
                  k > ctx_after ==> { break }
                  _ ==> {
                        diff = diff + " " + a_lines[a_end + k] + "\n"
                        k = k + 1
                  }
            }
      }

      emit(nice, diff, "ok")
}

function (linterPrintWithoutExtraNewline) (as string: text) as int64 {
      mut as int64: n = stdCollectionLength(text)
      route {
            n == 0 ==> { emit(nice, 0, "ok") }
            text[n] == "\n" ==> {
                  route {
                        n == 1 ==> { print("") }
                        _ ==> { print(text[1..(n - 1)]) }
                  }
            }
            _ ==> {
                  print(text)
            }
      }
      emit(nice, 0, "ok")
}

function (linterIsUpper) (as string: ch) as bool {
      mut as string: uppers = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      mut as int64: n = stdCollectionLength(uppers)
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  uppers[i] == ch ==> { emit(nice, true, "ok") }
                  _ ==> { i = i + 1 }
            }
      }
      emit(nice, false, "ok")
}

function (linterFindSubstr) (as string: hay, as string: ndl) as int64 {
      mut as int64: hlen = stdCollectionLength(hay)
      mut as int64: nlen = stdCollectionLength(ndl)
      route {
            nlen == 0 ==> { emit(nice, 1, "ok") }
            hlen < nlen ==> { emit(nice, 0, "ok") }
            _ ==> {}
      }
      mut as int64: i = 1
      infinite {
            route {
                  i + nlen - 1 > hlen ==> { break }
                  hay[i..(i + nlen - 1)] == ndl ==> {
                        emit(nice, i, "ok")
                  }
                  _ ==> { i = i + 1 }
            }
      }
      emit(nice, 0, "ok")
}

function (linterRepeatChar) (as string: ch, as int64: count) as string {
      mut as string: out = ""
      mut as int64: i = 1
      infinite {
            route {
                  i > count ==> { break }
                  _ ==> {
                        out = out + ch
                        i = i + 1
                  }
            }
      }
      emit(nice, out, "ok")
}

#L Analisador Central de Lints (Early & Late Passes)
function (linterAnalyzeFile) (as string: file_path, as string: src, as map: config_levels) as map {
      mut as list of string: raw_lines = linterSplitLines(src)
      mut as int64: num_lines = stdCollectionLength(raw_lines)

      mut as list of string: diag_records = []
      mut as map: repl_map = map{}
      mut as int64: total_errors = 0
      mut as int64: total_warnings = 0
      mut as bool: has_fixes = false

      #L Rastreamento de escopo e estado de analise
      mut as bool: in_route = false
      mut as bool: seen_wildcard_arm = false
      mut as int64: route_depth = 0

      mut as bool: in_infinite = false
      mut as int64: infinite_start_line = 0
      mut as int64: infinite_start_col = 0
      mut as bool: infinite_has_exit = false
      mut as int64: infinite_depth = 0

      mut as bool: in_agent = false
      mut as bool: in_op = false
      mut as int64: op_start_line = 0
      mut as int64: op_start_col = 0
      mut as string: op_name = ""
      mut as bool: op_has_emit = false
      mut as int64: op_depth = 0

      #L Rastreamento de variaveis mut: nome -> linha declarada
      mut as map: mut_vars_line = map{}
      mut as map: mut_vars_col = map{}
      mut as map: mut_vars_orig = map{}
      mut as map: mut_vars_mod = map{}
      mut as list of string: mut_var_list = []

      mut as int64: li = 1
      infinite {
            route {
                  li > num_lines ==> { break }
                  _ ==> {
                        mut as string: cur_line = "" + raw_lines[li]
                        mut as string: trimmed = linterTrimBoth(cur_line)
                        mut as int64: tlen = stdCollectionLength(trimmed)
                        mut as int64: col_offset = linterFindSubstr(cur_line, trimmed)
                        route { col_offset < 1 ==> { col_offset = 1 } _ ==> {} }

                        #L 1. Lint: fluxlinter::legacy_comment (style)
                        route {
                              tlen >= 2 and trimmed[1] == "#" ==> {
                                    mut as string: c2 = trimmed[2]
                                    route {
                                          c2 != "L" and c2 != "B" and c2 != "D" ==> {
                                                mut as string: sev1 = "warn"
                                                route { stdMapContainsKey(config_levels, "fluxlinter::legacy_comment") ==> { sev1 = "" + config_levels["fluxlinter::legacy_comment"] } _ ==> {} }
                                                route {
                                                      sev1 != "allow" ==> {
                                                            mut as string: fix_line = cur_line
                                                            mut as int64: hash_pos = linterFindSubstr(cur_line, "#")
                                                            route {
                                                                  hash_pos > 0 ==> {
                                                                        mut as string: before_h = ""
                                                                        route { hash_pos > 1 ==> { before_h = cur_line[1..(hash_pos - 1)] } _ ==> {} }
                                                                        fix_line = before_h + "#L" + cur_line[(hash_pos + 1)..stdCollectionLength(cur_line)]
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                            mut as string: k_li = "" + li
                                                            repl_map[k_li] = fix_line
                                                            has_fixes = true

                                                            mut as string: rec1 = sev1 + "|" + file_path + "|" + li + "|" + col_offset + "|fluxlinter::legacy_comment|comentario legado '#' em vez do padrao canonico '#L'|substitua '#' por '#L'|" + cur_line + "|" + fix_line
                                                            diag_records = stdListPushBack(diag_records, rec1)
                                                            route { sev1 == "error" ==> { total_errors = total_errors + 1 } _ ==> { total_warnings = total_warnings + 1 } }
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }

                        #L Ignora analise semantica se a linha for comentario
                        route {
                              tlen >= 2 and trimmed[1] == "#" ==> {}
                              _ ==> {
                                    #L 2. Lint: fluxlinter::division_by_zero (correctness)
                                    mut as int64: div_i_zero = linterFindSubstr(cur_line, "/i 0")
                                    mut as int64: div_r_zero = linterFindSubstr(cur_line, "/r 0")
                                    mut as int64: div_f_zero = linterFindSubstr(cur_line, "/f 0")
                                    mut as int64: div_s_zero = linterFindSubstr(cur_line, "/ 0")
                                    mut as int64: div_m_zero = linterFindSubstr(cur_line, "% 0")
                                    mut as int64: div_pos = 0
                                    mut as string: div_op = ""
                                    route {
                                          div_i_zero > 0 ==> { div_pos = div_i_zero; div_op = "/i" }
                                          div_r_zero > 0 ==> { div_pos = div_r_zero; div_op = "/r" }
                                          div_f_zero > 0 ==> { div_pos = div_f_zero; div_op = "/f" }
                                          div_s_zero > 0 ==> { div_pos = div_s_zero; div_op = "/" }
                                          div_m_zero > 0 ==> { div_pos = div_m_zero; div_op = "%" }
                                          _ ==> {}
                                    }
                                    route {
                                          div_pos > 0 ==> {
                                                mut as int64: qcount = 0
                                                mut as int64: qk = 1
                                                infinite {
                                                      route {
                                                            qk >= div_pos ==> { break }
                                                            _ ==> {
                                                                  route { cur_line[qk] == "\"" ==> { qcount = qcount + 1 } _ ==> {} }
                                                                  qk = qk + 1
                                                            }
                                                      }
                                                }
                                                route {
                                                      (qcount % 2) != 0 ==> { div_pos = 0 }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          div_pos > 0 ==> {
                                                mut as string: sev2 = "deny"
                                                route { stdMapContainsKey(config_levels, "fluxlinter::division_by_zero") ==> { sev2 = "" + config_levels["fluxlinter::division_by_zero"] } _ ==> {} }
                                                route {
                                                      sev2 != "allow" ==> {
                                                            mut as string: rec2 = sev2 + "|" + file_path + "|" + li + "|" + div_pos + "|fluxlinter::division_by_zero|divisao ou resto por literal zero ('" + div_op + " 0') causara erro em runtime|evite divisao por zero literal|" + cur_line + "|" + cur_line
                                                            diag_records = stdListPushBack(diag_records, rec2)
                                                            route { sev2 == "error" or sev2 == "deny" ==> { total_errors = total_errors + 1 } _ ==> { total_warnings = total_warnings + 1 } }
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }

                                    #L 3. Lint: fluxlinter::self_assignment (suspicious)
                                    #L Detecta 'x = x' isolado
                                    mut as int64: eq_pos = linterFindSubstr(trimmed, " = ")
                                    route {
                                          eq_pos > 0 ==> {
                                                mut as string: left_v = linterTrimBoth(trimmed[1..(eq_pos - 1)])
                                                mut as string: right_v = linterTrimBoth(trimmed[(eq_pos + 3)..tlen])
                                                route {
                                                      left_v != "" and left_v == right_v ==> {
                                                            mut as string: sev3 = "warn"
                                                            route { stdMapContainsKey(config_levels, "fluxlinter::self_assignment") ==> { sev3 = "" + config_levels["fluxlinter::self_assignment"] } _ ==> {} }
                                                            route {
                                                                  sev3 != "allow" ==> {
                                                                        mut as string: rec3 = sev3 + "|" + file_path + "|" + li + "|" + col_offset + "|fluxlinter::self_assignment|atribuicao redundante a mesma variavel ('" + left_v + " = " + right_v + "')|remova a atribuicao desnecessaria|" + cur_line + "|" + cur_line
                                                                        diag_records = stdListPushBack(diag_records, rec3)
                                                                        route { sev3 == "error" or sev3 == "deny" ==> { total_errors = total_errors + 1 } _ ==> { total_warnings = total_warnings + 1 } }
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }

                              #L Rastreamento de mutacoes para o lint redundant_mut
                              #L Verifica se alguma variavel mut registrada e reatribuida
                              mut as int64: eq_pos2 = linterFindSubstr(trimmed, " = ")
                              route {
                                    eq_pos2 > 0 ==> {
                                          mut as string: tgt_v = linterTrimBoth(trimmed[1..(eq_pos2 - 1)])
                                          route {
                                                stdMapContainsKey(mut_vars_line, tgt_v) ==> {
                                                      #L Se nao for a propria linha de declaracao, marca modificada
                                                      mut as string: cur_li_s = "" + li
                                                      mut as string: decl_li_s = "" + mut_vars_line[tgt_v]
                                                      route {
                                                            decl_li_s != cur_li_s ==> {
                                                                  mut_vars_mod[tgt_v] = true
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }

                              #L 4. Rastreamento e Lint: fluxlinter::naming_convention (style)
                              route {
                                    tlen >= 6 and (trimmed[1..6] == "agent " or (tlen >= 9 and trimmed[1..9] == "contract ")) ==> {
                                          mut as int64: p1 = linterFindSubstr(trimmed, "(")
                                          mut as int64: p2 = linterFindSubstr(trimmed, ")")
                                          route {
                                                p1 > 0 and p2 > p1 ==> {
                                                      mut as string: dname = linterTrimBoth(trimmed[(p1 + 1)..(p2 - 1)])
                                                      route {
                                                            stdCollectionLength(dname) > 0 and (not linterIsUpper(dname[1])) ==> {
                                                                  mut as string: sev4 = "warn"
                                                                  route { stdMapContainsKey(config_levels, "fluxlinter::naming_convention") ==> { sev4 = "" + config_levels["fluxlinter::naming_convention"] } _ ==> {} }
                                                                  route {
                                                                        sev4 != "allow" ==> {
                                                                              mut as string: rec4 = sev4 + "|" + file_path + "|" + li + "|" + (col_offset + p1) + "|fluxlinter::naming_convention|identificador '" + dname + "' deve seguir PascalCase (iniciar com letra maiuscula)|use PascalCase para agentes e contratos|" + cur_line + "|" + cur_line
                                                                              diag_records = stdListPushBack(diag_records, rec4)
                                                                              route { sev4 == "error" or sev4 == "deny" ==> { total_errors = total_errors + 1 } _ ==> { total_warnings = total_warnings + 1 } }
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }

                              #L 5. Rastreamento de Declaracoes: 'mut as tipo: nome = valor'
                              route {
                                    tlen >= 4 and trimmed[1..4] == "mut " ==> {
                                          mut as int64: colon_pos = linterFindSubstr(trimmed, ":")
                                          mut as int64: eq_idx = linterFindSubstr(trimmed, "=")
                                          route {
                                                colon_pos > 0 and eq_idx > colon_pos ==> {
                                                      mut as string: vname = linterTrimBoth(trimmed[(colon_pos + 1)..(eq_idx - 1)])
                                                      #L Registra para verificacao ao final do arquivo/escopo
                                                      mut_vars_line[vname] = "" + li
                                                      mut_vars_col[vname] = "" + col_offset
                                                      mut_vars_orig[vname] = cur_line
                                                      mut_var_list = stdListPushBack(mut_var_list, vname)
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }

                              #L 6. Rastreamento e Lints em 'route { ... }'
                              route {
                                    tlen >= 5 and (trimmed == "route" or trimmed == "route {" or (tlen >= 7 and trimmed[1..7] == "route {")) ==> {
                                          in_route = true
                                          seen_wildcard_arm = false
                                          route_depth = 1
                                    }
                                    in_route ==> {
                                          #L Verifica guarda apos coringa (fluxlinter::unreachable_route_arm)
                                          mut as int64: arrow_pos = linterFindSubstr(trimmed, "==>")
                                          route {
                                                arrow_pos > 0 ==> {
                                                      mut as string: guard_cond = linterTrimBoth(trimmed[1..(arrow_pos - 1)])
                                                      route {
                                                            seen_wildcard_arm ==> {
                                                                  mut as string: sev5 = "deny"
                                                                  route { stdMapContainsKey(config_levels, "fluxlinter::unreachable_route_arm") ==> { sev5 = "" + config_levels["fluxlinter::unreachable_route_arm"] } _ ==> {} }
                                                                  route {
                                                                        sev5 != "allow" ==> {
                                                                              mut as string: rec5 = sev5 + "|" + file_path + "|" + li + "|" + col_offset + "|fluxlinter::unreachable_route_arm|ramo de rota posicionado apos o coringa '_' e inalcancavel|posicione o ramo antes de '_' ou remova-o|" + cur_line + "|" + cur_line
                                                                              diag_records = stdListPushBack(diag_records, rec5)
                                                                              route { sev5 == "error" or sev5 == "deny" ==> { total_errors = total_errors + 1 } _ ==> { total_warnings = total_warnings + 1 } }
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            guard_cond == "_" ==> {
                                                                  seen_wildcard_arm = true
                                                            }
                                                            _ ==> {
                                                                  #L 7. Lint: fluxlinter::superfluous_guard_parens (complexity)
                                                                  mut as int64: glen = stdCollectionLength(guard_cond)
                                                                  mut as bool: outer_parens_match = false
                                                                  route {
                                                                        glen >= 3 and guard_cond[1] == "(" and guard_cond[glen] == ")" ==> {
                                                                              outer_parens_match = true
                                                                              mut as int64: pdepth = 0
                                                                              mut as int64: pki = 1
                                                                              infinite {
                                                                                    route {
                                                                                          pki > glen ==> { break }
                                                                                          _ ==> {
                                                                                                mut as string: pch = guard_cond[pki]
                                                                                                route {
                                                                                                      pch == "(" ==> { pdepth = pdepth + 1 }
                                                                                                      pch == ")" ==> {
                                                                                                            pdepth = pdepth - 1
                                                                                                            route { pdepth == 0 and pki < glen ==> { outer_parens_match = false } _ ==> {} }
                                                                                                      }
                                                                                                      _ ==> {}
                                                                                                }
                                                                                                pki = pki + 1
                                                                                          }
                                                                                    }
                                                                              }
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                                  route {
                                                                        outer_parens_match ==> {
                                                                              mut as string: sev6 = "warn"
                                                                              route { stdMapContainsKey(config_levels, "fluxlinter::superfluous_guard_parens") ==> { sev6 = "" + config_levels["fluxlinter::superfluous_guard_parens"] } _ ==> {} }
                                                                              route {
                                                                                    sev6 != "allow" ==> {
                                                                                          mut as string: unwrapped = guard_cond[2..(glen - 1)]
                                                                                          mut as string: fix_gline = cur_line
                                                                                          mut as int64: gpos = linterFindSubstr(cur_line, guard_cond)
                                                                                          route {
                                                                                                gpos > 0 ==> {
                                                                                                      mut as string: g_bef = ""
                                                                                                      route { gpos > 1 ==> { g_bef = cur_line[1..(gpos - 1)] } _ ==> {} }
                                                                                                      fix_gline = g_bef + unwrapped + cur_line[(gpos + glen)..stdCollectionLength(cur_line)]
                                                                                                }
                                                                                                _ ==> {}
                                                                                          }
                                                                                          mut as string: k_gli = "" + li
                                                                                          repl_map[k_gli] = fix_gline
                                                                                          has_fixes = true

                                                                                          mut as string: rec6 = sev6 + "|" + file_path + "|" + li + "|" + col_offset + "|fluxlinter::superfluous_guard_parens|parenteses externos superfluos na guarda da rota ('" + guard_cond + "')|remova os parenteses externos: '" + unwrapped + " ==> ...'|" + cur_line + "|" + fix_gline
                                                                                          diag_records = stdListPushBack(diag_records, rec6)
                                                                                          route { sev6 == "error" or sev6 == "deny" ==> { total_errors = total_errors + 1 } _ ==> { total_warnings = total_warnings + 1 } }
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                        }
                                                                        _ ==> {}
                                                                  }

                                                                  #L 8. Lint: fluxlinter::tautological_comparison (suspicious)
                                                                  mut as string: raw_cond = guard_cond
                                                                  route {
                                                                        glen >= 3 and raw_cond[1] == "(" and raw_cond[glen] == ")" ==> {
                                                                              raw_cond = raw_cond[2..(glen - 1)]
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                                  mut as int64: rlen = stdCollectionLength(raw_cond)
                                                                  mut as int64: eqeq_pos = linterFindSubstr(raw_cond, " == ")
                                                                  route {
                                                                        eqeq_pos > 0 ==> {
                                                                              mut as string: c_left = linterTrimBoth(raw_cond[1..(eqeq_pos - 1)])
                                                                              mut as string: c_right = linterTrimBoth(raw_cond[(eqeq_pos + 4)..rlen])
                                                                              route {
                                                                                    c_left != "" and c_left == c_right ==> {
                                                                                          mut as string: sev7 = "warn"
                                                                                          route { stdMapContainsKey(config_levels, "fluxlinter::tautological_comparison") ==> { sev7 = "" + config_levels["fluxlinter::tautological_comparison"] } _ ==> {} }
                                                                                          route {
                                                                                                sev7 != "allow" ==> {
                                                                                                      mut as string: rec7 = sev7 + "|" + file_path + "|" + li + "|" + col_offset + "|fluxlinter::tautological_comparison|comparacao tautologica ('" + c_left + " == " + c_right + "') sempre verdadeira|corrija a condicao ou remova comparacao redundante|" + cur_line + "|" + cur_line
                                                                                                      diag_records = stdListPushBack(diag_records, rec7)
                                                                                                      route { sev7 == "error" or sev7 == "deny" ==> { total_errors = total_errors + 1 } _ ==> { total_warnings = total_warnings + 1 } }
                                                                                                }
                                                                                                _ ==> {}
                                                                                          }
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                      }
                                                }
                                                _ ==> {}
                                          }

                                          mut as int64: ob_pos = linterFindSubstr(trimmed, "{")
                                          mut as int64: cb_pos = linterFindSubstr(trimmed, "}")
                                          route {
                                                ob_pos > 0 and cb_pos <= 0 ==> {
                                                      route_depth = route_depth + 1
                                                }
                                                cb_pos > 0 and ob_pos <= 0 ==> {
                                                      route_depth = route_depth - 1
                                                      route { route_depth <= 0 ==> { in_route = false } _ ==> {} }
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }

                              #L 9. Rastreamento e Lints em 'infinite { ... }'
                              route {
                                    (trimmed == "infinite" or trimmed == "infinite {" or (tlen >= 10 and trimmed[1..10] == "infinite {")) ==> {
                                          in_infinite = true
                                          infinite_start_line = li
                                          infinite_start_col = col_offset
                                          infinite_has_exit = false
                                          infinite_depth = 1
                                    }
                                    in_infinite ==> {
                                          route {
                                                linterFindSubstr(trimmed, "break") > 0 or linterFindSubstr(trimmed, "emit(") > 0 or linterFindSubstr(trimmed, "stdOsExit") > 0 ==> {
                                                      infinite_has_exit = true
                                                }
                                                _ ==> {}
                                          }
                                          mut as int64: inf_ob = linterFindSubstr(trimmed, "{")
                                          mut as int64: inf_cb = linterFindSubstr(trimmed, "}")
                                          route {
                                                inf_ob > 0 and inf_cb <= 0 ==> {
                                                      infinite_depth = infinite_depth + 1
                                                }
                                                inf_cb > 0 and inf_ob <= 0 ==> {
                                                      infinite_depth = infinite_depth - 1
                                                      route {
                                                            infinite_depth <= 0 ==> {
                                                                  in_infinite = false
                                                                  route {
                                                                        not infinite_has_exit ==> {
                                                                              mut as string: sev8 = "deny"
                                                                              route { stdMapContainsKey(config_levels, "fluxlinter::empty_infinite_loop") ==> { sev8 = "" + config_levels["fluxlinter::empty_infinite_loop"] } _ ==> {} }
                                                                              route {
                                                                                    sev8 != "allow" ==> {
                                                                                          mut as string: rec8 = sev8 + "|" + file_path + "|" + infinite_start_line + "|" + infinite_start_col + "|fluxlinter::empty_infinite_loop|loop 'infinite' sem mecanismo de saida detectado (break/emit/stdOsExit)|inclua condicao de saida para evitar travamento|" + raw_lines[infinite_start_line] + "|" + raw_lines[infinite_start_line]
                                                                                          diag_records = stdListPushBack(diag_records, rec8)
                                                                                          route { sev8 == "error" or sev8 == "deny" ==> { total_errors = total_errors + 1 } _ ==> { total_warnings = total_warnings + 1 } }
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }

                              #L 10. Rastreamento de Operacoes de Agentes: op Nome (...) ==> { ... }
                              route {
                                    tlen >= 4 and trimmed[1..3] == "op " and linterFindSubstr(trimmed, "==>") > 0 ==> {
                                          in_op = true
                                          op_start_line = li
                                          op_start_col = col_offset
                                          op_name = trimmed
                                          op_has_emit = false
                                          op_depth = 1
                                    }
                                    in_op ==> {
                                          route {
                                                linterFindSubstr(trimmed, "emit(") > 0 ==> {
                                                      op_has_emit = true
                                                }
                                                _ ==> {}
                                          }
                                          mut as int64: op_ob = linterFindSubstr(trimmed, "{")
                                          mut as int64: op_cb = linterFindSubstr(trimmed, "}")
                                          route {
                                                op_ob > 0 and op_cb <= 0 ==> {
                                                      op_depth = op_depth + 1
                                                }
                                                op_cb > 0 and op_ob <= 0 ==> {
                                                      op_depth = op_depth - 1
                                                      route {
                                                            op_depth <= 0 ==> {
                                                                  in_op = false
                                                                  route {
                                                                        not op_has_emit ==> {
                                                                              mut as string: sev9 = "warn"
                                                                              route { stdMapContainsKey(config_levels, "fluxlinter::missing_operation_emit") ==> { sev9 = "" + config_levels["fluxlinter::missing_operation_emit"] } _ ==> {} }
                                                                              route {
                                                                                    sev9 != "allow" ==> {
                                                                                          mut as string: rec9 = sev9 + "|" + file_path + "|" + op_start_line + "|" + op_start_col + "|fluxlinter::missing_operation_emit|operacao de agente sem caminho de saida 'emit(...)'|emita um resultado tipado (nice/fail) para satisfazer o contrato|" + raw_lines[op_start_line] + "|" + raw_lines[op_start_line]
                                                                                          diag_records = stdListPushBack(diag_records, rec9)
                                                                                          route { sev9 == "error" or sev9 == "deny" ==> { total_errors = total_errors + 1 } _ ==> { total_warnings = total_warnings + 1 } }
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                        }
                  }
                  li = li + 1
            }
      }
      }

      #L Pos-Pass: Avalia variaveis mut nunca modificadas (fluxlinter::redundant_mut)
      mut as int64: n_mvars = stdCollectionLength(mut_var_list)
      mut as int64: mvi = 1
      infinite {
            route {
                  mvi > n_mvars ==> { break }
                  _ ==> {
                        mut as string: mv_name = "" + mut_var_list[mvi]
                        mut as bool: was_modified = false
                        route { stdMapContainsKey(mut_vars_mod, mv_name) ==> { was_modified = true } _ ==> {} }
                        route {
                              not was_modified ==> {
                                    mut as string: sev10 = "warn"
                                    route { stdMapContainsKey(config_levels, "fluxlinter::redundant_mut") ==> { sev10 = "" + config_levels["fluxlinter::redundant_mut"] } _ ==> {} }
                                    route {
                                          sev10 != "allow" ==> {
                                                mut as string: mline = "" + mut_vars_line[mv_name]
                                                mut as string: mcol = "" + mut_vars_col[mv_name]
                                                mut as string: orig_m = "" + mut_vars_orig[mv_name]

                                                mut as string: fix_m = orig_m
                                                mut as int64: mut_pos = linterFindSubstr(orig_m, "mut ")
                                                route {
                                                      mut_pos > 0 ==> {
                                                            mut as string: mbef = ""
                                                            route { mut_pos > 1 ==> { mbef = orig_m[1..(mut_pos - 1)] } _ ==> {} }
                                                            fix_m = mbef + "imut " + orig_m[(mut_pos + 4)..stdCollectionLength(orig_m)]
                                                      }
                                                      _ ==> {}
                                                }
                                                repl_map[mline] = fix_m
                                                has_fixes = true

                                                mut as string: rec10 = sev10 + "|" + file_path + "|" + mline + "|" + mcol + "|fluxlinter::redundant_mut|variavel '" + mv_name + "' declarada como 'mut' mas nunca modificada|substitua 'mut' por 'imut'|" + orig_m + "|" + fix_m
                                                diag_records = stdListPushBack(diag_records, rec10)
                                                route { sev10 == "error" or sev10 == "deny" ==> { total_errors = total_errors + 1 } _ ==> { total_warnings = total_warnings + 1 } }
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        mvi = mvi + 1
                  }
            }
      }

      #L Reconstroi o codigo final formatado para --fix / --diff
      mut as string: fixed_src = ""
      mut as int64: rli = 1
      infinite {
            route {
                  rli > num_lines ==> { break }
                  _ ==> {
                        mut as string: k_rli = "" + rli
                        route {
                              stdMapContainsKey(repl_map, k_rli) ==> {
                                    fixed_src = fixed_src + ("" + repl_map[k_rli]) + "\n"
                              }
                              _ ==> {
                                    fixed_src = fixed_src + ("" + raw_lines[rli]) + "\n"
                              }
                        }
                        rli = rli + 1
                  }
            }
      }

      mut as map: res = map{}
      res["records"] = diag_records
      res["errors"] = total_errors
      res["warnings"] = total_warnings
      res["has_fixes"] = has_fixes
      res["fixed_src"] = fixed_src
      emit(nice, res, "ok")
}

#L Formatador Visual de Diagnosticos Ricos (Clippy-like Output)
function (linterRenderDiagnostic) (as string: record_str) as int64 {
      #L Record format: sev|file|line|col|lint|msg|help|orig_line|fix_line
      mut as list of string: parts = []
      mut as int64: rlen = stdCollectionLength(record_str)
      mut as int64: pstart = 1
      mut as int64: pi = 1
      infinite {
            route {
                  pi > rlen ==> { break }
                  record_str[pi] == "|" ==> {
                        mut as string: seg = ""
                        route { pi > pstart ==> { seg = record_str[pstart..(pi - 1)] } _ ==> {} }
                        parts = stdListPushBack(parts, seg)
                        pstart = pi + 1
                  }
                  _ ==> {}
            }
            pi = pi + 1
      }
      route {
            pstart <= rlen ==> {
                  parts = stdListPushBack(parts, record_str[pstart..rlen])
            }
            _ ==> {}
      }

      mut as int64: n_parts = stdCollectionLength(parts)
      route {
            n_parts < 7 ==> { emit(nice, 0, "ok") }
            _ ==> {}
      }

      mut as string: sev = "" + parts[1]
      mut as string: fpath = "" + parts[2]
      mut as string: sline = "" + parts[3]
      mut as string: scol = "" + parts[4]
      mut as string: lint = "" + parts[5]
      mut as string: msg = "" + parts[6]
      mut as string: help_text = "" + parts[7]
      mut as string: orig_code = ""
      mut as string: fix_code = ""
      route { n_parts >= 8 ==> { orig_code = "" + parts[8] } _ ==> {} }
      route { n_parts >= 9 ==> { fix_code = "" + parts[9] } _ ==> {} }

      mut as string: sev_label = "warning"
      route {
            sev == "error" or sev == "deny" or sev == "forbid" ==> {
                  sev_label = "error"
            }
            _ ==> {}
      }

      #L Cabecalho do Diagnostico
      print(sev_label + ": " + msg)
      print("  --> " + fpath + ":" + sline + ":" + scol)
      print("   |")

      #L Trecho de codigo e ponteiro
      mut as int64: col_num = 1
      mut as int64: cn_len = stdCollectionLength(scol)
      mut as int64: cni = 1
      mut as int64: acc_c = 0
      infinite {
            route {
                  cni > cn_len ==> { break }
                  _ ==> {
                        mut as string: digit_ch = scol[cni]
                        mut as int64: dval = linterCharRank(digit_ch) - 48
                        route { dval >= 0 and dval <= 9 ==> { acc_c = acc_c * 10 + dval } _ ==> {} }
                        cni = cni + 1
                  }
            }
      }
      route { acc_c > 0 ==> { col_num = acc_c } _ ==> {} }

      mut as string: pad_spaces = linterRepeatChar(" ", col_num - 1)
      print(sline + " | " + orig_code)
      print("   | " + pad_spaces + "^^^ help: " + help_text)
      print("   |")
      print("   = note: '-W " + lint + "' habilitado por padrao")
      route {
            fix_code != "" and fix_code != orig_code ==> {
                  print("   = suggestion: `" + linterTrimBoth(fix_code) + "` (Applicability: MachineApplicable)")
            }
            _ ==> {}
      }
      print("")
      emit(nice, 0, "ok")
}

program (FluxLinter) {
      mut as list of string: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)

      mut as bool: flag_fix = false
      mut as bool: flag_diff = false
      mut as bool: flag_list = false
      mut as bool: flag_recursive = false
      mut as bool: flag_version = false
      mut as bool: flag_help = false
      mut as string: explain_target = ""
      mut as list of string: targets = []

      #L Tabela de configuracoes de severidade: lint/categoria -> allow / warn / deny / forbid
      mut as map: config_levels = map{}

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
                        mut as int64: alen = stdCollectionLength(arg)
                        route {
                              arg == "--" ==> {}
                              arg == "help" or arg == "-h" or arg == "--h" or arg == "--help" or arg == "-help" ==> {
                                    flag_help = true
                              }
                              arg == "version" or arg == "-v" or arg == "--v" or arg == "--version" or arg == "-version" ==> {
                                    flag_version = true
                              }
                              arg == "-l" or arg == "--l" or arg == "--list" or arg == "-list" or arg == "--list-lints" or arg == "-list-lints" or arg == "list" ==> {
                                    flag_list = true
                              }
                              arg == "-f" or arg == "--f" or arg == "--fix" or arg == "-fix" ==> {
                                    flag_fix = true
                              }
                              arg == "-d" or arg == "--d" or arg == "--diff" or arg == "-diff" ==> {
                                    flag_diff = true
                              }
                              arg == "-r" or arg == "--r" or arg == "--recursive" or arg == "-recursive" ==> {
                                    flag_recursive = true
                              }
                              arg == "-e" or arg == "--e" or arg == "--explain" or arg == "-explain" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { explain_target = "" + args[i] }
                                          _ ==> {
                                                print("fluxlinter: esperado nome do lint apos flag --explain")
                                                stdOsExit(2)
                                          }
                                    }
                              }
                              arg == "-W" or arg == "--W" or arg == "--warn" or arg == "-warn" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { config_levels["" + args[i]] = "warn" }
                                          _ ==> {
                                                print("fluxlinter: esperado nome do lint apos flag -W/--warn")
                                                stdOsExit(2)
                                          }
                                    }
                              }
                              arg == "-D" or arg == "--D" or arg == "--deny" or arg == "-deny" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { config_levels["" + args[i]] = "deny" }
                                          _ ==> {
                                                print("fluxlinter: esperado nome do lint apos flag -D/--deny")
                                                stdOsExit(2)
                                          }
                                    }
                              }
                              arg == "-A" or arg == "--A" or arg == "--allow" or arg == "-allow" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { config_levels["" + args[i]] = "allow" }
                                          _ ==> {
                                                print("fluxlinter: esperado nome do lint apos flag -A/--allow")
                                                stdOsExit(2)
                                          }
                                    }
                              }
                              arg == "-F" or arg == "--F" or arg == "--forbid" or arg == "-forbid" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { config_levels["" + args[i]] = "forbid" }
                                          _ ==> {
                                                print("fluxlinter: esperado nome do lint apos flag -F/--forbid")
                                                stdOsExit(2)
                                          }
                                    }
                              }
                              #L Flags combinadas curtas como -fr, -dr, etc.
                              alen >= 2 and arg[1] == "-" and arg[2] != "-" ==> {
                                    mut as int64: fi = 2
                                    infinite {
                                          route {
                                                fi > alen ==> { break }
                                                _ ==> {
                                                      mut as string: fc = arg[fi]
                                                      route {
                                                            fc == "f" ==> { flag_fix = true }
                                                            fc == "d" ==> { flag_diff = true }
                                                            fc == "l" ==> { flag_list = true }
                                                            fc == "r" ==> { flag_recursive = true }
                                                            fc == "v" ==> { flag_version = true }
                                                            fc == "h" ==> { flag_help = true }
                                                            _ ==> {
                                                                  print("fluxlinter: flag desconhecida '-" + fc + "' (use --help)")
                                                                  stdOsExit(2)
                                                            }
                                                      }
                                                      fi = fi + 1
                                                }
                                          }
                                    }
                              }
                              alen >= 2 and arg[1] == "-" ==> {
                                    print("fluxlinter: flag desconhecida '" + arg + "' (use --help)")
                                    stdOsExit(2)
                              }
                              _ ==> {
                                    targets = stdListPushBack(targets, arg)
                              }
                        }
                        i = i + 1
                  }
            }
      }

      route {
            flag_help ==> {
                  mut as int64: hrc = linterPrintHelp()
                  stdOsExit(hrc)
            }
            flag_version ==> {
                  mut as int64: vrc = linterPrintVersion()
                  stdOsExit(vrc)
            }
            flag_list ==> {
                  mut as int64: lrc = linterPrintList()
                  stdOsExit(lrc)
            }
            explain_target != "" ==> {
                  mut as int64: erc = linterExplain(explain_target)
                  stdOsExit(erc)
            }
            _ ==> {}
      }

      mut as int64: n_targets = stdCollectionLength(targets)
      route {
            n_targets == 0 ==> {
                  targets = stdListPushBack(targets, ".")
                  n_targets = 1
            }
            _ ==> {}
      }

      #L Expansao dos alvos
      mut as list of string: all_files = []
      mut as int64: ti = 1
      infinite {
            route {
                  ti > n_targets ==> { break }
                  _ ==> {
                        mut as string: tgt = "" + targets[ti]
                        mut as map: rres = linterResolveTarget(tgt, flag_recursive, all_files)
                        all_files = rres["args"]
                        route {
                              not rres["ok"] ==> {
                                    print("" + rres["error"])
                                    stdOsExit(1)
                              }
                              _ ==> {}
                        }
                        ti = ti + 1
                  }
            }
      }

      mut as int64: n_files = stdCollectionLength(all_files)
      route {
            n_files == 0 ==> {
                  emit(nice, 0, "ok")
            }
            _ ==> {}
      }

      mut as int64: global_errors = 0
      mut as int64: global_warnings = 0

      #L Processa cada arquivo coletado
      mut as int64: fidx = 1
      infinite {
            route {
                  fidx > n_files ==> { break }
                  _ ==> {
                        mut as string: fpath = "" + all_files[fidx]
                        mut as string: src_code = stdIoReadFile(fpath)
                        mut as map: a_res = linterAnalyzeFile(fpath, src_code, config_levels)

                        mut as list of string: records = a_res["records"]
                        mut as int64: n_recs = stdCollectionLength(records)

                        #L Imprime os diagnosticos visuais e acumula severidades
                        mut as int64: ri = 1
                        infinite {
                              route {
                                    ri > n_recs ==> { break }
                                    _ ==> {
                                          mut as string: cur_rec = "" + records[ri]
                                          linterRenderDiagnostic(cur_rec)
                                          route {
                                                linterFindSubstr(cur_rec, "error|") == 1 or linterFindSubstr(cur_rec, "deny|") == 1 ==> {
                                                      global_errors = global_errors + 1
                                                }
                                                _ ==> {
                                                      global_warnings = global_warnings + 1
                                                }
                                          }
                                          ri = ri + 1
                                    }
                              }
                        }

                        mut as string: fixed_code = "" + a_res["fixed_src"]
                        mut as bool: has_changes = (fixed_code != src_code)

                        #L Modo --diff (-d)
                        route {
                              flag_diff and has_changes ==> {
                                    mut as string: diff_text = linterGenerateDiff(src_code, fixed_code, fpath)
                                    linterPrintWithoutExtraNewline(diff_text)
                              }
                              _ ==> {}
                        }

                        #L Modo --fix (-f)
                        route {
                              flag_fix and has_changes ==> {
                                    stdIoWriteFile(fpath, fixed_code)
                              }
                              _ ==> {}
                        }

                        fidx = fidx + 1
                  }
            }
      }

      #L Resumo final e codigo de saida
      route {
            global_errors > 0 ==> {
                  print("fluxlinter: falha com " + global_errors + " erro(s) e " + global_warnings + " aviso(s).")
                  stdOsExit(1)
            }
            global_warnings > 0 ==> {
                  print("fluxlinter: concluido com " + global_warnings + " aviso(s).")
                  stdOsExit(0)
            }
            _ ==> {
                  emit(nice, 0, "ok")
            }
      }
}
