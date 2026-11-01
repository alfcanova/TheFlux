#L ==============================================================================
#L TheFlux Compliance: Runner Unificado (Canon, NumericalRecipes, ScientificAlgorithms)
#L Arquivo: examples/compliance.flux
#L ==============================================================================

use RuntimeStdLib
use IoStdLib
use OsStdLib

program (ComplianceMaster) {
      #L 1. Parser de argumentos da linha de comando
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as bool: flag_ca = false
      mut as bool: flag_nr = false
      mut as bool: flag_sa = false
      mut as bool: flag_all = false
      mut as bool: flag_help = false
      mut as string: filtro_raw = ""
      mut as string: q = "\""

      mut as int64: ai = 1
      infinite {
            route {
                  ai > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[ai]
                        mut as bool: is_self = (a == "compliance.flux" or a == ".\\compliance.flux" or a == "./compliance.flux" or a == "examples\\compliance.flux" or a == "examples/compliance.flux" or a == ".\\examples\\compliance.flux" or a == "./examples/compliance.flux" or a == "compliance.exe" or a == ".\\compliance.exe" or a == "bin\\compliance.exe" or a == ".\\bin\\compliance.exe" or a == "--" or a == "run")
                        route {
                              is_self ==> {}
                              a == "--ca" ==> { flag_ca = true }
                              a == "--nr" ==> { flag_nr = true }
                              a == "--sa" ==> { flag_sa = true }
                              a == "--all" ==> { flag_all = true }
                              a == "--help" or a == "-h" ==> { flag_help = true }
                              a == "--filter" or a == "-f" ==> {
                                    ai = ai + 1
                                    route {
                                          ai <= n_args ==> {
                                                filtro_raw = "" + args[ai]
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {
                                    route {
                                          filtro_raw == "" ==> {
                                                filtro_raw = a
                                          }
                                          _ ==> {}
                                    }
                              }
                        }
                        ai = ai + 1
                  }
            }
      }

      #L 2. Verificacao de ajuda (--help) ou invocacao sem suite
      route {
            flag_help or (not flag_ca and not flag_nr and not flag_sa and not flag_all) ==> {
                  println("TheFlux Compliance Runner")
                  println("Uso: compliance [opções]")
                  println("")
                  println("Opções de Suíte:")
                  println("  --ca              Executa a suíte canônica (examples/Canon) -> compliance_CA00.md")
                  println("  --nr              Executa a suíte Numerical Recipes (examples/NumericalRecipes) -> compliance_NR00.md")
                  println("  --sa              Executa a suíte Scientific Algorithms (examples/ScientificAlgorithms) -> compliance_SA00.md")
                  println("  --all             Executa todas as 3 suítes na sequência (--ca, --nr, --sa)")
                  println("")
                  println("Opções Gerais:")
                  println("  --filter <termo>  Filtra os arquivos a serem testados por substring (case-insensitive)")
                  println("  --help, -h        Exibe esta mensagem de ajuda")
                  println("")
                  println("Exemplos:")
                  println("  compliance --ca --filter ExampleOfPrint.flux")
                  println("  compliance --nr --filter 01_preliminaries")
                  println("  compliance --sa --filter BoyerMoore")
                  println("  compliance --all")
                  stdOsExit(0)
            }
            _ ==> {}
      }

      #L 3. Normalizacao de flags de suite
      route {
            flag_all ==> {
                  flag_ca = true
                  flag_nr = true
                  flag_sa = true
            }
            _ ==> {}
      }

      #L 4. Conversao do filtro para minusculo
      mut as string: filtro_lower = ""
      mut as int64: flen = stdCollectionLength(filtro_raw)
      mut as int64: fi = 1
      infinite {
            route {
                  fi > flen ==> { break }
                  _ ==> {
                        mut as string: ch = filtro_raw[fi]
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
                        fi = fi + 1
                  }
            }
      }

      #L 5. Limpeza inicial de arquivos/pastas t_* e preparacao de ambiente
      #L Verificacao e limpeza nativa de arquivos nas pastas t_* (preservando .gitkeep)
      mut as list of data: cl_init_dirs = ["t_fvmbc", "t_llvm", "t_wasm", "t_wat"]
      mut as int64: cl_init_di = 1
      infinite {
            route {
                  cl_init_di > 4 ==> { break }
                  _ ==> {
                        mut as string: cl_init_cur_dir = "" + cl_init_dirs[cl_init_di]
                        route {
                              stdIoDirExists(cl_init_cur_dir) ==> {
                                    mut as list of data: cl_init_entries = stdIoListDir(cl_init_cur_dir)
                                    mut as int64: cl_init_n_entries = stdCollectionLength(cl_init_entries)
                                    mut as int64: cl_init_ei = 1
                                    infinite {
                                          route {
                                                cl_init_ei > cl_init_n_entries ==> { break }
                                                _ ==> {
                                                      mut as string: cl_init_fname = "" + cl_init_entries[cl_init_ei]
                                                      route {
                                                            cl_init_fname != ".gitkeep" ==> {
                                                                  mut as string: cl_init_fp = cl_init_cur_dir + "\\" + cl_init_fname
                                                                  route {
                                                                        stdIoFileExists(cl_init_fp) ==> {
                                                                              stdIoDeleteFile(cl_init_fp)
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      cl_init_ei = cl_init_ei + 1
                                                }
                                          }
                                    }
                              }
                              _ ==> {
                                    stdIoCreateDir(cl_init_cur_dir)
                              }
                        }
                        route {
                              stdIoFileExists(cl_init_cur_dir + "\\.gitkeep") ==> {}
                              _ ==> {
                                    stdIoWriteFile(cl_init_cur_dir + "\\.gitkeep", "")
                              }
                        }
                        cl_init_di = cl_init_di + 1
                  }
            }
      }
      mut as list of data: cl_init_root_tmps = ["t_stdin.tmp", "t_in.tmp", "t_vm.tmp", "t_vm_c.tmp", "t_vmr.tmp", "t_lv.tmp", "t_lv_c.tmp", "t_wat.tmp", "t_wat_c.tmp", "t_was.tmp", "t_was_c.tmp"]
      mut as int64: cl_init_ri = 1
      infinite {
            route {
                  cl_init_ri > 11 ==> { break }
                  _ ==> {
                        mut as string: cl_init_rtf = "" + cl_init_root_tmps[cl_init_ri]
                        route {
                              stdIoFileExists(cl_init_rtf) ==> {
                                    stdIoDeleteFile(cl_init_rtf)
                              }
                              _ ==> {}
                        }
                        cl_init_ri = cl_init_ri + 1
                  }
            }
      }
      stdIoWriteFile("t_stdin.tmp", "")
      stdIoWriteFile("t_fvmbc\\_input_interactive.txt", "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n")
      stdIoWriteFile("t_fvmbc\\_input_contract.txt", "andre\nluiz\n")

      #L 6. Localizacao dinamica do binario fluxc
      mut as string: fluxc_bin = ".\\bin\\fluxc.exe"
      route {
            stdIoFileExists(".\\bin\\fluxc.exe") ==> { fluxc_bin = ".\\bin\\fluxc.exe" }
            stdIoFileExists("bin\\fluxc.exe")    ==> { fluxc_bin = "bin\\fluxc.exe" }
            stdIoFileExists("fluxc.exe")        ==> { fluxc_bin = "fluxc.exe" }
            _                                    ==> { fluxc_bin = "fluxc" }
      }

      mut as int64: grand_falhas = 0
      mut as int64: grand_regressoes = 0

      #L ==========================================================================
      #L SUÍTE 1: CANON (--ca)
      #L ==========================================================================
      route {
            flag_ca ==> {
                  println("")
                  println("========================================================================")
                  println(">>> INICIANDO CONFORMIDADE: CANON (examples/Canon/)")
                  println("========================================================================")

                  mut as string: ca_md_00 = "examples\\compliance_CA00.md"
                  mut as string: ca_md_01 = "examples\\compliance_CA01.md"

                  #L 1.1 Backup de compliance_CA00.md -> compliance_CA01.md
                  route {
                        stdIoFileExists(ca_md_00) ==> {
                              mut as string: c00 = stdIoReadFile(ca_md_00)
                              stdIoWriteFile(ca_md_01, c00)
                              println("Baseline copiado: " + ca_md_00 + " -> " + ca_md_01)
                        }
                        _ ==> {}
                  }

                  #L 1.2 Leitura do baseline anterior
                  mut as string: old_ca_target = ca_md_01
                  route {
                        not stdIoFileExists(old_ca_target) ==> {
                              route {
                                    stdIoFileExists(ca_md_00) ==> { old_ca_target = ca_md_00 }
                                    _ ==> { old_ca_target = "" }
                              }
                        }
                        _ ==> {}
                  }

                  mut as map: old_ca_has = map{}
                  mut as map: old_ca_in = map{}
                  mut as map: old_ca_vm = map{}
                  mut as map: old_ca_vmr = map{}
                  mut as map: old_ca_lv = map{}
                  mut as map: old_ca_wat = map{}
                  mut as map: old_ca_was = map{}
                  mut as map: old_ca_all_ok = map{}

                  mut as bool: target_ready = false
                  route {
                        old_ca_target != "" ==> {
                              route {
                                    stdIoFileExists(old_ca_target) ==> { target_ready = true }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  route {
                        target_ready ==> {
                              mut as list of data: old_lines = stdIoReadLines(old_ca_target)
                              mut as int64: n_ol = stdCollectionLength(old_lines)
                              mut as int64: oli = 1
                              infinite {
                                    route {
                                          oli > n_ol ==> { break }
                                          _ ==> {
                                                mut as string: oln = "" + old_lines[oli]
                                                mut as int64: oln_len = stdCollectionLength(oln)
                                                mut as bool: is_pipe_row = false
                                                route {
                                                      oln_len >= 15 ==> {
                                                            route {
                                                                  oln[1] == "|" ==> { is_pipe_row = true }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                                route {
                                                      is_pipe_row ==> {
                                                            mut as int64: bar1 = 1
                                                            mut as int64: bar2 = 0
                                                            mut as int64: bi_k = 2
                                                            infinite {
                                                                  route {
                                                                        bi_k > oln_len ==> { break }
                                                                        oln[bi_k] == "|" ==> {
                                                                              bar2 = bi_k
                                                                              break
                                                                        }
                                                                        _ ==> { bi_k = bi_k + 1 }
                                                                  }
                                                            }
                                                            route {
                                                                  bar2 > bar1 + 1 ==> {
                                                                        mut as string: raw_fn = oln[(bar1 + 1)..(bar2 - 1)]
                                                                        mut as int64: rfn_len = stdCollectionLength(raw_fn)
                                                                        mut as int64: t_s = 1
                                                                        infinite {
                                                                              route {
                                                                                    t_s > rfn_len ==> { break }
                                                                                    raw_fn[t_s] != " " ==> { break }
                                                                                    _ ==> { t_s = t_s + 1 }
                                                                              }
                                                                        }
                                                                        mut as int64: t_e = rfn_len
                                                                        infinite {
                                                                              route {
                                                                                    t_e < t_s ==> { break }
                                                                                    raw_fn[t_e] != " " ==> { break }
                                                                                    _ ==> { t_e = t_e - 1 }
                                                                              }
                                                                        }
                                                                        route {
                                                                              t_e >= t_s ==> {
                                                                                    mut as string: o_name = raw_fn[t_s..t_e]
                                                                                    mut as int64: onlen = stdCollectionLength(o_name)
                                                                                    mut as bool: is_valid_flux = false
                                                                                    route {
                                                                                          onlen >= 5 ==> {
                                                                                                route {
                                                                                                      o_name[(onlen - 4)..onlen] == ".flux" ==> { is_valid_flux = true }
                                                                                                      _ ==> {}
                                                                                                }
                                                                                          }
                                                                                          _ ==> {}
                                                                                    }
                                                                                    route {
                                                                                          is_valid_flux ==> {
                                                                                                old_ca_has[o_name] = true
                                                                                                mut as list of data: bar_pos = [1, bar2]
                                                                                                mut as int64: n_bar = 2
                                                                                                mut as int64: b_k = bar2 + 1
                                                                                                infinite {
                                                                                                      route {
                                                                                                            b_k > oln_len ==> { break }
                                                                                                            oln[b_k] == "|" ==> {
                                                                                                                  n_bar = n_bar + 1
                                                                                                                  bar_pos[n_bar] = b_k
                                                                                                            }
                                                                                                            _ ==> {}
                                                                                                      }
                                                                                                      b_k = b_k + 1
                                                                                                }
                                                                                                route {
                                                                                                      n_bar >= 8 ==> {
                                                                                                            mut as string: c_in = oln[bar_pos[2]..bar_pos[3]]
                                                                                                            mut as string: c_vm = oln[bar_pos[3]..bar_pos[4]]
                                                                                                            mut as string: c_vmr = oln[bar_pos[4]..bar_pos[5]]
                                                                                                            mut as string: c_lv = oln[bar_pos[5]..bar_pos[6]]
                                                                                                            mut as string: c_wat = oln[bar_pos[6]..bar_pos[7]]
                                                                                                            mut as string: c_was = oln[bar_pos[7]..bar_pos[8]]
                                                                                                            mut as list of data: c_arr = [c_in, c_vm, c_vmr, c_lv, c_wat, c_was]
                                                                                                            mut as list of data: v_arr = [false, false, false, false, false, false]
                                                                                                            mut as int64: ai_c = 1
                                                                                                            infinite {
                                                                                                                  route {
                                                                                                                        ai_c > 6 ==> { break }
                                                                                                                        _ ==> {
                                                                                                                              mut as string: cs = "" + c_arr[ai_c]
                                                                                                                              mut as int64: cslen = stdCollectionLength(cs)
                                                                                                                              mut as int64: csk = 1
                                                                                                                              infinite {
                                                                                                                                    route {
                                                                                                                                          csk > cslen ==> { break }
                                                                                                                                          _ ==> {
                                                                                                                                                route {
                                                                                                                                                      cs[csk] == "✅" or cs[csk] == "✓" ==> {
                                                                                                                                                            v_arr[ai_c] = true
                                                                                                                                                            break
                                                                                                                                                      }
                                                                                                                                                      _ ==> { csk = csk + 1 }
                                                                                                                                                }
                                                                                                                                          }
                                                                                                                                    }
                                                                                                                              }
                                                                                                                              ai_c = ai_c + 1
                                                                                                                        }
                                                                                                                  }
                                                                                                            }
                                                                                                            old_ca_in[o_name] = v_arr[1]
                                                                                                            old_ca_vm[o_name] = v_arr[2]
                                                                                                            old_ca_vmr[o_name] = v_arr[3]
                                                                                                            old_ca_lv[o_name] = v_arr[4]
                                                                                                            old_ca_wat[o_name] = v_arr[5]
                                                                                                            old_ca_was[o_name] = v_arr[6]
                                                                                                            old_ca_all_ok[o_name] = (v_arr[1] and v_arr[2] and v_arr[3] and v_arr[4] and v_arr[5] and v_arr[6])
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
                                                oli = oli + 1
                                          }
                                    }
                              }
                        }
                        _ ==> {}
                  }

                  #L 1.3 Varredura da pasta examples/Canon/
                  mut as list of data: ca_entries = stdIoListDir("examples\\Canon")
                  mut as int64: n_ca_entries = stdCollectionLength(ca_entries)
                  mut as list of data: ca_pos_files = []
                  mut as list of data: ca_err_files = []
                  mut as int64: n_ca_pos = 0
                  mut as int64: n_ca_err = 0

                  mut as int64: cai = 1
                  infinite {
                        route {
                              cai > n_ca_entries ==> { break }
                              _ ==> {
                                    mut as string: ca_fname = "" + ca_entries[cai]
                                    mut as int64: ca_fnlen = stdCollectionLength(ca_fname)
                                    mut as bool: ca_is_flux = false
                                    route {
                                          ca_fnlen >= 5 ==> {
                                                route {
                                                      ca_fname[(ca_fnlen - 4)..ca_fnlen] == ".flux" ==> { ca_is_flux = true }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          ca_is_flux ==> {
                                                mut as string: ca_fn_lower = ""
                                                mut as int64: fki = 1
                                                infinite {
                                                      route {
                                                            fki > ca_fnlen ==> { break }
                                                            _ ==> {
                                                                  mut as string: ca_fc = ca_fname[fki]
                                                                  route {
                                                                        ca_fc == "A" ==> { ca_fc = "a" }
                                                                        ca_fc == "B" ==> { ca_fc = "b" }
                                                                        ca_fc == "C" ==> { ca_fc = "c" }
                                                                        ca_fc == "D" ==> { ca_fc = "d" }
                                                                        ca_fc == "E" ==> { ca_fc = "e" }
                                                                        ca_fc == "F" ==> { ca_fc = "f" }
                                                                        ca_fc == "G" ==> { ca_fc = "g" }
                                                                        ca_fc == "H" ==> { ca_fc = "h" }
                                                                        ca_fc == "I" ==> { ca_fc = "i" }
                                                                        ca_fc == "J" ==> { ca_fc = "j" }
                                                                        ca_fc == "K" ==> { ca_fc = "k" }
                                                                        ca_fc == "L" ==> { ca_fc = "l" }
                                                                        ca_fc == "M" ==> { ca_fc = "m" }
                                                                        ca_fc == "N" ==> { ca_fc = "n" }
                                                                        ca_fc == "O" ==> { ca_fc = "o" }
                                                                        ca_fc == "P" ==> { ca_fc = "p" }
                                                                        ca_fc == "Q" ==> { ca_fc = "q" }
                                                                        ca_fc == "R" ==> { ca_fc = "r" }
                                                                        ca_fc == "S" ==> { ca_fc = "s" }
                                                                        ca_fc == "T" ==> { ca_fc = "t" }
                                                                        ca_fc == "U" ==> { ca_fc = "u" }
                                                                        ca_fc == "V" ==> { ca_fc = "v" }
                                                                        ca_fc == "W" ==> { ca_fc = "w" }
                                                                        ca_fc == "X" ==> { ca_fc = "x" }
                                                                        ca_fc == "Y" ==> { ca_fc = "y" }
                                                                        ca_fc == "Z" ==> { ca_fc = "z" }
                                                                        _ ==> {}
                                                                  }
                                                                  ca_fn_lower = ca_fn_lower + ca_fc
                                                                  fki = fki + 1
                                                            }
                                                      }
                                                }

                                                mut as bool: match_filtro = true
                                                route {
                                                      filtro_lower != "" ==> {
                                                            match_filtro = false
                                                            mut as int64: qlen = stdCollectionLength(filtro_lower)
                                                            route {
                                                                  ca_fnlen >= qlen ==> {
                                                                        mut as int64: s_i = 1
                                                                        infinite {
                                                                              route {
                                                                                    s_i + qlen - 1 > ca_fnlen ==> { break }
                                                                                    ca_fn_lower[s_i..(s_i + qlen - 1)] == filtro_lower ==> {
                                                                                          match_filtro = true
                                                                                          break
                                                                                    }
                                                                                    _ ==> { s_i = s_i + 1 }
                                                                              }
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }

                                                route {
                                                      match_filtro ==> {
                                                            mut as bool: is_err = false
                                                            route {
                                                                  ca_fnlen >= 14 ==> {
                                                                        route {
                                                                              ca_fname[1..14] == "ExampleOfError" ==> { is_err = true }
                                                                              _ ==> {}
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                            route {
                                                                  is_err ==> {
                                                                        n_ca_err = n_ca_err + 1
                                                                        ca_err_files[n_ca_err] = ca_fname
                                                                  }
                                                                  _ ==> {
                                                                        n_ca_pos = n_ca_pos + 1
                                                                        ca_pos_files[n_ca_pos] = ca_fname
                                                                  }
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    cai = cai + 1
                              }
                        }
                  }

                  #L 1.4 Ordenacao alfabetica (A-Z)
                  mut as int64: s1_ca_pos_files = 1
                  infinite {
                        route {
                              s1_ca_pos_files >= n_ca_pos ==> { break }
                              _ ==> {
                                    mut as int64: s2_ca_pos_files = s1_ca_pos_files + 1
                                    infinite {
                                          route {
                                                s2_ca_pos_files > n_ca_pos ==> { break }
                                                _ ==> {
                                                      mut as string: astr = "" + ca_pos_files[s1_ca_pos_files]
                                                      mut as string: bstr = "" + ca_pos_files[s2_ca_pos_files]
                                                      route {
                                                            astr > bstr ==> {
                                                                  mut as data: tmp = ca_pos_files[s1_ca_pos_files]
                                                                  ca_pos_files[s1_ca_pos_files] = ca_pos_files[s2_ca_pos_files]
                                                                  ca_pos_files[s2_ca_pos_files] = tmp
                                                            }
                                                            _ ==> {}
                                                      }
                                                      s2_ca_pos_files = s2_ca_pos_files + 1
                                                }
                                          }
                                    }
                                    s1_ca_pos_files = s1_ca_pos_files + 1
                              }
                        }
                  }
                  mut as int64: s1_ca_err_files = 1
                  infinite {
                        route {
                              s1_ca_err_files >= n_ca_err ==> { break }
                              _ ==> {
                                    mut as int64: s2_ca_err_files = s1_ca_err_files + 1
                                    infinite {
                                          route {
                                                s2_ca_err_files > n_ca_err ==> { break }
                                                _ ==> {
                                                      mut as string: astr = "" + ca_err_files[s1_ca_err_files]
                                                      mut as string: bstr = "" + ca_err_files[s2_ca_err_files]
                                                      route {
                                                            astr > bstr ==> {
                                                                  mut as data: tmp = ca_err_files[s1_ca_err_files]
                                                                  ca_err_files[s1_ca_err_files] = ca_err_files[s2_ca_err_files]
                                                                  ca_err_files[s2_ca_err_files] = tmp
                                                            }
                                                            _ ==> {}
                                                      }
                                                      s2_ca_err_files = s2_ca_err_files + 1
                                                }
                                          }
                                    }
                                    s1_ca_err_files = s1_ca_err_files + 1
                              }
                        }
                  }

                  mut as int64: ca_total_files = n_ca_pos + n_ca_err
                  println("Canon: " + ca_total_files + " arquivo(s) selecionado(s) (" + n_ca_pos + " regulares, " + n_ca_err + " diagnósticos/erros).")
                  println("")
                  println("algoritmo                                                             in   vm  vmr llvm  wat wasm")
                  println("------------------------------------------------------------------------------------------------")
                  mut as map: ca_res_in = map{}
                  mut as map: ca_res_vm = map{}
                  mut as map: ca_res_vmr = map{}
                  mut as map: ca_res_lv = map{}
                  mut as map: ca_res_wat = map{}
                  mut as map: ca_res_was = map{}
                  mut as map: ca_res_all = map{}
                  mut as int64: ca_tot_in = 0
                  mut as int64: ca_tot_vm = 0
                  mut as int64: ca_tot_vmr = 0
                  mut as int64: ca_tot_lv = 0
                  mut as int64: ca_tot_wat = 0
                  mut as int64: ca_tot_was = 0
                  mut as int64: ca_tot_all_ok = 0
                  mut as int64: ca_pos_all_ok = 0
                  mut as int64: ca_err_all_ok = 0

                  mut as int64: ca_step = 1
                  infinite {
                        route {
                              ca_step > ca_total_files ==> { break }
                              _ ==> {
                                    mut as string: nome = ""
                                    mut as bool: is_err = false
                                    route {
                                          ca_step <= n_ca_pos ==> {
                                                nome = "" + ca_pos_files[ca_step]
                                                is_err = false
                                          }
                                          _ ==> {
                                                nome = "" + ca_err_files[ca_step - n_ca_pos]
                                                is_err = true
                                          }
                                    }

                                    mut as string: path = "examples\\Canon\\" + nome
                                    mut as int64: nlen = stdCollectionLength(nome)
                                    mut as string: stem = nome
                                    route {
                                          nlen > 5 ==> {
                                                route {
                                                      nome[(nlen - 4)..nlen] == ".flux" ==> {
                                                            stem = nome[1..(nlen - 5)]
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }

                                    mut as string: stdin_file = "t_stdin.tmp"
                                    route {
                                          nome == "ExampleOfInput.flux" ==> { stdin_file = "t_fvmbc\\_input_interactive.txt" }
                                          nome == "ExampleOfUseIoStdLib_IoInputContract.flux" ==> { stdin_file = "t_fvmbc\\_input_contract.txt" }
                                          _ ==> {}
                                    }

                                    route {
                                          nlen >= 8 ==> {
                                                mut as int64: di = 1
                                                infinite {
                                                      route {
                                                            di + 7 > nlen ==> { break }
                                                            nome[di..(di + 7)] == "DbStdLib" ==> {
                                                                  stdOsExec("cmd /c del /q /f dbs\\flux_*.db* dbs\\flux_*.kv dbs\\flux_*.unqlite dbs\\flux_*.duckdb dbs\\flux_*.kuzu dbs\\flux_*.obx 2>nul")
                                                                  break
                                                            }
                                                            _ ==> { di = di + 1 }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }

                                    mut as string: out_vm = "t_fvmbc\\" + stem
                                    mut as string: fvmbc_file = "t_fvmbc\\" + stem + ".fvmbc"
                                    mut as string: out_lv = "t_llvm\\" + stem
                                    mut as string: exe_file = "t_llvm\\" + stem + ".exe"
                                    mut as string: out_wat = "t_wat\\" + stem
                                    mut as string: wat_file = "t_wat\\" + stem + ".wat"
                                    mut as string: out_wasm = "t_wasm\\" + stem
                                    mut as string: wasm_file = "t_wasm\\" + stem + ".wasm"

                                    mut as string: cmd_in = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target in " + path + " < " + stdin_file + " > t_in.tmp 2>nul\""
                                    mut as int64: rc_in = stdOsExec(cmd_in)
                                    mut as string: cmd_vm_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vm " + path + " -o " + out_vm + " --no-run < " + stdin_file + " > t_vm_c.tmp 2>nul\""
                                    mut as int64: rc_vm_c = stdOsExec(cmd_vm_c)
                                    mut as string: cmd_vm = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vmr " + fvmbc_file + " < " + stdin_file + " > t_vm.tmp 2>nul\""
                                    mut as int64: rc_vm = stdOsExec(cmd_vm)
                                    mut as string: cmd_vmr = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vmr " + fvmbc_file + " < " + stdin_file + " > t_vmr.tmp 2>nul\""
                                    mut as int64: rc_vmr = stdOsExec(cmd_vmr)
                                    mut as string: cmd_lv_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target lv " + path + " -o " + out_lv + " --no-run < " + stdin_file + " > t_lv_c.tmp 2>nul\""
                                    mut as int64: rc_lv_c = stdOsExec(cmd_lv_c)
                                    mut as string: cmd_lv = "cmd /c \"set FLUX_CI=1 && " + exe_file + " < " + stdin_file + " > t_lv.tmp 2>nul\""
                                    mut as int64: rc_lv = stdOsExec(cmd_lv)
                                    mut as string: cmd_wat_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target wat " + path + " -o " + out_wat + " --no-run < " + stdin_file + " > t_wat_c.tmp 2>nul\""
                                    mut as int64: rc_wat_c = stdOsExec(cmd_wat_c)
                                    mut as string: cmd_wat = "cmd /c \"set FLUX_CI=1 && wasmer run " + wat_file + " < " + stdin_file + " > t_wat.tmp 2>nul\""
                                    mut as int64: rc_wat = stdOsExec(cmd_wat)
                                    mut as string: cmd_was_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target wasm " + path + " -o " + out_wasm + " --no-run < " + stdin_file + " > t_was_c.tmp 2>nul\""
                                    mut as int64: rc_was_c = stdOsExec(cmd_was_c)
                                    mut as string: cmd_was = "cmd /c \"set FLUX_CI=1 && wasmer run " + wasm_file + " < " + stdin_file + " > t_was.tmp 2>nul\""
                                    mut as int64: rc_was = stdOsExec(cmd_was)

                                    mut as bool: ok_in = false
                                    mut as bool: ok_vm = false
                                    mut as bool: ok_vmr = false
                                    mut as bool: ok_lv = false
                                    mut as bool: ok_wat = false
                                    mut as bool: ok_was = false
                                    route {
                                          is_err ==> {
                                                ok_in = (rc_in != 0)
                                                ok_vm = (rc_vm_c != 0 or rc_vm != 0)
                                                ok_vmr = (rc_vm_c != 0 or rc_vmr != 0)
                                                ok_lv = (rc_lv_c != 0 or rc_lv != 0)
                                                ok_wat = (rc_wat_c != 0 or rc_wat != 0)
                                                ok_was = (rc_was_c != 0 or rc_was != 0)
                                          }
                                          _ ==> {
                                                mut as string: s_in = ""
                                                mut as string: s_vm = ""
                                                mut as string: s_vmr = ""
                                                mut as string: s_lv = ""
                                                mut as string: s_wat = ""
                                                mut as string: s_was = ""
                                                route { stdIoFileExists("t_in.tmp") ==> { s_in = stdIoReadFile("t_in.tmp") } _ ==> {} }
                                                route { stdIoFileExists("t_vm.tmp") ==> { s_vm = stdIoReadFile("t_vm.tmp") } _ ==> {} }
                                                route { stdIoFileExists("t_vmr.tmp") ==> { s_vmr = stdIoReadFile("t_vmr.tmp") } _ ==> {} }
                                                route { stdIoFileExists("t_lv.tmp") ==> { s_lv = stdIoReadFile("t_lv.tmp") } _ ==> {} }
                                                route { stdIoFileExists("t_wat.tmp") ==> { s_wat = stdIoReadFile("t_wat.tmp") } _ ==> {} }
                                                route { stdIoFileExists("t_was.tmp") ==> { s_was = stdIoReadFile("t_was.tmp") } _ ==> {} }
                                                ok_in = (rc_in == 0)
                                                ok_vm = (rc_vm_c == 0 and rc_vm == 0)
                                                ok_vmr = (rc_vm_c == 0 and rc_vmr == 0)
                                                ok_lv = (rc_lv_c == 0 and rc_lv == 0)
                                                ok_wat = (rc_wat_c == 0 and rc_wat == 0)
                                                ok_was = (rc_was_c == 0 and rc_was == 0)
                                          }
                                    }

                                    ca_res_in[nome] = ok_in
                                    ca_res_vm[nome] = ok_vm
                                    ca_res_vmr[nome] = ok_vmr
                                    ca_res_lv[nome] = ok_lv
                                    ca_res_wat[nome] = ok_wat
                                    ca_res_was[nome] = ok_was
                                    mut as bool: all_ok = (ok_in and ok_vm and ok_vmr and ok_lv and ok_wat and ok_was)
                                    ca_res_all[nome] = all_ok

                                    route { ok_in ==> { ca_tot_in = ca_tot_in + 1 } _ ==> {} }
                                    route { ok_vm ==> { ca_tot_vm = ca_tot_vm + 1 } _ ==> {} }
                                    route { ok_vmr ==> { ca_tot_vmr = ca_tot_vmr + 1 } _ ==> {} }
                                    route { ok_lv ==> { ca_tot_lv = ca_tot_lv + 1 } _ ==> {} }
                                    route { ok_wat ==> { ca_tot_wat = ca_tot_wat + 1 } _ ==> {} }
                                    route { ok_was ==> { ca_tot_was = ca_tot_was + 1 } _ ==> {} }
                                    route {
                                          all_ok ==> {
                                                ca_tot_all_ok = ca_tot_all_ok + 1
                                                route { is_err ==> { ca_err_all_ok = ca_err_all_ok + 1 } _ ==> { ca_pos_all_ok = ca_pos_all_ok + 1 } }
                                          }
                                          _ ==> { grand_falhas = grand_falhas + 1 }
                                    }

                                    mut as string: ic_in = "✗"
                                    mut as string: ic_vm = "✗"
                                    mut as string: ic_vmr = "✗"
                                    mut as string: ic_lv = "✗"
                                    mut as string: ic_wat = "✗"
                                    mut as string: ic_was = "✗"
                                    route { ok_in ==> { ic_in = "✓" } _ ==> {} }
                                    route { ok_vm ==> { ic_vm = "✓" } _ ==> {} }
                                    route { ok_vmr ==> { ic_vmr = "✓" } _ ==> {} }
                                    route { ok_lv ==> { ic_lv = "✓" } _ ==> {} }
                                    route { ok_wat ==> { ic_wat = "✓" } _ ==> {} }
                                    route { ok_was ==> { ic_was = "✓" } _ ==> {} }

                                    mut as string: p_name = nome
                                    mut as int64: pn_len = stdCollectionLength(p_name)
                                    infinite {
                                          route {
                                                pn_len >= 67 ==> { break }
                                                _ ==> {
                                                      p_name = p_name + " "
                                                      pn_len = pn_len + 1
                                                }
                                          }
                                    }
                                    println(p_name + "   " + ic_in + "   " + ic_vm + "   " + ic_vmr + "    " + ic_lv + "    " + ic_wat + "   " + ic_was)

                                    ca_step = ca_step + 1
                              }
                        }
                  }

                  println("------------------------------------------------------------------------------------------------")
                  println("Canon: " + ca_tot_all_ok + "/" + ca_total_files + " arquivo(s) com todos os 6 backends OK")
                  route { ca_total_files > 0 ==> {
                        println("  - Positivos: " + ca_pos_all_ok + "/" + n_ca_pos + " OK")
                        println("  - Diagnósticos & erros: " + ca_err_all_ok + "/" + n_ca_err + " OK")
                        println("  in: " + ca_tot_in + "/" + ca_total_files + " OK")
                        println("  vm: " + ca_tot_vm + "/" + ca_total_files + " OK")
                        println("  vmr: " + ca_tot_vmr + "/" + ca_total_files + " OK")
                        println("  llvm: " + ca_tot_lv + "/" + ca_total_files + " OK")
                        println("  wat: " + ca_tot_wat + "/" + ca_total_files + " OK")
                        println("  wasm: " + ca_tot_was + "/" + ca_total_files + " OK")
                  } _ ==> {} }

                  mut as list of data: ca_reg_files = []
                  mut as int64: n_ca_reg = 0
                  mut as int64: ca_ri = 1
                  infinite {
                        route {
                              ca_ri > ca_total_files ==> { break }
                              _ ==> {
                                    mut as string: rfn = ""
                                    route { ca_ri <= n_ca_pos ==> { rfn = "" + ca_pos_files[ca_ri] } _ ==> { rfn = "" + ca_err_files[ca_ri - n_ca_pos] } }
                                    mut as bool: had_old = (old_ca_has[rfn] == true)
                                    route {
                                          had_old ==> {
                                                mut as bool: o_in = (old_ca_in[rfn] == true)
                                                mut as bool: o_vm = (old_ca_vm[rfn] == true)
                                                mut as bool: o_vmr = (old_ca_vmr[rfn] == true)
                                                mut as bool: o_lv = (old_ca_lv[rfn] == true)
                                                mut as bool: o_wat = (old_ca_wat[rfn] == true)
                                                mut as bool: o_was = (old_ca_was[rfn] == true)
                                                mut as bool: n_in = (ca_res_in[rfn] == true)
                                                mut as bool: n_vm = (ca_res_vm[rfn] == true)
                                                mut as bool: n_vmr = (ca_res_vmr[rfn] == true)
                                                mut as bool: n_lv = (ca_res_lv[rfn] == true)
                                                mut as bool: n_wat = (ca_res_wat[rfn] == true)
                                                mut as bool: n_was = (ca_res_was[rfn] == true)
                                                mut as bool: reg = ((o_in and not n_in) or (o_vm and not n_vm) or (o_vmr and not n_vmr) or (o_lv and not n_lv) or (o_wat and not n_wat) or (o_was and not n_was))
                                                route {
                                                      reg ==> {
                                                            n_ca_reg = n_ca_reg + 1
                                                            ca_reg_files[n_ca_reg] = rfn
                                                            grand_regressoes = grand_regressoes + 1
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    ca_ri = ca_ri + 1
                              }
                        }
                  }

                  route {
                        n_ca_reg > 0 ==> {
                              println("")
                              println("⚠️  ATENÇÃO: " + n_ca_reg + " regressão(ões) detectada(s) em Canon!")
                              mut as int64: rli = 1
                              infinite {
                                    route {
                                          rli > n_ca_reg ==> { break }
                                          _ ==> {
                                                println("  ❌ " + ca_reg_files[rli])
                                                rli = rli + 1
                                          }
                                    }
                              }
                        }
                        _ ==> { println("Rastreamento de regressão Canon: ✅ Nenhuma regressão detectada!") }
                  }

                  #L 1.9 Gravacao fiel do relatorio compliance_CA00.md
                  mut as string: ca_md_hdr = "| arquivo                                                             |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |\n| ------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |\n"
                  stdIoWriteFile(ca_md_00, "## 📦 Programas Regulares de Execução\n\n")
                  mut as int64: p_idx = 1
                  mut as int64: cur_p_count = 0
                  mut as int64: p_num = 1
                  infinite {
                        route {
                              p_idx > n_ca_pos ==> { break }
                              _ ==> {
                                    route {
                                          cur_p_count == 0 ==> {
                                                stdIoAppendFile(ca_md_00, "### Tabela de conformidade — página " + p_num + "\n\n")
                                                stdIoAppendFile(ca_md_00, ca_md_hdr)
                                          }
                                          _ ==> {}
                                    }
                                    mut as string: pfn = "" + ca_pos_files[p_idx]
                                    mut as string: pfn_fmt = pfn
                                    mut as int64: pfn_len = stdCollectionLength(pfn_fmt)
                                    infinite {
                                          route {
                                                pfn_len >= 67 ==> { break }
                                                _ ==> {
                                                      pfn_fmt = pfn_fmt + " "
                                                      pfn_len = pfn_len + 1
                                                }
                                          }
                                    }
                                    mut as string: ca_in_s = "  ❌  "
                                    mut as string: ca_vm_s = "  ❌  "
                                    mut as string: ca_vmr_s = "  ❌  "
                                    mut as string: ca_lv_s = "  ❌  "
                                    mut as string: ca_wat_s = "  ❌  "
                                    mut as string: ca_was_s = "  ❌  "
                                    mut as string: ca_res_s = "   ❌   "
                                    route { ca_res_in[pfn] == true ==> { ca_in_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_vm[pfn] == true ==> { ca_vm_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_vmr[pfn] == true ==> { ca_vmr_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_lv[pfn] == true ==> { ca_lv_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_wat[pfn] == true ==> { ca_wat_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_was[pfn] == true ==> { ca_was_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_all[pfn] == true ==> { ca_res_s = "   ✅   " } _ ==> {} }
                                    stdIoAppendFile(ca_md_00, "| " + pfn_fmt + " |" + ca_in_s + "|" + ca_vm_s + "|" + ca_vmr_s + "|" + ca_lv_s + "|" + ca_wat_s + "|" + ca_was_s + "|" + ca_res_s + "|\n")
                                    cur_p_count = cur_p_count + 1
                                    route {
                                          cur_p_count >= 10 ==> {
                                                stdIoAppendFile(ca_md_00, "\n")
                                                cur_p_count = 0
                                                p_num = p_num + 1
                                          }
                                          _ ==> {}
                                    }
                                    p_idx = p_idx + 1
                              }
                        }
                  }
                  route { cur_p_count > 0 ==> { stdIoAppendFile(ca_md_00, "\n") } _ ==> {} }

                  stdIoAppendFile(ca_md_00, "## 🧪 Tabela de Conformidade — Testes de Diagnósticos e Erros (Negativos)\n\n")
                  stdIoAppendFile(ca_md_00, "> Testes de validação de diagnósticos estáticos canônicos e operações matemáticas de erro em runtime.\n\n")
                  stdIoAppendFile(ca_md_00, ca_md_hdr)
                  mut as int64: e_idx = 1
                  infinite {
                        route {
                              e_idx > n_ca_err ==> { break }
                              _ ==> {
                                    mut as string: efn = "" + ca_err_files[e_idx]
                                    mut as string: efn_fmt = efn
                                    mut as int64: efn_len = stdCollectionLength(efn_fmt)
                                    infinite {
                                          route {
                                                efn_len >= 67 ==> { break }
                                                _ ==> {
                                                      efn_fmt = efn_fmt + " "
                                                      efn_len = efn_len + 1
                                                }
                                          }
                                    }
                                    mut as string: e_in_s = "  ❌  "
                                    mut as string: e_vm_s = "  ❌  "
                                    mut as string: e_vmr_s = "  ❌  "
                                    mut as string: e_lv_s = "  ❌  "
                                    mut as string: e_wat_s = "  ❌  "
                                    mut as string: e_was_s = "  ❌  "
                                    mut as string: e_res_s = "   ❌   "
                                    route { ca_res_in[efn] == true ==> { e_in_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_vm[efn] == true ==> { e_vm_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_vmr[efn] == true ==> { e_vmr_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_lv[efn] == true ==> { e_lv_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_wat[efn] == true ==> { e_wat_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_was[efn] == true ==> { e_was_s = "  ✅  " } _ ==> {} }
                                    route { ca_res_all[efn] == true ==> { e_res_s = "   ✅   " } _ ==> {} }
                                    stdIoAppendFile(ca_md_00, "| " + efn_fmt + " |" + e_in_s + "|" + e_vm_s + "|" + e_vmr_s + "|" + e_lv_s + "|" + e_wat_s + "|" + e_was_s + "|" + e_res_s + "|\n")
                                    e_idx = e_idx + 1
                              }
                        }
                  }
                  stdIoAppendFile(ca_md_00, "\n")

                  stdIoAppendFile(ca_md_00, "### Resumo de Conformidade:\n\n")
                  stdIoAppendFile(ca_md_00, "-    POSITIVOS : ✅  " + ca_pos_all_ok + " of  " + n_ca_pos + " — ✅\n")
                  stdIoAppendFile(ca_md_00, "-  DIAGNÓSTICO : ✅   " + ca_err_all_ok + " of   " + n_ca_err + " — ✅\n")
                  stdIoAppendFile(ca_md_00, "-           IN : ✅  " + ca_tot_in + " of  " + ca_total_files + " — ✅\n")
                  stdIoAppendFile(ca_md_00, "-           VM : ✅  " + ca_tot_vm + " of  " + ca_total_files + " — ✅\n")
                  stdIoAppendFile(ca_md_00, "-          VMR : ✅  " + ca_tot_vmr + " of  " + ca_total_files + " — ✅\n")
                  stdIoAppendFile(ca_md_00, "-         LLVM : ✅  " + ca_tot_lv + " of  " + ca_total_files + " — ✅\n")
                  stdIoAppendFile(ca_md_00, "-          WAT : ✅  " + ca_tot_wat + " of  " + ca_total_files + " — ✅\n")
                  stdIoAppendFile(ca_md_00, "-         WASM : ✅  " + ca_tot_was + " of  " + ca_total_files + " — ✅\n")
                  mut as int64: ca_total_checks = ca_total_files * 6
                  mut as int64: ca_all_checks_ok = ca_tot_in + ca_tot_vm + ca_tot_vmr + ca_tot_lv + ca_tot_wat + ca_tot_was
                  stdIoAppendFile(ca_md_00, "-  TOTAL GERAL : ✅ " + ca_all_checks_ok + " of " + ca_total_checks + " — ✅\n\n")
                  stdIoAppendFile(ca_md_00, "### Regressão:\n\n")
                  route {
                        n_ca_reg > 0 ==> {
                              stdIoAppendFile(ca_md_00, ca_md_hdr)
                              mut as int64: cri = 1
                              infinite {
                                    route {
                                          cri > n_ca_reg ==> { break }
                                          _ ==> {
                                                mut as string: reg_fn = "" + ca_reg_files[cri]
                                                mut as string: r_fmt = reg_fn
                                                mut as int64: r_len = stdCollectionLength(r_fmt)
                                                infinite {
                                                      route {
                                                            r_len >= 67 ==> { break }
                                                            _ ==> {
                                                                  r_fmt = r_fmt + " "
                                                                  r_len = r_len + 1
                                                            }
                                                      }
                                                }
                                                mut as string: r_in = "  ❌  "
                                                mut as string: r_vm = "  ❌  "
                                                mut as string: r_vmr = "  ❌  "
                                                mut as string: r_lv = "  ❌  "
                                                mut as string: r_wat = "  ❌  "
                                                mut as string: r_was = "  ❌  "
                                                route { ca_res_in[reg_fn] == true ==> { r_in = "  ✅  " } _ ==> {} }
                                                route { ca_res_vm[reg_fn] == true ==> { r_vm = "  ✅  " } _ ==> {} }
                                                route { ca_res_vmr[reg_fn] == true ==> { r_vmr = "  ✅  " } _ ==> {} }
                                                route { ca_res_lv[reg_fn] == true ==> { r_lv = "  ✅  " } _ ==> {} }
                                                route { ca_res_wat[reg_fn] == true ==> { r_wat = "  ✅  " } _ ==> {} }
                                                route { ca_res_was[reg_fn] == true ==> { r_was = "  ✅  " } _ ==> {} }
                                                stdIoAppendFile(ca_md_00, "| " + r_fmt + " |" + r_in + "|" + r_vm + "|" + r_vmr + "|" + r_lv + "|" + r_wat + "|" + r_was + "|   ❌   |\n")
                                                cri = cri + 1
                                          }
                                    }
                              }
                        }
                        _ ==> { stdIoAppendFile(ca_md_00, "Nenhuma regressão detectada.\n") }
                  }
                  println("📄 Tabela de conformidade atualizada em: " + ca_md_00)
            }
            _ ==> {}
      }

      #L ==========================================================================
      #L SUÍTE 2: NUMERICAL RECIPES (--nr)
      #L ==========================================================================
      route {
            flag_nr ==> {
                  println("")
                  println("========================================================================")
                  println(">>> INICIANDO CONFORMIDADE: NUMERICAL RECIPES (examples/NumericalRecipes/)")
                  println("========================================================================")

                  mut as string: nr_md_00 = "examples\\compliance_NR00.md"
                  mut as string: nr_md_01 = "examples\\compliance_NR01.md"

                  #L 2.1 Backup de compliance_NR00.md -> compliance_NR01.md
                  route {
                        stdIoFileExists(nr_md_00) ==> {
                              mut as string: c00 = stdIoReadFile(nr_md_00)
                              stdIoWriteFile(nr_md_01, c00)
                              println("Baseline copiado: " + nr_md_00 + " -> " + nr_md_01)
                        }
                        _ ==> {}
                  }

                  #L 2.2 Leitura do baseline anterior
                  mut as string: old_nr_target = nr_md_01
                  route {
                        not stdIoFileExists(old_nr_target) ==> {
                              route {
                                    stdIoFileExists(nr_md_00) ==> { old_nr_target = nr_md_00 }
                                    _ ==> { old_nr_target = "" }
                              }
                        }
                        _ ==> {}
                  }

                  mut as map: old_nr_has = map{}
                  mut as map: old_nr_in = map{}
                  mut as map: old_nr_vm = map{}
                  mut as map: old_nr_vmr = map{}
                  mut as map: old_nr_lv = map{}
                  mut as map: old_nr_wat = map{}
                  mut as map: old_nr_was = map{}
                  mut as map: old_nr_all_ok = map{}

                  mut as bool: target_ready = false
                  route {
                        old_nr_target != "" ==> {
                              route {
                                    stdIoFileExists(old_nr_target) ==> { target_ready = true }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  route {
                        target_ready ==> {
                              mut as list of data: old_lines = stdIoReadLines(old_nr_target)
                              mut as int64: n_ol = stdCollectionLength(old_lines)
                              mut as int64: oli = 1
                              infinite {
                                    route {
                                          oli > n_ol ==> { break }
                                          _ ==> {
                                                mut as string: oln = "" + old_lines[oli]
                                                mut as int64: oln_len = stdCollectionLength(oln)
                                                mut as bool: is_pipe_row = false
                                                route {
                                                      oln_len >= 15 ==> {
                                                            route {
                                                                  oln[1] == "|" ==> { is_pipe_row = true }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                                route {
                                                      is_pipe_row ==> {
                                                            mut as int64: bar1 = 1
                                                            mut as int64: bar2 = 0
                                                            mut as int64: bi_k = 2
                                                            infinite {
                                                                  route {
                                                                        bi_k > oln_len ==> { break }
                                                                        oln[bi_k] == "|" ==> {
                                                                              bar2 = bi_k
                                                                              break
                                                                        }
                                                                        _ ==> { bi_k = bi_k + 1 }
                                                                  }
                                                            }
                                                            route {
                                                                  bar2 > bar1 + 1 ==> {
                                                                        mut as string: raw_fn = oln[(bar1 + 1)..(bar2 - 1)]
                                                                        mut as int64: rfn_len = stdCollectionLength(raw_fn)
                                                                        mut as int64: t_s = 1
                                                                        infinite {
                                                                              route {
                                                                                    t_s > rfn_len ==> { break }
                                                                                    raw_fn[t_s] != " " ==> { break }
                                                                                    _ ==> { t_s = t_s + 1 }
                                                                              }
                                                                        }
                                                                        mut as int64: t_e = rfn_len
                                                                        infinite {
                                                                              route {
                                                                                    t_e < t_s ==> { break }
                                                                                    raw_fn[t_e] != " " ==> { break }
                                                                                    _ ==> { t_e = t_e - 1 }
                                                                              }
                                                                        }
                                                                        route {
                                                                              t_e >= t_s ==> {
                                                                                    mut as string: o_name = raw_fn[t_s..t_e]
                                                                                    mut as int64: onlen = stdCollectionLength(o_name)
                                                                                    mut as bool: is_valid_flux = false
                                                                                    route {
                                                                                          onlen >= 5 ==> {
                                                                                                route {
                                                                                                      o_name[(onlen - 4)..onlen] == ".flux" ==> { is_valid_flux = true }
                                                                                                      _ ==> {}
                                                                                                }
                                                                                          }
                                                                                          _ ==> {}
                                                                                    }
                                                                                    route {
                                                                                          is_valid_flux ==> {
                                                                                                old_nr_has[o_name] = true
                                                                                                mut as list of data: bar_pos = [1, bar2]
                                                                                                mut as int64: n_bar = 2
                                                                                                mut as int64: b_k = bar2 + 1
                                                                                                infinite {
                                                                                                      route {
                                                                                                            b_k > oln_len ==> { break }
                                                                                                            oln[b_k] == "|" ==> {
                                                                                                                  n_bar = n_bar + 1
                                                                                                                  bar_pos[n_bar] = b_k
                                                                                                            }
                                                                                                            _ ==> {}
                                                                                                      }
                                                                                                      b_k = b_k + 1
                                                                                                }
                                                                                                route {
                                                                                                      n_bar >= 8 ==> {
                                                                                                            mut as string: c_in = oln[bar_pos[2]..bar_pos[3]]
                                                                                                            mut as string: c_vm = oln[bar_pos[3]..bar_pos[4]]
                                                                                                            mut as string: c_vmr = oln[bar_pos[4]..bar_pos[5]]
                                                                                                            mut as string: c_lv = oln[bar_pos[5]..bar_pos[6]]
                                                                                                            mut as string: c_wat = oln[bar_pos[6]..bar_pos[7]]
                                                                                                            mut as string: c_was = oln[bar_pos[7]..bar_pos[8]]
                                                                                                            mut as list of data: c_arr = [c_in, c_vm, c_vmr, c_lv, c_wat, c_was]
                                                                                                            mut as list of data: v_arr = [false, false, false, false, false, false]
                                                                                                            mut as int64: ai_c = 1
                                                                                                            infinite {
                                                                                                                  route {
                                                                                                                        ai_c > 6 ==> { break }
                                                                                                                        _ ==> {
                                                                                                                              mut as string: cs = "" + c_arr[ai_c]
                                                                                                                              mut as int64: cslen = stdCollectionLength(cs)
                                                                                                                              mut as int64: csk = 1
                                                                                                                              infinite {
                                                                                                                                    route {
                                                                                                                                          csk > cslen ==> { break }
                                                                                                                                          _ ==> {
                                                                                                                                                route {
                                                                                                                                                      cs[csk] == "✅" or cs[csk] == "✓" ==> {
                                                                                                                                                            v_arr[ai_c] = true
                                                                                                                                                            break
                                                                                                                                                      }
                                                                                                                                                      _ ==> { csk = csk + 1 }
                                                                                                                                                }
                                                                                                                                          }
                                                                                                                                    }
                                                                                                                              }
                                                                                                                              ai_c = ai_c + 1
                                                                                                                        }
                                                                                                                  }
                                                                                                            }
                                                                                                            old_nr_in[o_name] = v_arr[1]
                                                                                                            old_nr_vm[o_name] = v_arr[2]
                                                                                                            old_nr_vmr[o_name] = v_arr[3]
                                                                                                            old_nr_lv[o_name] = v_arr[4]
                                                                                                            old_nr_wat[o_name] = v_arr[5]
                                                                                                            old_nr_was[o_name] = v_arr[6]
                                                                                                            old_nr_all_ok[o_name] = (v_arr[1] and v_arr[2] and v_arr[3] and v_arr[4] and v_arr[5] and v_arr[6])
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
                                                oli = oli + 1
                                          }
                                    }
                              }
                        }
                        _ ==> {}
                  }

                  #L 2.3 Catalogo dos 22 capitulos de Numerical Recipes
                  mut as list of data: nr_chap_dirs = [
                        "01_preliminaries",
                        "02_linear_algebra",
                        "03_interpolation",
                        "04_integration",
                        "05_function_evaluation",
                        "06_special_functions",
                        "07_random_numbers",
                        "08_sorting_selection",
                        "09_root_finding",
                        "10_minimization",
                        "11_eigensystems",
                        "12_fast_fourier_transform",
                        "13_fourier_spectral",
                        "14_statistical_description",
                        "15_modeling_data",
                        "16_classification_inference",
                        "17_differential_equations",
                        "18_boundary_value_problems",
                        "19_integral_equations",
                        "20_partial_differential_eqs",
                        "21_computational_geometry",
                        "22_less_numerical",
                  ]

                  mut as list of data: nr_chap_titles = [
                        "Capítulo 01: Preliminares, Precisão de Máquina & Análise de Erro (01_preliminaries)",
                        "Capítulo 02: Resolução de Sistemas de Equações Algébricas Lineares (02_linear_algebra)",
                        "Capítulo 03: Interpolação e Extrapolação (03_interpolation)",
                        "Capítulo 04: Integração Numérica de Funções (04_integration)",
                        "Capítulo 05: Avaliação de Funções, Séries e Frações Contínuas (05_function_evaluation)",
                        "Capítulo 06: Funções Especiais da Física Matemática (06_special_functions)",
                        "Capítulo 07: Geração de Números Aleatórios e Métodos de Monte Carlo (07_random_numbers)",
                        "Capítulo 08: Algoritmos de Ordenação e Seleção Estatística (08_sorting_selection)",
                        "Capítulo 09: Localização de Raízes e Sistemas de Equações Não-Lineares (09_root_finding)",
                        "Capítulo 10: Minimização e Maximização de Funções (10_minimization)",
                        "Capítulo 11: Sistemas de Autovalores e Autovetores (11_eigensystems)",
                        "Capítulo 12: Transformada Rápida de Fourier — FFT (12_fast_fourier_transform)",
                        "Capítulo 13: Aplicações Espectrais e Processamento de Sinais por Fourier (13_fourier_spectral)",
                        "Capítulo 14: Descrição Estatística de Dados (14_statistical_description)",
                        "Capítulo 15: Modelagem, Ajuste de Parâmetros e Teoria da Estimação (15_modeling_data)",
                        "Capítulo 16: Classificação, Agrupamento e Inferência Estatística (16_classification_inference)",
                        "Capítulo 17: Integração Numérica de EDOs (17_differential_equations)",
                        "Capítulo 18: Problemas de Valor de Contorno em Dois Pontos — BVPs (18_boundary_value_problems)",
                        "Capítulo 19: Equações Integrais e Teoria Inversa (19_integral_equations)",
                        "Capítulo 20: Resolução Numérica de EDPs (20_partial_differential_eqs)",
                        "Capítulo 21: Geometria Computacional (21_computational_geometry)",
                        "Capítulo 22: Algoritmos Discretos, Criptográficos e Menos Numéricos (22_less_numerical)",
                  ]

                  #L 2.4 Varredura dos arquivos de Numerical Recipes por capitulo
                  mut as list of data: nr_all_files = []
                  mut as list of data: nr_all_paths = []
                  mut as list of data: nr_all_chaps = []
                  mut as int64: nr_total_files = 0

                  mut as int64: nchi = 1
                  infinite {
                        route {
                              nchi > 22 ==> { break }
                              _ ==> {
                                    mut as string: cdir = "" + nr_chap_dirs[nchi]
                                    mut as string: full_cdir = "examples\\NumericalRecipes\\" + cdir
                                    mut as list of data: centries = stdIoListDir(full_cdir)
                                    mut as int64: n_centries = stdCollectionLength(centries)
                                    mut as list of data: ch_files = []
                                    mut as int64: n_ch_files = 0
                                    mut as int64: cei = 1
                                    infinite {
                                          route {
                                                cei > n_centries ==> { break }
                                                _ ==> {
                                                      mut as string: fname = "" + centries[cei]
                                                      mut as int64: fn_len = stdCollectionLength(fname)
                                                      mut as bool: is_flux = false
                                                      route {
                                                            fn_len >= 5 ==> {
                                                                  route {
                                                                        fname[(fn_len - 4)..fn_len] == ".flux" ==> { is_flux = true }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            is_flux ==> {
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

                                                                  mut as bool: aceito = true
                                                                  route {
                                                                        filtro_lower != "" ==> {
                                                                              aceito = false
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
                                                                              route {
                                                                                    not aceito ==> {
                                                                                          mut as int64: cdlen = stdCollectionLength(cdir)
                                                                                          route {
                                                                                                cdlen >= qlen ==> {
                                                                                                      mut as int64: cki = 1
                                                                                                      infinite {
                                                                                                            route {
                                                                                                                  cki + qlen - 1 > cdlen ==> { break }
                                                                                                                  cdir[cki..(cki + qlen - 1)] == filtro_lower ==> {
                                                                                                                        aceito = true
                                                                                                                        break
                                                                                                                  }
                                                                                                                  _ ==> { cki = cki + 1 }
                                                                                                            }
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
                                                                  route {
                                                                        aceito ==> {
                                                                              n_ch_files = n_ch_files + 1
                                                                              ch_files[n_ch_files] = fname
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      cei = cei + 1
                                                }
                                          }
                                    }

                                    mut as int64: s1 = 1
                                    infinite {
                                          route {
                                                s1 >= n_ch_files ==> { break }
                                                _ ==> {
                                                      mut as int64: s2 = s1 + 1
                                                      infinite {
                                                            route {
                                                                  s2 > n_ch_files ==> { break }
                                                                  _ ==> {
                                                                        mut as string: as_ = "" + ch_files[s1]
                                                                        mut as string: bs_ = "" + ch_files[s2]
                                                                        route {
                                                                              as_ > bs_ ==> {
                                                                                    mut as data: tmp = ch_files[s1]
                                                                                    ch_files[s1] = ch_files[s2]
                                                                                    ch_files[s2] = tmp
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                        s2 = s2 + 1
                                                                  }
                                                            }
                                                      }
                                                      s1 = s1 + 1
                                                }
                                          }
                                    }

                                    mut as int64: cfi = 1
                                    infinite {
                                          route {
                                                cfi > n_ch_files ==> { break }
                                                _ ==> {
                                                      nr_total_files = nr_total_files + 1
                                                      nr_all_files[nr_total_files] = ch_files[cfi]
                                                      nr_all_paths[nr_total_files] = full_cdir + "\\" + ch_files[cfi]
                                                      nr_all_chaps[nr_total_files] = nchi
                                                      cfi = cfi + 1
                                                }
                                          }
                                    }
                                    nchi = nchi + 1
                              }
                        }
                  }

                  println("Numerical Recipes: " + nr_total_files + " arquivo(s) selecionado(s).")
                  println("")
                  println("algoritmo                                                                    in   vm  vmr llvm  wat wasm")
                  println("--------------------------------------------------------------------------------------------------------")

                  mut as map: nr_res_in = map{}
                  mut as map: nr_res_vm = map{}
                  mut as map: nr_res_vmr = map{}
                  mut as map: nr_res_lv = map{}
                  mut as map: nr_res_wat = map{}
                  mut as map: nr_res_was = map{}
                  mut as map: nr_res_all = map{}
                  mut as int64: nr_tot_in = 0
                  mut as int64: nr_tot_vm = 0
                  mut as int64: nr_tot_vmr = 0
                  mut as int64: nr_tot_lv = 0
                  mut as int64: nr_tot_wat = 0
                  mut as int64: nr_tot_was = 0
                  mut as int64: nr_tot_all_ok = 0

                  mut as int64: nri = 1
                  infinite {
                        route {
                              nri > nr_total_files ==> { break }
                              _ ==> {
                                    mut as string: nome = "" + nr_all_files[nri]
                                    mut as string: path = "" + nr_all_paths[nri]
                                    mut as int64: nlen = stdCollectionLength(nome)
                                    mut as string: stem = nome
                                    route {
                                          nlen > 5 ==> {
                                                route {
                                                      nome[(nlen - 4)..nlen] == ".flux" ==> {
                                                            stem = nome[1..(nlen - 5)]
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }

                                    mut as string: out_vm = "t_fvmbc\\" + stem
                                    mut as string: fvmbc_file = "t_fvmbc\\" + stem + ".fvmbc"
                                    mut as string: out_lv = "t_llvm\\" + stem
                                    mut as string: exe_file = "t_llvm\\" + stem + ".exe"
                                    mut as string: out_wat = "t_wat\\" + stem
                                    mut as string: wat_file = "t_wat\\" + stem + ".wat"
                                    mut as string: out_wasm = "t_wasm\\" + stem
                                    mut as string: wasm_file = "t_wasm\\" + stem + ".wasm"

                                    mut as string: cmd_in = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target in " + path + " < " + "t_stdin.tmp" + " > t_in.tmp 2>nul\""
                                    mut as int64: rc_in = stdOsExec(cmd_in)
                                    mut as string: cmd_vm_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vm " + path + " -o " + out_vm + " --no-run < " + "t_stdin.tmp" + " > t_vm_c.tmp 2>nul\""
                                    mut as int64: rc_vm_c = stdOsExec(cmd_vm_c)
                                    mut as string: cmd_vm = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vmr " + fvmbc_file + " < " + "t_stdin.tmp" + " > t_vm.tmp 2>nul\""
                                    mut as int64: rc_vm = stdOsExec(cmd_vm)
                                    mut as string: cmd_vmr = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vmr " + fvmbc_file + " < " + "t_stdin.tmp" + " > t_vmr.tmp 2>nul\""
                                    mut as int64: rc_vmr = stdOsExec(cmd_vmr)
                                    mut as string: cmd_lv_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target lv " + path + " -o " + out_lv + " --no-run < " + "t_stdin.tmp" + " > t_lv_c.tmp 2>nul\""
                                    mut as int64: rc_lv_c = stdOsExec(cmd_lv_c)
                                    mut as string: cmd_lv = "cmd /c \"set FLUX_CI=1 && " + exe_file + " < " + "t_stdin.tmp" + " > t_lv.tmp 2>nul\""
                                    mut as int64: rc_lv = stdOsExec(cmd_lv)
                                    mut as string: cmd_wat_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target wat " + path + " -o " + out_wat + " --no-run < " + "t_stdin.tmp" + " > t_wat_c.tmp 2>nul\""
                                    mut as int64: rc_wat_c = stdOsExec(cmd_wat_c)
                                    mut as string: cmd_wat = "cmd /c \"set FLUX_CI=1 && wasmer run " + wat_file + " < " + "t_stdin.tmp" + " > t_wat.tmp 2>nul\""
                                    mut as int64: rc_wat = stdOsExec(cmd_wat)
                                    mut as string: cmd_was_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target wasm " + path + " -o " + out_wasm + " --no-run < " + "t_stdin.tmp" + " > t_was_c.tmp 2>nul\""
                                    mut as int64: rc_was_c = stdOsExec(cmd_was_c)
                                    mut as string: cmd_was = "cmd /c \"set FLUX_CI=1 && wasmer run " + wasm_file + " < " + "t_stdin.tmp" + " > t_was.tmp 2>nul\""
                                    mut as int64: rc_was = stdOsExec(cmd_was)

                                    mut as string: s_in = ""
                                    mut as string: s_vm = ""
                                    mut as string: s_vmr = ""
                                    mut as string: s_lv = ""
                                    mut as string: s_wat = ""
                                    mut as string: s_was = ""
                                    route { stdIoFileExists("t_in.tmp") ==> { s_in = stdIoReadFile("t_in.tmp") } _ ==> {} }
                                    route { stdIoFileExists("t_vm.tmp") ==> { s_vm = stdIoReadFile("t_vm.tmp") } _ ==> {} }
                                    route { stdIoFileExists("t_vmr.tmp") ==> { s_vmr = stdIoReadFile("t_vmr.tmp") } _ ==> {} }
                                    route { stdIoFileExists("t_lv.tmp") ==> { s_lv = stdIoReadFile("t_lv.tmp") } _ ==> {} }
                                    route { stdIoFileExists("t_wat.tmp") ==> { s_wat = stdIoReadFile("t_wat.tmp") } _ ==> {} }
                                    route { stdIoFileExists("t_was.tmp") ==> { s_was = stdIoReadFile("t_was.tmp") } _ ==> {} }
                                    mut as bool: ok_in = (rc_in == 0)
                                    mut as bool: ok_vm = (rc_vm_c == 0 and rc_vm == 0)
                                    mut as bool: ok_vmr = (rc_vm_c == 0 and rc_vmr == 0)
                                    mut as bool: ok_lv = (rc_lv_c == 0 and rc_lv == 0)
                                    mut as bool: ok_wat = (rc_wat_c == 0 and rc_wat == 0)
                                    mut as bool: ok_was = (rc_was_c == 0 and rc_was == 0)
                                    nr_res_in[nome] = ok_in
                                    nr_res_vm[nome] = ok_vm
                                    nr_res_vmr[nome] = ok_vmr
                                    nr_res_lv[nome] = ok_lv
                                    nr_res_wat[nome] = ok_wat
                                    nr_res_was[nome] = ok_was
                                    mut as bool: all_ok = (ok_in and ok_vm and ok_vmr and ok_lv and ok_wat and ok_was)
                                    nr_res_all[nome] = all_ok
                                    route { ok_in ==> { nr_tot_in = nr_tot_in + 1 } _ ==> {} }
                                    route { ok_vm ==> { nr_tot_vm = nr_tot_vm + 1 } _ ==> {} }
                                    route { ok_vmr ==> { nr_tot_vmr = nr_tot_vmr + 1 } _ ==> {} }
                                    route { ok_lv ==> { nr_tot_lv = nr_tot_lv + 1 } _ ==> {} }
                                    route { ok_wat ==> { nr_tot_wat = nr_tot_wat + 1 } _ ==> {} }
                                    route { ok_was ==> { nr_tot_was = nr_tot_was + 1 } _ ==> {} }
                                    route {
                                          all_ok ==> { nr_tot_all_ok = nr_tot_all_ok + 1 }
                                          _ ==> { grand_falhas = grand_falhas + 1 }
                                    }

                                    mut as string: ic_in = "✗"
                                    mut as string: ic_vm = "✗"
                                    mut as string: ic_vmr = "✗"
                                    mut as string: ic_lv = "✗"
                                    mut as string: ic_wat = "✗"
                                    mut as string: ic_was = "✗"
                                    route { ok_in ==> { ic_in = "✓" } _ ==> {} }
                                    route { ok_vm ==> { ic_vm = "✓" } _ ==> {} }
                                    route { ok_vmr ==> { ic_vmr = "✓" } _ ==> {} }
                                    route { ok_lv ==> { ic_lv = "✓" } _ ==> {} }
                                    route { ok_wat ==> { ic_wat = "✓" } _ ==> {} }
                                    route { ok_was ==> { ic_was = "✓" } _ ==> {} }
                                    mut as string: p_name = nome
                                    mut as int64: pn_len = stdCollectionLength(p_name)
                                    infinite {
                                          route {
                                                pn_len >= 77 ==> { break }
                                                _ ==> {
                                                      p_name = p_name + " "
                                                      pn_len = pn_len + 1
                                                }
                                          }
                                    }
                                    println(p_name + "   " + ic_in + "   " + ic_vm + "   " + ic_vmr + "    " + ic_lv + "    " + ic_wat + "   " + ic_was)
                                    nri = nri + 1
                              }
                        }
                  }

                  println("--------------------------------------------------------------------------------------------------------")
                  println("Numerical Recipes: " + nr_tot_all_ok + "/" + nr_total_files + " arquivo(s) com todos os 6 backends OK")
                  route { nr_total_files > 0 ==> {
                        println("  in: " + nr_tot_in + "/" + nr_total_files + " OK")
                        println("  vm: " + nr_tot_vm + "/" + nr_total_files + " OK")
                        println("  vmr: " + nr_tot_vmr + "/" + nr_total_files + " OK")
                        println("  llvm: " + nr_tot_lv + "/" + nr_total_files + " OK")
                        println("  wat: " + nr_tot_wat + "/" + nr_total_files + " OK")
                        println("  wasm: " + nr_tot_was + "/" + nr_total_files + " OK")
                  } _ ==> {} }

                  mut as list of data: nr_reg_files = []
                  mut as int64: n_nr_reg = 0
                  mut as int64: nr_ri = 1
                  infinite {
                        route {
                              nr_ri > nr_total_files ==> { break }
                              _ ==> {
                                    mut as string: rfn = "" + nr_all_files[nr_ri]
                                    mut as bool: had_old = (old_nr_has[rfn] == true)
                                    route {
                                          had_old ==> {
                                                mut as bool: o_in = (old_nr_in[rfn] == true)
                                                mut as bool: o_vm = (old_nr_vm[rfn] == true)
                                                mut as bool: o_vmr = (old_nr_vmr[rfn] == true)
                                                mut as bool: o_lv = (old_nr_lv[rfn] == true)
                                                mut as bool: o_wat = (old_nr_wat[rfn] == true)
                                                mut as bool: o_was = (old_nr_was[rfn] == true)
                                                mut as bool: n_in = (nr_res_in[rfn] == true)
                                                mut as bool: n_vm = (nr_res_vm[rfn] == true)
                                                mut as bool: n_vmr = (nr_res_vmr[rfn] == true)
                                                mut as bool: n_lv = (nr_res_lv[rfn] == true)
                                                mut as bool: n_wat = (nr_res_wat[rfn] == true)
                                                mut as bool: n_was = (nr_res_was[rfn] == true)
                                                mut as bool: reg = ((o_in and not n_in) or (o_vm and not n_vm) or (o_vmr and not n_vmr) or (o_lv and not n_lv) or (o_wat and not n_wat) or (o_was and not n_was))
                                                route {
                                                      reg ==> {
                                                            n_nr_reg = n_nr_reg + 1
                                                            nr_reg_files[n_nr_reg] = rfn
                                                            grand_regressoes = grand_regressoes + 1
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    nr_ri = nr_ri + 1
                              }
                        }
                  }

                  route {
                        n_nr_reg > 0 ==> {
                              println("")
                              println("⚠️  ATENÇÃO: " + n_nr_reg + " regressão(ões) detectada(s) em Numerical Recipes!")
                              mut as int64: rli = 1
                              infinite {
                                    route {
                                          rli > n_nr_reg ==> { break }
                                          _ ==> {
                                                println("  ❌ " + nr_reg_files[rli])
                                                rli = rli + 1
                                          }
                                    }
                              }
                        }
                        _ ==> { println("Rastreamento de regressão Numerical Recipes: ✅ Nenhuma regressão detectada!") }
                  }

                  #L 2.7 Gravacao de compliance_NR00.md
                  mut as string: nr_md_hdr = "| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |\n| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |\n"
                  stdIoWriteFile(nr_md_00, "# 📊 Tabela de Conformidade Multi-Backend: Numerical Recipes v3\n\n")
                  stdIoAppendFile(nr_md_00, "> **Suíte**: `examples/NumericalRecipes/` (22 capítulos clássicos)\n")
                  stdIoAppendFile(nr_md_00, "> **Backends**: `in` (AST interpretado), `vm` (FVM Bytecode), `vmr` (FVM Reloaded), `llvm` (LLVM nativo), `wat` (WebAssembly Text), `wasm` (WebAssembly Binário)\n\n")

                  mut as int64: mci = 1
                  infinite {
                        route {
                              mci > 22 ==> { break }
                              _ ==> {
                                    mut as int64: count_ch = 0
                                    mut as int64: cchk = 1
                                    infinite {
                                          route {
                                                cchk > nr_total_files ==> { break }
                                                _ ==> {
                                                      route { nr_all_chaps[cchk] == mci ==> { count_ch = count_ch + 1 } _ ==> {} }
                                                      cchk = cchk + 1
                                                }
                                          }
                                    }
                                    route {
                                          count_ch > 0 ==> {
                                                mut as string: m_ctitle = "" + nr_chap_titles[mci]
                                                stdIoAppendFile(nr_md_00, "### Tabela de conformidade — " + m_ctitle + "\n\n")
                                                stdIoAppendFile(nr_md_00, nr_md_hdr)
                                                mut as int64: cfi = 1
                                                infinite {
                                                      route {
                                                            cfi > nr_total_files ==> { break }
                                                            _ ==> {
                                                                  route {
                                                                        nr_all_chaps[cfi] == mci ==> {
                                                                              mut as string: mfn = "" + nr_all_files[cfi]
                                                                              mut as string: mfn_fmt = mfn
                                                                              mut as int64: mfn_len = stdCollectionLength(mfn_fmt)
                                                                              infinite {
                                                                                    route {
                                                                                          mfn_len >= 77 ==> { break }
                                                                                          _ ==> {
                                                                                                mfn_fmt = mfn_fmt + " "
                                                                                                mfn_len = mfn_len + 1
                                                                                          }
                                                                                    }
                                                                              }
                                                                              mut as string: mi_in = "  ❌  "
                                                                              mut as string: mi_vm = "  ❌  "
                                                                              mut as string: mi_vmr = "  ❌  "
                                                                              mut as string: mi_lv = "  ❌  "
                                                                              mut as string: mi_wat = "  ❌  "
                                                                              mut as string: mi_was = "  ❌  "
                                                                              mut as string: mi_res = "   ❌   "
                                                                              route { nr_res_in[mfn] == true ==> { mi_in = "  ✅  " } _ ==> {} }
                                                                              route { nr_res_vm[mfn] == true ==> { mi_vm = "  ✅  " } _ ==> {} }
                                                                              route { nr_res_vmr[mfn] == true ==> { mi_vmr = "  ✅  " } _ ==> {} }
                                                                              route { nr_res_lv[mfn] == true ==> { mi_lv = "  ✅  " } _ ==> {} }
                                                                              route { nr_res_wat[mfn] == true ==> { mi_wat = "  ✅  " } _ ==> {} }
                                                                              route { nr_res_was[mfn] == true ==> { mi_was = "  ✅  " } _ ==> {} }
                                                                              route { nr_res_all[mfn] == true ==> { mi_res = "   ✅   " } _ ==> {} }
                                                                              stdIoAppendFile(nr_md_00, "| " + mfn_fmt + " |" + mi_in + "|" + mi_vm + "|" + mi_vmr + "|" + mi_lv + "|" + mi_wat + "|" + mi_was + "|" + mi_res + "|\n")
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                                  cfi = cfi + 1
                                                            }
                                                      }
                                                }
                                                stdIoAppendFile(nr_md_00, "\n\n\n")
                                          }
                                          _ ==> {}
                                    }
                                    mci = mci + 1
                              }
                        }
                  }

                  stdIoAppendFile(nr_md_00, "## 📊 Sumário Consolidado de Backends\n\n")
                  stdIoAppendFile(nr_md_00, "-   IN : ✅  " + nr_tot_in + " of  " + nr_total_files + " — ✅\n")
                  stdIoAppendFile(nr_md_00, "-   VM : ✅  " + nr_tot_vm + " of  " + nr_total_files + " — ✅\n")
                  stdIoAppendFile(nr_md_00, "-  VMR : ✅  " + nr_tot_vmr + " of  " + nr_total_files + " — ✅\n")
                  stdIoAppendFile(nr_md_00, "- LLVM : ✅  " + nr_tot_lv + " of  " + nr_total_files + " — ✅\n")
                  stdIoAppendFile(nr_md_00, "-  WAT : ✅  " + nr_tot_wat + " of  " + nr_total_files + " — ✅\n")
                  stdIoAppendFile(nr_md_00, "- WASM : ✅  " + nr_tot_was + " of  " + nr_total_files + " — ✅\n")
                  mut as int64: nr_total_checks = nr_total_files * 6
                  mut as int64: nr_all_checks_ok = nr_tot_in + nr_tot_vm + nr_tot_vmr + nr_tot_lv + nr_tot_wat + nr_tot_was
                  stdIoAppendFile(nr_md_00, "-  ALL : ✅  " + nr_all_checks_ok + " of  " + nr_total_checks + " — ✅\n\n\n\n")
                  stdIoAppendFile(nr_md_00, "### Regressão:\n\n")
                  route {
                        n_nr_reg > 0 ==> {
                              stdIoAppendFile(nr_md_00, nr_md_hdr)
                              mut as int64: nri_k = 1
                              infinite {
                                    route {
                                          nri_k > n_nr_reg ==> { break }
                                          _ ==> {
                                                mut as string: reg_fn = "" + nr_reg_files[nri_k]
                                                mut as string: r_fmt = reg_fn
                                                mut as int64: r_len = stdCollectionLength(r_fmt)
                                                infinite {
                                                      route {
                                                            r_len >= 77 ==> { break }
                                                            _ ==> {
                                                                  r_fmt = r_fmt + " "
                                                                  r_len = r_len + 1
                                                            }
                                                      }
                                                }
                                                mut as string: r_in = "  ❌  "
                                                mut as string: r_vm = "  ❌  "
                                                mut as string: r_vmr = "  ❌  "
                                                mut as string: r_lv = "  ❌  "
                                                mut as string: r_wat = "  ❌  "
                                                mut as string: r_was = "  ❌  "
                                                route { nr_res_in[reg_fn] == true ==> { r_in = "  ✅  " } _ ==> {} }
                                                route { nr_res_vm[reg_fn] == true ==> { r_vm = "  ✅  " } _ ==> {} }
                                                route { nr_res_vmr[reg_fn] == true ==> { r_vmr = "  ✅  " } _ ==> {} }
                                                route { nr_res_lv[reg_fn] == true ==> { r_lv = "  ✅  " } _ ==> {} }
                                                route { nr_res_wat[reg_fn] == true ==> { r_wat = "  ✅  " } _ ==> {} }
                                                route { nr_res_was[reg_fn] == true ==> { r_was = "  ✅  " } _ ==> {} }
                                                stdIoAppendFile(nr_md_00, "| " + r_fmt + " |" + r_in + "|" + r_vm + "|" + r_vmr + "|" + r_lv + "|" + r_wat + "|" + r_was + "|   ❌   |\n")
                                                nri_k = nri_k + 1
                                          }
                                    }
                              }
                        }
                        _ ==> { stdIoAppendFile(nr_md_00, "Nenhuma regressão detectada.\n") }
                  }
                  println("📄 Tabela de conformidade atualizada em: " + nr_md_00)
            }
            _ ==> {}
      }

      #L ==========================================================================
      #L SUÍTE 3: SCIENTIFIC ALGORITHMS (--sa)
      #L ==========================================================================
      route {
            flag_sa ==> {
                  println("")
                  println("========================================================================")
                  println(">>> INICIANDO CONFORMIDADE: SCIENTIFIC ALGORITHMS (examples/ScientificAlgorithms/)")
                  println("========================================================================")

                  mut as string: sa_md_00 = "examples\\compliance_SA00.md"
                  mut as string: sa_md_01 = "examples\\compliance_SA01.md"

                  #L 3.1 Backup de compliance_SA00.md -> compliance_SA01.md
                  route {
                        stdIoFileExists(sa_md_00) ==> {
                              mut as string: c00 = stdIoReadFile(sa_md_00)
                              stdIoWriteFile(sa_md_01, c00)
                              println("Baseline copiado: " + sa_md_00 + " -> " + sa_md_01)
                        }
                        _ ==> {}
                  }

                  #L 3.2 Leitura do baseline anterior
                  mut as string: old_sa_target = sa_md_01
                  route {
                        not stdIoFileExists(old_sa_target) ==> {
                              route {
                                    stdIoFileExists(sa_md_00) ==> { old_sa_target = sa_md_00 }
                                    _ ==> { old_sa_target = "" }
                              }
                        }
                        _ ==> {}
                  }

                  mut as map: old_sa_has = map{}
                  mut as map: old_sa_in = map{}
                  mut as map: old_sa_vm = map{}
                  mut as map: old_sa_vmr = map{}
                  mut as map: old_sa_lv = map{}
                  mut as map: old_sa_wat = map{}
                  mut as map: old_sa_was = map{}
                  mut as map: old_sa_all_ok = map{}

                  mut as bool: target_ready = false
                  route {
                        old_sa_target != "" ==> {
                              route {
                                    stdIoFileExists(old_sa_target) ==> { target_ready = true }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  route {
                        target_ready ==> {
                              mut as list of data: old_lines = stdIoReadLines(old_sa_target)
                              mut as int64: n_ol = stdCollectionLength(old_lines)
                              mut as int64: oli = 1
                              infinite {
                                    route {
                                          oli > n_ol ==> { break }
                                          _ ==> {
                                                mut as string: oln = "" + old_lines[oli]
                                                mut as int64: oln_len = stdCollectionLength(oln)
                                                mut as bool: is_pipe_row = false
                                                route {
                                                      oln_len >= 15 ==> {
                                                            route {
                                                                  oln[1] == "|" ==> { is_pipe_row = true }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                                route {
                                                      is_pipe_row ==> {
                                                            mut as int64: bar1 = 1
                                                            mut as int64: bar2 = 0
                                                            mut as int64: bi_k = 2
                                                            infinite {
                                                                  route {
                                                                        bi_k > oln_len ==> { break }
                                                                        oln[bi_k] == "|" ==> {
                                                                              bar2 = bi_k
                                                                              break
                                                                        }
                                                                        _ ==> { bi_k = bi_k + 1 }
                                                                  }
                                                            }
                                                            route {
                                                                  bar2 > bar1 + 1 ==> {
                                                                        mut as string: raw_fn = oln[(bar1 + 1)..(bar2 - 1)]
                                                                        mut as int64: rfn_len = stdCollectionLength(raw_fn)
                                                                        mut as int64: t_s = 1
                                                                        infinite {
                                                                              route {
                                                                                    t_s > rfn_len ==> { break }
                                                                                    raw_fn[t_s] != " " ==> { break }
                                                                                    _ ==> { t_s = t_s + 1 }
                                                                              }
                                                                        }
                                                                        mut as int64: t_e = rfn_len
                                                                        infinite {
                                                                              route {
                                                                                    t_e < t_s ==> { break }
                                                                                    raw_fn[t_e] != " " ==> { break }
                                                                                    _ ==> { t_e = t_e - 1 }
                                                                              }
                                                                        }
                                                                        route {
                                                                              t_e >= t_s ==> {
                                                                                    mut as string: o_name = raw_fn[t_s..t_e]
                                                                                    mut as int64: onlen = stdCollectionLength(o_name)
                                                                                    mut as bool: is_valid_flux = false
                                                                                    route {
                                                                                          onlen >= 5 ==> {
                                                                                                route {
                                                                                                      o_name[(onlen - 4)..onlen] == ".flux" ==> { is_valid_flux = true }
                                                                                                      _ ==> {}
                                                                                                }
                                                                                          }
                                                                                          _ ==> {}
                                                                                    }
                                                                                    route {
                                                                                          is_valid_flux ==> {
                                                                                                old_sa_has[o_name] = true
                                                                                                mut as list of data: bar_pos = [1, bar2]
                                                                                                mut as int64: n_bar = 2
                                                                                                mut as int64: b_k = bar2 + 1
                                                                                                infinite {
                                                                                                      route {
                                                                                                            b_k > oln_len ==> { break }
                                                                                                            oln[b_k] == "|" ==> {
                                                                                                                  n_bar = n_bar + 1
                                                                                                                  bar_pos[n_bar] = b_k
                                                                                                            }
                                                                                                            _ ==> {}
                                                                                                      }
                                                                                                      b_k = b_k + 1
                                                                                                }
                                                                                                route {
                                                                                                      n_bar >= 8 ==> {
                                                                                                            mut as string: c_in = oln[bar_pos[2]..bar_pos[3]]
                                                                                                            mut as string: c_vm = oln[bar_pos[3]..bar_pos[4]]
                                                                                                            mut as string: c_vmr = oln[bar_pos[4]..bar_pos[5]]
                                                                                                            mut as string: c_lv = oln[bar_pos[5]..bar_pos[6]]
                                                                                                            mut as string: c_wat = oln[bar_pos[6]..bar_pos[7]]
                                                                                                            mut as string: c_was = oln[bar_pos[7]..bar_pos[8]]
                                                                                                            mut as list of data: c_arr = [c_in, c_vm, c_vmr, c_lv, c_wat, c_was]
                                                                                                            mut as list of data: v_arr = [false, false, false, false, false, false]
                                                                                                            mut as int64: ai_c = 1
                                                                                                            infinite {
                                                                                                                  route {
                                                                                                                        ai_c > 6 ==> { break }
                                                                                                                        _ ==> {
                                                                                                                              mut as string: cs = "" + c_arr[ai_c]
                                                                                                                              mut as int64: cslen = stdCollectionLength(cs)
                                                                                                                              mut as int64: csk = 1
                                                                                                                              infinite {
                                                                                                                                    route {
                                                                                                                                          csk > cslen ==> { break }
                                                                                                                                          _ ==> {
                                                                                                                                                route {
                                                                                                                                                      cs[csk] == "✅" or cs[csk] == "✓" ==> {
                                                                                                                                                            v_arr[ai_c] = true
                                                                                                                                                            break
                                                                                                                                                      }
                                                                                                                                                      _ ==> { csk = csk + 1 }
                                                                                                                                                }
                                                                                                                                          }
                                                                                                                                    }
                                                                                                                              }
                                                                                                                              ai_c = ai_c + 1
                                                                                                                        }
                                                                                                                  }
                                                                                                            }
                                                                                                            old_sa_in[o_name] = v_arr[1]
                                                                                                            old_sa_vm[o_name] = v_arr[2]
                                                                                                            old_sa_vmr[o_name] = v_arr[3]
                                                                                                            old_sa_lv[o_name] = v_arr[4]
                                                                                                            old_sa_wat[o_name] = v_arr[5]
                                                                                                            old_sa_was[o_name] = v_arr[6]
                                                                                                            old_sa_all_ok[o_name] = (v_arr[1] and v_arr[2] and v_arr[3] and v_arr[4] and v_arr[5] and v_arr[6])
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
                                                oli = oli + 1
                                          }
                                    }
                              }
                        }
                        _ ==> {}
                  }

                  #L 3.3 Catalogo dos 13 dominios de Scientific Algorithms
                  mut as list of data: sa_dom_dirs = [
                        "01_foundations",
                        "02_data_structures",
                        "03_graphs",
                        "04_strings",
                        "05_mathematics",
                        "06_numerical_physics",
                        "07_optimization_stat",
                        "08_artificial_intel",
                        "09_systems_infra",
                        "10_bio_quantum",
                        "11_dsp_multimedia",
                        "12_robotics_control",
                        "13_classical_crypto",
                  ]

                  mut as list of data: sa_dom_titles = [
                        "Domínio I: Fundamentos, Busca e Ordenação (01_foundations)",
                        "Domínio II: Estruturas de Dados Avançadas & Streaming (02_data_structures)",
                        "Domínio III: Teoria dos Grafos & Redes (03_graphs)",
                        "Domínio IV: Strings, Texto & Teoria da Informação (04_strings)",
                        "Domínio V: Matemática Computacional, Teoria dos Números & Álgebra (05_mathematics)",
                        "Domínio VI: Métodos Numéricos, Geometria & Física Computacional (06_numerical_physics)",
                        "Domínio VII: Otimização & Estatística Científica (07_optimization_stat)",
                        "Domínio VIII: Inteligência Artificial, ML & Deep Learning (08_artificial_intel)",
                        "Domínio IX: Sistemas Computacionais, Compiladores & Infraestrutura (09_systems_infra)",
                        "Domínio X: Bioinformática, Computação Quântica & Criptografia Pós-Quântica (10_bio_quantum)",
                        "Domínio XI: Processamento Digital de Sinais (DSP), Áudio & Multimídia (11_dsp_multimedia)",
                        "Domínio XII: Robótica, Cinemática, Controle & Navegação (12_robotics_control)",
                        "Domínio XIII: Criptografia Fundamental Clássica & Segurança (13_classical_crypto)",
                  ]

                  #L 3.4 Varredura dos arquivos de Scientific Algorithms por dominio
                  mut as list of data: sa_all_files = []
                  mut as list of data: sa_all_paths = []
                  mut as list of data: sa_all_doms = []
                  mut as int64: sa_total_files = 0

                  mut as int64: sdmi = 1
                  infinite {
                        route {
                              sdmi > 13 ==> { break }
                              _ ==> {
                                    mut as string: ddir = "" + sa_dom_dirs[sdmi]
                                    mut as string: full_ddir = "examples\\ScientificAlgorithms\\" + ddir
                                    mut as list of data: dentries = stdIoListDir(full_ddir)
                                    mut as int64: n_dentries = stdCollectionLength(dentries)
                                    mut as list of data: dm_files = []
                                    mut as int64: n_dm_files = 0
                                    mut as int64: dei = 1
                                    infinite {
                                          route {
                                                dei > n_dentries ==> { break }
                                                _ ==> {
                                                      mut as string: fname = "" + dentries[dei]
                                                      mut as int64: fn_len = stdCollectionLength(fname)
                                                      mut as bool: is_flux = false
                                                      route {
                                                            fn_len >= 5 ==> {
                                                                  route {
                                                                        fname[(fn_len - 4)..fn_len] == ".flux" ==> { is_flux = true }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            is_flux ==> {
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

                                                                  mut as bool: aceito = true
                                                                  route {
                                                                        filtro_lower != "" ==> {
                                                                              aceito = false
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
                                                                              route {
                                                                                    not aceito ==> {
                                                                                          mut as int64: ddlen = stdCollectionLength(ddir)
                                                                                          route {
                                                                                                ddlen >= qlen ==> {
                                                                                                      mut as int64: dki = 1
                                                                                                      infinite {
                                                                                                            route {
                                                                                                                  dki + qlen - 1 > ddlen ==> { break }
                                                                                                                  ddir[dki..(dki + qlen - 1)] == filtro_lower ==> {
                                                                                                                        aceito = true
                                                                                                                        break
                                                                                                                  }
                                                                                                                  _ ==> { dki = dki + 1 }
                                                                                                            }
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
                                                                  route {
                                                                        aceito ==> {
                                                                              n_dm_files = n_dm_files + 1
                                                                              dm_files[n_dm_files] = fname
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      dei = dei + 1
                                                }
                                          }
                                    }

                                    mut as int64: s1 = 1
                                    infinite {
                                          route {
                                                s1 >= n_dm_files ==> { break }
                                                _ ==> {
                                                      mut as int64: s2 = s1 + 1
                                                      infinite {
                                                            route {
                                                                  s2 > n_dm_files ==> { break }
                                                                  _ ==> {
                                                                        mut as string: as_ = "" + dm_files[s1]
                                                                        mut as string: bs_ = "" + dm_files[s2]
                                                                        route {
                                                                              as_ > bs_ ==> {
                                                                                    mut as data: tmp = dm_files[s1]
                                                                                    dm_files[s1] = dm_files[s2]
                                                                                    dm_files[s2] = tmp
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                        s2 = s2 + 1
                                                                  }
                                                            }
                                                      }
                                                      s1 = s1 + 1
                                                }
                                          }
                                    }

                                    mut as int64: dfi = 1
                                    infinite {
                                          route {
                                                dfi > n_dm_files ==> { break }
                                                _ ==> {
                                                      sa_total_files = sa_total_files + 1
                                                      sa_all_files[sa_total_files] = dm_files[dfi]
                                                      sa_all_paths[sa_total_files] = full_ddir + "\\" + dm_files[dfi]
                                                      sa_all_doms[sa_total_files] = sdmi
                                                      dfi = dfi + 1
                                                }
                                          }
                                    }
                                    sdmi = sdmi + 1
                              }
                        }
                  }

                  println("Scientific Algorithms: " + sa_total_files + " arquivo(s) selecionado(s).")
                  println("")
                  println("algoritmo                                                                    in   vm  vmr llvm  wat wasm")
                  println("--------------------------------------------------------------------------------------------------------")

                  mut as map: sa_res_in = map{}
                  mut as map: sa_res_vm = map{}
                  mut as map: sa_res_vmr = map{}
                  mut as map: sa_res_lv = map{}
                  mut as map: sa_res_wat = map{}
                  mut as map: sa_res_was = map{}
                  mut as map: sa_res_all = map{}
                  mut as int64: sa_tot_in = 0
                  mut as int64: sa_tot_vm = 0
                  mut as int64: sa_tot_vmr = 0
                  mut as int64: sa_tot_lv = 0
                  mut as int64: sa_tot_wat = 0
                  mut as int64: sa_tot_was = 0
                  mut as int64: sa_tot_all_ok = 0

                  mut as int64: sai = 1
                  infinite {
                        route {
                              sai > sa_total_files ==> { break }
                              _ ==> {
                                    mut as string: nome = "" + sa_all_files[sai]
                                    mut as string: path = "" + sa_all_paths[sai]
                                    mut as int64: nlen = stdCollectionLength(nome)
                                    mut as string: stem = nome
                                    route {
                                          nlen > 5 ==> {
                                                route {
                                                      nome[(nlen - 4)..nlen] == ".flux" ==> {
                                                            stem = nome[1..(nlen - 5)]
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }

                                    mut as string: out_vm = "t_fvmbc\\" + stem
                                    mut as string: fvmbc_file = "t_fvmbc\\" + stem + ".fvmbc"
                                    mut as string: out_lv = "t_llvm\\" + stem
                                    mut as string: exe_file = "t_llvm\\" + stem + ".exe"
                                    mut as string: out_wat = "t_wat\\" + stem
                                    mut as string: wat_file = "t_wat\\" + stem + ".wat"
                                    mut as string: out_wasm = "t_wasm\\" + stem
                                    mut as string: wasm_file = "t_wasm\\" + stem + ".wasm"

                                    mut as string: cmd_in = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target in " + path + " < " + "t_stdin.tmp" + " > t_in.tmp 2>nul\""
                                    mut as int64: rc_in = stdOsExec(cmd_in)
                                    mut as string: cmd_vm_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vm " + path + " -o " + out_vm + " --no-run < " + "t_stdin.tmp" + " > t_vm_c.tmp 2>nul\""
                                    mut as int64: rc_vm_c = stdOsExec(cmd_vm_c)
                                    mut as string: cmd_vm = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vmr " + fvmbc_file + " < " + "t_stdin.tmp" + " > t_vm.tmp 2>nul\""
                                    mut as int64: rc_vm = stdOsExec(cmd_vm)
                                    mut as string: cmd_vmr = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vmr " + fvmbc_file + " < " + "t_stdin.tmp" + " > t_vmr.tmp 2>nul\""
                                    mut as int64: rc_vmr = stdOsExec(cmd_vmr)
                                    mut as string: cmd_lv_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target lv " + path + " -o " + out_lv + " --no-run < " + "t_stdin.tmp" + " > t_lv_c.tmp 2>nul\""
                                    mut as int64: rc_lv_c = stdOsExec(cmd_lv_c)
                                    mut as string: cmd_lv = "cmd /c \"set FLUX_CI=1 && " + exe_file + " < " + "t_stdin.tmp" + " > t_lv.tmp 2>nul\""
                                    mut as int64: rc_lv = stdOsExec(cmd_lv)
                                    mut as string: cmd_wat_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target wat " + path + " -o " + out_wat + " --no-run < " + "t_stdin.tmp" + " > t_wat_c.tmp 2>nul\""
                                    mut as int64: rc_wat_c = stdOsExec(cmd_wat_c)
                                    mut as string: cmd_wat = "cmd /c \"set FLUX_CI=1 && wasmer run " + wat_file + " < " + "t_stdin.tmp" + " > t_wat.tmp 2>nul\""
                                    mut as int64: rc_wat = stdOsExec(cmd_wat)
                                    mut as string: cmd_was_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target wasm " + path + " -o " + out_wasm + " --no-run < " + "t_stdin.tmp" + " > t_was_c.tmp 2>nul\""
                                    mut as int64: rc_was_c = stdOsExec(cmd_was_c)
                                    mut as string: cmd_was = "cmd /c \"set FLUX_CI=1 && wasmer run " + wasm_file + " < " + "t_stdin.tmp" + " > t_was.tmp 2>nul\""
                                    mut as int64: rc_was = stdOsExec(cmd_was)

                                    mut as string: s_in = ""
                                    mut as string: s_vm = ""
                                    mut as string: s_vmr = ""
                                    mut as string: s_lv = ""
                                    mut as string: s_wat = ""
                                    mut as string: s_was = ""
                                    route { stdIoFileExists("t_in.tmp") ==> { s_in = stdIoReadFile("t_in.tmp") } _ ==> {} }
                                    route { stdIoFileExists("t_vm.tmp") ==> { s_vm = stdIoReadFile("t_vm.tmp") } _ ==> {} }
                                    route { stdIoFileExists("t_vmr.tmp") ==> { s_vmr = stdIoReadFile("t_vmr.tmp") } _ ==> {} }
                                    route { stdIoFileExists("t_lv.tmp") ==> { s_lv = stdIoReadFile("t_lv.tmp") } _ ==> {} }
                                    route { stdIoFileExists("t_wat.tmp") ==> { s_wat = stdIoReadFile("t_wat.tmp") } _ ==> {} }
                                    route { stdIoFileExists("t_was.tmp") ==> { s_was = stdIoReadFile("t_was.tmp") } _ ==> {} }
                                    mut as bool: ok_in = (rc_in == 0)
                                    mut as bool: ok_vm = (rc_vm_c == 0 and rc_vm == 0)
                                    mut as bool: ok_vmr = (rc_vm_c == 0 and rc_vmr == 0)
                                    mut as bool: ok_lv = (rc_lv_c == 0 and rc_lv == 0)
                                    mut as bool: ok_wat = (rc_wat_c == 0 and rc_wat == 0)
                                    mut as bool: ok_was = (rc_was_c == 0 and rc_was == 0)
                                    sa_res_in[nome] = ok_in
                                    sa_res_vm[nome] = ok_vm
                                    sa_res_vmr[nome] = ok_vmr
                                    sa_res_lv[nome] = ok_lv
                                    sa_res_wat[nome] = ok_wat
                                    sa_res_was[nome] = ok_was
                                    mut as bool: all_ok = (ok_in and ok_vm and ok_vmr and ok_lv and ok_wat and ok_was)
                                    sa_res_all[nome] = all_ok
                                    route { ok_in ==> { sa_tot_in = sa_tot_in + 1 } _ ==> {} }
                                    route { ok_vm ==> { sa_tot_vm = sa_tot_vm + 1 } _ ==> {} }
                                    route { ok_vmr ==> { sa_tot_vmr = sa_tot_vmr + 1 } _ ==> {} }
                                    route { ok_lv ==> { sa_tot_lv = sa_tot_lv + 1 } _ ==> {} }
                                    route { ok_wat ==> { sa_tot_wat = sa_tot_wat + 1 } _ ==> {} }
                                    route { ok_was ==> { sa_tot_was = sa_tot_was + 1 } _ ==> {} }
                                    route {
                                          all_ok ==> { sa_tot_all_ok = sa_tot_all_ok + 1 }
                                          _ ==> { grand_falhas = grand_falhas + 1 }
                                    }

                                    mut as string: ic_in = "✗"
                                    mut as string: ic_vm = "✗"
                                    mut as string: ic_vmr = "✗"
                                    mut as string: ic_lv = "✗"
                                    mut as string: ic_wat = "✗"
                                    mut as string: ic_was = "✗"
                                    route { ok_in ==> { ic_in = "✓" } _ ==> {} }
                                    route { ok_vm ==> { ic_vm = "✓" } _ ==> {} }
                                    route { ok_vmr ==> { ic_vmr = "✓" } _ ==> {} }
                                    route { ok_lv ==> { ic_lv = "✓" } _ ==> {} }
                                    route { ok_wat ==> { ic_wat = "✓" } _ ==> {} }
                                    route { ok_was ==> { ic_was = "✓" } _ ==> {} }
                                    mut as string: p_name = nome
                                    mut as int64: pn_len = stdCollectionLength(p_name)
                                    infinite {
                                          route {
                                                pn_len >= 77 ==> { break }
                                                _ ==> {
                                                      p_name = p_name + " "
                                                      pn_len = pn_len + 1
                                                }
                                          }
                                    }
                                    println(p_name + "   " + ic_in + "   " + ic_vm + "   " + ic_vmr + "    " + ic_lv + "    " + ic_wat + "   " + ic_was)
                                    sai = sai + 1
                              }
                        }
                  }

                  println("--------------------------------------------------------------------------------------------------------")
                  println("Scientific Algorithms: " + sa_tot_all_ok + "/" + sa_total_files + " arquivo(s) com todos os 6 backends OK")
                  route { sa_total_files > 0 ==> {
                        println("  in: " + sa_tot_in + "/" + sa_total_files + " OK")
                        println("  vm: " + sa_tot_vm + "/" + sa_total_files + " OK")
                        println("  vmr: " + sa_tot_vmr + "/" + sa_total_files + " OK")
                        println("  llvm: " + sa_tot_lv + "/" + sa_total_files + " OK")
                        println("  wat: " + sa_tot_wat + "/" + sa_total_files + " OK")
                        println("  wasm: " + sa_tot_was + "/" + sa_total_files + " OK")
                  } _ ==> {} }

                  mut as list of data: sa_reg_files = []
                  mut as int64: n_sa_reg = 0
                  mut as int64: sa_ri = 1
                  infinite {
                        route {
                              sa_ri > sa_total_files ==> { break }
                              _ ==> {
                                    mut as string: rfn = "" + sa_all_files[sa_ri]
                                    mut as bool: had_old = (old_sa_has[rfn] == true)
                                    route {
                                          had_old ==> {
                                                mut as bool: o_in = (old_sa_in[rfn] == true)
                                                mut as bool: o_vm = (old_sa_vm[rfn] == true)
                                                mut as bool: o_vmr = (old_sa_vmr[rfn] == true)
                                                mut as bool: o_lv = (old_sa_lv[rfn] == true)
                                                mut as bool: o_wat = (old_sa_wat[rfn] == true)
                                                mut as bool: o_was = (old_sa_was[rfn] == true)
                                                mut as bool: n_in = (sa_res_in[rfn] == true)
                                                mut as bool: n_vm = (sa_res_vm[rfn] == true)
                                                mut as bool: n_vmr = (sa_res_vmr[rfn] == true)
                                                mut as bool: n_lv = (sa_res_lv[rfn] == true)
                                                mut as bool: n_wat = (sa_res_wat[rfn] == true)
                                                mut as bool: n_was = (sa_res_was[rfn] == true)
                                                mut as bool: reg = ((o_in and not n_in) or (o_vm and not n_vm) or (o_vmr and not n_vmr) or (o_lv and not n_lv) or (o_wat and not n_wat) or (o_was and not n_was))
                                                route {
                                                      reg ==> {
                                                            n_sa_reg = n_sa_reg + 1
                                                            sa_reg_files[n_sa_reg] = rfn
                                                            grand_regressoes = grand_regressoes + 1
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    sa_ri = sa_ri + 1
                              }
                        }
                  }

                  route {
                        n_sa_reg > 0 ==> {
                              println("")
                              println("⚠️  ATENÇÃO: " + n_sa_reg + " regressão(ões) detectada(s) em Scientific Algorithms!")
                              mut as int64: rli = 1
                              infinite {
                                    route {
                                          rli > n_sa_reg ==> { break }
                                          _ ==> {
                                                println("  ❌ " + sa_reg_files[rli])
                                                rli = rli + 1
                                          }
                                    }
                              }
                        }
                        _ ==> { println("Rastreamento de regressão Scientific Algorithms: ✅ Nenhuma regressão detectada!") }
                  }

                  #L 3.7 Gravacao de compliance_SA00.md
                  mut as string: sa_md_hdr = "| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |\n| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |\n"
                  mut as bool: first_dom_written = false

                  mut as int64: mdi = 1
                  infinite {
                        route {
                              mdi > 13 ==> { break }
                              _ ==> {
                                    mut as int64: count_dm = 0
                                    mut as int64: dchk = 1
                                    infinite {
                                          route {
                                                dchk > sa_total_files ==> { break }
                                                _ ==> {
                                                      route { sa_all_doms[dchk] == mdi ==> { count_dm = count_dm + 1 } _ ==> {} }
                                                      dchk = dchk + 1
                                                }
                                          }
                                    }
                                    route {
                                          count_dm > 0 ==> {
                                                mut as string: m_dtitle = "" + sa_dom_titles[mdi]
                                                route {
                                                      not first_dom_written ==> {
                                                            stdIoWriteFile(sa_md_00, "### Tabela de conformidade — " + m_dtitle + "\n\n")
                                                            first_dom_written = true
                                                      }
                                                      _ ==> { stdIoAppendFile(sa_md_00, "### Tabela de conformidade — " + m_dtitle + "\n\n") }
                                                }
                                                stdIoAppendFile(sa_md_00, sa_md_hdr)
                                                mut as int64: sfi = 1
                                                infinite {
                                                      route {
                                                            sfi > sa_total_files ==> { break }
                                                            _ ==> {
                                                                  route {
                                                                        sa_all_doms[sfi] == mdi ==> {
                                                                              mut as string: sfn = "" + sa_all_files[sfi]
                                                                              mut as string: sfn_fmt = sfn
                                                                              mut as int64: sfn_len = stdCollectionLength(sfn_fmt)
                                                                              infinite {
                                                                                    route {
                                                                                          sfn_len >= 77 ==> { break }
                                                                                          _ ==> {
                                                                                                sfn_fmt = sfn_fmt + " "
                                                                                                sfn_len = sfn_len + 1
                                                                                          }
                                                                                    }
                                                                              }
                                                                              mut as string: si_in = "  ❌  "
                                                                              mut as string: si_vm = "  ❌  "
                                                                              mut as string: si_vmr = "  ❌  "
                                                                              mut as string: si_lv = "  ❌  "
                                                                              mut as string: si_wat = "  ❌  "
                                                                              mut as string: si_was = "  ❌  "
                                                                              mut as string: si_res = "   ❌   "
                                                                              route { sa_res_in[sfn] == true ==> { si_in = "  ✅  " } _ ==> {} }
                                                                              route { sa_res_vm[sfn] == true ==> { si_vm = "  ✅  " } _ ==> {} }
                                                                              route { sa_res_vmr[sfn] == true ==> { si_vmr = "  ✅  " } _ ==> {} }
                                                                              route { sa_res_lv[sfn] == true ==> { si_lv = "  ✅  " } _ ==> {} }
                                                                              route { sa_res_wat[sfn] == true ==> { si_wat = "  ✅  " } _ ==> {} }
                                                                              route { sa_res_was[sfn] == true ==> { si_was = "  ✅  " } _ ==> {} }
                                                                              route { sa_res_all[sfn] == true ==> { si_res = "   ✅   " } _ ==> {} }
                                                                              stdIoAppendFile(sa_md_00, "| " + sfn_fmt + " |" + si_in + "|" + si_vm + "|" + si_vmr + "|" + si_lv + "|" + si_wat + "|" + si_was + "|" + si_res + "|\n")
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                                  sfi = sfi + 1
                                                            }
                                                      }
                                                }
                                                stdIoAppendFile(sa_md_00, "\n\n\n")
                                          }
                                          _ ==> {}
                                    }
                                    mdi = mdi + 1
                              }
                        }
                  }

                  stdIoAppendFile(sa_md_00, "## 📊 Sumário Consolidado de Backends\n\n")
                  stdIoAppendFile(sa_md_00, "-   IN : ✅  " + sa_tot_in + " of  " + sa_total_files + " — ✅\n")
                  stdIoAppendFile(sa_md_00, "-   VM : ✅  " + sa_tot_vm + " of  " + sa_total_files + " — ✅\n")
                  stdIoAppendFile(sa_md_00, "-  VMR : ✅  " + sa_tot_vmr + " of  " + sa_total_files + " — ✅\n")
                  stdIoAppendFile(sa_md_00, "- LLVM : ✅  " + sa_tot_lv + " of  " + sa_total_files + " — ✅\n")
                  stdIoAppendFile(sa_md_00, "-  WAT : ✅  " + sa_tot_wat + " of  " + sa_total_files + " — ✅\n")
                  stdIoAppendFile(sa_md_00, "- WASM : ✅  " + sa_tot_was + " of  " + sa_total_files + " — ✅\n")
                  mut as int64: sa_total_checks = sa_total_files * 6
                  mut as int64: sa_all_checks_ok = sa_tot_in + sa_tot_vm + sa_tot_vmr + sa_tot_lv + sa_tot_wat + sa_tot_was
                  stdIoAppendFile(sa_md_00, "-  ALL : ✅  " + sa_all_checks_ok + " of  " + sa_total_checks + " — ✅\n\n\n\n")
                  stdIoAppendFile(sa_md_00, "### Regressão:\n\n")
                  route {
                        n_sa_reg > 0 ==> {
                              stdIoAppendFile(sa_md_00, sa_md_hdr)
                              mut as int64: sai_k = 1
                              infinite {
                                    route {
                                          sai_k > n_sa_reg ==> { break }
                                          _ ==> {
                                                mut as string: reg_fn = "" + sa_reg_files[sai_k]
                                                mut as string: r_fmt = reg_fn
                                                mut as int64: r_len = stdCollectionLength(r_fmt)
                                                infinite {
                                                      route {
                                                            r_len >= 77 ==> { break }
                                                            _ ==> {
                                                                  r_fmt = r_fmt + " "
                                                                  r_len = r_len + 1
                                                            }
                                                      }
                                                }
                                                mut as string: r_in = "  ❌  "
                                                mut as string: r_vm = "  ❌  "
                                                mut as string: r_vmr = "  ❌  "
                                                mut as string: r_lv = "  ❌  "
                                                mut as string: r_wat = "  ❌  "
                                                mut as string: r_was = "  ❌  "
                                                route { sa_res_in[reg_fn] == true ==> { r_in = "  ✅  " } _ ==> {} }
                                                route { sa_res_vm[reg_fn] == true ==> { r_vm = "  ✅  " } _ ==> {} }
                                                route { sa_res_vmr[reg_fn] == true ==> { r_vmr = "  ✅  " } _ ==> {} }
                                                route { sa_res_lv[reg_fn] == true ==> { r_lv = "  ✅  " } _ ==> {} }
                                                route { sa_res_wat[reg_fn] == true ==> { r_wat = "  ✅  " } _ ==> {} }
                                                route { sa_res_was[reg_fn] == true ==> { r_was = "  ✅  " } _ ==> {} }
                                                stdIoAppendFile(sa_md_00, "| " + r_fmt + " |" + r_in + "|" + r_vm + "|" + r_vmr + "|" + r_lv + "|" + r_wat + "|" + r_was + "|   ❌   |\n")
                                                sai_k = sai_k + 1
                                          }
                                    }
                              }
                        }
                        _ ==> { stdIoAppendFile(sa_md_00, "Nenhuma regressão detectada.\n") }
                  }
                  println("📄 Tabela de conformidade atualizada em: " + sa_md_00)
            }
            _ ==> {}
      }

      #L 7. Limpeza final de arquivos e pastas temporarias t_*
      #L Verificacao e limpeza nativa de arquivos nas pastas t_* (preservando .gitkeep)
      mut as list of data: cl_fin_dirs = ["t_fvmbc", "t_llvm", "t_wasm", "t_wat"]
      mut as int64: cl_fin_di = 1
      infinite {
            route {
                  cl_fin_di > 4 ==> { break }
                  _ ==> {
                        mut as string: cl_fin_cur_dir = "" + cl_fin_dirs[cl_fin_di]
                        route {
                              stdIoDirExists(cl_fin_cur_dir) ==> {
                                    mut as list of data: cl_fin_entries = stdIoListDir(cl_fin_cur_dir)
                                    mut as int64: cl_fin_n_entries = stdCollectionLength(cl_fin_entries)
                                    mut as int64: cl_fin_ei = 1
                                    infinite {
                                          route {
                                                cl_fin_ei > cl_fin_n_entries ==> { break }
                                                _ ==> {
                                                      mut as string: cl_fin_fname = "" + cl_fin_entries[cl_fin_ei]
                                                      route {
                                                            cl_fin_fname != ".gitkeep" ==> {
                                                                  mut as string: cl_fin_fp = cl_fin_cur_dir + "\\" + cl_fin_fname
                                                                  route {
                                                                        stdIoFileExists(cl_fin_fp) ==> {
                                                                              stdIoDeleteFile(cl_fin_fp)
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      cl_fin_ei = cl_fin_ei + 1
                                                }
                                          }
                                    }
                              }
                              _ ==> {
                                    stdIoCreateDir(cl_fin_cur_dir)
                              }
                        }
                        route {
                              stdIoFileExists(cl_fin_cur_dir + "\\.gitkeep") ==> {}
                              _ ==> {
                                    stdIoWriteFile(cl_fin_cur_dir + "\\.gitkeep", "")
                              }
                        }
                        cl_fin_di = cl_fin_di + 1
                  }
            }
      }
      mut as list of data: cl_fin_root_tmps = ["t_stdin.tmp", "t_in.tmp", "t_vm.tmp", "t_vm_c.tmp", "t_vmr.tmp", "t_lv.tmp", "t_lv_c.tmp", "t_wat.tmp", "t_wat_c.tmp", "t_was.tmp", "t_was_c.tmp"]
      mut as int64: cl_fin_ri = 1
      infinite {
            route {
                  cl_fin_ri > 11 ==> { break }
                  _ ==> {
                        mut as string: cl_fin_rtf = "" + cl_fin_root_tmps[cl_fin_ri]
                        route {
                              stdIoFileExists(cl_fin_rtf) ==> {
                                    stdIoDeleteFile(cl_fin_rtf)
                              }
                              _ ==> {}
                        }
                        cl_fin_ri = cl_fin_ri + 1
                  }
            }
      }

      #L 8. Codigo de retorno final
      println("")
      route {
            grand_regressoes > 0 or grand_falhas > 0 ==> {
                  println("❌ Execução concluída com " + grand_falhas + " falha(s) e " + grand_regressoes + " regressão(ões).")
                  stdOsExit(1)
            }
            _ ==> {
                  println("✅ Execução 100% concluída com sucesso e ZERO regressões!")
                  stdOsExit(0)
            }
      }
}
