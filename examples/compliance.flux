#L Driver Canonico de Conformidade e Regressao Multi-Backend (TheFlux)
#L Backends comparados contra 'in': in (referencia), vm (vm + vmr), llvm, wat, wasm.
#L Baselines fixas em examples\00_Standarts\compliance_XX00.md -> relatorios em compliance_XX01.md.

function (compPrintHelp) () as int64 {
      println("TheFlux Compliance Runner - Conformidade e Regressao Multi-Backend")
      println("")
      println("Uso:")
      println("  compliance [opcoes]")
      println("")
      println("Suites:")
      println("  --ca, --canon                  Executa suite examples\\Canon (CA00 -> CA01)")
      println("  --nr, --recipes                Executa suite examples\\NumericalRecipes (NR00 -> NR01)")
      println("  --sa, --science, --algorithms  Executa suite examples\\ScientificAlgorithms (SA00 -> SA01)")
      println("  --all                          Executa todas as 3 suites (padrao sem flags)")
      println("")
      println("Filtros e Informacoes:")
      println("  --filter <subtexto>            Filtra arquivos por nome (nao sobrescreve XX01.md)")
      println("  --filter=<subtexto>            Forma alternativa do filtro")
      println("  -j, --jobs <N>                 Numero de workers paralelos (padrao: 8; 1 = sequencial)")
      println("  -h, --help                     Exibe esta mensagem de ajuda")
      emit(nice, 0, "ok")
}

function (compIndexOf) (as string: hay, as string: ndl) as int64 {
      imut as int64: hlen = stdCollectionLength(hay)
      imut as int64: nlen = stdCollectionLength(ndl)
      route {
            nlen == 0 ==> { emit(nice, 1, "ok") }
            hlen < nlen ==> { emit(nice, 0, "ok") }
            _ ==> {}
      }
      imut as string: first_ch = ndl[1]
      imut as int64: max_start = hlen - nlen + 1
      mut as int64: i = 1
      infinite {
            route {
                  i > max_start ==> { break }
                  hay[i] == first_ch ==> {
                        route {
                              nlen == 1 ==> { emit(nice, i, "ok") }
                              hay[i..(i + nlen - 1)] == ndl ==> { emit(nice, i, "ok") }
                              _ ==> { i = i + 1 }
                        }
                  }
                  _ ==> { i = i + 1 }
            }
      }
      emit(nice, 0, "ok")
}

function (compContains) (as string: hay, as string: ndl) as bool {
      emit(nice, compIndexOf(hay, ndl) > 0, "ok")
}

function (compStartsWith) (as string: s, as string: pref) as bool {
      imut as int64: slen = stdCollectionLength(s)
      imut as int64: plen = stdCollectionLength(pref)
      route {
            plen == 0 ==> { emit(nice, true, "ok") }
            slen < plen ==> { emit(nice, false, "ok") }
            _ ==> { emit(nice, s[1..plen] == pref, "ok") }
      }
}

function (compEndsWith) (as string: s, as string: suf) as bool {
      imut as int64: slen = stdCollectionLength(s)
      imut as int64: flen = stdCollectionLength(suf)
      route {
            flen == 0 ==> { emit(nice, true, "ok") }
            slen < flen ==> { emit(nice, false, "ok") }
            _ ==> { emit(nice, s[(slen - flen + 1)..slen] == suf, "ok") }
      }
}

