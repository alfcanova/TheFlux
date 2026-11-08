#L ==============================================================================
#L TheFlux Canonical Code Formatter: fluxfmt
#L Arquivo: src/tools/fluxfmt/fluxfmt.flux
#L Versao: 0.9.9
#L ==============================================================================

use RuntimeStdLib
use OsStdLib
use IoStdLib
use CollectionStdLib
use ListStdLib
use MapStdLib

function (fmtPrintHelp) () as int64 {
      print("fluxfmt - Utilitario de Formatacao Canonica TheFlux (v0.9.9)")
      print("")
      print("Sintaxe:")
      print("  fluxfmt [flags] [caminho ...]")
      print("")
      print("Modos de Operacao:")
      print("  fluxfmt .\\*              Formata arquivos .flux e .fdsl no diretorio atual")
      print("  fluxfmt .\\* -r           Formata recursivamente a partir do diretorio atual")
      print("  fluxfmt <Nome>           Formata arquivo especifico ou pasta/projeto <Nome>")
      print("  fluxfmt help | -h        Exibe este manual de ajuda")
      print("  fluxfmt version | -v     Exibe a versao do utilitario")
      print("")
      print("Flags Suportadas (aceitam '-' ou '--'):")
      print("  -w, --write              Reescreve o arquivo fonte no disco se houver mudancas")
      print("  -d, --diff               Exibe diff unificado (--- / +++ / @@) sem alterar o disco")
      print("  -l, --list               Lista caminhos dos arquivos fora do padrao canonico")
      print("  -s, --simplify           Simplifica codigo (# -> #L, parenteses superfluos em rotas)")
      print("  -e, --all-errors         Reporta todos os erros lexicos/estruturais sem abortar cedo")
      print("  -r, --recursive          Percorre subdiretorios recursivamente")
      print("  -v, --version            Exibe a versao (fluxfmt version 0.9.9)")
      print("  -h, --help               Exibe esta mensagem de ajuda")
      print("")
      print("Exemplos:")
      print("  fluxfmt -l examples\\Canon\\ExampleOfRoute.flux")
      print("  fluxfmt -d examples\\Canon\\ExampleOfRoute.flux")
      print("  fluxfmt -s -w src\\tools\\fluxfmt\\fluxfmt.flux")
      print("  fluxfmt .\\* -r -l")
      emit(nice, 0, "ok")
}

function (fmtRepeatSpaces) (as int64: count) as string {
      mut as string: out = ""
      mut as int64: i = 1
      infinite {
            route {
                  i > count ==> { break }
                  _ ==> {
                        out = out + " "
                        i = i + 1
                  }
            }
      }
      emit(nice, out, "ok")
}

function (fmtTrimRight) (as string: s) as string {
      mut as int64: n = stdCollectionLength(s)
      mut as int64: end_idx = n
      infinite {
            route {
                  end_idx < 1 ==> { break }
                  _ ==> {
                        mut as string: ch = s[end_idx]
                        route {
                              ch == " " or ch == "\t" or ch == "\r" ==> {
                                    end_idx = end_idx - 1
                              }
                              _ ==> { break }
                        }
                  }
            }
      }
      route {
            end_idx < 1 ==> { emit(nice, "", "ok") }
            _ ==> { emit(nice, s[1..end_idx], "ok") }
      }
}

function (fmtTrimBoth) (as string: s) as string {
      mut as string: r = fmtTrimRight(s)
      mut as int64: n = stdCollectionLength(r)
      mut as int64: start_idx = 1
      infinite {
            route {
                  start_idx > n ==> { break }
                  _ ==> {
                        mut as string: ch = r[start_idx]
                        route {
                              ch == " " or ch == "\t" or ch == "\r" ==> {
                                    start_idx = start_idx + 1
                              }
                              _ ==> { break }
                        }
                  }
            }
      }
      route {
            start_idx > n ==> { emit(nice, "", "ok") }
            _ ==> { emit(nice, r[start_idx..n], "ok") }
      }
}

function (fmtLeadingVisualCols) (as string: s) as int64 {
      mut as int64: n = stdCollectionLength(s)
      mut as int64: cols = 0
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        mut as string: ch = s[i]
                        route {
                              ch == " " ==> {
                                    cols = cols + 1
                                    i = i + 1
                              }
                              ch == "\t" ==> {
                                    cols = cols + 6
                                    i = i + 1
                              }
                              _ ==> { break }
                        }
                  }
            }
      }
      emit(nice, cols, "ok")
}

function (fmtHasFluxExt) (as string: path) as bool {
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

function (fmtIsIgnoredDir) (as string: name) as bool {
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

function (fmtMatchWildcard) (as string: name, as string: pat) as bool {
      route {
            pat == "" or pat == "*" or pat == "*.*" ==> {
                  emit(nice, fmtHasFluxExt(name), "ok")
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
                  mut as string: suff = ""
                  route {
                        star_pos > 1 ==> { pref = pat[1..(star_pos - 1)] }
                        _ ==> {}
                  }
                  route {
                        star_pos < plen ==> { suff = pat[(star_pos + 1)..plen] }
                        _ ==> {}
                  }
                  mut as int64: pre_len = stdCollectionLength(pref)
                  mut as int64: suf_len = stdCollectionLength(suff)
                  route {
                        nlen < pre_len + suf_len ==> { emit(nice, false, "ok") }
                        _ ==> {}
                  }
                  route {
                        pre_len > 0 ==> {
                              route {
                                    name[1..pre_len] != pref ==> { emit(nice, false, "ok") }
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
                                    not fmtHasFluxExt(name) ==> { emit(nice, false, "ok") }
                                    _ ==> {}
                              }
                        }
                  }
                  emit(nice, true, "ok")
            }
      }
}

function (fmtCharRank) (as string: ch) as int64 {
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

function (fmtStringLess) (as string: a, as string: b) as bool {
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
                                    emit(nice, fmtCharRank(ca) < fmtCharRank(cb), "ok")
                              }
                              _ ==> { i = i + 1 }
                        }
                  }
            }
      }
      emit(nice, la < lb, "ok")
}

