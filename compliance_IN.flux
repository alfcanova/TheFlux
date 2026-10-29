#L ==============================================================================
#L TheFlux Compliance: IN (Auditoria de Conformidade Lado a Lado do Interpretador)
#L Arquivo: compliance_IN.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib
use IoStdLib

program (ComplianceIn) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)

      #L 1. Localizacao dinamica do binario fluxc
      mut as string: fluxc_bin = ".\\bin\\fluxc.exe"
      route {
            stdIoFileExists(".\\bin\\fluxc.exe") ==> { fluxc_bin = ".\\bin\\fluxc.exe" }
            stdIoFileExists("bin\\fluxc.exe")    ==> { fluxc_bin = "bin\\fluxc.exe" }
            stdIoFileExists("fluxc.exe")        ==> { fluxc_bin = "fluxc.exe" }
            _                                    ==> { fluxc_bin = "fluxc" }
      }

      #L 2. Coleta de filtro opcional de linha de comando
      mut as string: filtro = ""
      mut as int64: ai = 1
      infinite {
            route {
                  ai > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[ai]
                        mut as bool: is_self = (a == "compliance_IN.flux" or a == ".\\compliance_IN.flux" or a == "./compliance_IN.flux" or a == "compliance_IN.exe" or a == ".\\compliance_IN.exe" or a == "bin\\compliance_IN.exe" or a == ".\\bin\\compliance_IN.exe" or a == "--")
                        route {
                              is_self ==> {}
                              _ ==> {
                                    mut as int64: alen = stdCollectionLength(a)
                                    route {
                                          alen > 0 ==> {
                                                route {
                                                      a[1] != "-" ==> {
                                                            route {
                                                                  filtro == "" ==> {
                                                                        filtro = a
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
                        ai = ai + 1
                  }
            }
      }

      #L Lowercase do filtro (para busca case-insensitive)
      mut as string: filtro_lower = ""
      mut as int64: fl_len = stdCollectionLength(filtro)
      mut as int64: f_i = 1
      infinite {
            route {
                  f_i > fl_len ==> { break }
                  _ ==> {
                        mut as string: ch = filtro[f_i]
                        route {
                              ch == "A" ==> { ch = "a" }
                              ch == "B" ==> { ch = "b" }
                              ch == "C" ==> { ch = "c" }
                              ch == "D" ==> { ch = "d" }
                              ch == "E" ==> { ch = "e" }
                              ch == "F" ==> { ch = "f" }
                              ch == "G" ==> { ch = "g" }
                              ch == "H" ==> { ch = "h" }
                              ch == "I" ==> { ch = "i" }
                              ch == "J" ==> { ch = "j" }
                              ch == "K" ==> { ch = "k" }
                              ch == "L" ==> { ch = "l" }
                              ch == "M" ==> { ch = "m" }
                              ch == "N" ==> { ch = "n" }
                              ch == "O" ==> { ch = "o" }
                              ch == "P" ==> { ch = "p" }
                              ch == "Q" ==> { ch = "q" }
                              ch == "R" ==> { ch = "r" }
                              ch == "S" ==> { ch = "s" }
                              ch == "T" ==> { ch = "t" }
                              ch == "U" ==> { ch = "u" }
                              ch == "V" ==> { ch = "v" }
                              ch == "W" ==> { ch = "w" }
                              ch == "X" ==> { ch = "x" }
                              ch == "Y" ==> { ch = "y" }
                              ch == "Z" ==> { ch = "z" }
                              _ ==> {}
                        }
                        filtro_lower = filtro_lower + ch
                        f_i = f_i + 1
                  }
            }
      }

      #L 3. Listagem de todos os arquivos na pasta flux/
      mut as list of data: entries = stdIoListDir("flux")
      mut as int64: total_entries = stdCollectionLength(entries)
      mut as list of data: flux_files = []
      mut as int64: n_flux = 0
      mut as int64: ei = 1
      infinite {
            route {
                  ei > total_entries ==> { break }
                  _ ==> {
                        mut as string: fname = "" + entries[ei]
                        mut as int64: fn_len = stdCollectionLength(fname)
                        route {
                              fn_len >= 5 ==> {
                                    mut as string: ext = fname[(fn_len - 4)..fn_len]
                                    route {
                                          ext == ".flux" ==> {
                                                mut as bool: aceito = true
                                                route {
                                                      filtro_lower != "" ==> {
                                                            aceito = false
                                                            mut as string: fname_lower = ""
                                                            mut as int64: nli = 1
                                                            infinite {
                                                                  route {
                                                                        nli > fn_len ==> { break }
                                                                        _ ==> {
                                                                              mut as string: nch = fname[nli]
                                                                              route {
                                                                                    nch == "A" ==> { nch = "a" }
                                                                                    nch == "B" ==> { nch = "b" }
                                                                                    nch == "C" ==> { nch = "c" }
                                                                                    nch == "D" ==> { nch = "d" }
                                                                                    nch == "E" ==> { nch = "e" }
                                                                                    nch == "F" ==> { nch = "f" }
                                                                                    nch == "G" ==> { nch = "g" }
                                                                                    nch == "H" ==> { nch = "h" }
                                                                                    nch == "I" ==> { nch = "i" }
                                                                                    nch == "J" ==> { nch = "j" }
                                                                                    nch == "K" ==> { nch = "k" }
                                                                                    nch == "L" ==> { nch = "l" }
                                                                                    nch == "M" ==> { nch = "m" }
                                                                                    nch == "N" ==> { nch = "n" }
                                                                                    nch == "O" ==> { nch = "o" }
                                                                                    nch == "P" ==> { nch = "p" }
                                                                                    nch == "Q" ==> { nch = "q" }
                                                                                    nch == "R" ==> { nch = "r" }
                                                                                    nch == "S" ==> { nch = "s" }
                                                                                    nch == "T" ==> { nch = "t" }
                                                                                    nch == "U" ==> { nch = "u" }
                                                                                    nch == "V" ==> { nch = "v" }
                                                                                    nch == "W" ==> { nch = "w" }
                                                                                    nch == "X" ==> { nch = "x" }
                                                                                    nch == "Y" ==> { nch = "y" }
                                                                                    nch == "Z" ==> { nch = "z" }
                                                                                    _ ==> {}
                                                                              }
                                                                              fname_lower = fname_lower + nch
                                                                              nli = nli + 1
                                                                        }
                                                                  }
                                                            }
                                                            mut as int64: qlen = stdCollectionLength(filtro_lower)
                                                            route {
                                                                  fn_len >= qlen ==> {
                                                                        mut as int64: ki = 1
                                                                        infinite {
                                                                              route {
                                                                                    ki + qlen - 1 > fn_len ==> { break }
                                                                                    fname_lower[ki..(ki + qlen - 1)] == filtro_lower ==> {
                                                                                          aceito = true
                                                                                          break
                                                                                    }
                                                                                    _ ==> { ki = ki + 1 }
                                                                              }
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                                route {
                                                      aceito ==> {
                                                            n_flux = n_flux + 1
                                                            flux_files[n_flux] = fname
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

      #L 4. Ordenacao deterministica (A-Z)
      mut as int64: si = 1
      infinite {
            route {
                  si >= n_flux ==> { break }
                  _ ==> {
                        mut as int64: sj = si + 1
                        infinite {
                              route {
                                    sj > n_flux ==> { break }
                                    _ ==> {
                                          mut as string: a_str = "" + flux_files[si]
                                          mut as string: b_str = "" + flux_files[sj]
                                          route {
                                                a_str > b_str ==> {
                                                      mut as data: tmp = flux_files[si]
                                                      flux_files[si] = flux_files[sj]
                                                      flux_files[sj] = tmp
                                                }
                                                _ ==> {}
                                          }
                                          sj = sj + 1
                                    }
                              }
                        }
                        si = si + 1
                  }
            }
      }

      route {
            n_flux == 0 ==> {
                  println("Nenhum arquivo .flux encontrado para o filtro informado.")
                  stdOsExit(1)
            }
            _ ==> {}
      }

      #L 5. Backup e leitura de baseline (compliance_IN00.md -> compliance_IN01.md)
      route {
            filtro == "" and stdIoFileExists("compliance_IN00.md") ==> {
                  stdOsExec("cmd /c copy /y compliance_IN00.md compliance_IN01.md >nul")
                  println("Movido/copiado baseline: compliance_IN00.md -> compliance_IN01.md")
            }
            _ ==> {}
      }

      #L Mapeia baseline anterior de compliance_IN01.md se existir
      mut as map: old_status_sh = map{}
      mut as map: old_escolha = map{}
      route {
            stdIoFileExists("compliance_IN01.md") ==> {
                  mut as list of data: old_lines = stdIoReadLines("compliance_IN01.md")
                  mut as int64: n_old = stdCollectionLength(old_lines)
                  mut as int64: oli = 1
                  infinite {
                        route {
                              oli > n_old ==> { break }
                              _ ==> {
                                    mut as string: oln = "" + old_lines[oli]
                                    mut as int64: oln_len = stdCollectionLength(oln)
                                    route {
                                          oln_len > 15 ==> {
                                                route {
                                                      oln[1] == "|" ==> {
                                                            #L Extrai partes entre crases `...`
                                                            mut as list of data: bt_pos = []
                                                            mut as int64: n_bt = 0
                                                            mut as int64: bi = 1
                                                            infinite {
                                                                  route {
                                                                        bi > oln_len ==> { break }
                                                                        oln[bi] == "`" ==> {
                                                                              n_bt = n_bt + 1
                                                                              bt_pos[n_bt] = bi
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                                  bi = bi + 1
                                                            }
                                                            route {
                                                                  n_bt >= 8 ==> {
                                                                        mut as int64: p1 = bt_pos[1]
                                                                        mut as int64: p2 = bt_pos[2]
                                                                        mut as int64: p5 = bt_pos[5]
                                                                        mut as int64: p6 = bt_pos[6]
                                                                        mut as int64: p7 = bt_pos[7]
                                                                        mut as int64: p8 = bt_pos[8]
                                                                        route {
                                                                              p2 > p1 + 1 and p6 > p5 + 1 and p8 > p7 + 1 ==> {
                                                                                    mut as string: o_name = oln[(p1 + 1)..(p2 - 1)]
                                                                                    mut as string: o_sh = oln[(p5 + 1)..(p6 - 1)]
                                                                                    mut as string: o_esc = oln[(p7 + 1)..(p8 - 1)]
                                                                                    old_status_sh[o_name] = o_sh
                                                                                    old_escolha[o_name] = o_esc
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
                                    oli = oli + 1
                              }
                        }
                  }
            }
            _ ==> {}
      }

      #L 6. Carregamento da referencia legada docs/legacy_in.txt
      mut as map: legacy_lines = map{}
      mut as map: legacy_status = map{}
      route {
            stdIoFileExists("docs\\legacy_in.txt") ==> {
                  mut as list of data: leg_all = stdIoReadLines("docs\\legacy_in.txt")
                  mut as int64: n_leg = stdCollectionLength(leg_all)
                  mut as list of data: cur_leg_buf = []
                  mut as int64: cur_leg_cnt = 0
                  mut as int64: lgi = 1
                  infinite {
                        route {
                              lgi > n_leg ==> { break }
                              _ ==> {
                                    mut as string: lline = "" + leg_all[lgi]
                                    mut as int64: lllen = stdCollectionLength(lline)
                                    route {
                                          lllen >= 4 ==> {
                                                route {
                                                      lline[1..4] == "  | " ==> {
                                                            cur_leg_cnt = cur_leg_cnt + 1
                                                            cur_leg_buf[cur_leg_cnt] = lline
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          lllen >= 6 ==> {
                                                route {
                                                      lline[1..6] == "  OK  " ==> {
                                                            mut as string: lfile = lline[7..lllen]
                                                            cur_leg_cnt = cur_leg_cnt + 1
                                                            cur_leg_buf[cur_leg_cnt] = lline
                                                            legacy_lines[lfile] = cur_leg_buf
                                                            legacy_status[lfile] = "OK"
                                                            cur_leg_buf = []
                                                            cur_leg_cnt = 0
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          lllen >= 7 ==> {
                                                route {
                                                      lline[1..7] == "FALHA  " ==> {
                                                            mut as string: lrest = lline[8..lllen]
                                                            mut as int64: lrlen = stdCollectionLength(lrest)
                                                            mut as string: lfile = ""
                                                            mut as int64: cpi = 1
                                                            infinite {
                                                                  route {
                                                                        cpi > lrlen ==> { break }
                                                                        lrest[cpi] == ":" or lrest[cpi] == " " ==> { break }
                                                                        _ ==> {
                                                                              lfile = lfile + lrest[cpi]
                                                                              cpi = cpi + 1
                                                                        }
                                                                  }
                                                            }
                                                            cur_leg_cnt = cur_leg_cnt + 1
                                                            cur_leg_buf[cur_leg_cnt] = lline
                                                            legacy_lines[lfile] = cur_leg_buf
                                                            legacy_status[lfile] = "FALHA"
                                                            cur_leg_buf = []
                                                            cur_leg_cnt = 0
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    lgi = lgi + 1
                              }
                        }
                  }
            }
            _ ==> {}
      }

      #L 7. Execucao de cada arquivo de teste
      mut as list of data: eval_nome = []
      mut as list of data: eval_st_leg = []
      mut as list of data: eval_st_sh = []
      mut as list of data: eval_escolha = []
      mut as list of data: eval_leg_lines = []
      mut as list of data: eval_sh_lines = []

      mut as int64: ti = 1
      infinite {
            route {
                  ti > n_flux ==> { break }
                  _ ==> {
                        mut as string: nome = "" + flux_files[ti]
                        mut as string: path = "flux\\" + nome
                        mut as int64: nlen = stdCollectionLength(nome)

                        #L 7.1 Limpeza de DBs scratch para testes DbStdLib
                        route {
                              nlen >= 8 ==> {
                                    mut as int64: di = 1
                                    infinite {
                                          route {
                                                di + 7 > nlen ==> { break }
                                                nome[di..(di + 7)] == "DbStdLib" ==> {
                                                      stdOsExec("cmd /c del /q /f scratch\\flux_*.db* scratch\\flux_*.kv scratch\\flux_*.unqlite scratch\\flux_*.duckdb scratch\\flux_*.kuzu scratch\\flux_*.obx 2>nul")
                                                      break
                                                }
                                                _ ==> { di = di + 1 }
                                          }
                                    }
                              }
                              _ ==> {}
                        }

                        #L 7.2 Carrega referencia legada para este teste
                        mut as list of data: leg_lines = []
                        mut as string: st_leg = "FALHA"
                        route {
                              nome in legacy_lines ==> {
                                    leg_lines = legacy_lines[nome]
                                    st_leg = "" + legacy_status[nome]
                              }
                              _ ==> {
                                    leg_lines[1] = "FALHA  " + nome + ": ausente em docs/legacy_in.txt"
                              }
                        }

                        #L 7.3 Executa bin/fluxc.exe --target in diretamente
                        mut as string: cmd = ""
                        route {
                              nome == "ExampleOfInput.flux" ==> {
                                    cmd = "cmd /c \"set FLUX_CI=1 && (echo Ana& echo 30& echo 9.99& echo true& echo A& echo 2+3i& echo 2026-08-28T12:00:00Z) | " + fluxc_bin + " --target in \"flux\\" + nome + "\" > t_compliance_in.tmp 2>&1\""
                              }
                              nome == "ExampleOfUseIoStdLib_IoInputContract.flux" ==> {
                                    cmd = "cmd /c \"set FLUX_CI=1 && (echo andre& echo luiz) | " + fluxc_bin + " --target in \"flux\\" + nome + "\" > t_compliance_in.tmp 2>&1\""
                              }
                              nome == "input.flux" ==> {
                                    cmd = "cmd /c \"set FLUX_CI=1 && (echo dado) | " + fluxc_bin + " --target in \"flux\\" + nome + "\" > t_compliance_in.tmp 2>&1\""
                              }
                              _ ==> {
                                    cmd = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target in \"flux\\" + nome + "\" > t_compliance_in.tmp 2>&1\""
                              }
                        }
                        mut as int64: rc = stdOsExec(cmd)

                        #L 7.4 Leitura da saida do selfhosted
                        mut as list of data: raw_sh = []
                        route {
                              stdIoFileExists("t_compliance_in.tmp") ==> {
                                    raw_sh = stdIoReadLines("t_compliance_in.tmp")
                              }
                              _ ==> {}
                        }
                        mut as int64: n_raw_sh = stdCollectionLength(raw_sh)

                        #L 7.5 Verificacao de EXPECT_ERROR
                        mut as string: src_code = stdIoReadFile(path)
                        mut as int64: src_len = stdCollectionLength(src_code)
                        mut as string: exp_code = ""
                        route {
                              src_len >= 17 ==> {
                                    mut as string: exp_pref = src_code[1..17]
                                    route {
                                          exp_pref == "#L EXPECT_ERROR: " ==> {
                                                mut as int64: eci = 18
                                                infinite {
                                                      route {
                                                            eci > src_len ==> { break }
                                                            _ ==> {
                                                                  mut as string: ech = src_code[eci]
                                                                  route {
                                                                        ech == " " or ech == "\r" or ech == "\n" or ech == "\t" ==> { break }
                                                                        _ ==> {
                                                                              exp_code = exp_code + ech
                                                                              eci = eci + 1
                                                                        }
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }

                        #L 7.6 Analise de saida esperada e formatacao
                        mut as bool: has_diag_code = false
                        mut as bool: has_dica = false
                        route {
                              exp_code != "" ==> {
                                    mut as string: target_pat = "[" + exp_code + " - "
                                    mut as int64: tlen = stdCollectionLength(target_pat)
                                    mut as int64: ri = 1
                                    infinite {
                                          route {
                                                ri > n_raw_sh ==> { break }
                                                _ ==> {
                                                      mut as string: rln = "" + raw_sh[ri]
                                                      mut as int64: rllen = stdCollectionLength(rln)
                                                      route {
                                                            rllen >= tlen ==> {
                                                                  mut as int64: cki = 1
                                                                  infinite {
                                                                        route {
                                                                              cki + tlen - 1 > rllen ==> { break }
                                                                              rln[cki..(cki + tlen - 1)] == target_pat ==> {
                                                                                    has_diag_code = true
                                                                                    break
                                                                              }
                                                                              _ ==> { cki = cki + 1 }
                                                                        }
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            rllen >= 5 ==> {
                                                                  mut as int64: dki = 1
                                                                  infinite {
                                                                        route {
                                                                              dki + 4 > rllen ==> { break }
                                                                              rln[dki..(dki + 4)] == "Dica:" ==> {
                                                                                    has_dica = true
                                                                                    break
                                                                              }
                                                                              _ ==> { dki = dki + 1 }
                                                                        }
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      ri = ri + 1
                                                }
                                          }
                                    }
                              }
                              _ ==> {}
                        }

                        mut as list of data: sh_lines = []
                        mut as int64: n_sh_lines = 0
                        mut as string: st_sh = "FALHA"
                        route {
                              exp_code != "" ==> {
                                    route {
                                          rc != 0 and has_diag_code and has_dica ==> {
                                                st_sh = "OK"
                                                mut as int64: si_l = 1
                                                infinite {
                                                      route {
                                                            si_l > n_raw_sh ==> { break }
                                                            _ ==> {
                                                                  mut as string: sln = "" + raw_sh[si_l]
                                                                  route {
                                                                        sln != "" ==> {
                                                                              n_sh_lines = n_sh_lines + 1
                                                                              sh_lines[n_sh_lines] = "  | " + sln
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                                  si_l = si_l + 1
                                                            }
                                                      }
                                                }
                                                n_sh_lines = n_sh_lines + 1
                                                sh_lines[n_sh_lines] = "  OK  " + nome
                                          }
                                          _ ==> {
                                                st_sh = "FALHA"
                                                mut as string: last_err = "esperava erro " + exp_code
                                                route {
                                                      n_raw_sh > 0 ==> { last_err = "" + raw_sh[n_raw_sh] }
                                                      _ ==> {}
                                                }
                                                n_sh_lines = n_sh_lines + 1
                                                sh_lines[n_sh_lines] = "FALHA  " + nome + ": " + last_err
                                          }
                                    }
                              }
                              _ ==> {
                                    route {
                                          rc == 0 ==> {
                                                st_sh = "OK"
                                                mut as int64: si_l = 1
                                                infinite {
                                                      route {
                                                            si_l > n_raw_sh ==> { break }
                                                            _ ==> {
                                                                  mut as string: sln = "" + raw_sh[si_l]
                                                                  route {
                                                                        sln != "" ==> {
                                                                              n_sh_lines = n_sh_lines + 1
                                                                              sh_lines[n_sh_lines] = "  | " + sln
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                                  si_l = si_l + 1
                                                            }
                                                      }
                                                }
                                                n_sh_lines = n_sh_lines + 1
                                                sh_lines[n_sh_lines] = "  OK  " + nome
                                          }
                                          _ ==> {
                                                st_sh = "FALHA"
                                                mut as string: last_err = "erro de execucao"
                                                route {
                                                      n_raw_sh > 0 ==> { last_err = "" + raw_sh[n_raw_sh] }
                                                      _ ==> {}
                                                }
                                                n_sh_lines = n_sh_lines + 1
                                                sh_lines[n_sh_lines] = "FALHA  " + nome + ": " + last_err
                                          }
                                    }
                              }
                        }

                        #L 7.7 Exibicao lado a lado (Side-by-side de 58 colunas)
                        mut as int64: max_lines = stdCollectionLength(leg_lines)
                        mut as int64: len_sh = stdCollectionLength(sh_lines)
                        route {
                              len_sh > max_lines ==> { max_lines = len_sh }
                              _ ==> {}
                        }

                        println("")
                        println("=============================================================================================================================")
                        println("[" + ti + "/" + n_flux + "] Arquivo: " + nome)
                        println("-----------------------------------------------------------------------------------------------------------------------------")
                        println("LEGACY (docs/legacy_in.txt)                                | SELFHOSTED (bin/fluxc.exe -> selfhosted_in.txt)                 ")
                        println("-----------------------------------------------------------------------------------------------------------------------------")

                        mut as int64: pli = 1
                        infinite {
                              route {
                                    pli > max_lines ==> { break }
                                    _ ==> {
                                          mut as string: esq = ""
                                          route {
                                                pli <= stdCollectionLength(leg_lines) ==> { esq = "" + leg_lines[pli] }
                                                _ ==> {}
                                          }
                                          mut as string: dir_txt = ""
                                          route {
                                                pli <= stdCollectionLength(sh_lines) ==> { dir_txt = "" + sh_lines[pli] }
                                                _ ==> {}
                                          }

                                          mut as int64: elen = stdCollectionLength(esq)
                                          mut as string: esq_fmt = ""
                                          route {
                                                elen <= 58 ==> {
                                                      esq_fmt = esq
                                                      mut as int64: pad_e = 58 - elen
                                                      mut as int64: pi = 1
                                                      infinite {
                                                            route {
                                                                  pi > pad_e ==> { break }
                                                                  _ ==> {
                                                                        esq_fmt = esq_fmt + " "
                                                                        pi = pi + 1
                                                                  }
                                                            }
                                                      }
                                                }
                                                _ ==> {
                                                      esq_fmt = esq[1..55] + "..."
                                                }
                                          }

                                          mut as int64: dlen = stdCollectionLength(dir_txt)
                                          mut as string: dir_fmt = ""
                                          route {
                                                dlen <= 58 ==> {
                                                      dir_fmt = dir_txt
                                                      mut as int64: pad_d = 58 - dlen
                                                      mut as int64: pdi = 1
                                                      infinite {
                                                            route {
                                                                  pdi > pad_d ==> { break }
                                                                  _ ==> {
                                                                        dir_fmt = dir_fmt + " "
                                                                        pdi = pdi + 1
                                                                  }
                                                            }
                                                      }
                                                }
                                                _ ==> {
                                                      dir_fmt = dir_txt[1..55] + "..."
                                                }
                                          }

                                          println(esq_fmt + " | " + dir_fmt)
                                          pli = pli + 1
                                    }
                              }
                        }
                        println("=============================================================================================================================")

                        #L 7.8 Prompt interativo: (C)erto ou (E)rrado [C/E]
                        mut as string: prompt = "Avaliação para " + nome + " — Tecle (C)erto ou (E)rrado [C/E]: "
                        mut as string: escolha = ""
                        infinite {
                              mut as string: resp = input(prompt)
                              mut as int64: rlen = stdCollectionLength(resp)
                              mut as string: clean_up = ""
                              mut as int64: ci = 1
                              infinite {
                                    route {
                                          ci > rlen ==> { break }
                                          _ ==> {
                                                mut as string: cch = resp[ci]
                                                route {
                                                      cch == " " or cch == "\t" or cch == "\r" or cch == "\n" ==> {}
                                                      _ ==> {
                                                            route {
                                                                  cch == "a" ==> { cch = "A" }
                                                                  cch == "b" ==> { cch = "B" }
                                                                  cch == "c" ==> { cch = "C" }
                                                                  cch == "d" ==> { cch = "D" }
                                                                  cch == "e" ==> { cch = "E" }
                                                                  cch == "f" ==> { cch = "F" }
                                                                  cch == "g" ==> { cch = "G" }
                                                                  cch == "h" ==> { cch = "H" }
                                                                  cch == "i" ==> { cch = "I" }
                                                                  cch == "j" ==> { cch = "J" }
                                                                  cch == "k" ==> { cch = "K" }
                                                                  cch == "l" ==> { cch = "L" }
                                                                  cch == "m" ==> { cch = "M" }
                                                                  cch == "n" ==> { cch = "N" }
                                                                  cch == "o" ==> { cch = "O" }
                                                                  cch == "p" ==> { cch = "P" }
                                                                  cch == "q" ==> { cch = "Q" }
                                                                  cch == "r" ==> { cch = "R" }
                                                                  cch == "s" ==> { cch = "S" }
                                                                  cch == "t" ==> { cch = "T" }
                                                                  cch == "u" ==> { cch = "U" }
                                                                  cch == "v" ==> { cch = "V" }
                                                                  cch == "w" ==> { cch = "W" }
                                                                  cch == "x" ==> { cch = "X" }
                                                                  cch == "y" ==> { cch = "Y" }
                                                                  cch == "z" ==> { cch = "Z" }
                                                                  _ ==> {}
                                                            }
                                                            clean_up = clean_up + cch
                                                      }
                                                }
                                                ci = ci + 1
                                          }
                                    }
                              }

                              route {
                                    clean_up == "" ==> {
                                          escolha = "C"
                                          println("CERTO (C)")
                                          break
                                    }
                                    clean_up == "C" or clean_up == "CERTO" ==> {
                                          escolha = "C"
                                          println("CERTO (C)")
                                          break
                                    }
                                    clean_up == "E" or clean_up == "ERRADO" ==> {
                                          escolha = "E"
                                          println("ERRADO (E)")
                                          break
                                    }
                                    _ ==> {
                                          println("Entrada inválida. Por favor, tecle C para (C)erto ou E para (E)rrado.")
                                    }
                              }
                        }

                        #L Registra a avaliacao
                        eval_nome[ti] = nome
                        eval_st_leg[ti] = st_leg
                        eval_st_sh[ti] = st_sh
                        eval_escolha[ti] = escolha
                        eval_leg_lines[ti] = leg_lines
                        eval_sh_lines[ti] = sh_lines

                        ti = ti + 1
                  }
            }
      }

      #L 8. Geracao de relatorio compliance_IN00.md
      mut as int64: tot_c = 0
      mut as int64: tot_e = 0
      mut as int64: pos_c = 0
      mut as int64: pos_tot = 0
      mut as int64: err_c = 0
      mut as int64: err_tot = 0
      mut as int64: vi = 1
      infinite {
            route {
                  vi > n_flux ==> { break }
                  _ ==> {
                        mut as string: vn = "" + eval_nome[vi]
                        mut as string: ve = "" + eval_escolha[vi]
                        mut as bool: is_err_item = false
                        route {
                              stdCollectionLength(vn) >= 14 ==> {
                                    route {
                                          vn[1..14] == "ExampleOfError" ==> {
                                                is_err_item = true
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        route {
                              ve == "C" ==> {
                                    tot_c = tot_c + 1
                                    route {
                                          is_err_item ==> { err_c = err_c + 1 }
                                          _           ==> { pos_c = pos_c + 1 }
                                    }
                              }
                              _ ==> {
                                    tot_e = tot_e + 1
                              }
                        }
                        route {
                              is_err_item ==> { err_tot = err_tot + 1 }
                              _           ==> { pos_tot = pos_tot + 1 }
                        }
                        vi = vi + 1
                  }
            }
      }

      stdIoWriteFile("compliance_IN00.md", "# Relatório de Conformidade Interativo (`legacy` vs `selfhosted`)\n\n- **Fonte Legacy**: `docs/legacy_in.txt` (`legacy/exemplos_in.py`)\n- **Fonte Selfhosted**: `docs/selfhosted_in.txt` (`bin/fluxc.exe` / `exemplos_in.py`)\n- **Baseline de Regressão**: `compliance_IN01.md`\n\n## 📊 Resumo da Avaliação do Usuário\n\n")

      stdIoAppendFile("compliance_IN00.md", "- **Total de Arquivos Avaliados**: `" + n_flux + "`\n")
      route {
            tot_c == n_flux ==> {
                  stdIoAppendFile("compliance_IN00.md", "- **Marcados como (C)erto**: 🟢 **`" + tot_c + "/" + n_flux + "`**\n")
            }
            _ ==> {
                  stdIoAppendFile("compliance_IN00.md", "- **Marcados como (C)erto**: 🔴 **`" + tot_c + "/" + n_flux + "`**\n")
            }
      }
      stdIoAppendFile("compliance_IN00.md", "- **Marcados como (E)rrado**: `" + tot_e + "/" + n_flux + "`\n")
      stdIoAppendFile("compliance_IN00.md", "- **Programas Regulares Certos**: `" + pos_c + "/" + pos_tot + "`\n")
      stdIoAppendFile("compliance_IN00.md", "- **Diagnósticos e Erros (`ExampleOfError_*`) Certos**: `" + err_c + "/" + err_tot + "`\n\n")

      stdIoAppendFile("compliance_IN00.md", "## 📋 Tabela de Conformidade (Atualizada pela Entrada `C`/`E`)\n\n| Arquivo | Status Legacy | Status Selfhosted | Avaliação (`C`/`E`) | Resultado |\n| :--- | :---: | :---: | :---: | :---: |\n")

      vi = 1
      infinite {
            route {
                  vi > n_flux ==> { break }
                  _ ==> {
                        mut as string: vn = "" + eval_nome[vi]
                        mut as string: vl = "" + eval_st_leg[vi]
                        mut as string: vs = "" + eval_st_sh[vi]
                        mut as string: ve = "" + eval_escolha[vi]
                        mut as string: vres = "❌ ERRADO"
                        route {
                              ve == "C" ==> { vres = "✅ CERTO" }
                              _ ==> {}
                        }
                        stdIoAppendFile("compliance_IN00.md", "| `" + vn + "` | `" + vl + "` | `" + vs + "` | **`" + ve + "`** | " + vres + " |\n")
                        vi = vi + 1
                  }
            }
      }

      #L Analise de regressao
      stdIoAppendFile("compliance_IN00.md", "\n## 🔍 Análise de Regressão (`compliance_IN00.md` vs `compliance_IN01.md`)\n\n")
      mut as list of data: reg_list = []
      mut as int64: n_reg = 0
      vi = 1
      infinite {
            route {
                  vi > n_flux ==> { break }
                  _ ==> {
                        mut as string: vn = "" + eval_nome[vi]
                        route {
                              vn in old_escolha ==> {
                                    mut as string: ant_esc = "" + old_escolha[vn]
                                    mut as string: ant_sh = "" + old_status_sh[vn]
                                    mut as string: cur_esc = "" + eval_escolha[vi]
                                    mut as string: cur_sh = "" + eval_st_sh[vi]
                                    mut as bool: regrediu = false
                                    route {
                                          ant_esc == "C" and cur_esc == "E" ==> { regrediu = true }
                                          ant_sh == "OK" and cur_sh != "OK" ==> { regrediu = true }
                                          _ ==> {}
                                    }
                                    route {
                                          regrediu ==> {
                                                n_reg = n_reg + 1
                                                reg_list[n_reg] = "| `" + vn + "` | `" + ant_sh + "` | `" + cur_sh + "` | **`" + ant_esc + "`** | **`" + cur_esc + "`** |"
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        vi = vi + 1
                  }
            }
      }

      route {
            stdCollectionLength(old_escolha) == 0 ==> {
                  stdIoAppendFile("compliance_IN00.md", "> ℹ️ **Nenhum baseline anterior (`compliance_IN01.md`) com registros para comparação.**\n")
            }
            n_reg == 0 ==> {
                  stdIoAppendFile("compliance_IN00.md", "> ✅ **Nenhuma regressão detectada em relação ao `compliance_IN01.md`!**\n")
            }
            _ ==> {
                  stdIoAppendFile("compliance_IN00.md", "> ⚠️ **`" + n_reg + "` regressão(ões) detectada(s) em relação ao `compliance_IN01.md`:**\n\n| Arquivo | Selfhosted Anterior (`IN01`) | Selfhosted Atual (`IN00`) | Avaliação Anterior | Avaliação Atual |\n| :--- | :---: | :---: | :---: | :---: |\n")
                  mut as int64: rgi = 1
                  infinite {
                        route {
                              rgi > n_reg ==> { break }
                              _ ==> {
                                    stdIoAppendFile("compliance_IN00.md", ("" + reg_list[rgi]) + "\n")
                                    rgi = rgi + 1
                              }
                        }
                  }
            }
      }

      #L Erros assinalados
      stdIoAppendFile("compliance_IN00.md", "\n## ❌ Erros Assinalados pelo Usuário (`E`)\n\n")
      route {
            tot_e == 0 ==> {
                  stdIoAppendFile("compliance_IN00.md", "> ✅ **Nenhum arquivo foi assinalado como `(E)rrado`.** Todos os testes foram validados como `(C)erto`.\n")
            }
            _ ==> {
                  vi = 1
                  infinite {
                        route {
                              vi > n_flux ==> { break }
                              _ ==> {
                                    route {
                                          eval_escolha[vi] == "E" ==> {
                                                mut as string: vn = "" + eval_nome[vi]
                                                mut as list of data: vl_l = eval_leg_lines[vi]
                                                mut as list of data: vs_l = eval_sh_lines[vi]
                                                stdIoAppendFile("compliance_IN00.md", "### ❌ `" + vn + "` (Marcado como `E` - Errado)\n\n| Linha | Saída Legacy (`docs/legacy_in.txt`) | Saída Selfhosted (`docs/selfhosted_in.txt`) |\n| :---: | :--- | :--- |\n")
                                                mut as int64: ml = stdCollectionLength(vl_l)
                                                route {
                                                      stdCollectionLength(vs_l) > ml ==> { ml = stdCollectionLength(vs_l) }
                                                      _ ==> {}
                                                }
                                                mut as int64: li = 1
                                                infinite {
                                                      route {
                                                            li > ml ==> { break }
                                                            _ ==> {
                                                                  mut as string: leg_c = "(vazio)"
                                                                  route {
                                                                        li <= stdCollectionLength(vl_l) ==> { leg_c = "" + vl_l[li] }
                                                                        _ ==> {}
                                                                  }
                                                                  mut as string: sh_c = "(vazio)"
                                                                  route {
                                                                        li <= stdCollectionLength(vs_l) ==> { sh_c = "" + vs_l[li] }
                                                                        _ ==> {}
                                                                  }
                                                                  stdIoAppendFile("compliance_IN00.md", "| " + li + " | `" + leg_c + "` | `" + sh_c + "` |\n")
                                                                  li = li + 1
                                                            }
                                                      }
                                                }
                                                stdIoAppendFile("compliance_IN00.md", "\n")
                                          }
                                          _ ==> {}
                                    }
                                    vi = vi + 1
                              }
                        }
                  }
            }
      }

      #L 9. Atualizacao de docs/selfhosted_in.txt se executada a suite completa
      route {
            filtro == "" and n_flux == 376 ==> {
                  stdIoWriteFile("docs\\selfhosted_in.txt", "")
                  mut as int64: s_ok = 0
                  mut as int64: s_fail = 0
                  vi = 1
                  infinite {
                        route {
                              vi > n_flux ==> { break }
                              _ ==> {
                                    mut as list of data: vs_l = eval_sh_lines[vi]
                                    mut as int64: nvs = stdCollectionLength(vs_l)
                                    mut as int64: si_k = 1
                                    infinite {
                                          route {
                                                si_k > nvs ==> { break }
                                                _ ==> {
                                                      stdIoAppendFile("docs\\selfhosted_in.txt", ("" + vs_l[si_k]) + "\n")
                                                      si_k = si_k + 1
                                                }
                                          }
                                    }
                                    route {
                                          eval_st_sh[vi] == "OK" ==> { s_ok = s_ok + 1 }
                                          _                      ==> { s_fail = s_fail + 1 }
                                    }
                                    vi = vi + 1
                              }
                        }
                  }
                  stdIoAppendFile("docs\\selfhosted_in.txt", "\n" + s_ok + " sucesso, " + s_fail + " falha(s)\n")
            }
            _ ==> {}
      }

      #L 10. Tabela final resumida no console
      println("")
      println("================================================================================")
      println("TABELA DE CONFORMIDADE ATUALIZADA (CONFORME ENTRADA C / E)")
      println("================================================================================")
      println("arquivo                                             |  legacy  | selfhosted | tecla |  resultado  ")
      println("--------------------------------------------------------------------------------")
      vi = 1
      infinite {
            route {
                  vi > n_flux ==> { break }
                  _ ==> {
                        mut as string: vn = "" + eval_nome[vi]
                        mut as string: vl = "" + eval_st_leg[vi]
                        mut as string: vs = "" + eval_st_sh[vi]
                        mut as string: ve = "" + eval_escolha[vi]
                        mut as int64: nmlen = stdCollectionLength(vn)
                        mut as string: nm_fmt = ""
                        route {
                              nmlen <= 50 ==> {
                                    nm_fmt = vn
                                    mut as int64: pn = 50 - nmlen
                                    mut as int64: pni = 1
                                    infinite {
                                          route {
                                                pni > pn ==> { break }
                                                _ ==> {
                                                      nm_fmt = nm_fmt + " "
                                                      pni = pni + 1
                                                }
                                          }
                                    }
                              }
                              _ ==> {
                                    nm_fmt = vn[1..47] + "..."
                              }
                        }
                        mut as string: badge = "✓ CERTO"
                        route {
                              ve == "E" ==> { badge = "✗ ERRADO" }
                              _ ==> {}
                        }
                        println(nm_fmt + "  |    " + vl + "    |     " + vs + "     |   " + ve + "   | " + badge)
                        vi = vi + 1
                  }
            }
      }
      println("--------------------------------------------------------------------------------")

      println("")
      println("================================================================================")
      println("RESUMO FINAL")
      println("================================================================================")
      println("  Total avaliados    : " + n_flux)
      println("  (C)erto            : " + tot_c + "/" + n_flux)
      println("  (E)rrado           : " + tot_e + "/" + n_flux)
      println("================================================================================")

      route {
            stdCollectionLength(old_escolha) == 0 ==> {
                  println("Rastreamento de regressão: Nenhum baseline anterior em compliance_IN01.md para comparação.")
            }
            n_reg == 0 ==> {
                  println("Rastreamento de regressão: ✅ Nenhuma regressão detectada em relação ao compliance_IN01.md!")
            }
            _ ==> {
                  println("ATENÇÃO: " + n_reg + " regressão(ões) detectada(s) em relação ao compliance_IN01.md:")
                  mut as int64: rgi = 1
                  infinite {
                        route {
                              rgi > n_reg ==> { break }
                              _ ==> {
                                    println("  " + reg_list[rgi])
                                    rgi = rgi + 1
                              }
                        }
                  }
            }
      }

      route {
            tot_e > 0 ==> {
                  println("\nERROS ASSINALADOS PELO USUÁRIO (E):")
                  vi = 1
                  infinite {
                        route {
                              vi > n_flux ==> { break }
                              _ ==> {
                                    route {
                                          eval_escolha[vi] == "E" ==> {
                                                mut as string: vn = "" + eval_nome[vi]
                                                println("\n>>> " + vn + " (Marcado como ERRADO - E)")
                                          }
                                          _ ==> {}
                                    }
                                    vi = vi + 1
                              }
                        }
                  }
            }
            _ ==> {
                  println("\nNenhum erro assinalado com (E) pelo usuário.")
            }
      }

      println("\nRelatório atualizado em: compliance_IN00.md")

      #L Limpeza final de arquivos temporarios
      stdIoDeleteFile("t_compliance_in.tmp")

      route {
            tot_e == 0 ==> { stdOsExit(0) }
            _           ==> { stdOsExit(1) }
      }
}