function (compTrimRight) (as string: s) as string {
      mut as int64: end_idx = stdCollectionLength(s)
      infinite {
            route {
                  end_idx < 1 ==> { break }
                  _ ==> {
                        imut as string: ch = s[end_idx]
                        route {
                              ch == " " or ch == "\t" or ch == "\r" or ch == "\n" ==> {
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

function (compTrimBoth) (as string: s) as string {
      imut as int64: n = stdCollectionLength(s)
      mut as int64: start_idx = 1
      infinite {
            route {
                  start_idx > n ==> { break }
                  _ ==> {
                        imut as string: ch = s[start_idx]
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
                        imut as string: ch2 = s[end_idx]
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

function (compLower) (as string: s) as string {
      imut as string: up = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      imut as string: lo = "abcdefghijklmnopqrstuvwxyz"
      imut as int64: n = stdCollectionLength(s)
      mut as list of string: parts = []
      mut as int64: seg_start = 1
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        imut as string: ch = s[i]
                        imut as int64: idx = compIndexOf(up, ch)
                        route {
                              idx > 0 ==> {
                                    route {
                                          i > seg_start ==> {
                                                parts = stdListPushBack(parts, s[seg_start..(i - 1)])
                                          }
                                          _ ==> {}
                                    }
                                    parts = stdListPushBack(parts, lo[idx])
                                    seg_start = i + 1
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }
            }
      }
      route {
            stdCollectionLength(parts) == 0 ==> { emit(nice, s, "ok") }
            _ ==> {}
      }
      route {
            seg_start <= n ==> {
                  parts = stdListPushBack(parts, s[seg_start..n])
            }
            _ ==> {}
      }
      emit(nice, compJoinRange(parts, 1, stdCollectionLength(parts), ""), "ok")
}

function (compRepeatStr) (as string: unit, as int64: count) as string {
      mut as string: out = ""
      mut as int64: i = 1
      infinite {
            route {
                  i > count ==> { break }
                  _ ==> {
                        out = out + unit
                        i = i + 1
                  }
            }
      }
      emit(nice, out, "ok")
}

function (compPadRight) (as string: s, as int64: width) as string {
      imut as int64: n = stdCollectionLength(s)
      route {
            n >= width ==> { emit(nice, s, "ok") }
            _ ==> { emit(nice, s + compRepeatStr(" ", width - n), "ok") }
      }
}

function (compPadLeft) (as string: s, as int64: width) as string {
      imut as int64: n = stdCollectionLength(s)
      route {
            n >= width ==> { emit(nice, s, "ok") }
            _ ==> { emit(nice, compRepeatStr(" ", width - n) + s, "ok") }
      }
}

function (compJoinRange) (as list of string: parts, as int64: lo, as int64: hi, as string: sep) as string {
      route {
            lo > hi ==> { emit(nice, "", "ok") }
            lo == hi ==> { emit(nice, "" + parts[lo], "ok") }
            _ ==> {
                  imut as int64: mid = (lo + hi) /i 2
                  imut as string: left = compJoinRange(parts, lo, mid, sep)
                  imut as string: right = compJoinRange(parts, mid + 1, hi, sep)
                  emit(nice, left + sep + right, "ok")
            }
      }
}

function (compSplitChar) (as string: text, as string: sep_ch, as bool: strip_cr) as list of string {
      mut as list of string: out = []
      imut as int64: n = stdCollectionLength(text)
      route {
            n == 0 ==> { emit(nice, out, "ok") }
            _ ==> {}
      }
      mut as int64: start_idx = 1
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> {
                        route {
                              start_idx <= n ==> {
                                    mut as string: tail_seg = text[start_idx..n]
                                    route {
                                          strip_cr and compEndsWith(tail_seg, "\r") ==> {
                                                imut as int64: tl = stdCollectionLength(tail_seg)
                                                route {
                                                      tl == 1 ==> { tail_seg = "" }
                                                      _ ==> { tail_seg = tail_seg[1..(tl - 1)] }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    out = stdListPushBack(out, tail_seg)
                              }
                              _ ==> {}
                        }
                        break
                  }
                  text[i] == sep_ch ==> {
                        mut as string: seg = ""
                        route {
                              i > start_idx ==> {
                                    seg = text[start_idx..(i - 1)]
                                    route {
                                          strip_cr and compEndsWith(seg, "\r") ==> {
                                                imut as int64: sl = stdCollectionLength(seg)
                                                route {
                                                      sl == 1 ==> { seg = "" }
                                                      _ ==> { seg = seg[1..(sl - 1)] }
                                                }
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        out = stdListPushBack(out, seg)
                        start_idx = i + 1
                        i = i + 1
                  }
                  _ ==> { i = i + 1 }
            }
      }
      emit(nice, out, "ok")
}

function (compSplitLines) (as string: text) as list of string {
      emit(nice, compSplitChar(text, "\n", true), "ok")
}

function (compSplitByPipe) (as string: line) as list of string {
      imut as list of string: raw = compSplitChar(line, "|", false)
      imut as int64: n = stdCollectionLength(raw)
      mut as list of string: cells = []
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        imut as string: cell = compTrimBoth("" + raw[i])
                        route {
                              (i == 1 or i == n) and cell == "" ==> {}
                              _ ==> { cells = stdListPushBack(cells, cell) }
                        }
                        i = i + 1
                  }
            }
      }
      emit(nice, cells, "ok")
}

function (compCharRank) (as string: ch) as int64 {
      imut as string: tbl = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
      imut as int64: idx = compIndexOf(tbl, ch)
      route {
            idx > 0 ==> { emit(nice, idx + 31, "ok") }
            _ ==> { emit(nice, 255, "ok") }
      }
}

function (compStringLess) (as string: a, as string: b) as bool {
      imut as int64: na = stdCollectionLength(a)
      imut as int64: nb = stdCollectionLength(b)
      mut as int64: i = 1
      infinite {
            route {
                  i > na or i > nb ==> { break }
                  _ ==> {
                        imut as int64: ra = compCharRank(a[i])
                        imut as int64: rb = compCharRank(b[i])
                        route {
                              ra < rb ==> { emit(nice, true, "ok") }
                              ra > rb ==> { emit(nice, false, "ok") }
                              _ ==> { i = i + 1 }
                        }
                  }
            }
      }
      emit(nice, na < nb, "ok")
}

function (compMergeSorted) (as list of string: left, as list of string: right) as list of string {
      imut as int64: nl = stdCollectionLength(left)
      imut as int64: nr = stdCollectionLength(right)
      mut as list of string: out = []
      mut as int64: li = 1
      mut as int64: ri = 1
      infinite {
            route {
                  li > nl and ri > nr ==> { break }
                  li > nl ==> {
                        out = stdListPushBack(out, "" + right[ri])
                        ri = ri + 1
                  }
                  ri > nr ==> {
                        out = stdListPushBack(out, "" + left[li])
                        li = li + 1
                  }
                  compStringLess("" + left[li], "" + right[ri]) ==> {
                        out = stdListPushBack(out, "" + left[li])
                        li = li + 1
                  }
                  _ ==> {
                        out = stdListPushBack(out, "" + right[ri])
                        ri = ri + 1
                  }
            }
      }
      emit(nice, out, "ok")
}

function (compSortRange) (as list of string: items, as int64: lo, as int64: hi) as list of string {
      mut as list of string: single = []
      route {
            lo > hi ==> { emit(nice, single, "ok") }
            lo == hi ==> {
                  single = stdListPushBack(single, "" + items[lo])
                  emit(nice, single, "ok")
            }
            _ ==> {
                  imut as int64: mid = (lo + hi) /i 2
                  imut as list of string: left = compSortRange(items, lo, mid)
                  imut as list of string: right = compSortRange(items, mid + 1, hi)
                  emit(nice, compMergeSorted(left, right), "ok")
            }
      }
}

function (compSortStrings) (as list of string: items) as list of string {
      imut as int64: n = stdCollectionLength(items)
      route {
            n <= 1 ==> { emit(nice, items, "ok") }
            _ ==> { emit(nice, compSortRange(items, 1, n), "ok") }
      }
}

function (compStripCR) (as string: text) as string {
      imut as int64: n = stdCollectionLength(text)
      mut as list of string: chunks = []
      mut as int64: seg_start = 1
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  text[i] == "\r" ==> {
                        route {
                              i > seg_start ==> {
                                    chunks = stdListPushBack(chunks, text[seg_start..(i - 1)])
                              }
                              _ ==> {}
                        }
                        seg_start = i + 1
                        i = i + 1
                  }
                  _ ==> { i = i + 1 }
            }
      }
      route {
            stdCollectionLength(chunks) == 0 and seg_start == 1 ==> {
                  emit(nice, text, "ok")
            }
            _ ==> {}
      }
      route {
            seg_start <= n ==> {
                  chunks = stdListPushBack(chunks, text[seg_start..n])
            }
            _ ==> {}
      }
      imut as int64: nc = stdCollectionLength(chunks)
      route {
            nc == 0 ==> { emit(nice, "", "ok") }
            _ ==> { emit(nice, compJoinRange(chunks, 1, nc, ""), "ok") }
      }
}

function (compIsWordOrDot) (as string: ch) as bool {
      imut as string: tbl = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_."
      emit(nice, compIndexOf(tbl, ch) > 0, "ok")
}

#L Normaliza tokens isolados '-0.0+' ou '0.0+' para '0' (equivalente a normalizar_saida em compliance_BE.py)
function (compNormalizeFloatZeros) (as string: s) as string {
      imut as int64: n = stdCollectionLength(s)
      mut as list of string: parts = []
      mut as int64: seg_start = 1
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        mut as bool: prev_ok = true
                        route {
                              i > 1 ==> { prev_ok = not compIsWordOrDot(s[i - 1]) }
                              _ ==> {}
                        }
                        mut as int64: matched_end = 0
                        route {
                              prev_ok ==> {
                                    mut as int64: p = i
                                    route {
                                          s[p] == "-" ==> { p = p + 1 }
                                          _ ==> {}
                                    }
                                    route {
                                          p + 2 <= n and s[p] == "0" and s[p + 1] == "." and s[p + 2] == "0" ==> {
                                                mut as int64: z = p + 2
                                                infinite {
                                                      route {
                                                            z <= n and s[z] == "0" ==> { z = z + 1 }
                                                            _ ==> { break }
                                                      }
                                                }
                                                mut as bool: next_ok = true
                                                route {
                                                      z <= n ==> { next_ok = not compIsWordOrDot(s[z]) }
                                                      _ ==> {}
                                                }
                                                route {
                                                      next_ok ==> { matched_end = z - 1 }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        route {
                              matched_end > 0 ==> {
                                    route {
                                          i > seg_start ==> {
                                                parts = stdListPushBack(parts, s[seg_start..(i - 1)])
                                          }
                                          _ ==> {}
                                    }
                                    parts = stdListPushBack(parts, "0")
                                    seg_start = matched_end + 1
                                    i = matched_end + 1
                              }
                              _ ==> { i = i + 1 }
                        }
                  }
            }
      }
      route {
            stdCollectionLength(parts) == 0 ==> { emit(nice, s, "ok") }
            _ ==> {}
      }
      route {
            seg_start <= n ==> {
                  parts = stdListPushBack(parts, s[seg_start..n])
            }
            _ ==> {}
      }
      emit(nice, compJoinRange(parts, 1, stdCollectionLength(parts), ""), "ok")
}

function (compNormalizeOutput) (as string: raw) as string {
      imut as string: no_cr = compStripCR(raw)
      imut as string: norm_zero = compNormalizeFloatZeros(no_cr)
      emit(nice, compTrimRight(norm_zero), "ok")
}

function (compSanitizeOneLine) (as string: s, as int64: max_len) as string {
      imut as string: clean = compTrimBoth(compStripCR(s))
      imut as int64: n = stdCollectionLength(clean)
      mut as list of string: parts = []
      mut as int64: i = 1
      mut as int64: limit = n
      route {
            limit > max_len ==> { limit = max_len }
            _ ==> {}
      }
      infinite {
            route {
                  i > limit ==> { break }
                  _ ==> {
                        imut as string: ch = clean[i]
                        route {
                              ch == "\n" ==> { parts = stdListPushBack(parts, "\\n") }
                              ch == "\t" ==> { parts = stdListPushBack(parts, "\\t") }
                              ch == "|" ==> { parts = stdListPushBack(parts, "/") }
                              ch == "`" ==> { parts = stdListPushBack(parts, "'") }
                              _ ==> { parts = stdListPushBack(parts, ch) }
                        }
                        i = i + 1
                  }
            }
      }
      mut as string: res = ""
      route {
            stdCollectionLength(parts) > 0 ==> {
                  res = compJoinRange(parts, 1, stdCollectionLength(parts), "")
            }
            _ ==> {}
      }
      route {
            n > max_len ==> { res = res + "." + "." + "." }
            _ ==> {}
      }
      emit(nice, res, "ok")
}

function (compFirstDiffPreview) (as string: expected, as string: actual) as string {
      imut as list of string: elines = compSplitLines(expected)
      imut as list of string: alines = compSplitLines(actual)
      imut as int64: ne = stdCollectionLength(elines)
      imut as int64: na = stdCollectionLength(alines)
      mut as int64: max_n = ne
      route {
            na > max_n ==> { max_n = na }
            _ ==> {}
      }
      mut as int64: i = 1
      infinite {
            route {
                  i > max_n ==> { break }
                  _ ==> {
                        mut as string: el = "<EOF>"
                        mut as string: al = "<EOF>"
                        route { i <= ne ==> { el = "" + elines[i] } _ ==> {} }
                        route { i <= na ==> { al = "" + alines[i] } _ ==> {} }
                        route {
                              el != al ==> {
                                    emit(nice, "L" + i + ": esperado `" + compSanitizeOneLine(el, 55) + "` | obtido `" + compSanitizeOneLine(al, 55) + "`", "ok")
                              }
                              _ ==> { i = i + 1 }
                        }
                  }
            }
      }
      emit(nice, "divergencia de formatacao/espacamento", "ok")
}

function (compExtractErrorCodeFromName) (as string: fname) as string {
      route {
            not compStartsWith(fname, "ExampleOfError_") ==> { emit(nice, "", "ok") }
            compStartsWith(fname, "ExampleOfError_RT") ==> { emit(nice, "", "ok") }
            _ ==> {}
      }
      imut as string: rest = fname[16..stdCollectionLength(fname)]
      imut as int64: us = compIndexOf(rest, "_")
      route {
            us > 1 ==> { emit(nice, rest[1..(us - 1)], "ok") }
            _ ==> { emit(nice, "", "ok") }
      }
}

function (compGetStaticErrorCode) (as string: filepath, as string: fname) as string {
      route {
            compStartsWith(fname, "ExampleOfError_RT") ==> { emit(nice, "", "ok") }
            _ ==> {}
      }
      imut as string: src = stdIoReadFile(filepath)
      imut as list of string: lines = compSplitLines(src)
      imut as int64: n = stdCollectionLength(lines)
      mut as int64: limit = 20
      route {
            n < limit ==> { limit = n }
            _ ==> {}
      }
      mut as int64: i = 1
      infinite {
            route {
                  i > limit ==> { break }
                  _ ==> {
                        imut as string: ln = "" + lines[i]
                        imut as int64: pos = compIndexOf(ln, "EXPECT_ERROR:")
                        route {
                              pos > 0 ==> {
                                    imut as int64: ln_len = stdCollectionLength(ln)
                                    imut as string: raw_code = compTrimBoth(ln[(pos + 13)..ln_len])
                                    route {
                                          compStartsWith(raw_code, "RT") ==> { emit(nice, "", "ok") }
                                          raw_code != "" ==> { emit(nice, raw_code, "ok") }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }
            }
      }
      emit(nice, compExtractErrorCodeFromName(fname), "ok")
}

function (compGetStdinForFile) (as string: filepath, as string: fname) as string {
      imut as int64: flen = stdCollectionLength(filepath)
      route {
            flen > 5 ==> {
                  imut as string: yaml_path = filepath[1..(flen - 5)] + ".yaml"
                  route {
                        stdIoFileExists(yaml_path) ==> {
                              imut as string: ytxt = stdIoReadFile(yaml_path)
                              imut as list of string: ylines = compSplitLines(ytxt)
                              imut as int64: yn = stdCollectionLength(ylines)
                              mut as bool: in_inputs = false
                              mut as list of string: vals = []
                              mut as int64: yi = 1
                              infinite {
                                    route {
                                          yi > yn ==> { break }
                                          _ ==> {
                                                imut as string: s = compTrimBoth("" + ylines[yi])
                                                route {
                                                      not in_inputs ==> {
                                                            route {
                                                                  compStartsWith(s, "inputs:") ==> { in_inputs = true }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      compStartsWith(s, "- ") ==> {
                                                            mut as string: item = compTrimBoth(s[3..stdCollectionLength(s)])
                                                            imut as int64: ilen = stdCollectionLength(item)
                                                            route {
                                                                  ilen >= 2 and item[1] == "\"" and item[ilen] == "\"" ==> {
                                                                        route {
                                                                              ilen == 2 ==> { item = "" }
                                                                              _ ==> { item = item[2..(ilen - 1)] }
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                            vals = stdListPushBack(vals, item)
                                                      }
                                                      s != "" and not compStartsWith(s, "#") ==> { break }
                                                      _ ==> {}
                                                }
                                                yi = yi + 1
                                          }
                                    }
                              }
                              route {
                                    stdCollectionLength(vals) > 0 ==> {
                                          emit(nice, compJoinRange(vals, 1, stdCollectionLength(vals), "\n") + "\n", "ok")
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }
      route {
            fname == "ExampleOfInput.flux" ==> { emit(nice, "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n", "ok") }
            fname == "ExampleOfUseIoStdLib_IoInputContract.flux" ==> { emit(nice, "andre\nluiz\n", "ok") }
            fname == "input.flux" ==> { emit(nice, "dado\n", "ok") }
            _ ==> { emit(nice, "", "ok") }
      }
}

function (compJoinPath) (as string: dir, as string: name) as string {
      route {
            compEndsWith(dir, "\\") or compEndsWith(dir, "/") ==> { emit(nice, dir + name, "ok") }
            _ ==> { emit(nice, dir + "\\" + name, "ok") }
      }
}

function (compEnsureDir) (as string: dir_path) as int64 {
      route {
            not stdIoDirExists(dir_path) ==> {
                  emit(nice, stdOsExec("if not exist \"" + dir_path + "\" mkdir \"" + dir_path + "\""), "ok")
            }
            _ ==> { emit(nice, 0, "ok") }
      }
}

function (compDeleteIfExists) (as string: path) as int64 {
      route {
            stdIoFileExists(path) ==> { emit(nice, stdIoDeleteFile(path), "ok") }
            _ ==> { emit(nice, 0, "ok") }
      }
}

function (compCleanTestArtifacts) (as string: tmp_dir) as int64 {
      compDeleteIfExists(tmp_dir + "\\_out.tmp")
      compDeleteIfExists(tmp_dir + "\\_err.tmp")
      compDeleteIfExists(tmp_dir + "\\_stdin.tmp")
      compDeleteIfExists(tmp_dir + "\\_c_vm.fvmbc")
      compDeleteIfExists(tmp_dir + "\\_c_lv.ll")
      compDeleteIfExists(tmp_dir + "\\_c_lv.exe")
      compDeleteIfExists(tmp_dir + "\\_c_wat.wat")
      compDeleteIfExists(tmp_dir + "\\_c_was.wasm")
      emit(nice, 0, "ok")
}

function (compCleanDbArtifacts) () as int64 {
      imut as string: dd = "." + "."
      route {
            stdIoDirExists("dbs") ==> {
                  imut as list of string: ents = stdIoListDir("dbs")
                  imut as int64: n = stdCollectionLength(ents)
                  mut as int64: i = 1
                  infinite {
                        route {
                              i > n ==> { break }
                              _ ==> {
                                    imut as string: name = "" + ents[i]
                                    route {
                                          name != "." and name != dd and name != ".gitkeep" ==> {
                                                stdIoDeleteFile("dbs\\" + name)
                                          }
                                          _ ==> {}
                                    }
                                    i = i + 1
                              }
                        }
                  }
            }
            _ ==> {}
      }
      emit(nice, 0, "ok")
}

function (compDetectEnv) (as int64: shard_id) as map {
      imut as string: base_tmp = "build\\intermediates\\tmp"
      imut as string: tmp_dir = base_tmp + "\\r_" + stdDateTimeMonotonicNow() + "_" + shard_id
      compEnsureDir("build")
      compEnsureDir("build\\intermediates")
      compEnsureDir(base_tmp)
      compEnsureDir(tmp_dir)

      mut as string: fluxc_bin = "bin\\fluxc.exe"
      route {
            not stdIoFileExists(fluxc_bin) and stdIoFileExists("bin/fluxc") ==> {
                  fluxc_bin = "bin/fluxc"
            }
            _ ==> {}
      }

      mut as string: self_exe = "bin\\compliance.exe"
      imut as string: argv0 = stdRuntimeExecutablePath()
      route {
            argv0 != "" and stdIoFileExists(argv0) ==> { self_exe = argv0 }
            argv0 != "" and stdIoFileExists(argv0 + ".exe") ==> { self_exe = argv0 + ".exe" }
            _ ==> {}
      }

      imut as string: probe_file = tmp_dir + "\\_wasmer_probe.tmp"
      compDeleteIfExists(probe_file)
      mut as string: wasmer_bin = ""
      imut as int64: rc_w1 = stdOsExec("where wasmer > \"" + probe_file + "\" 2>nul")
      route {
            rc_w1 == 0 and stdIoFileExists(probe_file) ==> {
                  imut as list of string: wlines = compSplitLines(stdIoReadFile(probe_file))
                  route {
                        stdCollectionLength(wlines) > 0 ==> {
                              wasmer_bin = compTrimBoth("" + wlines[1])
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }
      route {
            wasmer_bin == "" ==> {
                  compDeleteIfExists(probe_file)
                  stdOsExec("if exist \"%USERPROFILE%\\.wasmer\\bin\\wasmer.exe\" echo %USERPROFILE%\\.wasmer\\bin\\wasmer.exe > \"" + probe_file + "\"")
                  route {
                        stdIoFileExists(probe_file) ==> {
                              imut as list of string: wlines2 = compSplitLines(stdIoReadFile(probe_file))
                              route {
                                    stdCollectionLength(wlines2) > 0 ==> {
                                          wasmer_bin = compTrimBoth("" + wlines2[1])
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }
      compDeleteIfExists(probe_file)

      mut as string: has_clang = "0"
      route {
            stdOsExec("clang --version >nul 2>&1") == 0 ==> { has_clang = "1" }
            _ ==> {}
      }

      mut as map: env = map{}
      env["m_fluxc"] = fluxc_bin
      env["m_self"] = self_exe
      env["m_wasmer"] = wasmer_bin
      env["m_clang"] = has_clang
      env["m_tmp"] = tmp_dir
      route {
            stdIoFileExists("io_stdlib_fixture.txt") ==> { env["m_fix"] = "1" }
            _ ==> { env["m_fix"] = "0" }
      }
      emit(nice, env, "ok")
}

function (compRunExecCapture) (as string: inner_cmd, as string: stdin_file, as string: out_file, as string: err_file) as int64 {
      mut as string: in_redir = "< nul"
      route {
            stdin_file != "" ==> { in_redir = "< \"" + stdin_file + "\"" }
            _ ==> {}
      }
      imut as string: full_cmd = "set FLUX_CI=1&& " + inner_cmd + " " + in_redir + " > \"" + out_file + "\" 2> \"" + err_file + "\""
      emit(nice, stdOsExec(full_cmd), "ok")
}

function (compCheckErrorMatch) (as string: combined_out, as string: expected_code) as bool {
      emit(nice, compContains(combined_out, "[" + expected_code + " - ") or compContains(combined_out, "[" + expected_code + "]") or compContains(combined_out, "[" + expected_code), "ok")
}

function (compEvalStaticErrorBackend) (as map: env, as string: target_flag, as string: out_base, as string: filepath, as string: expected_code, as string: stdin_file) as map {
      imut as string: fluxc = "" + env["m_fluxc"]
      imut as string: tmp_dir = "" + env["m_tmp"]
      imut as string: out_file = tmp_dir + "\\_out.tmp"
      imut as string: err_file = tmp_dir + "\\_err.tmp"
      mut as string: cmd = "\"" + fluxc + "\" "
      route {
            target_flag == "in" ==> {
                  cmd = cmd + "--target in \"" + filepath + "\""
            }
            _ ==> {
                  cmd = cmd + "--no-run --target " + target_flag + " -o \"" + out_base + "\" \"" + filepath + "\""
            }
      }
      imut as int64: rc = compRunExecCapture(cmd, stdin_file, out_file, err_file)
      imut as string: combined = stdIoReadFile(out_file) + "\n" + stdIoReadFile(err_file)
      mut as bool: ok = (rc != 0 and compCheckErrorMatch(combined, expected_code))
      mut as string: reason = "OK"
      route {
            rc == 0 ==> {
                  ok = false
                  reason = "UNEXPECTED_OK(esperado [" + expected_code + "])"
            }
            not ok ==> {
                  reason = "ERR_MISMATCH(esperado [" + expected_code + "], rc=" + rc + "): " + compSanitizeOneLine(combined, 70)
            }
            _ ==> {}
      }
      mut as map: res = map{}
      route { ok ==> { res["m_ok"] = "1" } _ ==> { res["m_ok"] = "0" } }
      res["m_reason"] = reason
      emit(nice, res, "ok")
}

function (compEvalCompiledBackend) (as map: env, as string: bname, as string: target_flag, as string: out_base, as string: artifact_path, as string: run_prefix, as string: run_suffix, as string: filepath, as string: stdin_file, as string: ref_out, as bool: ref_ok, as bool: is_db) as map {
      mut as map: res = map{}
      route {
            is_db ==> { compCleanDbArtifacts() }
            _ ==> {}
      }
      route {
            (bname == "wat" or bname == "wasm") and ("" + env["m_wasmer"]) == "" ==> {
                  res["m_ok"] = "0"
                  res["m_reason"] = "WASMER_MISSING"
                  emit(nice, res, "ok")
            }
            _ ==> {}
      }
      imut as string: fluxc = "" + env["m_fluxc"]
      imut as string: tmp_dir = "" + env["m_tmp"]
      imut as string: out_file = tmp_dir + "\\_out.tmp"
      imut as string: err_file = tmp_dir + "\\_err.tmp"

      compDeleteIfExists(artifact_path)
      imut as string: compile_cmd = "\"" + fluxc + "\" --no-run --target " + target_flag + " -o \"" + out_base + "\" \"" + filepath + "\""
      imut as int64: c_rc = compRunExecCapture(compile_cmd, "", out_file, err_file)
      route {
            c_rc != 0 or not stdIoFileExists(artifact_path) ==> {
                  imut as string: cerr = stdIoReadFile(err_file) + "\n" + stdIoReadFile(out_file)
                  res["m_ok"] = "0"
                  res["m_reason"] = "COMP_FAIL(rc=" + c_rc + "): " + compSanitizeOneLine(cerr, 70)
                  emit(nice, res, "ok")
            }
            _ ==> {}
      }

      imut as string: run_cmd = run_prefix + "\"" + artifact_path + "\"" + run_suffix
      imut as int64: r_rc = compRunExecCapture(run_cmd, stdin_file, out_file, err_file)
      route {
            r_rc != 0 ==> {
                  imut as string: rerr = stdIoReadFile(err_file) + "\n" + stdIoReadFile(out_file)
                  res["m_ok"] = "0"
                  res["m_reason"] = "EXEC_FAIL(rc=" + r_rc + "): " + compSanitizeOneLine(rerr, 70)
                  emit(nice, res, "ok")
            }
            _ ==> {}
      }
      route {
            not ref_ok ==> {
                  res["m_ok"] = "0"
                  res["m_reason"] = "NO_IN_REF"
                  emit(nice, res, "ok")
            }
            _ ==> {}
      }

      imut as string: norm_out = compNormalizeOutput(stdIoReadFile(out_file))
      route {
            norm_out == ref_out ==> {
                  res["m_ok"] = "1"
                  res["m_reason"] = "OK"
                  emit(nice, res, "ok")
            }
            _ ==> {
                  res["m_ok"] = "0"
                  res["m_reason"] = "OUT_DIFF(" + compFirstDiffPreview(ref_out, norm_out) + ")"
                  emit(nice, res, "ok")
            }
      }
}

function (compRunSingleTest) (as map: env, as string: filepath, as string: fname) as map {
      imut as string: tmp_dir = "" + env["m_tmp"]
      compCleanTestArtifacts(tmp_dir)

      imut as string: static_err_code = compGetStaticErrorCode(filepath, fname)
      imut as bool: is_static_err = (static_err_code != "")
      imut as bool: is_diag = compStartsWith(fname, "ExampleOfError_") or is_static_err
      imut as bool: is_db = compContains(fname, "DbStdLib")

      imut as string: stdin_text = compGetStdinForFile(filepath, fname)
      mut as string: stdin_file = ""
      route {
            stdin_text != "" ==> {
                  stdin_file = tmp_dir + "\\_stdin.tmp"
                  stdIoWriteFile(stdin_file, stdin_text)
            }
            _ ==> {}
      }

      imut as string: fluxc = "" + env["m_fluxc"]
      imut as string: wasmer = "" + env["m_wasmer"]
      imut as string: vm_base = tmp_dir + "\\_c_vm"
      imut as string: lv_base = tmp_dir + "\\_c_lv"
      imut as string: wat_base = tmp_dir + "\\_c_wat"
      imut as string: was_base = tmp_dir + "\\_c_was"

      mut as bool: ok_in = false
      mut as bool: ok_vm = false
      mut as bool: ok_lv = false
      mut as bool: ok_wat = false
      mut as bool: ok_was = false
      mut as list of string: notes = []

      route {
            is_static_err ==> {
                  imut as map: r_in = compEvalStaticErrorBackend(env, "in", "", filepath, static_err_code, stdin_file)
                  ok_in = ("" + r_in["m_ok"]) == "1"
                  route { not ok_in ==> { notes = stdListPushBack(notes, "in: " + r_in["m_reason"]) } _ ==> {} }

                  imut as map: r_vm = compEvalStaticErrorBackend(env, "vm", vm_base, filepath, static_err_code, stdin_file)
                  ok_vm = ("" + r_vm["m_ok"]) == "1"
                  route { not ok_vm ==> { notes = stdListPushBack(notes, "vm: " + r_vm["m_reason"]) } _ ==> {} }

                  imut as map: r_lv = compEvalStaticErrorBackend(env, "lv", lv_base, filepath, static_err_code, stdin_file)
                  ok_lv = ("" + r_lv["m_ok"]) == "1"
                  route { not ok_lv ==> { notes = stdListPushBack(notes, "llvm: " + r_lv["m_reason"]) } _ ==> {} }

                  imut as map: r_wat = compEvalStaticErrorBackend(env, "wat", wat_base, filepath, static_err_code, stdin_file)
                  ok_wat = ("" + r_wat["m_ok"]) == "1"
                  route { not ok_wat ==> { notes = stdListPushBack(notes, "wat: " + r_wat["m_reason"]) } _ ==> {} }

                  imut as map: r_was = compEvalStaticErrorBackend(env, "wasm", was_base, filepath, static_err_code, stdin_file)
                  ok_was = ("" + r_was["m_ok"]) == "1"
                  route { not ok_was ==> { notes = stdListPushBack(notes, "wasm: " + r_was["m_reason"]) } _ ==> {} }
            }
            _ ==> {
                  route { is_db ==> { compCleanDbArtifacts() } _ ==> {} }
                  imut as string: out_file = tmp_dir + "\\_out.tmp"
                  imut as string: err_file = tmp_dir + "\\_err.tmp"
                  imut as int64: rc_in = compRunExecCapture("\"" + fluxc + "\" --target in \"" + filepath + "\"", stdin_file, out_file, err_file)
                  mut as string: ref_out = ""
                  route {
                        rc_in == 0 ==> {
                              ok_in = true
                              ref_out = compNormalizeOutput(stdIoReadFile(out_file))
                        }
                        _ ==> {
                              imut as string: ierr = stdIoReadFile(err_file) + "\n" + stdIoReadFile(out_file)
                              notes = stdListPushBack(notes, "in: EXEC_FAIL(rc=" + rc_in + "): " + compSanitizeOneLine(ierr, 70))
                        }
                  }

                  imut as string: vmr_pref = "\"" + fluxc + "\" --target vmr "
                  imut as map: r_vm = compEvalCompiledBackend(env, "vm", "vm", vm_base, vm_base + ".fvmbc", vmr_pref, "", filepath, stdin_file, ref_out, ok_in, is_db)
                  ok_vm = ("" + r_vm["m_ok"]) == "1"
                  route { not ok_vm ==> { notes = stdListPushBack(notes, "vm: " + r_vm["m_reason"]) } _ ==> {} }

                  imut as map: r_lv = compEvalCompiledBackend(env, "llvm", "lv", lv_base, lv_base + ".exe", "", "", filepath, stdin_file, ref_out, ok_in, is_db)
                  ok_lv = ("" + r_lv["m_ok"]) == "1"
                  route { not ok_lv ==> { notes = stdListPushBack(notes, "llvm: " + r_lv["m_reason"]) } _ ==> {} }

                  imut as string: wat_pref = "\"" + wasmer + "\" run --env FLUX_CI=1 "
                  imut as map: r_wat = compEvalCompiledBackend(env, "wat", "wat", wat_base, wat_base + ".wat", wat_pref, "", filepath, stdin_file, ref_out, ok_in, is_db)
                  ok_wat = ("" + r_wat["m_ok"]) == "1"
                  route { not ok_wat ==> { notes = stdListPushBack(notes, "wat: " + r_wat["m_reason"]) } _ ==> {} }

                  imut as map: r_was = compEvalCompiledBackend(env, "wasm", "wasm", was_base, was_base + ".wasm", wat_pref, "", filepath, stdin_file, ref_out, ok_in, is_db)
                  ok_was = ("" + r_was["m_ok"]) == "1"
                  route { not ok_was ==> { notes = stdListPushBack(notes, "wasm: " + r_was["m_reason"]) } _ ==> {} }
            }
      }

      route { is_db ==> { compCleanDbArtifacts() } _ ==> {} }
      compCleanTestArtifacts(tmp_dir)

      imut as bool: all_ok = ok_in and ok_vm and ok_lv and ok_wat and ok_was
      mut as map: rec = map{}
      rec["m_fname"] = fname
      route { is_diag ==> { rec["m_diag"] = "1" } _ ==> { rec["m_diag"] = "0" } }
      route { ok_in ==> { rec["m_in"] = "1" } _ ==> { rec["m_in"] = "0" } }
      route { ok_vm ==> { rec["m_vm"] = "1" } _ ==> { rec["m_vm"] = "0" } }
      route { ok_lv ==> { rec["m_lv"] = "1" } _ ==> { rec["m_lv"] = "0" } }
      route { ok_wat ==> { rec["m_wat"] = "1" } _ ==> { rec["m_wat"] = "0" } }
      route { ok_was ==> { rec["m_was"] = "1" } _ ==> { rec["m_was"] = "0" } }
      route { all_ok ==> { rec["m_res"] = "1" } _ ==> { rec["m_res"] = "0" } }
      route {
            stdCollectionLength(notes) > 0 ==> {
                  rec["m_notes"] = compJoinRange(notes, 1, stdCollectionLength(notes), " ; ")
            }
            _ ==> {
                  rec["m_notes"] = ""
            }
      }
      emit(nice, rec, "ok")
}

function (compBoolStr) (as bool: b) as string {
      route {
            b ==> { emit(nice, "1", "ok") }
            _ ==> { emit(nice, "0", "ok") }
      }
}

function (compLoadBaseline) (as string: base_path) as map {
      mut as map: rows = map{}
      mut as list of string: order = []
      mut as int64: cnt_total = 0
      mut as int64: cnt_in = 0
      mut as int64: cnt_vm = 0
      mut as int64: cnt_lv = 0
      mut as int64: cnt_wat = 0
      mut as int64: cnt_was = 0
      mut as int64: cnt_res = 0
      mut as bool: exists = stdIoFileExists(base_path)

      route {
            exists ==> {
                  imut as string: content = stdIoReadFile(base_path)
                  imut as list of string: lines = compSplitLines(content)
                  imut as int64: nl = stdCollectionLength(lines)
                  mut as int64: i = 1
                  infinite {
                        route {
                              i > nl ==> { break }
                              _ ==> {
                                    imut as string: ln = compTrimBoth("" + lines[i])
                                    route {
                                          compStartsWith(ln, "|") and compContains(ln, ".flux") ==> {
                                                imut as list of string: cells = compSplitByPipe(ln)
                                                imut as int64: nc = stdCollectionLength(cells)
                                                imut as string: fn = "" + cells[1]
                                                route {
                                                      compEndsWith(fn, ".flux") and (nc == 7 or nc == 8) ==> {
                                                            mut as bool: b_in = false
                                                            mut as bool: b_vm = false
                                                            mut as bool: b_lv = false
                                                            mut as bool: b_wat = false
                                                            mut as bool: b_was = false
                                                            mut as bool: b_res = false
                                                            route {
                                                                  nc == 8 ==> {
                                                                        b_in = compContains("" + cells[2], "✅")
                                                                        b_vm = compContains("" + cells[3], "✅") and compContains("" + cells[4], "✅")
                                                                        b_lv = compContains("" + cells[5], "✅")
                                                                        b_wat = compContains("" + cells[6], "✅")
                                                                        b_was = compContains("" + cells[7], "✅")
                                                                        b_res = b_in and b_vm and b_lv and b_wat and b_was
                                                                  }
                                                                  _ ==> {
                                                                        b_in = compContains("" + cells[2], "✅")
                                                                        b_vm = compContains("" + cells[3], "✅")
                                                                        b_lv = compContains("" + cells[4], "✅")
                                                                        b_wat = compContains("" + cells[5], "✅")
                                                                        b_was = compContains("" + cells[6], "✅")
                                                                        b_res = b_in and b_vm and b_lv and b_wat and b_was
                                                                  }
                                                            }
                                                            imut as string: encoded = compBoolStr(b_in) + "|" + compBoolStr(b_vm) + "|" + compBoolStr(b_lv) + "|" + compBoolStr(b_wat) + "|" + compBoolStr(b_was) + "|" + compBoolStr(b_res)
                                                            route {
                                                                  not stdMapContainsKey(rows, fn) ==> {
                                                                        order = stdListPushBack(order, fn)
                                                                        cnt_total = cnt_total + 1
                                                                        route { b_in ==> { cnt_in = cnt_in + 1 } _ ==> {} }
                                                                        route { b_vm ==> { cnt_vm = cnt_vm + 1 } _ ==> {} }
                                                                        route { b_lv ==> { cnt_lv = cnt_lv + 1 } _ ==> {} }
                                                                        route { b_wat ==> { cnt_wat = cnt_wat + 1 } _ ==> {} }
                                                                        route { b_was ==> { cnt_was = cnt_was + 1 } _ ==> {} }
                                                                        route { b_res ==> { cnt_res = cnt_res + 1 } _ ==> {} }
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                            rows[fn] = encoded
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
            }
            _ ==> {}
      }

      mut as map: res = map{}
      res["m_exists"] = compBoolStr(exists)
      res["m_rows"] = rows
      route {
            stdCollectionLength(order) > 0 ==> {
                  res["m_order_str"] = compJoinRange(order, 1, stdCollectionLength(order), "\n")
            }
            _ ==> { res["m_order_str"] = "" }
      }
      res["m_total"] = "" + cnt_total
      res["m_in"] = "" + cnt_in
      res["m_vm"] = "" + cnt_vm
      res["m_lv"] = "" + cnt_lv
      res["m_wat"] = "" + cnt_wat
      res["m_was"] = "" + cnt_was
      res["m_res"] = "" + cnt_res
      emit(nice, res, "ok")
}

function (compStatusCell) (as string: flag, as int64: width) as string {
      mut as string: icon = " ❌ "
      route {
            flag == "1" ==> { icon = " ✅ " }
            _ ==> {}
      }
      route {
            width <= 4 ==> { emit(nice, icon, "ok") }
            width == 5 ==> { emit(nice, " " + icon, "ok") }
            _ ==> { emit(nice, " " + icon + " ", "ok") }
      }
}

function (compHeaderLines) () as list of string {
      mut as list of string: out = []
      out = stdListPushBack(out, "| arquivo                                                             |  in   |  vm  | llvm |  wat | wasm  | result |")
      out = stdListPushBack(out, "| ------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ----- | ------ |")
      emit(nice, out, "ok")
}

function (compFormatRecordRow) (as string: encoded_row) as string {
      imut as list of string: parts = compSplitChar(encoded_row, "|", false)
      imut as string: fname = "" + parts[1]
      imut as string: c_in = compStatusCell("" + parts[2], 5)
      imut as string: c_vm = compStatusCell("" + parts[3], 4)
      imut as string: c_lv = compStatusCell("" + parts[4], 4)
      imut as string: c_wat = compStatusCell("" + parts[5], 4)
      imut as string: c_was = compStatusCell("" + parts[6], 5)
      imut as string: c_res = compStatusCell("" + parts[7], 6)
      emit(nice, "| " + compPadRight(fname, 67) + " |" + c_in + "|" + c_vm + "|" + c_lv + "|" + c_wat + "|" + c_was + "|" + c_res + "|", "ok")
}

function (compSummaryLine) (as string: label, as int64: pass_cnt, as int64: total_cnt) as string {
      mut as string: icon = "❌"
      route {
            total_cnt > 0 and pass_cnt == total_cnt ==> { icon = "✅" }
            total_cnt == 0 ==> { icon = "✅" }
            _ ==> {}
      }
      emit(nice, "- " + compPadLeft(label, 12) + " : " + icon + " " + compPadLeft("" + pass_cnt, 4) + " of " + compPadLeft("" + total_cnt, 4) + " — " + icon, "ok")
}

function (compAppendStringList) (as list of string: dst, as list of string: src) as list of string {
      mut as list of string: out = dst
      imut as int64: n = stdCollectionLength(src)
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        out = stdListPushBack(out, "" + src[i])
                        i = i + 1
                  }
            }
      }
      emit(nice, out, "ok")
}

function (compCheckDelta) (as string: fname, as list of string: cur_parts, as list of string: base_parts) as map {
      mut as list of string: regs = []
      mut as list of string: imps = []
      mut as list of string: names = []
      names = stdListPushBack(names, "in")
      names = stdListPushBack(names, "vm")
      names = stdListPushBack(names, "llvm")
      names = stdListPushBack(names, "wat")
      names = stdListPushBack(names, "wasm")
      names = stdListPushBack(names, "result")

      mut as int64: k = 1
      infinite {
            route {
                  k > 6 ==> { break }
                  _ ==> {
                        imut as string: cur_v = "" + cur_parts[k + 1]
                        imut as string: old_v = "" + base_parts[k]
                        route {
                              old_v == "1" and cur_v == "0" ==> {
                                    regs = stdListPushBack(regs, "" + names[k] + ": ✅→❌")
                              }
                              old_v == "0" and cur_v == "1" ==> {
                                    imps = stdListPushBack(imps, "" + names[k] + ": ❌→✅")
                              }
                              _ ==> {}
                        }
                        k = k + 1
                  }
            }
      }

      mut as map: res = map{}
      route {
            stdCollectionLength(regs) > 0 ==> {
                  res["m_reg"] = "`" + fname + "` (" + compJoinRange(regs, 1, stdCollectionLength(regs), ", ") + ")"
            }
            _ ==> { res["m_reg"] = "" }
      }
      route {
            stdCollectionLength(imps) > 0 ==> {
                  res["m_imp"] = "`" + fname + "` (" + compJoinRange(imps, 1, stdCollectionLength(imps), ", ") + ")"
            }
            _ ==> { res["m_imp"] = "" }
      }
      emit(nice, res, "ok")
}

function (compAppendPaginatedTable) (as list of string: dst, as list of string: rows) as list of string {
      mut as list of string: out = dst
      imut as int64: n = stdCollectionLength(rows)
      mut as int64: i = 1
      mut as int64: page = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        route {
                              ((i - 1) % 10) == 0 ==> {
                                    out = stdListPushBack(out, "")
                                    out = stdListPushBack(out, "### Tabela de conformidade — página " + page)
                                    out = stdListPushBack(out, "")
                                    out = compAppendStringList(out, compHeaderLines())
                                    page = page + 1
                              }
                              _ ==> {}
                        }
                        out = stdListPushBack(out, compFormatRecordRow("" + rows[i]))
                        i = i + 1
                  }
            }
      }
      emit(nice, out, "ok")
}

function (compParseInt) (as string: s) as int64 {
      imut as string: t = compTrimBoth(s)
      imut as int64: n = stdCollectionLength(t)
      route {
            n == 0 ==> { emit(nice, 0, "ok") }
            _ ==> {}
      }
      mut as int64: val = 0
      mut as int64: i = 1
      mut as bool: neg = false
      route {
            t[1] == "-" ==> {
                  neg = true
                  i = 2
            }
            _ ==> {}
      }
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        imut as int64: d = compIndexOf("0123456789", t[i]) - 1
                        route {
                              d < 0 ==> { break }
                              _ ==> { val = (val * 10) + d }
                        }
                        i = i + 1
                  }
            }
      }
      route {
            neg ==> { emit(nice, 0 - val, "ok") }
            _ ==> { emit(nice, val, "ok") }
      }
}

function (compCompareRowMetric) (as string: label, as string: old_val_str, as int64: old_tot, as int64: new_val, as int64: new_tot) as string {
      imut as int64: old_val = compParseInt(old_val_str)
      imut as int64: diff = new_val - old_val
      mut as string: d_str = "="
      route {
            diff > 0 ==> { d_str = "+" + diff }
            diff < 0 ==> { d_str = "" + diff }
            _ ==> {}
      }
      emit(nice, "| " + compPadRight(label, 8) + " | " + compPadLeft(old_val + "/" + old_tot, 11) + " | " + compPadLeft(new_val + "/" + new_tot, 11) + " | " + compPadLeft(d_str, 6) + " |", "ok")
}

function (compWriteComplianceReport) (as string: out_md, as string: base_md, as map: base, as list of string: pos_rows, as list of string: diag_rows, as list of string: fail_details, as map: counts) as int64 {
      mut as list of string: lines = []
      imut as int64: n_pos = stdCollectionLength(pos_rows)
      imut as int64: n_diag = stdCollectionLength(diag_rows)
      imut as int64: total_files = n_pos + n_diag

      lines = stdListPushBack(lines, "## 📦 Programas Regulares de Execução")
      lines = compAppendPaginatedTable(lines, pos_rows)

      route {
            n_diag > 0 ==> {
                  lines = stdListPushBack(lines, "")
                  lines = stdListPushBack(lines, "## 🧪 Tabela de Conformidade — Testes de Diagnósticos e Erros (Negativos)")
                  lines = stdListPushBack(lines, "")
                  lines = stdListPushBack(lines, "> Testes de validação de diagnósticos estáticos canônicos e operações matemáticas de erro em runtime.")
                  lines = stdListPushBack(lines, "")
                  lines = compAppendStringList(lines, compHeaderLines())
                  mut as int64: di = 1
                  infinite {
                        route {
                              di > n_diag ==> { break }
                              _ ==> {
                                    lines = stdListPushBack(lines, compFormatRecordRow("" + diag_rows[di]))
                                    di = di + 1
                              }
                        }
                  }
            }
            _ ==> {}
      }

      imut as int64: cnt_pos_ok = compParseInt("" + counts["m_pos_ok"])
      imut as int64: cnt_diag_ok = compParseInt("" + counts["m_diag_ok"])
      imut as int64: cnt_in = compParseInt("" + counts["m_in"])
      imut as int64: cnt_vm = compParseInt("" + counts["m_vm"])
      imut as int64: cnt_lv = compParseInt("" + counts["m_lv"])
      imut as int64: cnt_wat = compParseInt("" + counts["m_wat"])
      imut as int64: cnt_was = compParseInt("" + counts["m_was"])
      imut as int64: total_checks = total_files * 5
      imut as int64: total_passed = cnt_in + cnt_vm + cnt_lv + cnt_wat + cnt_was

      lines = stdListPushBack(lines, "")
      lines = stdListPushBack(lines, "### Resumo de Conformidade:")
      lines = stdListPushBack(lines, "")
      lines = stdListPushBack(lines, compSummaryLine("POSITIVOS", cnt_pos_ok, n_pos))
      route {
            n_diag > 0 ==> {
                  lines = stdListPushBack(lines, compSummaryLine("DIAGNÓSTICO", cnt_diag_ok, n_diag))
            }
            _ ==> {}
      }
      lines = stdListPushBack(lines, compSummaryLine("IN", cnt_in, total_files))
      lines = stdListPushBack(lines, compSummaryLine("VM", cnt_vm, total_files))
      lines = stdListPushBack(lines, compSummaryLine("LLVM", cnt_lv, total_files))
      lines = stdListPushBack(lines, compSummaryLine("WAT", cnt_wat, total_files))
      lines = stdListPushBack(lines, compSummaryLine("WASM", cnt_was, total_files))
      lines = stdListPushBack(lines, compSummaryLine("TOTAL GERAL", total_passed, total_checks))

      #L Relatorio de Regressao comparado a baseline fixa (XX00.md)
      lines = stdListPushBack(lines, "")
      lines = stdListPushBack(lines, "## 📊 Relatório de Regressão vs Baseline Fixa")
      lines = stdListPushBack(lines, "")
      lines = stdListPushBack(lines, "- **Baseline de referência (fixa):** `" + base_md + "`")
      lines = stdListPushBack(lines, "- **Relatório atual:** `" + out_md + "`")

      imut as bool: has_base = ("" + base["m_exists"]) == "1"
      mut as list of string: all_rows = []
      all_rows = compAppendStringList(all_rows, pos_rows)
      all_rows = compAppendStringList(all_rows, diag_rows)

      route {
            not has_base ==> {
                  lines = stdListPushBack(lines, "")
                  lines = stdListPushBack(lines, "> ⚠️ Arquivo baseline `" + base_md + "` não encontrado; comparação de regressão indisponível.")
            }
            _ ==> {
                  imut as int64: base_tot = compParseInt("" + base["m_total"])
                  imut as int64: cnt_res = compParseInt("" + counts["m_res"])
                  lines = stdListPushBack(lines, "")
                  lines = stdListPushBack(lines, "| Métrica  | Baseline 00 | Atual 01    | Delta  |")
                  lines = stdListPushBack(lines, "| -------- | ----------- | ----------- | ------ |")
                  lines = stdListPushBack(lines, compCompareRowMetric("in", "" + base["m_in"], base_tot, cnt_in, total_files))
                  lines = stdListPushBack(lines, compCompareRowMetric("vm", "" + base["m_vm"], base_tot, cnt_vm, total_files))
                  lines = stdListPushBack(lines, compCompareRowMetric("llvm", "" + base["m_lv"], base_tot, cnt_lv, total_files))
                  lines = stdListPushBack(lines, compCompareRowMetric("wat", "" + base["m_wat"], base_tot, cnt_wat, total_files))
                  lines = stdListPushBack(lines, compCompareRowMetric("wasm", "" + base["m_was"], base_tot, cnt_was, total_files))
                  lines = stdListPushBack(lines, compCompareRowMetric("result", "" + base["m_res"], base_tot, cnt_res, total_files))

                  imut as map: base_rows = base["m_rows"]
                  mut as map: seen_map = map{}
                  mut as list of string: regressions = []
                  mut as list of string: improvements = []
                  mut as list of string: added_files = []
                  mut as list of string: removed_files = []

                  imut as int64: na = stdCollectionLength(all_rows)
                  mut as int64: ai = 1
                  infinite {
                        route {
                              ai > na ==> { break }
                              _ ==> {
                                    imut as list of string: cur_p = compSplitChar("" + all_rows[ai], "|", false)
                                    imut as string: fname = "" + cur_p[1]
                                    seen_map[fname] = "1"
                                    route {
                                          stdMapContainsKey(base_rows, fname) ==> {
                                                imut as list of string: old_p = compSplitChar("" + base_rows[fname], "|", false)
                                                imut as map: dm = compCheckDelta(fname, cur_p, old_p)
                                                route { ("" + dm["m_reg"]) != "" ==> { regressions = stdListPushBack(regressions, "" + dm["m_reg"]) } _ ==> {} }
                                                route { ("" + dm["m_imp"]) != "" ==> { improvements = stdListPushBack(improvements, "" + dm["m_imp"]) } _ ==> {} }
                                          }
                                          _ ==> {
                                                added_files = stdListPushBack(added_files, "`" + fname + "`")
                                          }
                                    }
                                    ai = ai + 1
                              }
                        }
                  }

                  imut as list of string: base_order = compSplitLines("" + base["m_order_str"])
                  imut as int64: nb = stdCollectionLength(base_order)
                  mut as int64: bi = 1
                  infinite {
                        route {
                              bi > nb ==> { break }
                              _ ==> {
                                    imut as string: bfn = "" + base_order[bi]
                                    route {
                                          not stdMapContainsKey(seen_map, bfn) ==> {
                                                removed_files = stdListPushBack(removed_files, "`" + bfn + "`")
                                          }
                                          _ ==> {}
                                    }
                                    bi = bi + 1
                              }
                        }
                  }

                  lines = stdListPushBack(lines, "")
                  lines = stdListPushBack(lines, "### ❌ Regressões Detectadas (✅ → ❌): " + stdCollectionLength(regressions))
                  lines = stdListPushBack(lines, "")
                  route {
                        stdCollectionLength(regressions) == 0 ==> {
                              lines = stdListPushBack(lines, "Nenhuma regressão detectada em relação à baseline `" + base_md + "`.")
                        }
                        _ ==> {
                              mut as int64: ri = 1
                              infinite {
                                    route {
                                          ri > stdCollectionLength(regressions) ==> { break }
                                          _ ==> {
                                                lines = stdListPushBack(lines, "- " + regressions[ri])
                                                ri = ri + 1
                                          }
                                    }
                              }
                        }
                  }

                  lines = stdListPushBack(lines, "")
                  lines = stdListPushBack(lines, "### ✅ Melhorias Detectadas (❌ → ✅): " + stdCollectionLength(improvements))
                  lines = stdListPushBack(lines, "")
                  route {
                        stdCollectionLength(improvements) == 0 ==> {
                              lines = stdListPushBack(lines, "Nenhuma melhoria pontual em relação à baseline.")
                        }
                        _ ==> {
                              mut as int64: ii = 1
                              infinite {
                                    route {
                                          ii > stdCollectionLength(improvements) ==> { break }
                                          _ ==> {
                                                lines = stdListPushBack(lines, "- " + improvements[ii])
                                                ii = ii + 1
                                          }
                                    }
                              }
                        }
                  }

                  route {
                        stdCollectionLength(added_files) > 0 or stdCollectionLength(removed_files) > 0 ==> {
                              lines = stdListPushBack(lines, "")
                              lines = stdListPushBack(lines, "### 📂 Diferenças de Conjunto de Arquivos vs Baseline")
                              lines = stdListPushBack(lines, "")
                              route {
                                    stdCollectionLength(added_files) > 0 ==> {
                                          lines = stdListPushBack(lines, "- **Adicionados (" + stdCollectionLength(added_files) + "):** " + compJoinRange(added_files, 1, stdCollectionLength(added_files), ", "))
                                    }
                                    _ ==> {}
                              }
                              route {
                                    stdCollectionLength(removed_files) > 0 ==> {
                                          lines = stdListPushBack(lines, "- **Removidos (" + stdCollectionLength(removed_files) + "):** " + compJoinRange(removed_files, 1, stdCollectionLength(removed_files), ", "))
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
            }
      }

      route {
            stdCollectionLength(fail_details) > 0 ==> {
                  lines = stdListPushBack(lines, "")
                  lines = stdListPushBack(lines, "### 🔍 Detalhamento de Falhas e Divergências vs `in` (" + stdCollectionLength(fail_details) + " arquivo(s))")
                  lines = stdListPushBack(lines, "")
                  mut as int64: fi = 1
                  infinite {
                        route {
                              fi > stdCollectionLength(fail_details) ==> { break }
                              _ ==> {
                                    lines = stdListPushBack(lines, "- " + fail_details[fi])
                                    fi = fi + 1
                              }
                        }
                  }
            }
            _ ==> {}
      }

      imut as string: doc = compJoinRange(lines, 1, stdCollectionLength(lines), "\n") + "\n"
      stdIoWriteFile(out_md, doc)
      emit(nice, 0, "ok")
}

function (compCollectFluxFiles) (as string: base_dir, as string: rel_dir, as string: filtro_lower, as list of string: acc) as list of string {
      mut as list of string: out = acc
      mut as string: scan_dir = base_dir
      route {
            rel_dir != "" ==> { scan_dir = compJoinPath(base_dir, rel_dir) }
            _ ==> {}
      }
      imut as list of string: raw_entries = stdIoListDir(scan_dir)
      imut as int64: n_raw = stdCollectionLength(raw_entries)
      mut as int64: ei = 1
      infinite {
            route {
                  ei > n_raw ==> { break }
                  _ ==> {
                        imut as string: name = "" + raw_entries[ei]
                        route {
                              not compStartsWith(name, ".") ==> {
                                    mut as string: rel_path = name
                                    route {
                                          rel_dir != "" ==> { rel_path = rel_dir + "\\" + name }
                                          _ ==> {}
                                    }
                                    imut as string: full_path = compJoinPath(base_dir, rel_path)
                                    route {
                                          stdIoDirExists(full_path) ==> {
                                                out = compCollectFluxFiles(base_dir, rel_path, filtro_lower, out)
                                          }
                                          compEndsWith(name, ".flux") and name != "input.flux" ==> {
                                                route {
                                                      filtro_lower == "" or compContains(compLower(rel_path), filtro_lower) ==> {
                                                            out = stdListPushBack(out, rel_path)
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        ei = ei + 1
                  }
            }
      }
      emit(nice, out, "ok")
}

function (compNeedsSerial) (as string: fname) as bool {
      emit(nice, compContains(fname, "DbStdLib") or compContains(fname, "IoStdLib") or compContains(fname, "ArchiveStdLib") or compContains(fname, "FileSignatureStdLib") or compContains(fname, "CompressStdLib"), "ok")
}

function (compRecordToTsv) (as map: r) as string {
      emit(nice, ("" + r["m_fname"]) + "\t" + ("" + r["m_diag"]) + "\t" + ("" + r["m_in"]) + "\t" + ("" + r["m_vm"]) + "\t" + ("" + r["m_lv"]) + "\t" + ("" + r["m_wat"]) + "\t" + ("" + r["m_was"]) + "\t" + ("" + r["m_res"]) + "\t" + ("" + r["m_notes"]) + "\n", "ok")
}

function (compTsvToRecord) (as string: raw_txt) as map {
      imut as list of string: lns = compSplitLines(raw_txt)
      mut as string: ln = ""
      route {
            stdCollectionLength(lns) > 0 ==> { ln = "" + lns[1] }
            _ ==> {}
      }
      imut as list of string: cols = compSplitChar(ln, "\t", false)
      imut as int64: nc = stdCollectionLength(cols)
      mut as map: r = map{}
      route {
            nc >= 8 ==> {
                  r["m_fname"] = "" + cols[1]
                  r["m_diag"] = "" + cols[2]
                  r["m_in"] = "" + cols[3]
                  r["m_vm"] = "" + cols[4]
                  r["m_lv"] = "" + cols[5]
                  r["m_wat"] = "" + cols[6]
                  r["m_was"] = "" + cols[7]
                  r["m_res"] = "" + cols[8]
                  route {
                        nc >= 9 ==> { r["m_notes"] = "" + cols[9] }
                        _ ==> { r["m_notes"] = "" }
                  }
            }
            _ ==> {
                  r["m_fname"] = ""
                  r["m_diag"] = "0"
                  r["m_in"] = "0"
                  r["m_vm"] = "0"
                  r["m_lv"] = "0"
                  r["m_wat"] = "0"
                  r["m_was"] = "0"
                  r["m_res"] = "0"
                  r["m_notes"] = "INVALID_TSV"
            }
      }
      emit(nice, r, "ok")
}

function (compWriteResultAtomic) (as string: res_dir, as int64: fi, as map: r) as int64 {
      imut as string: tmp_p = res_dir + "\\_r_" + fi + ".tsv.tmp"
      imut as string: fin_p = res_dir + "\\_r_" + fi + ".tsv"
      stdIoWriteFile(tmp_p, compRecordToTsv(r))
      stdOsExec("move /y \"" + tmp_p + "\" \"" + fin_p + "\" >nul 2>&1")
      emit(nice, 0, "ok")
}

function (compFormatEncodedRow) (as map: r) as string {
      imut as string: fn = "" + r["m_fname"]
      imut as string: s_in = "" + r["m_in"]
      imut as string: s_vm = "" + r["m_vm"]
      imut as string: s_lv = "" + r["m_lv"]
      imut as string: s_wat = "" + r["m_wat"]
      imut as string: s_was = "" + r["m_was"]
      imut as string: s_res = "" + r["m_res"]
      emit(nice, fn + "|" + s_in + "|" + s_vm + "|" + s_lv + "|" + s_wat + "|" + s_was + "|" + s_res, "ok")
}

function (compAllWorkersDone) (as string: res_dir, as int64: jobs) as bool {
      mut as int64: w = 1
      infinite {
            route {
                  w > jobs ==> { break }
                  not stdIoFileExists(res_dir + "\\_w" + w + ".done") ==> { emit(nice, false, "ok") }
                  _ ==> { w = w + 1 }
            }
      }
      emit(nice, true, "ok")
}

function (compRunSuite) (as map: env, as string: suite_flag, as string: title, as string: dir_path, as string: base_md, as string: out_md, as string: filtro_lower, as int64: jobs, as int64: shard_idx, as int64: shard_total, as string: worker_res_dir) as map {
      mut as map: suite_res = map{}
      route {
            shard_idx == 0 ==> {
                  println("")
                  println("==========================================================================")
                  println("  Suite: " + title + " (" + dir_path + ")")
                  println("==========================================================================")
            }
            _ ==> {}
      }

      route {
            not stdIoDirExists(dir_path) ==> {
                  route {
                        shard_idx == 0 ==> { println("[AVISO] Diretorio nao encontrado: " + dir_path) }
                        _ ==> {}
                  }
                  suite_res["m_total"] = "0"
                  suite_res["m_res"] = "0"
                  emit(nice, suite_res, "ok")
            }
            _ ==> {}
      }

      mut as list of string: files = []
      files = compCollectFluxFiles(dir_path, "", filtro_lower, files)
      files = compSortStrings(files)
      imut as int64: nf = stdCollectionLength(files)

      #L Modo worker (--shard k/N)
      route {
            shard_idx > 0 ==> {
                  mut as int64: par_seq = 0
                  mut as int64: fi = 1
                  infinite {
                        route {
                              fi > nf ==> { break }
                              _ ==> {
                                    imut as string: rel_path = "" + files[fi]
                                    imut as string: fname = stdIoPathBaseName(rel_path)
                                    route {
                                          not compNeedsSerial(fname) ==> {
                                                par_seq = par_seq + 1
                                                route {
                                                      ((par_seq - 1) % shard_total) + 1 == shard_idx ==> {
                                                            imut as string: fpath = compJoinPath(dir_path, rel_path)
                                                            imut as map: r = compRunSingleTest(env, fpath, fname)
                                                            compWriteResultAtomic(worker_res_dir, fi, r)
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    fi = fi + 1
                              }
                        }
                  }
                  suite_res["m_total"] = "0"
                  suite_res["m_res"] = "0"
                  emit(nice, suite_res, "ok")
            }
            _ ==> {}
      }

      imut as bool: use_parallel = (jobs > 1 and nf >= 16 and filtro_lower == "")
      route {
            use_parallel ==> {
                  println("[*] Arquivos selecionados: " + nf + " (workers paralelos: " + jobs + ")")
            }
            _ ==> {
                  println("[*] Arquivos selecionados: " + nf)
            }
      }

      imut as map: base = compLoadBaseline(base_md)
      mut as list of string: pos_rows = []
      mut as list of string: diag_rows = []
      mut as list of string: fail_details = []
      mut as int64: cnt_pos_ok = 0
      mut as int64: cnt_diag_ok = 0
      mut as int64: cnt_in = 0
      mut as int64: cnt_vm = 0
      mut as int64: cnt_lv = 0
      mut as int64: cnt_wat = 0
      mut as int64: cnt_was = 0
      mut as int64: cnt_res = 0

      route {
            use_parallel ==> {
                  imut as string: run_res_dir = ("" + env["m_tmp"]) + "\\res"
                  compEnsureDir(run_res_dir)
                  imut as string: self_exe = "" + env["m_self"]
                  mut as list of string: spawn_lines = []
                  spawn_lines = stdListPushBack(spawn_lines, "@echo off")

                  mut as int64: w = 1
                  infinite {
                        route {
                              w > jobs ==> { break }
                              _ ==> {
                                    imut as string: w_bat = run_res_dir + "\\_w" + w + ".bat"
                                    imut as string: w_err = run_res_dir + "\\_w" + w + ".err"
                                    imut as string: w_done = run_res_dir + "\\_w" + w + ".done"
                                    imut as string: w_body = "@echo off\n\"" + self_exe + "\" " + suite_flag + " --shard " + w + "/" + jobs + " --res-dir \"" + run_res_dir + "\" >nul 2>\"" + w_err + "\"\necho 1>\"" + w_done + "\"\n"
                                    stdIoWriteFile(w_bat, w_body)
                                    spawn_lines = stdListPushBack(spawn_lines, "start \"\" /b cmd /c \"" + w_bat + "\"")
                                    w = w + 1
                              }
                        }
                  }
                  imut as string: spawn_bat = run_res_dir + "\\_spawn.bat"
                  stdIoWriteFile(spawn_bat, compJoinRange(spawn_lines, 1, stdCollectionLength(spawn_lines), "\n") + "\n")
                  stdOsExec("\"" + spawn_bat + "\"")

                  mut as map: printed_map = map{}
                  mut as int64: sfi = 1
                  infinite {
                        route {
                              sfi > nf ==> { break }
                              _ ==> {
                                    imut as string: s_rel = "" + files[sfi]
                                    imut as string: s_fname = stdIoPathBaseName(s_rel)
                                    route {
                                          compNeedsSerial(s_fname) ==> {
                                                imut as string: s_fpath = compJoinPath(dir_path, s_rel)
                                                imut as map: sr = compRunSingleTest(env, s_fpath, s_fname)
                                                compWriteResultAtomic(run_res_dir, sfi, sr)
                                                println("[" + compPadLeft("" + sfi, 4) + "/" + compPadLeft("" + nf, 4) + "] " + compFormatRecordRow(compFormatEncodedRow(sr)))
                                                printed_map["" + sfi] = "1"
                                          }
                                          _ ==> {}
                                    }
                                    sfi = sfi + 1
                              }
                        }
                  }

                  infinite {
                        mut as int64: pfi = 1
                        infinite {
                              route {
                                    pfi > nf ==> { break }
                                    _ ==> {
                                          imut as string: k_pfi = "" + pfi
                                          route {
                                                not stdMapContainsKey(printed_map, k_pfi) ==> {
                                                      imut as string: rp = run_res_dir + "\\_r_" + pfi + ".tsv"
                                                      route {
                                                            stdIoFileExists(rp) ==> {
                                                                  imut as map: pr = compTsvToRecord(stdIoReadFile(rp))
                                                                  println("[" + compPadLeft("" + pfi, 4) + "/" + compPadLeft("" + nf, 4) + "] " + compFormatRecordRow(compFormatEncodedRow(pr)))
                                                                  printed_map[k_pfi] = "1"
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          pfi = pfi + 1
                                    }
                              }
                        }
                        route {
                              compAllWorkersDone(run_res_dir, jobs) ==> { break }
                              _ ==> { stdOsExec("ping -n 2 127.0.0.1 >nul") }
                        }
                  }

                  mut as int64: cfi = 1
                  infinite {
                        route {
                              cfi > nf ==> { break }
                              _ ==> {
                                    imut as string: rp2 = run_res_dir + "\\_r_" + cfi + ".tsv"
                                    mut as map: cr = map{}
                                    route {
                                          stdIoFileExists(rp2) ==> {
                                                cr = compTsvToRecord(stdIoReadFile(rp2))
                                                route {
                                                      not stdMapContainsKey(printed_map, "" + cfi) ==> {
                                                            println("[" + compPadLeft("" + cfi, 4) + "/" + compPadLeft("" + nf, 4) + "] " + compFormatRecordRow(compFormatEncodedRow(cr)))
                                                            printed_map["" + cfi] = "1"
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {
                                                imut as string: fb_rel = "" + files[cfi]
                                                imut as string: fb_fname = stdIoPathBaseName(fb_rel)
                                                imut as string: fb_fpath = compJoinPath(dir_path, fb_rel)
                                                cr = compRunSingleTest(env, fb_fpath, fb_fname)
                                                println("[" + compPadLeft("" + cfi, 4) + "/" + compPadLeft("" + nf, 4) + "] " + compFormatRecordRow(compFormatEncodedRow(cr)))
                                          }
                                    }

                                    imut as string: cf_fname = "" + cr["m_fname"]
                                    imut as string: s_in = "" + cr["m_in"]
                                    imut as string: s_vm = "" + cr["m_vm"]
                                    imut as string: s_lv = "" + cr["m_lv"]
                                    imut as string: s_wat = "" + cr["m_wat"]
                                    imut as string: s_was = "" + cr["m_was"]
                                    imut as string: s_res = "" + cr["m_res"]
                                    imut as string: s_diag = "" + cr["m_diag"]
                                    imut as string: notes = "" + cr["m_notes"]

                                    route { s_in == "1" ==> { cnt_in = cnt_in + 1 } _ ==> {} }
                                    route { s_vm == "1" ==> { cnt_vm = cnt_vm + 1 } _ ==> {} }
                                    route { s_lv == "1" ==> { cnt_lv = cnt_lv + 1 } _ ==> {} }
                                    route { s_wat == "1" ==> { cnt_wat = cnt_wat + 1 } _ ==> {} }
                                    route { s_was == "1" ==> { cnt_was = cnt_was + 1 } _ ==> {} }
                                    route { s_res == "1" ==> { cnt_res = cnt_res + 1 } _ ==> {} }

                                    imut as string: row_enc = compFormatEncodedRow(cr)
                                    route {
                                          s_diag == "1" ==> {
                                                diag_rows = stdListPushBack(diag_rows, row_enc)
                                                route { s_res == "1" ==> { cnt_diag_ok = cnt_diag_ok + 1 } _ ==> {} }
                                          }
                                          _ ==> {
                                                pos_rows = stdListPushBack(pos_rows, row_enc)
                                                route { s_res == "1" ==> { cnt_pos_ok = cnt_pos_ok + 1 } _ ==> {} }
                                          }
                                    }
                                    route {
                                          notes != "" ==> {
                                                fail_details = stdListPushBack(fail_details, "`" + cf_fname + "`: " + notes)
                                          }
                                          _ ==> {}
                                    }
                                    cfi = cfi + 1
                              }
                        }
                  }
                  stdOsExec("rmdir /s /q \"" + run_res_dir + "\" >nul 2>&1")
            }
            _ ==> {
                  mut as int64: fi = 1
                  infinite {
                        route {
                              fi > nf ==> { break }
                              _ ==> {
                                    imut as string: rel_path = "" + files[fi]
                                    imut as string: fname = stdIoPathBaseName(rel_path)
                                    imut as string: fpath = compJoinPath(dir_path, rel_path)
                                    imut as map: r = compRunSingleTest(env, fpath, fname)

                                    imut as string: s_in = "" + r["m_in"]
                                    imut as string: s_vm = "" + r["m_vm"]
                                    imut as string: s_lv = "" + r["m_lv"]
                                    imut as string: s_wat = "" + r["m_wat"]
                                    imut as string: s_was = "" + r["m_was"]
                                    imut as string: s_res = "" + r["m_res"]
                                    imut as string: s_diag = "" + r["m_diag"]
                                    imut as string: notes = "" + r["m_notes"]

                                    route { s_in == "1" ==> { cnt_in = cnt_in + 1 } _ ==> {} }
                                    route { s_vm == "1" ==> { cnt_vm = cnt_vm + 1 } _ ==> {} }
                                    route { s_lv == "1" ==> { cnt_lv = cnt_lv + 1 } _ ==> {} }
                                    route { s_wat == "1" ==> { cnt_wat = cnt_wat + 1 } _ ==> {} }
                                    route { s_was == "1" ==> { cnt_was = cnt_was + 1 } _ ==> {} }
                                    route { s_res == "1" ==> { cnt_res = cnt_res + 1 } _ ==> {} }

                                    imut as string: row_enc = compFormatEncodedRow(r)
                                    route {
                                          s_diag == "1" ==> {
                                                diag_rows = stdListPushBack(diag_rows, row_enc)
                                                route { s_res == "1" ==> { cnt_diag_ok = cnt_diag_ok + 1 } _ ==> {} }
                                          }
                                          _ ==> {
                                                pos_rows = stdListPushBack(pos_rows, row_enc)
                                                route { s_res == "1" ==> { cnt_pos_ok = cnt_pos_ok + 1 } _ ==> {} }
                                          }
                                    }
                                    route {
                                          notes != "" ==> {
                                                fail_details = stdListPushBack(fail_details, "`" + fname + "`: " + notes)
                                          }
                                          _ ==> {}
                                    }

                                    println("[" + compPadLeft("" + fi, 4) + "/" + compPadLeft("" + nf, 4) + "] " + compFormatRecordRow(row_enc))
                                    route {
                                          notes != "" and filtro_lower != "" ==> {
                                                println("    -> " + notes)
                                          }
                                          _ ==> {}
                                    }
                                    fi = fi + 1
                              }
                        }
                  }
            }
      }

      mut as map: counts = map{}
      counts["m_pos_ok"] = "" + cnt_pos_ok
      counts["m_diag_ok"] = "" + cnt_diag_ok
      counts["m_in"] = "" + cnt_in
      counts["m_vm"] = "" + cnt_vm
      counts["m_lv"] = "" + cnt_lv
      counts["m_wat"] = "" + cnt_wat
      counts["m_was"] = "" + cnt_was
      counts["m_res"] = "" + cnt_res

      println("")
      println(compSummaryLine("POSITIVOS", cnt_pos_ok, stdCollectionLength(pos_rows)))
      route {
            stdCollectionLength(diag_rows) > 0 ==> {
                  println(compSummaryLine("DIAGNOSTICO", cnt_diag_ok, stdCollectionLength(diag_rows)))
            }
            _ ==> {}
      }
      println(compSummaryLine("IN", cnt_in, nf))
      println(compSummaryLine("VM", cnt_vm, nf))
      println(compSummaryLine("LLVM", cnt_lv, nf))
      println(compSummaryLine("WAT", cnt_wat, nf))
      println(compSummaryLine("WASM", cnt_was, nf))
      println(compSummaryLine("RESULT", cnt_res, nf))

      route {
            filtro_lower == "" ==> {
                  compWriteComplianceReport(out_md, base_md, base, pos_rows, diag_rows, fail_details, counts)
                  println("[OK] Relatorio gerado em: " + out_md)
            }
            _ ==> {
                  println("[*] Modo --filter ativo: '" + out_md + "' preservado sem alteracoes.")
            }
      }

      suite_res["m_total"] = "" + nf
      suite_res["m_res"] = "" + cnt_res
      suite_res["m_in"] = "" + cnt_in
      suite_res["m_vm"] = "" + cnt_vm
      suite_res["m_lv"] = "" + cnt_lv
      suite_res["m_wat"] = "" + cnt_wat
      suite_res["m_was"] = "" + cnt_was
      emit(nice, suite_res, "ok")
}

program (FluxCompliance) {
      imut as list of string: args = stdRuntimeGetArgs()
      imut as int64: argc = stdCollectionLength(args)

      mut as bool: run_ca = false
      mut as bool: run_nr = false
      mut as bool: run_sa = false
      mut as bool: run_all = false
      mut as bool: suite_explicit = false
      mut as string: filtro_raw = ""
      mut as int64: jobs = 8
      mut as int64: shard_idx = 0
      mut as int64: shard_total = 1
      mut as string: res_dir = ""

      mut as int64: i = 1
      infinite {
            route {
                  i > argc ==> { break }
                  _ ==> {
                        imut as string: arg = "" + args[i]
                        route {
                              arg == "--help" or arg == "-h" ==> {
                                    compPrintHelp()
                                    stdOsExit(0)
                              }
                              arg == "--ca" or arg == "--canon" ==> {
                                    run_ca = true
                                    suite_explicit = true
                              }
                              arg == "--nr" or arg == "--recipes" ==> {
                                    run_nr = true
                                    suite_explicit = true
                              }
                              arg == "--sa" or arg == "--science" or arg == "--algorithms" ==> {
                                    run_sa = true
                                    suite_explicit = true
                              }
                              arg == "--all" ==> {
                                    run_all = true
                                    suite_explicit = true
                              }
                              arg == "--filter" ==> {
                                    route {
                                          i + 1 > argc ==> {
                                                println("[ERRO] --filter requer um argumento.")
                                                stdOsExit(1)
                                          }
                                          _ ==> {
                                                i = i + 1
                                                filtro_raw = "" + args[i]
                                          }
                                    }
                              }
                              compStartsWith(arg, "--filter=") ==> {
                                    imut as int64: alen = stdCollectionLength(arg)
                                    route {
                                          alen > 9 ==> { filtro_raw = arg[10..alen] }
                                          _ ==> { filtro_raw = "" }
                                    }
                              }
                              arg == "-j" or arg == "--jobs" ==> {
                                    route {
                                          i + 1 > argc ==> {
                                                println("[ERRO] " + arg + " requer um numero inteiro positivo.")
                                                stdOsExit(1)
                                          }
                                          _ ==> {
                                                i = i + 1
                                                jobs = compParseInt("" + args[i])
                                                route {
                                                      jobs < 1 ==> {
                                                            println("[ERRO] Numero de workers invalido.")
                                                            stdOsExit(1)
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                    }
                              }
                              compStartsWith(arg, "--jobs=") ==> {
                                    imut as int64: jlen = stdCollectionLength(arg)
                                    route {
                                          jlen > 7 ==> { jobs = compParseInt(arg[8..jlen]) }
                                          _ ==> { jobs = 0 }
                                    }
                                    route {
                                          jobs < 1 ==> {
                                                println("[ERRO] Numero de workers invalido.")
                                                stdOsExit(1)
                                          }
                                          _ ==> {}
                                    }
                              }
                              arg == "--shard" ==> {
                                    route {
                                          i + 1 > argc ==> {
                                                println("[ERRO] --shard requer k/N.")
                                                stdOsExit(1)
                                          }
                                          _ ==> {
                                                i = i + 1
                                                imut as list of string: sp = compSplitChar("" + args[i], "/", false)
                                                route {
                                                      stdCollectionLength(sp) == 2 ==> {
                                                            shard_idx = compParseInt("" + sp[1])
                                                            shard_total = compParseInt("" + sp[2])
                                                      }
                                                      _ ==> {}
                                                }
                                                route {
                                                      shard_idx < 1 or shard_total < 1 or shard_idx > shard_total ==> {
                                                            println("[ERRO] --shard invalido.")
                                                            stdOsExit(1)
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                    }
                              }
                              arg == "--res-dir" ==> {
                                    route {
                                          i + 1 > argc ==> {
                                                println("[ERRO] --res-dir requer caminho.")
                                                stdOsExit(1)
                                          }
                                          _ ==> {
                                                i = i + 1
                                                res_dir = "" + args[i]
                                          }
                                    }
                              }
                              arg == "--" ==> {}
                              _ ==> {
                                    println("[ERRO] Opcao desconhecida: " + arg)
                                    compPrintHelp()
                                    stdOsExit(1)
                              }
                        }
                        i = i + 1
                  }
            }
      }

      route {
            not suite_explicit or run_all ==> {
                  run_ca = true
                  run_nr = true
                  run_sa = true
            }
            _ ==> {}
      }

      imut as map: env = compDetectEnv(shard_idx)
      route {
            shard_idx == 0 and ("" + env["m_fix"]) != "1" ==> {
                  println("[AVISO] io_stdlib_fixture.txt nao encontrado na raiz; contratos de leitura de IoStdLib podem falhar.")
            }
            _ ==> {}
      }
      route {
            shard_idx == 0 and ("" + env["m_wasmer"]) == "" ==> {
                  println("[AVISO] wasmer nao encontrado no PATH ou em %USERPROFILE%\\.wasmer\\bin\\wasmer.exe; testes WAT/WASM falharao.")
            }
            _ ==> {}
      }
      route {
            shard_idx == 0 and ("" + env["m_clang"]) != "1" ==> {
                  println("[AVISO] clang nao encontrado no PATH; testes LLVM falharao.")
            }
            _ ==> {}
      }

      imut as string: filtro_lower = compLower(compTrimBoth(filtro_raw))
      imut as int64: t0 = stdDateTimeMonotonicNow()
      mut as int64: grand_files = 0
      mut as int64: grand_ok = 0

      route {
            run_ca ==> {
                  imut as map: s_ca = compRunSuite(env, "--ca", "Canon (CA)", "examples\\Canon", "examples\\00_Standarts\\compliance_CA00.md", "examples\\00_Standarts\\compliance_CA01.md", filtro_lower, jobs, shard_idx, shard_total, res_dir)
                  grand_files = grand_files + compParseInt("" + s_ca["m_total"])
                  grand_ok = grand_ok + compParseInt("" + s_ca["m_res"])
            }
            _ ==> {}
      }
      route {
            run_nr ==> {
                  imut as map: s_nr = compRunSuite(env, "--nr", "Numerical Recipes (NR)", "examples\\NumericalRecipes", "examples\\00_Standarts\\compliance_NR00.md", "examples\\00_Standarts\\compliance_NR01.md", filtro_lower, jobs, shard_idx, shard_total, res_dir)
                  grand_files = grand_files + compParseInt("" + s_nr["m_total"])
                  grand_ok = grand_ok + compParseInt("" + s_nr["m_res"])
            }
            _ ==> {}
      }
      route {
            run_sa ==> {
                  imut as map: s_sa = compRunSuite(env, "--sa", "Scientific Algorithms (SA)", "examples\\ScientificAlgorithms", "examples\\00_Standarts\\compliance_SA00.md", "examples\\00_Standarts\\compliance_SA01.md", filtro_lower, jobs, shard_idx, shard_total, res_dir)
                  grand_files = grand_files + compParseInt("" + s_sa["m_total"])
                  grand_ok = grand_ok + compParseInt("" + s_sa["m_res"])
            }
            _ ==> {}
      }

      imut as string: tmp_dir = "" + env["m_tmp"]
      compCleanTestArtifacts(tmp_dir)
      stdOsExec("rmdir /s /q \"" + tmp_dir + "\" >nul 2>&1")
      route {
            shard_idx == 0 ==> {
                  imut as int64: elapsed_ms = stdDateTimeMonotonicElapsed(t0) /i 1000000
                  println("")
                  println("==========================================================================")
                  println("  Concluido: " + grand_ok + "/" + grand_files + " arquivos 100% conformes | Tempo: " + elapsed_ms + " ms")
                  println("==========================================================================")
            }
            _ ==> {}
      }
      stdOsExit(0)
}