function (fmtSortStrings) (as list of string: items) as list of string {
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
                                                            best_idx == 0 or fmtStringLess(cand, best_val) ==> {
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

function (fmtJoinDirEntry) (as string: dir_path, as string: ent) as string {
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

function (fmtCollectDir) (as string: dir_path, as string: pattern, as bool: recursive, as list of string: acc) as list of string {
      mut as list of string: out = acc
      mut as list of string: raw_entries = stdIoListDir(dir_path)
      mut as list of string: entries = fmtSortStrings(raw_entries)
      mut as int64: n = stdCollectionLength(entries)
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        mut as string: ent = "" + entries[i]
                        mut as string: full_p = fmtJoinDirEntry(dir_path, ent)
                        route {
                              stdIoDirExists(full_p) ==> {
                                    route {
                                          recursive and (not fmtIsIgnoredDir(ent)) ==> {
                                                out = fmtCollectDir(full_p, pattern, true, out)
                                          }
                                          _ ==> {}
                                    }
                              }
                              stdIoFileExists(full_p) ==> {
                                    route {
                                          fmtMatchWildcard(ent, pattern) ==> {
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

function (fmtResolveTarget) (as string: target, as bool: recursive, as list of string: acc) as map {
      mut as map: res = map{}
      res["ok"] = true
      res["error"] = ""
      mut as list of string: files = acc
      mut as int64: tlen = stdCollectionLength(target)

      route {
            target == "." or target == ".\\" or target == "./" or target == "*" or target == ".\\*" or target == "./*" ==> {
                  files = fmtCollectDir(".", "*", recursive, files)
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
                              res["error"] = "fluxfmt: diretorio nao encontrado: " + base_dir
                              res["args"] = files
                              emit(nice, res, "ok")
                        }
                        _ ==> {
                              files = fmtCollectDir(base_dir, pat, recursive, files)
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
                  files = fmtCollectDir(target, "*", recursive, files)
                  res["args"] = files
                  emit(nice, res, "ok")
            }
            stdIoDirExists("src\\" + target) ==> {
                  files = fmtCollectDir("src\\" + target, "*", recursive, files)
                  res["args"] = files
                  emit(nice, res, "ok")
            }
            stdIoDirExists("examples\\" + target) ==> {
                  files = fmtCollectDir("examples\\" + target, "*", recursive, files)
                  res["args"] = files
                  emit(nice, res, "ok")
            }
            _ ==> {
                  res["ok"] = false
                  res["error"] = "fluxfmt: caminho nao encontrado: " + target
                  res["args"] = files
                  emit(nice, res, "ok")
            }
      }
}

function (fmtIsDigit) (as string: ch) as bool {
      route {
            ch == "0" or ch == "1" or ch == "2" or ch == "3" or ch == "4" or ch == "5" or ch == "6" or ch == "7" or ch == "8" or ch == "9" ==> {
                  emit(nice, true, "ok")
            }
            _ ==> {
                  emit(nice, false, "ok")
            }
      }
}

function (fmtIsIdentStart) (as string: ch) as bool {
      mut as string: alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
      mut as int64: alen = stdCollectionLength(alpha)
      mut as int64: i = 1
      infinite {
            route {
                  i > alen ==> { break }
                  alpha[i] == ch ==> { emit(nice, true, "ok") }
                  _ ==> { i = i + 1 }
            }
      }
      emit(nice, false, "ok")
}

function (fmtIsIdentPart) (as string: ch) as bool {
      emit(nice, fmtIsIdentStart(ch) or fmtIsDigit(ch), "ok")
}

function (fmtValidateSource) (as string: src, as string: file_path, as bool: flag_simplify) as list of string {
      mut as list of string: errs = []
      mut as int64: n = stdCollectionLength(src)
      mut as int64: pos = 1
      mut as int64: line = 1
      mut as int64: col = 1
      mut as int64: brace_depth = 0
      mut as int64: paren_depth = 0
      mut as int64: bracket_depth = 0

      infinite {
            route {
                  pos > n ==> { break }
                  _ ==> {
                        mut as string: ch = src[pos]
                        mut as string: nxt = ""
                        route {
                              pos < n ==> { nxt = src[pos + 1] }
                              _ ==> {}
                        }
                        route {
                              ch == "\r" ==> {
                                    pos = pos + 1
                              }
                              ch == "\n" ==> {
                                    line = line + 1
                                    col = 1
                                    pos = pos + 1
                              }
                              ch == "#" ==> {
                                    route {
                                          nxt == "L" ==> {
                                                infinite {
                                                      route {
                                                            pos > n or src[pos] == "\n" ==> { break }
                                                            _ ==> { pos = pos + 1 }
                                                      }
                                                }
                                          }
                                          nxt == "B" or nxt == "D" ==> {
                                                mut as string: tag_ch = nxt
                                                mut as int64: open_line = line
                                                mut as int64: open_col = col
                                                pos = pos + 2
                                                col = col + 2
                                                mut as bool: closed = false
                                                infinite {
                                                      route {
                                                            pos > n ==> { break }
                                                            src[pos] == tag_ch and pos < n and src[pos + 1] == "#" ==> {
                                                                  pos = pos + 2
                                                                  col = col + 2
                                                                  closed = true
                                                                  break
                                                            }
                                                            src[pos] == "\n" ==> {
                                                                  line = line + 1
                                                                  col = 1
                                                                  pos = pos + 1
                                                            }
                                                            _ ==> {
                                                                  pos = pos + 1
                                                                  col = col + 1
                                                            }
                                                      }
                                                }
                                                route {
                                                      not closed ==> {
                                                            errs = stdListPushBack(errs, file_path + ":" + open_line + ":" + open_col + ": bloco '#" + tag_ch + "...' nao fechado")
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {
                                                route {
                                                      not flag_simplify ==> {
                                                            errs = stdListPushBack(errs, file_path + ":" + line + ":" + col + ": [LEX001] comentario '#' invalido (esperado '#L', '#B...B#' ou '#D...D#'; use -s para converter)")
                                                      }
                                                      _ ==> {}
                                                }
                                                infinite {
                                                      route {
                                                            pos > n or src[pos] == "\n" ==> { break }
                                                            _ ==> { pos = pos + 1 }
                                                      }
                                                }
                                          }
                                    }
                              }
                              ch == "\"" ==> {
                                    mut as int64: s_line = line
                                    mut as int64: s_col = col
                                    pos = pos + 1
                                    col = col + 1
                                    mut as bool: s_closed = false
                                    infinite {
                                          route {
                                                pos > n ==> { break }
                                                src[pos] == "\\" ==> {
                                                      pos = pos + 2
                                                      col = col + 2
                                                }
                                                src[pos] == "\"" ==> {
                                                      pos = pos + 1
                                                      col = col + 1
                                                      s_closed = true
                                                      break
                                                }
                                                src[pos] == "\n" ==> { break }
                                                _ ==> {
                                                      pos = pos + 1
                                                      col = col + 1
                                                }
                                          }
                                    }
                                    route {
                                          not s_closed ==> {
                                                errs = stdListPushBack(errs, file_path + ":" + s_line + ":" + s_col + ": literal de string nao fechado")
                                          }
                                          _ ==> {}
                                    }
                              }
                              ch == "'" ==> {
                                    mut as int64: c_line = line
                                    mut as int64: c_col = col
                                    pos = pos + 1
                                    col = col + 1
                                    mut as bool: c_closed = false
                                    infinite {
                                          route {
                                                pos > n ==> { break }
                                                src[pos] == "\\" ==> {
                                                      pos = pos + 2
                                                      col = col + 2
                                                }
                                                src[pos] == "'" ==> {
                                                      pos = pos + 1
                                                      col = col + 1
                                                      c_closed = true
                                                      break
                                                }
                                                src[pos] == "\n" ==> { break }
                                                _ ==> {
                                                      pos = pos + 1
                                                      col = col + 1
                                                }
                                          }
                                    }
                                    route {
                                          not c_closed ==> {
                                                errs = stdListPushBack(errs, file_path + ":" + c_line + ":" + c_col + ": literal de caractere nao fechado")
                                          }
                                          _ ==> {}
                                    }
                              }
                              ch == "{" ==> {
                                    brace_depth = brace_depth + 1
                                    pos = pos + 1
                                    col = col + 1
                              }
                              ch == "}" ==> {
                                    brace_depth = brace_depth - 1
                                    route {
                                          brace_depth < 0 ==> {
                                                errs = stdListPushBack(errs, file_path + ":" + line + ":" + col + ": chave '}' sem abertura correspondente")
                                                brace_depth = 0
                                          }
                                          _ ==> {}
                                    }
                                    pos = pos + 1
                                    col = col + 1
                              }
                              ch == "(" ==> {
                                    paren_depth = paren_depth + 1
                                    pos = pos + 1
                                    col = col + 1
                              }
                              ch == ")" ==> {
                                    paren_depth = paren_depth - 1
                                    route {
                                          paren_depth < 0 ==> {
                                                errs = stdListPushBack(errs, file_path + ":" + line + ":" + col + ": parentese ')' sem abertura correspondente")
                                                paren_depth = 0
                                          }
                                          _ ==> {}
                                    }
                                    pos = pos + 1
                                    col = col + 1
                              }
                              ch == "[" ==> {
                                    bracket_depth = bracket_depth + 1
                                    pos = pos + 1
                                    col = col + 1
                              }
                              ch == "]" ==> {
                                    bracket_depth = bracket_depth - 1
                                    route {
                                          bracket_depth < 0 ==> {
                                                errs = stdListPushBack(errs, file_path + ":" + line + ":" + col + ": colchete ']' sem abertura correspondente")
                                                bracket_depth = 0
                                          }
                                          _ ==> {}
                                    }
                                    pos = pos + 1
                                    col = col + 1
                              }
                              ch == ";" ==> {
                                    route {
                                          not flag_simplify ==> {
                                                errs = stdListPushBack(errs, file_path + ":" + line + ":" + col + ": ponto-e-virgula ';' nao permitido em TheFlux")
                                          }
                                          _ ==> {}
                                    }
                                    pos = pos + 1
                                    col = col + 1
                              }
                              ch == "=" and pos + 2 <= n and (src[pos..(pos + 2)] == "=/i" or src[pos..(pos + 2)] == "=/f" or src[pos..(pos + 2)] == "=/r") ==> {
                                    pos = pos + 3
                                    col = col + 3
                              }
                              ch == "/" ==> {
                                    route {
                                          nxt == "i" or nxt == "f" or nxt == "r" ==> {
                                                pos = pos + 2
                                                col = col + 2
                                          }
                                          _ ==> {
                                                errs = stdListPushBack(errs, file_path + ":" + line + ":" + col + ": [SYN100] operador '/' isolado invalido (utilize '/i', '/f' ou '/r')")
                                                pos = pos + 1
                                                col = col + 1
                                          }
                                    }
                              }
                              _ ==> {
                                    pos = pos + 1
                                    col = col + 1
                              }
                        }
                  }
            }
      }

      route {
            brace_depth > 0 ==> {
                  errs = stdListPushBack(errs, file_path + ":" + line + ":" + col + ": " + brace_depth + " bloco(s) '{' nao fechado(s) no fim do arquivo")
            }
            _ ==> {}
      }
      route {
            paren_depth > 0 ==> {
                  errs = stdListPushBack(errs, file_path + ":" + line + ":" + col + ": " + paren_depth + " parentese(s) '(' nao fechado(s) no fim do arquivo")
            }
            _ ==> {}
      }
      route {
            bracket_depth > 0 ==> {
                  errs = stdListPushBack(errs, file_path + ":" + line + ":" + col + ": " + bracket_depth + " colchete(s) '[' nao fechado(s) no fim do arquivo")
            }
            _ ==> {}
      }

      emit(nice, errs, "ok")
}

function (fmtSplitLines) (as string: text) as list of string {
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
                  i > n ==> {
                        route {
                              line_start <= n ==> {
                                    mut as string: tail_seg = text[line_start..n]
                                    mut as int64: tlen = stdCollectionLength(tail_seg)
                                    route {
                                          tlen > 0 and tail_seg[tlen] == "\r" ==> {
                                                route {
                                                      tlen == 1 ==> { tail_seg = "" }
                                                      _ ==> { tail_seg = tail_seg[1..(tlen - 1)] }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    lines = stdListPushBack(lines, tail_seg)
                              }
                              _ ==> {}
                        }
                        break
                  }
                  text[i] == "\n" ==> {
                        mut as string: seg = ""
                        route {
                              i > line_start ==> {
                                    seg = text[line_start..(i - 1)]
                                    mut as int64: slen = stdCollectionLength(seg)
                                    route {
                                          slen > 0 and seg[slen] == "\r" ==> {
                                                route {
                                                      slen == 1 ==> { seg = "" }
                                                      _ ==> { seg = seg[1..(slen - 1)] }
                                                }
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        lines = stdListPushBack(lines, seg)
                        line_start = i + 1
                        i = i + 1
                  }
                  _ ==> {
                        i = i + 1
                  }
            }
      }
      emit(nice, lines, "ok")
}

function (fmtIsBannerComment) (as string: trimmed, as int64: orig_cols) as bool {
      route {
            orig_cols != 0 ==> { emit(nice, false, "ok") }
            _ ==> {}
      }
      mut as int64: n = stdCollectionLength(trimmed)
      route {
            n >= 6 ==> {
                  mut as string: p6 = trimmed[1..6]
                  route {
                        p6 == "#L ===" or p6 == "#L ---" ==> { emit(nice, true, "ok") }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }
      emit(nice, false, "ok")
}

function (fmtNormalizeComment) (as string: raw_cmt, as bool: flag_simplify) as string {
      mut as string: c = fmtTrimRight(raw_cmt)
      mut as int64: n = stdCollectionLength(c)
      route {
            n == 0 ==> { emit(nice, "", "ok") }
            n >= 2 and (c[1..2] == "#L" or c[1..2] == "#B" or c[1..2] == "#D") ==> {
                  emit(nice, c, "ok")
            }
            flag_simplify and c[1] == "#" ==> {
                  route {
                        n == 1 ==> { emit(nice, "#L", "ok") }
                        c[2] == " " or c[2] == "\t" ==> {
                              emit(nice, "#L " + fmtTrimBoth(c[2..n]), "ok")
                        }
                        _ ==> {
                              emit(nice, "#L " + c[2..n], "ok")
                        }
                  }
            }
            _ ==> {
                  emit(nice, c, "ok")
            }
      }
}

function (fmtFindCommentSplit) (as string: line) as int64 {
      mut as int64: n = stdCollectionLength(line)
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        mut as string: ch = line[i]
                        route {
                              ch == "\"" ==> {
                                    i = i + 1
                                    infinite {
                                          route {
                                                i > n ==> { break }
                                                line[i] == "\\" ==> { i = i + 2 }
                                                line[i] == "\"" ==> {
                                                      i = i + 1
                                                      break
                                                }
                                                _ ==> { i = i + 1 }
                                          }
                                    }
                              }
                              ch == "'" ==> {
                                    i = i + 1
                                    infinite {
                                          route {
                                                i > n ==> { break }
                                                line[i] == "\\" ==> { i = i + 2 }
                                                line[i] == "'" ==> {
                                                      i = i + 1
                                                      break
                                                }
                                                _ ==> { i = i + 1 }
                                          }
                                    }
                              }
                              ch == "#" ==> {
                                    route {
                                          i < n and (line[i + 1] == "B" or line[i + 1] == "D") ==> {
                                                emit(nice, 0, "ok")
                                          }
                                          _ ==> {
                                                emit(nice, i, "ok")
                                          }
                                    }
                              }
                              _ ==> {
                                    i = i + 1
                              }
                        }
                  }
            }
      }
      emit(nice, 0, "ok")
}

function (fmtIsUnaryPrev) (as string: prev_val, as string: prev_kind) as bool {
      mut as string: dd = "." + "."
      route {
            prev_val == "" ==> { emit(nice, true, "ok") }
            prev_kind == "BIN_OP" or prev_kind == "UNARY_OP" or prev_kind == "BIN_WORD" or prev_kind == "NOT_WORD" ==> {
                  emit(nice, true, "ok")
            }
            prev_val == "(" or prev_val == "[" or prev_val == "{" or prev_val == "," or prev_val == ":" or prev_val == dd or prev_val == "?" ==> {
                  emit(nice, true, "ok")
            }
            _ ==> {
                  emit(nice, false, "ok")
            }
      }
}

function (fmtNeedsSpaceBetween) (as string: prev2_v, as string: pv, as string: pk, as string: cv, as string: ck, as string: first_tok, as int64: cur_idx) as bool {
      mut as string: dd = "." + "."
      route {
            pv == "" ==> { emit(nice, false, "ok") }
            cv == "," or cv == ";" or cv == ":" or cv == "::" or cv == "." or cv == dd or cv == "..." ==> {
                  route {
                        cv == "." and (pv == "," or pk == "BIN_OP" or pv == "=") ==> {
                              emit(nice, true, "ok")
                        }
                        _ ==> { emit(nice, false, "ok") }
                  }
            }
            pv == "::" or pv == "." or pv == dd or pv == "..." ==> {
                  emit(nice, false, "ok")
            }
            pv == "(" or pv == "[" ==> {
                  emit(nice, false, "ok")
            }
            cv == ")" or cv == "]" ==> {
                  emit(nice, false, "ok")
            }
            pk == "UNARY_OP" ==> {
                  emit(nice, false, "ok")
            }
            pv == "{" and cv == "}" ==> {
                  emit(nice, false, "ok")
            }
            pv == "{" ==> {
                  route {
                        cv == "." ==> { emit(nice, false, "ok") }
                        _ ==> { emit(nice, true, "ok") }
                  }
            }
            cv == "}" ==> {
                  emit(nice, true, "ok")
            }
            cv == "{" ==> {
                  route {
                        (pv == "map" or pv == "set") and prev2_v != "as" and prev2_v != "of" ==> {
                              emit(nice, false, "ok")
                        }
                        _ ==> { emit(nice, true, "ok") }
                  }
            }
            cv == "(" ==> {
                  route {
                        pv == "program" or pv == "agent" or pv == "contract" or pv == "struct" or pv == "enum" or pv == "function" or pv == "op" or pv == "route" ==> {
                              emit(nice, true, "ok")
                        }
                        pv == ")" ==> {
                              emit(nice, true, "ok")
                        }
                        first_tok == "op" and cur_idx == 3 ==> {
                              emit(nice, true, "ok")
                        }
                        pk == "BIN_OP" or pk == "BIN_WORD" or pk == "NOT_WORD" or pv == "," or pv == ":" or pv == "?" ==> {
                              emit(nice, true, "ok")
                        }
                        _ ==> {
                              emit(nice, false, "ok")
                        }
                  }
            }
            cv == "[" ==> {
                  route {
                        pk == "BIN_OP" or pk == "BIN_WORD" or pk == "NOT_WORD" or pv == "," or pv == ":" or pv == "?" ==> {
                              emit(nice, true, "ok")
                        }
                        _ ==> {
                              emit(nice, false, "ok")
                        }
                  }
            }
            pv == "," or pv == ":" or pv == "?" or cv == "?" ==> {
                  emit(nice, true, "ok")
            }
            pk == "BIN_OP" or ck == "BIN_OP" or pk == "BIN_WORD" or ck == "BIN_WORD" or pk == "NOT_WORD" ==> {
                  emit(nice, true, "ok")
            }
            ck == "UNARY_OP" ==> {
                  emit(nice, true, "ok")
            }
            _ ==> {
                  emit(nice, true, "ok")
            }
      }
}

function (fmtFormatCodePart) (as string: code_in, as bool: flag_simplify) as map {
      mut as list of string: tvals = []
      mut as list of string: tkinds = []
      mut as int64: n = stdCollectionLength(code_in)
      mut as int64: p = 1

      infinite {
            route {
                  p > n ==> { break }
                  _ ==> {
                        mut as string: ch = code_in[p]
                        route {
                              ch == " " or ch == "\t" or ch == "\r" ==> {
                                    p = p + 1
                              }
                              ch == "\"" ==> {
                                    mut as int64: start_p = p
                                    p = p + 1
                                    infinite {
                                          route {
                                                p > n ==> { break }
                                                code_in[p] == "\\" ==> { p = p + 2 }
                                                code_in[p] == "\"" ==> {
                                                      p = p + 1
                                                      break
                                                }
                                                _ ==> { p = p + 1 }
                                          }
                                    }
                                    mut as int64: end_s = p - 1
                                    route { end_s > n ==> { end_s = n } _ ==> {} }
                                    tvals = stdListPushBack(tvals, code_in[start_p..end_s])
                                    tkinds = stdListPushBack(tkinds, "LIT")
                              }
                              ch == "'" ==> {
                                    mut as int64: start_c = p
                                    p = p + 1
                                    infinite {
                                          route {
                                                p > n ==> { break }
                                                code_in[p] == "\\" ==> { p = p + 2 }
                                                code_in[p] == "'" ==> {
                                                      p = p + 1
                                                      break
                                                }
                                                _ ==> { p = p + 1 }
                                          }
                                    }
                                    mut as int64: end_c = p - 1
                                    route { end_c > n ==> { end_c = n } _ ==> {} }
                                    tvals = stdListPushBack(tvals, code_in[start_c..end_c])
                                    tkinds = stdListPushBack(tkinds, "LIT")
                              }
                              fmtIsDigit(ch) ==> {
                                    mut as int64: start_n = p
                                    p = p + 1
                                    infinite {
                                          route {
                                                p > n ==> { break }
                                                _ ==> {
                                                      mut as string: nc = code_in[p]
                                                      route {
                                                            fmtIsIdentPart(nc) ==> {
                                                                  p = p + 1
                                                            }
                                                            nc == "." and p < n and fmtIsDigit(code_in[p + 1]) ==> {
                                                                  p = p + 1
                                                            }
                                                            (nc == "+" or nc == "-") and (code_in[p - 1] == "e" or code_in[p - 1] == "E") ==> {
                                                                  p = p + 1
                                                            }
                                                            _ ==> { break }
                                                      }
                                                }
                                          }
                                    }
                                    tvals = stdListPushBack(tvals, code_in[start_n..(p - 1)])
                                    tkinds = stdListPushBack(tkinds, "LIT")
                              }
                              fmtIsIdentStart(ch) ==> {
                                    mut as int64: start_w = p
                                    p = p + 1
                                    infinite {
                                          route {
                                                p > n ==> { break }
                                                fmtIsIdentPart(code_in[p]) ==> { p = p + 1 }
                                                _ ==> { break }
                                          }
                                    }
                                    mut as string: w = code_in[start_w..(p - 1)]
                                    mut as string: wk = "WORD"
                                    route {
                                          w == "and" or w == "or" or w == "in" ==> { wk = "BIN_WORD" }
                                          w == "not" ==> { wk = "NOT_WORD" }
                                          _ ==> {}
                                    }
                                    tvals = stdListPushBack(tvals, w)
                                    tkinds = stdListPushBack(tkinds, wk)
                              }
                              _ ==> {
                                    mut as string: op_s = ""
                                    mut as int64: cons = 0
                                    route {
                                          p + 3 <= n and code_in[p..(p + 3)] == "=>>>" ==> {
                                                op_s = "=>>>"
                                                cons = 4
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          cons == 0 and p + 2 <= n ==> {
                                                mut as string: s3 = code_in[p..(p + 2)]
                                                route {
                                                      s3 == "-->" or s3 == "==>" or s3 == "..." or s3 == "=>>" or s3 == "=<<" or s3 == "=^e" or s3 == "=^r" or s3 == "=/f" or s3 == "=/i" or s3 == "=/r" or s3 == ">>>" ==> {
                                                            op_s = s3
                                                            cons = 3
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    mut as string: dd = "." + "."
                                    route {
                                          cons == 0 and p + 1 <= n ==> {
                                                mut as string: s2 = code_in[p..(p + 1)]
                                                route {
                                                      s2 == "^e" or s2 == "^r" or s2 == "=+" or s2 == "=-" or s2 == "=*" or s2 == "=^" or s2 == "=|" or s2 == "=&" or s2 == "=~" or s2 == "==" or s2 == "!=" or s2 == "<=" or s2 == ">=" or s2 == "&&" or s2 == "||" or s2 == "::" or s2 == dd or s2 == ">>" or s2 == "<<" or s2 == "/r" or s2 == "/f" or s2 == "/i" ==> {
                                                            op_s = s2
                                                            cons = 2
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          cons == 0 ==> {
                                                op_s = ch
                                                cons = 1
                                          }
                                          _ ==> {}
                                    }

                                    mut as int64: cur_len = stdCollectionLength(tvals)
                                    mut as string: pv = ""
                                    mut as string: pk = ""
                                    route {
                                          cur_len > 0 ==> {
                                                pv = "" + tvals[cur_len]
                                                pk = "" + tkinds[cur_len]
                                          }
                                          _ ==> {}
                                    }

                                    route {
                                          flag_simplify and op_s == ";" ==> {
                                                p = p + cons
                                          }
                                          _ ==> {
                                                mut as string: okind = "PUNCT"
                                                route {
                                                      op_s == "+" or op_s == "-" ==> {
                                                            route {
                                                                  fmtIsUnaryPrev(pv, pk) ==> { okind = "UNARY_OP" }
                                                                  _ ==> { okind = "BIN_OP" }
                                                            }
                                                      }
                                                      op_s == "!" or op_s == "~" ==> {
                                                            okind = "UNARY_OP"
                                                      }
                                                      op_s == "(" or op_s == ")" or op_s == "[" or op_s == "]" or op_s == "{" or op_s == "}" or op_s == "," or op_s == ":" or op_s == "::" or op_s == "." or op_s == dd or op_s == "..." or op_s == "?" or op_s == "@" or op_s == ";" ==> {
                                                            okind = "PUNCT"
                                                      }
                                                      _ ==> {
                                                            okind = "BIN_OP"
                                                      }
                                                }
                                                tvals = stdListPushBack(tvals, op_s)
                                                tkinds = stdListPushBack(tkinds, okind)
                                                p = p + cons
                                          }
                                    }
                              }
                        }
                  }
            }
      }

      #L Simplificacao (-s): remove parenteses externos redundantes em guardas de rota '(cond) ==> {'
      mut as int64: nt = stdCollectionLength(tvals)
      route {
            flag_simplify and nt >= 4 ==> {
                  mut as int64: arrow_idx = 0
                  mut as int64: ai = 1
                  infinite {
                        route {
                              ai > nt ==> { break }
                              ("" + tvals[ai]) == "==>" ==> {
                                    arrow_idx = ai
                                    break
                              }
                              _ ==> { ai = ai + 1 }
                        }
                  }
                  route {
                        arrow_idx >= 4 and ("" + tvals[1]) == "(" and ("" + tvals[arrow_idx - 1]) == ")" ==> {
                              mut as int64: pdepth = 0
                              mut as bool: wraps_all = true
                              mut as int64: pi = 1
                              infinite {
                                    route {
                                          pi >= arrow_idx ==> { break }
                                          _ ==> {
                                                mut as string: ptok = "" + tvals[pi]
                                                route {
                                                      ptok == "(" ==> { pdepth = pdepth + 1 }
                                                      ptok == ")" ==> { pdepth = pdepth - 1 }
                                                      _ ==> {}
                                                }
                                                route {
                                                      pdepth == 0 and pi < (arrow_idx - 1) ==> {
                                                            wraps_all = false
                                                            break
                                                      }
                                                      _ ==> {}
                                                }
                                                pi = pi + 1
                                          }
                                    }
                              }
                              route {
                                    wraps_all and pdepth == 0 ==> {
                                          mut as list of string: nvals = []
                                          mut as list of string: nkinds = []
                                          mut as int64: cpi = 2
                                          infinite {
                                                route {
                                                      cpi > nt ==> { break }
                                                      cpi == (arrow_idx - 1) ==> { cpi = cpi + 1 }
                                                      _ ==> {
                                                            nvals = stdListPushBack(nvals, "" + tvals[cpi])
                                                            nkinds = stdListPushBack(nkinds, "" + tkinds[cpi])
                                                            cpi = cpi + 1
                                                      }
                                                }
                                          }
                                          tvals = nvals
                                          tkinds = nkinds
                                          nt = stdCollectionLength(tvals)
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }

      mut as int64: leading_close = 0
      mut as bool: still_leading = true
      mut as int64: net_delta = 0
      mut as string: first_tok = ""
      route {
            nt > 0 ==> { first_tok = "" + tvals[1] }
            _ ==> {}
      }

      mut as string: out_code = ""
      mut as string: prev2_v = ""
      mut as string: prev_v = ""
      mut as string: prev_k = ""
      mut as int64: ti = 1
      infinite {
            route {
                  ti > nt ==> { break }
                  _ ==> {
                        mut as string: cv = "" + tvals[ti]
                        mut as string: ck = "" + tkinds[ti]
                        route {
                              still_leading ==> {
                                    route {
                                          cv == "}" or cv == "]" ==> {
                                                leading_close = leading_close + 1
                                          }
                                          _ ==> {
                                                still_leading = false
                                          }
                                    }
                              }
                              _ ==> {}
                        }
                        route {
                              cv == "{" or cv == "[" ==> { net_delta = net_delta + 1 }
                              cv == "}" or cv == "]" ==> { net_delta = net_delta - 1 }
                              _ ==> {}
                        }
                        route {
                              fmtNeedsSpaceBetween(prev2_v, prev_v, prev_k, cv, ck, first_tok, ti) ==> {
                                    out_code = out_code + " " + cv
                              }
                              _ ==> {
                                    out_code = out_code + cv
                              }
                        }
                        prev2_v = prev_v
                        prev_v = cv
                        prev_k = ck
                        ti = ti + 1
                  }
            }
      }

      mut as map: res = map{}
      res["val"] = out_code
      res["line"] = leading_close
      res["count"] = net_delta
      emit(nice, res, "ok")
}

function (fmtFormatSource) (as string: src, as bool: flag_simplify) as string {
      mut as list of string: raw_lines = fmtSplitLines(src)
      mut as int64: n_lines = stdCollectionLength(raw_lines)
      mut as list of string: out_lines = []
      mut as int64: depth = 0
      mut as bool: in_block_cmt = false
      mut as string: block_tag = ""
      mut as bool: prev_blank = false
      mut as bool: prev_opened_block = false

      mut as int64: li = 1
      infinite {
            route {
                  li > n_lines ==> { break }
                  _ ==> {
                        mut as string: raw_line = "" + raw_lines[li]
                        route {
                              in_block_cmt ==> {
                                    mut as string: rtrim = fmtTrimRight(raw_line)
                                    out_lines = stdListPushBack(out_lines, rtrim)
                                    prev_blank = false
                                    prev_opened_block = false
                                    mut as int64: rlen = stdCollectionLength(rtrim)
                                    mut as int64: bi = 1
                                    infinite {
                                          route {
                                                bi + 1 > rlen ==> { break }
                                                rtrim[bi] == block_tag and rtrim[bi + 1] == "#" ==> {
                                                      in_block_cmt = false
                                                      block_tag = ""
                                                      break
                                                }
                                                _ ==> { bi = bi + 1 }
                                          }
                                    }
                              }
                              _ ==> {
                                    mut as int64: orig_cols = fmtLeadingVisualCols(raw_line)
                                    mut as string: trimmed = fmtTrimBoth(raw_line)
                                    mut as int64: tlen = stdCollectionLength(trimmed)
                                    route {
                                          tlen == 0 ==> {
                                                route {
                                                      stdCollectionLength(out_lines) > 0 and (not prev_blank) and (not prev_opened_block) ==> {
                                                            out_lines = stdListPushBack(out_lines, "")
                                                            prev_blank = true
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          tlen >= 2 and (trimmed[1..2] == "#B" or trimmed[1..2] == "#D") ==> {
                                                mut as string: btag = trimmed[2]
                                                mut as string: ind = fmtRepeatSpaces(depth * 6)
                                                route {
                                                      orig_cols == 0 and depth == 0 ==> { ind = "" }
                                                      _ ==> {}
                                                }
                                                out_lines = stdListPushBack(out_lines, ind + trimmed)
                                                prev_blank = false
                                                prev_opened_block = false
                                                mut as bool: closed_same = false
                                                mut as int64: sbi = 3
                                                infinite {
                                                      route {
                                                            sbi + 1 > tlen ==> { break }
                                                            trimmed[sbi] == btag and trimmed[sbi + 1] == "#" ==> {
                                                                  closed_same = true
                                                                  break
                                                            }
                                                            _ ==> { sbi = sbi + 1 }
                                                      }
                                                }
                                                route {
                                                      not closed_same ==> {
                                                            in_block_cmt = true
                                                            block_tag = btag
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {
                                                mut as int64: csplit = fmtFindCommentSplit(trimmed)
                                                mut as string: code_part = trimmed
                                                mut as string: cmt_part = ""
                                                route {
                                                      csplit == 1 ==> {
                                                            code_part = ""
                                                            cmt_part = trimmed
                                                      }
                                                      csplit > 1 ==> {
                                                            code_part = fmtTrimRight(trimmed[1..(csplit - 1)])
                                                            cmt_part = trimmed[csplit..tlen]
                                                      }
                                                      _ ==> {}
                                                }

                                                route {
                                                      code_part == "" ==> {
                                                            mut as string: norm_cmt = fmtNormalizeComment(cmt_part, flag_simplify)
                                                            mut as string: c_ind = fmtRepeatSpaces(depth * 6)
                                                            route {
                                                                  fmtIsBannerComment(norm_cmt, orig_cols) ==> { c_ind = "" }
                                                                  _ ==> {}
                                                            }
                                                            out_lines = stdListPushBack(out_lines, c_ind + norm_cmt)
                                                            prev_blank = false
                                                            prev_opened_block = false
                                                      }
                                                      _ ==> {
                                                            mut as map: cfmt = fmtFormatCodePart(code_part, flag_simplify)
                                                            mut as string: f_code = "" + cfmt["val"]
                                                            mut as int64: lead_cl = cfmt["line"]
                                                            mut as int64: delta = cfmt["count"]

                                                            #L Regra 4: Nenhuma linha em branco imediatamente antes de '}'
                                                            route {
                                                                  lead_cl > 0 and prev_blank ==> {
                                                                        mut as int64: cur_olen = stdCollectionLength(out_lines)
                                                                        route {
                                                                              cur_olen > 0 and ("" + out_lines[cur_olen]) == "" ==> {
                                                                                    mut as list of string: popped = []
                                                                                    mut as int64: pk = 1
                                                                                    infinite {
                                                                                          route {
                                                                                                pk >= cur_olen ==> { break }
                                                                                                _ ==> {
                                                                                                      popped = stdListPushBack(popped, "" + out_lines[pk])
                                                                                                      pk = pk + 1
                                                                                                }
                                                                                          }
                                                                                    }
                                                                                    out_lines = popped
                                                                                    prev_blank = false
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }

                                                            mut as int64: disp_level = depth - lead_cl
                                                            route { disp_level < 0 ==> { disp_level = 0 } _ ==> {} }
                                                            mut as string: line_ind = fmtRepeatSpaces(disp_level * 6)
                                                            mut as string: full_line = line_ind + f_code
                                                            route {
                                                                  cmt_part != "" ==> {
                                                                        full_line = full_line + " " + fmtNormalizeComment(cmt_part, flag_simplify)
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                            out_lines = stdListPushBack(out_lines, full_line)
                                                            prev_blank = false

                                                            mut as int64: flen = stdCollectionLength(f_code)
                                                            prev_opened_block = false
                                                            route {
                                                                  flen > 0 and (f_code[flen] == "{" or f_code[flen] == "[") ==> {
                                                                        prev_opened_block = true
                                                                  }
                                                                  _ ==> {}
                                                            }

                                                            depth = depth + delta
                                                            route { depth < 0 ==> { depth = 0 } _ ==> {} }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                        li = li + 1
                  }
            }
      }

      #L Remove linhas em branco finais e garante exatamente um '\n' no final
      mut as int64: final_n = stdCollectionLength(out_lines)
      infinite {
            route {
                  final_n < 1 ==> { break }
                  ("" + out_lines[final_n]) == "" ==> {
                        final_n = final_n - 1
                  }
                  _ ==> { break }
            }
      }

      mut as string: result = ""
      mut as int64: oi = 1
      infinite {
            route {
                  oi > final_n ==> { break }
                  _ ==> {
                        result = result + out_lines[oi] + "\n"
                        oi = oi + 1
                  }
            }
      }
      emit(nice, result, "ok")
}

function (fmtEndsWithNewline) (as string: s) as bool {
      mut as int64: n = stdCollectionLength(s)
      route {
            n == 0 ==> { emit(nice, false, "ok") }
            _ ==> { emit(nice, s[n] == "\n", "ok") }
      }
}

function (fmtGenerateDiff) (as string: file_path, as string: orig_src, as string: fmt_src) as string {
      route {
            orig_src == fmt_src ==> { emit(nice, "", "ok") }
            _ ==> {}
      }
      mut as list of string: a_lines = fmtSplitLines(orig_src)
      mut as list of string: b_lines = fmtSplitLines(fmt_src)
      mut as int64: na = stdCollectionLength(a_lines)
      mut as int64: nb = stdCollectionLength(b_lines)
      mut as bool: a_nl = fmtEndsWithNewline(orig_src)
      mut as bool: b_nl = fmtEndsWithNewline(fmt_src)

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

function (fmtPrintWithoutExtraNewline) (as string: text) as int64 {
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

program (FluxFmt) {
      mut as list of string: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)

      mut as bool: flag_write = false
      mut as bool: flag_diff = false
      mut as bool: flag_list = false
      mut as bool: flag_simplify = false
      mut as bool: flag_all_errors = false
      mut as bool: flag_recursive = false
      mut as bool: flag_version = false
      mut as bool: flag_help = false
      mut as list of string: targets = []

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
                              arg == "-w" or arg == "--w" or arg == "--write" or arg == "-write" ==> {
                                    flag_write = true
                              }
                              arg == "-d" or arg == "--d" or arg == "--diff" or arg == "-diff" ==> {
                                    flag_diff = true
                              }
                              arg == "-l" or arg == "--l" or arg == "--list" or arg == "-list" ==> {
                                    flag_list = true
                              }
                              arg == "-s" or arg == "--s" or arg == "--simplify" or arg == "-simplify" ==> {
                                    flag_simplify = true
                              }
                              arg == "-e" or arg == "--e" or arg == "--all-errors" or arg == "-all-errors" ==> {
                                    flag_all_errors = true
                              }
                              arg == "-r" or arg == "--r" or arg == "--recursive" or arg == "-recursive" ==> {
                                    flag_recursive = true
                              }
                              alen >= 2 and arg[1] == "-" and arg[2] != "-" ==> {
                                    mut as int64: fi = 2
                                    infinite {
                                          route {
                                                fi > alen ==> { break }
                                                _ ==> {
                                                      mut as string: fc = arg[fi]
                                                      route {
                                                            fc == "w" ==> { flag_write = true }
                                                            fc == "d" ==> { flag_diff = true }
                                                            fc == "l" ==> { flag_list = true }
                                                            fc == "s" ==> { flag_simplify = true }
                                                            fc == "e" ==> { flag_all_errors = true }
                                                            fc == "r" ==> { flag_recursive = true }
                                                            fc == "v" ==> { flag_version = true }
                                                            fc == "h" ==> { flag_help = true }
                                                            _ ==> {
                                                                  print("fluxfmt: flag desconhecida '-" + fc + "' (use --help)")
                                                                  stdOsExit(2)
                                                            }
                                                      }
                                                      fi = fi + 1
                                                }
                                          }
                                    }
                              }
                              alen >= 2 and arg[1] == "-" ==> {
                                    print("fluxfmt: flag desconhecida '" + arg + "' (use --help)")
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
                  mut as int64: hrc = fmtPrintHelp()
                  stdOsExit(hrc)
            }
            flag_version ==> {
                  print("fluxfmt version 0.9.9")
                  stdOsExit(0)
            }
            _ ==> {}
      }

      mut as int64: n_targets = stdCollectionLength(targets)
      route {
            n_targets == 0 ==> {
                  mut as int64: hrc2 = fmtPrintHelp()
                  stdOsExit(hrc2)
            }
            _ ==> {}
      }

      mut as list of string: files = []
      mut as int64: exit_code = 0
      mut as int64: ti = 1
      infinite {
            route {
                  ti > n_targets ==> { break }
                  _ ==> {
                        mut as string: tgt = "" + targets[ti]
                        mut as map: rres = fmtResolveTarget(tgt, flag_recursive, files)
                        files = rres["args"]
                        route {
                              not rres["ok"] ==> {
                                    print("" + rres["error"])
                                    exit_code = 1
                                    route {
                                          not flag_all_errors ==> { stdOsExit(1) }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        ti = ti + 1
                  }
            }
      }

      mut as int64: n_files = stdCollectionLength(files)
      mut as int64: fi = 1
      infinite {
            route {
                  fi > n_files ==> { break }
                  _ ==> {
                        mut as string: fpath = "" + files[fi]
                        mut as string: raw_src = stdIoReadFile(fpath)
                        mut as list of string: ferrs = fmtValidateSource(raw_src, fpath, flag_simplify)
                        mut as int64: n_ferrs = stdCollectionLength(ferrs)

                        route {
                              n_ferrs > 0 ==> {
                                    exit_code = 1
                                    mut as int64: max_rep = 1
                                    route {
                                          flag_all_errors ==> { max_rep = n_ferrs }
                                          _ ==> {}
                                    }
                                    mut as int64: ei = 1
                                    infinite {
                                          route {
                                                ei > max_rep ==> { break }
                                                _ ==> {
                                                      print("" + ferrs[ei])
                                                      ei = ei + 1
                                                }
                                          }
                                    }
                                    route {
                                          not flag_all_errors ==> { stdOsExit(1) }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {
                                    mut as string: norm_orig = ""
                                    mut as int64: rlen = stdCollectionLength(raw_src)
                                    mut as int64: rpos = 1
                                    infinite {
                                          route {
                                                rpos > rlen ==> { break }
                                                raw_src[rpos] == "\r" ==> { rpos = rpos + 1 }
                                                _ ==> {
                                                      norm_orig = norm_orig + raw_src[rpos]
                                                      rpos = rpos + 1
                                                }
                                          }
                                    }

                                    mut as string: formatted = fmtFormatSource(raw_src, flag_simplify)
                                    mut as bool: changed = (norm_orig != formatted)

                                    route {
                                          flag_list and changed ==> {
                                                print(fpath)
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          flag_diff and changed ==> {
                                                mut as string: dtext = fmtGenerateDiff(fpath, norm_orig, formatted)
                                                mut as int64: drc = fmtPrintWithoutExtraNewline(dtext)
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          flag_write and changed ==> {
                                                stdIoWriteFile(fpath, formatted)
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          (not flag_list) and (not flag_diff) and (not flag_write) ==> {
                                                mut as int64: prc = fmtPrintWithoutExtraNewline(formatted)
                                          }
                                          _ ==> {}
                                    }
                              }
                        }
                        fi = fi + 1
                  }
            }
      }

      stdOsExit(exit_code)
}
