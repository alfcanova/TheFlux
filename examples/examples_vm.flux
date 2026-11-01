#L ==============================================================================
#L TheFlux Runner: Examples VM (Compilador de Bytecode)
#L Arquivo: examples/examples_vm.flux
#L ==============================================================================

use RuntimeStdLib
use IoStdLib
use OsStdLib

program (ExamplesVm) {
      #L 1. Parser de argumentos da linha de comando
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as bool: flag_ca = false
      mut as bool: flag_nr = false
      mut as bool: flag_sa = false
      mut as bool: flag_all = false
      mut as bool: flag_help = false
      mut as string: filtro_raw = ""

      mut as int64: ai = 1
      infinite {
            route {
                  ai > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[ai]
                        mut as bool: is_self = (a == "examples_vm.flux" or a == ".\\examples_vm.flux" or a == "./examples_vm.flux" or a == "examples\\examples_vm.flux" or a == "examples/examples_vm.flux" or a == ".\\examples\\examples_vm.flux" or a == "./examples/examples_vm.flux" or a == "examples_vm.exe" or a == ".\\examples_vm.exe" or a == "bin\\examples_vm.exe" or a == ".\\bin\\examples_vm.exe" or a == "exemplos_vm.flux" or a == ".\\exemplos_vm.flux" or a == "./exemplos_vm.flux" or a == "exemplos_vm.exe" or a == ".\\exemplos_vm.exe" or a == "bin\\exemplos_vm.exe" or a == ".\\bin\\exemplos_vm.exe" or a == "--" or a == "run" or a == "vm")
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
                                    mut as int64: alen = stdCollectionLength(a)
                                    route {
                                          alen > 0 ==> {
                                                mut as string: ch0 = a[1]
                                                route {
                                                      ch0 != "-" ==> {
                                                            route {
                                                                  filtro_raw == "" ==> {
                                                                        filtro_raw = a
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

      #L 2. Verificacao de ajuda (--help) ou execucao sem suite
      route {
            flag_help or (not flag_ca and not flag_nr and not flag_sa and not flag_all) ==> {
                  println("TheFlux Runner: Examples VM (Compilador de Bytecode)")
                  println("Uso: examples_vm [opções]")
                  println("")
                  println("Opções de Suíte:")
                  println("  --ca              Executa a suíte canônica (examples/Canon)")
                  println("  --nr              Executa a suíte Numerical Recipes (examples/NumericalRecipes)")
                  println("  --sa              Executa a suíte Scientific Algorithms (examples/ScientificAlgorithms)")
                  println("  --all             Executa todas as 3 suítes na sequência (--ca, --nr, --sa)")
                  println("")
                  println("Opções Gerais:")
                  println("  --filter <termo>  Filtra os arquivos a serem testados por substring (case-insensitive)")
                  println("  --help, -h        Exibe esta mensagem de ajuda")
                  println("")
                  println("Exemplos:")
                  println("  examples_vm --ca --filter ExampleOfPrint.flux")
                  println("  examples_vm --nr --filter 01_preliminaries")
                  println("  examples_vm --sa --filter BoyerMoore")
                  println("  examples_vm --all")
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
      mut as list of data: cl_init_root_tmps = ["t_stdin.tmp", "t_input_interactive.txt", "t_input_contract.txt", "t_in.tmp", "t_vm.tmp", "t_vm_c.tmp", "t_vmr.tmp", "t_lv.tmp", "t_lv_c.tmp", "t_wat.tmp", "t_wat_c.tmp", "t_was.tmp", "t_was_c.tmp"]
      mut as int64: cl_init_ri = 1
      infinite {
            route {
                  cl_init_ri > 13 ==> { break }
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
      stdIoWriteFile("t_input_interactive.txt", "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n")
      stdIoWriteFile("t_input_contract.txt", "andre\nluiz\n")

      #L 6. Localizacao dinamica do binario fluxc
      mut as string: fluxc_bin = ".\\bin\\fluxc.exe"
      route {
            stdIoFileExists(".\\bin\\fluxc.exe") ==> { fluxc_bin = ".\\bin\\fluxc.exe" }
            stdIoFileExists("bin\\fluxc.exe")    ==> { fluxc_bin = "bin\\fluxc.exe" }
            stdIoFileExists("fluxc.exe")        ==> { fluxc_bin = "fluxc.exe" }
            _                                    ==> { fluxc_bin = "fluxc" }
      }

      #L 7. Contadores globais de Certos e Falhas
      mut as int64: grand_certos = 0
      mut as int64: grand_falhas = 0

      #L ==========================================================================
      #L SUÍTE 1: CANON (--ca)
      #L ==========================================================================
      route {
            flag_ca ==> {
                  mut as list of data: ca_entries = stdIoListDir("examples\\Canon")
                  mut as int64: n_ca_entries = stdCollectionLength(ca_entries)
                  mut as list of data: ca_files = []
                  mut as list of data: ca_files_lower = []
                  mut as int64: n_ca = 0
                  mut as int64: cei = 1
                  infinite {
                        route {
                              cei > n_ca_entries ==> { break }
                              _ ==> {
                                    mut as string: fname = "" + ca_entries[cei]
                                    mut as int64: fnlen = stdCollectionLength(fname)
                                    route {
                                          fnlen >= 5 ==> {
                                                mut as string: fext = fname[(fnlen - 4)..fnlen]
                                                route {
                                                      fext == ".flux" ==> {
                                                            mut as string: fn_low = ""
                                                            mut as int64: fni = 1
                                                            infinite {
                                                                  route {
                                                                        fni > fnlen ==> { break }
                                                                        _ ==> {
                                                                              mut as string: fch = fname[fni]
                                                                              route {
                                                                                    fch == "A" ==> { fch = "a" }
                                                                                    fch == "B" ==> { fch = "b" }
                                                                                    fch == "C" ==> { fch = "c" }
                                                                                    fch == "D" ==> { fch = "d" }
                                                                                    fch == "E" ==> { fch = "e" }
                                                                                    fch == "F" ==> { fch = "f" }
                                                                                    fch == "G" ==> { fch = "g" }
                                                                                    fch == "H" ==> { fch = "h" }
                                                                                    fch == "I" ==> { fch = "i" }
                                                                                    fch == "J" ==> { fch = "j" }
                                                                                    fch == "K" ==> { fch = "k" }
                                                                                    fch == "L" ==> { fch = "l" }
                                                                                    fch == "M" ==> { fch = "m" }
                                                                                    fch == "N" ==> { fch = "n" }
                                                                                    fch == "O" ==> { fch = "o" }
                                                                                    fch == "P" ==> { fch = "p" }
                                                                                    fch == "Q" ==> { fch = "q" }
                                                                                    fch == "R" ==> { fch = "r" }
                                                                                    fch == "S" ==> { fch = "s" }
                                                                                    fch == "T" ==> { fch = "t" }
                                                                                    fch == "U" ==> { fch = "u" }
                                                                                    fch == "V" ==> { fch = "v" }
                                                                                    fch == "W" ==> { fch = "w" }
                                                                                    fch == "X" ==> { fch = "x" }
                                                                                    fch == "Y" ==> { fch = "y" }
                                                                                    fch == "Z" ==> { fch = "z" }
                                                                                    _ ==> {}
                                                                              }
                                                                              fn_low = fn_low + fch
                                                                              fni = fni + 1
                                                                        }
                                                                  }
                                                            }
                                                            mut as bool: match_ca = false
                                                            route {
                                                                  filtro_lower == "" ==> { match_ca = true }
                                                                  _ ==> {
                                                                        route {
                                                                              fnlen >= flen ==> {
                                                                                    mut as int64: mi = 1
                                                                                    infinite {
                                                                                          route {
                                                                                                mi + flen - 1 > fnlen ==> { break }
                                                                                                _ ==> {
                                                                                                      mut as string: sub = fn_low[mi..(mi + flen - 1)]
                                                                                                      route {
                                                                                                            sub == filtro_lower ==> {
                                                                                                                  match_ca = true
                                                                                                                  break
                                                                                                            }
                                                                                                            _ ==> { mi = mi + 1 }
                                                                                                      }
                                                                                                }
                                                                                          }
                                                                                    }
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                  }
                                                            }
                                                            route {
                                                                  match_ca ==> {
                                                                        n_ca = n_ca + 1
                                                                        ca_files[n_ca] = fname
                                                                        ca_files_lower[n_ca] = fn_low
                                                                  }
                                                                  _ ==> {}
                                                            }
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
                  #L Ordenacao deterministica A-Z de Canon
                  mut as int64: csi = 1
                  infinite {
                        route {
                              csi >= n_ca ==> { break }
                              _ ==> {
                                    mut as int64: csj = csi + 1
                                    infinite {
                                          route {
                                                csj > n_ca ==> { break }
                                                _ ==> {
                                                      mut as string: a_low = "" + ca_files_lower[csi]
                                                      mut as string: b_low = "" + ca_files_lower[csj]
                                                      mut as bool: swap = false
                                                      route {
                                                            a_low > b_low ==> { swap = true }
                                                            a_low == b_low ==> {
                                                                  mut as string: a_orig = "" + ca_files[csi]
                                                                  mut as string: b_orig = "" + ca_files[csj]
                                                                  route {
                                                                        a_orig > b_orig ==> { swap = true }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            swap ==> {
                                                                  mut as data: tmp = ca_files[csi]
                                                                  ca_files[csi] = ca_files[csj]
                                                                  ca_files[csj] = tmp
                                                                  mut as data: tmp_low = ca_files_lower[csi]
                                                                  ca_files_lower[csi] = ca_files_lower[csj]
                                                                  ca_files_lower[csj] = tmp_low
                                                            }
                                                            _ ==> {}
                                                      }
                                                      csj = csj + 1
                                                }
                                          }
                                    }
                                    csi = csi + 1
                              }
                        }
                  }
                  mut as int64: cti = 1
                  infinite {
                        route {
                              cti > n_ca ==> { break }
                              _ ==> {
                                    mut as string: nome = "" + ca_files[cti]
                                    mut as string: path = "examples\\Canon\\" + nome
                                    mut as string: rel_name = nome
                                    mut as int64: nlen = stdCollectionLength(nome)
                                    route {
                                          nlen >= 8 ==> {
                                                mut as int64: di = 1
                                                infinite {
                                                      route {
                                                            di + 7 > nlen ==> { break }
                                                            _ ==> {
                                                                  mut as string: dsub = nome[di..(di + 7)]
                                                                  route {
                                                                        dsub == "DbStdLib" ==> {
                                                                              stdOsExec("cmd /c del /q /f scratch\\flux_*.db* scratch\\flux_*.kv scratch\\flux_*.unqlite scratch\\flux_*.duckdb scratch\\flux_*.kuzu scratch\\flux_*.obx 2>nul")
                                                                              break
                                                                        }
                                                                        _ ==> { di = di + 1 }
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    mut as string: stdin_file = "t_stdin.tmp"
                                    route {
                                          nome == "ExampleOfInput.flux" ==> { stdin_file = "t_input_interactive.txt" }
                                          nome == "ExampleOfUseIoStdLib_IoInputContract.flux" ==> { stdin_file = "t_input_contract.txt" }
                                          _ ==> {}
                                    }
                                    mut as string: stem = nome
                                    route {
                                          nlen > 5 ==> {
                                                mut as string: sext = nome[(nlen - 4)..nlen]
                                                route {
                                                      sext == ".flux" ==> { stem = nome[1..(nlen - 5)] }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    mut as string: src_code = stdIoReadFile(path)
                                    mut as int64: src_len = stdCollectionLength(src_code)
                                    mut as bool: is_err = false
                                    route {
                                          src_len >= 17 ==> {
                                                mut as string: exp_pref = src_code[1..17]
                                                route {
                                                      exp_pref == "#L EXPECT_ERROR: " ==> { is_err = true }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    mut as bool: is_ok = false
                                    mut as string: out_vm = "t_fvmbc\\" + stem
                                    mut as string: fvmbc_file = "t_fvmbc\\" + stem + ".fvmbc"
                                    mut as string: cmd = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vm \"" + path + "\" -o \"" + out_vm + "\" --no-run < " + stdin_file + " > nul 2>&1\""
                                    mut as int64: rc = stdOsExec(cmd)
                                    route {
                                          is_err ==> { is_ok = (rc != 0) }
                                          _      ==> {
                                                route {
                                                      rc == 0 and stdIoFileExists(fvmbc_file) ==> { is_ok = true }
                                                      _ ==> { is_ok = false }
                                                }
                                          }
                                    }
                                    route {
                                          is_ok ==> {
                                                grand_certos = grand_certos + 1
                                                println("Certo --> " + rel_name)
                                          }
                                          _ ==> {
                                                grand_falhas = grand_falhas + 1
                                                println("Falha --> " + rel_name)
                                          }
                                    }
                                    cti = cti + 1
                              }
                        }
                  }
            }
            _ ==> {}
      }

      #L ==========================================================================
      #L SUÍTE 2: NUMERICAL RECIPES (--nr)
      #L ==========================================================================
      route {
            flag_nr ==> {
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
                  mut as int64: n_nr_chaps = 22
                  mut as int64: nri = 1
                  infinite {
                        route {
                              nri > n_nr_chaps ==> { break }
                              _ ==> {
                                    mut as string: chap = "" + nr_chap_dirs[nri]
                                    mut as string: chap_dir = "examples\\NumericalRecipes\\" + chap
                                    mut as list of data: nr_entries = stdIoListDir(chap_dir)
                                    mut as int64: n_nr_entries = stdCollectionLength(nr_entries)
                                    mut as list of data: nr_files = []
                                    mut as list of data: nr_files_lower = []
                                    mut as int64: n_nr = 0
                                    mut as int64: nei = 1
                                    infinite {
                                          route {
                                                nei > n_nr_entries ==> { break }
                                                _ ==> {
                                                      mut as string: fname = "" + nr_entries[nei]
                                                      mut as int64: fnlen = stdCollectionLength(fname)
                                                      route {
                                                            fnlen >= 5 ==> {
                                                                  mut as string: fext = fname[(fnlen - 4)..fnlen]
                                                                  route {
                                                                        fext == ".flux" ==> {
                                                                              mut as string: rel_name = chap + "\\" + fname
                                                                              mut as int64: rnlen = stdCollectionLength(rel_name)
                                                                              mut as string: rn_low = ""
                                                                              mut as int64: rni = 1
                                                                              infinite {
                                                                                    route {
                                                                                          rni > rnlen ==> { break }
                                                                                          _ ==> {
                                                                                                mut as string: rch = rel_name[rni]
                                                                                                route {
                                                                                                      rch == "A" ==> { rch = "a" }
                                                                                                      rch == "B" ==> { rch = "b" }
                                                                                                      rch == "C" ==> { rch = "c" }
                                                                                                      rch == "D" ==> { rch = "d" }
                                                                                                      rch == "E" ==> { rch = "e" }
                                                                                                      rch == "F" ==> { rch = "f" }
                                                                                                      rch == "G" ==> { rch = "g" }
                                                                                                      rch == "H" ==> { rch = "h" }
                                                                                                      rch == "I" ==> { rch = "i" }
                                                                                                      rch == "J" ==> { rch = "j" }
                                                                                                      rch == "K" ==> { rch = "k" }
                                                                                                      rch == "L" ==> { rch = "l" }
                                                                                                      rch == "M" ==> { rch = "m" }
                                                                                                      rch == "N" ==> { rch = "n" }
                                                                                                      rch == "O" ==> { rch = "o" }
                                                                                                      rch == "P" ==> { rch = "p" }
                                                                                                      rch == "Q" ==> { rch = "q" }
                                                                                                      rch == "R" ==> { rch = "r" }
                                                                                                      rch == "S" ==> { rch = "s" }
                                                                                                      rch == "T" ==> { rch = "t" }
                                                                                                      rch == "U" ==> { rch = "u" }
                                                                                                      rch == "V" ==> { rch = "v" }
                                                                                                      rch == "W" ==> { rch = "w" }
                                                                                                      rch == "X" ==> { rch = "x" }
                                                                                                      rch == "Y" ==> { rch = "y" }
                                                                                                      rch == "Z" ==> { rch = "z" }
                                                                                                      _ ==> {}
                                                                                                }
                                                                                                rn_low = rn_low + rch
                                                                                                rni = rni + 1
                                                                                          }
                                                                                    }
                                                                              }
                                                                              mut as bool: match_nr = false
                                                                              route {
                                                                                    filtro_lower == "" ==> { match_nr = true }
                                                                                    _ ==> {
                                                                                          route {
                                                                                                rnlen >= flen ==> {
                                                                                                      mut as int64: mi = 1
                                                                                                      infinite {
                                                                                                            route {
                                                                                                                  mi + flen - 1 > rnlen ==> { break }
                                                                                                                  _ ==> {
                                                                                                                        mut as string: sub = rn_low[mi..(mi + flen - 1)]
                                                                                                                        route {
                                                                                                                              sub == filtro_lower ==> {
                                                                                                                                    match_nr = true
                                                                                                                                    break
                                                                                                                              }
                                                                                                                              _ ==> { mi = mi + 1 }
                                                                                                                        }
                                                                                                                  }
                                                                                                            }
                                                                                                      }
                                                                                                }
                                                                                                _ ==> {}
                                                                                          }
                                                                                    }
                                                                              }
                                                                              route {
                                                                                    match_nr ==> {
                                                                                          n_nr = n_nr + 1
                                                                                          nr_files[n_nr] = fname
                                                                                          nr_files_lower[n_nr] = rn_low
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      nei = nei + 1
                                                }
                                          }
                                    }
                                    mut as int64: nsi = 1
                                    infinite {
                                          route {
                                                nsi >= n_nr ==> { break }
                                                _ ==> {
                                                      mut as int64: nsj = nsi + 1
                                                      infinite {
                                                            route {
                                                                  nsj > n_nr ==> { break }
                                                                  _ ==> {
                                                                        mut as string: a_low = "" + nr_files_lower[nsi]
                                                                        mut as string: b_low = "" + nr_files_lower[nsj]
                                                                        mut as bool: swap = false
                                                                        route {
                                                                              a_low > b_low ==> { swap = true }
                                                                              a_low == b_low ==> {
                                                                                    mut as string: a_orig = "" + nr_files[nsi]
                                                                                    mut as string: b_orig = "" + nr_files[nsj]
                                                                                    route {
                                                                                          a_orig > b_orig ==> { swap = true }
                                                                                          _ ==> {}
                                                                                    }
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                        route {
                                                                              swap ==> {
                                                                                    mut as data: tmp = nr_files[nsi]
                                                                                    nr_files[nsi] = nr_files[nsj]
                                                                                    nr_files[nsj] = tmp
                                                                                    mut as data: tmp_low = nr_files_lower[nsi]
                                                                                    nr_files_lower[nsi] = nr_files_lower[nsj]
                                                                                    nr_files_lower[nsj] = tmp_low
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                        nsj = nsj + 1
                                                                  }
                                                            }
                                                      }
                                                      nsi = nsi + 1
                                                }
                                          }
                                    }
                                    mut as int64: nti = 1
                                    infinite {
                                          route {
                                                nti > n_nr ==> { break }
                                                _ ==> {
                                                      mut as string: nome = "" + nr_files[nti]
                                                      mut as string: path = chap_dir + "\\" + nome
                                                      mut as string: rel_name = chap + "\\" + nome
                                                      mut as int64: nlen = stdCollectionLength(nome)
                                                      mut as string: stdin_file = "t_stdin.tmp"
                                                      mut as string: stem = nome
                                                      route {
                                                            nlen > 5 ==> {
                                                                  mut as string: sext = nome[(nlen - 4)..nlen]
                                                                  route {
                                                                        sext == ".flux" ==> { stem = nome[1..(nlen - 5)] }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      mut as string: src_code = stdIoReadFile(path)
                                                      mut as int64: src_len = stdCollectionLength(src_code)
                                                      mut as bool: is_err = false
                                                      route {
                                                            src_len >= 17 ==> {
                                                                  mut as string: exp_pref = src_code[1..17]
                                                                  route {
                                                                        exp_pref == "#L EXPECT_ERROR: " ==> { is_err = true }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      mut as bool: is_ok = false
                                                      mut as string: out_vm = "t_fvmbc\\" + stem
                                                      mut as string: fvmbc_file = "t_fvmbc\\" + stem + ".fvmbc"
                                                      mut as string: cmd = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vm \"" + path + "\" -o \"" + out_vm + "\" --no-run < " + stdin_file + " > nul 2>&1\""
                                                      mut as int64: rc = stdOsExec(cmd)
                                                      route {
                                                            is_err ==> { is_ok = (rc != 0) }
                                                            _      ==> {
                                                                  route {
                                                                        rc == 0 and stdIoFileExists(fvmbc_file) ==> { is_ok = true }
                                                                        _ ==> { is_ok = false }
                                                                  }
                                                            }
                                                      }
                                                      route {
                                                            is_ok ==> {
                                                                  grand_certos = grand_certos + 1
                                                                  println("Certo --> " + rel_name)
                                                            }
                                                            _ ==> {
                                                                  grand_falhas = grand_falhas + 1
                                                                  println("Falha --> " + rel_name)
                                                            }
                                                      }
                                                      nti = nti + 1
                                                }
                                          }
                                    }
                                    nri = nri + 1
                              }
                        }
                  }
            }
            _ ==> {}
      }

      #L ==========================================================================
      #L SUÍTE 3: SCIENTIFIC ALGORITHMS (--sa)
      #L ==========================================================================
      route {
            flag_sa ==> {
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
                  mut as int64: n_sa_doms = 13
                  mut as int64: sai = 1
                  infinite {
                        route {
                              sai > n_sa_doms ==> { break }
                              _ ==> {
                                    mut as string: dom = "" + sa_dom_dirs[sai]
                                    mut as string: dom_dir = "examples\\ScientificAlgorithms\\" + dom
                                    mut as list of data: sa_entries = stdIoListDir(dom_dir)
                                    mut as int64: n_sa_entries = stdCollectionLength(sa_entries)
                                    mut as list of data: sa_files = []
                                    mut as list of data: sa_files_lower = []
                                    mut as int64: n_sa = 0
                                    mut as int64: sei = 1
                                    infinite {
                                          route {
                                                sei > n_sa_entries ==> { break }
                                                _ ==> {
                                                      mut as string: fname = "" + sa_entries[sei]
                                                      mut as int64: fnlen = stdCollectionLength(fname)
                                                      route {
                                                            fnlen >= 5 ==> {
                                                                  mut as string: fext = fname[(fnlen - 4)..fnlen]
                                                                  route {
                                                                        fext == ".flux" ==> {
                                                                              mut as string: rel_name = dom + "\\" + fname
                                                                              mut as int64: rnlen = stdCollectionLength(rel_name)
                                                                              mut as string: rn_low = ""
                                                                              mut as int64: rni = 1
                                                                              infinite {
                                                                                    route {
                                                                                          rni > rnlen ==> { break }
                                                                                          _ ==> {
                                                                                                mut as string: rch = rel_name[rni]
                                                                                                route {
                                                                                                      rch == "A" ==> { rch = "a" }
                                                                                                      rch == "B" ==> { rch = "b" }
                                                                                                      rch == "C" ==> { rch = "c" }
                                                                                                      rch == "D" ==> { rch = "d" }
                                                                                                      rch == "E" ==> { rch = "e" }
                                                                                                      rch == "F" ==> { rch = "f" }
                                                                                                      rch == "G" ==> { rch = "g" }
                                                                                                      rch == "H" ==> { rch = "h" }
                                                                                                      rch == "I" ==> { rch = "i" }
                                                                                                      rch == "J" ==> { rch = "j" }
                                                                                                      rch == "K" ==> { rch = "k" }
                                                                                                      rch == "L" ==> { rch = "l" }
                                                                                                      rch == "M" ==> { rch = "m" }
                                                                                                      rch == "N" ==> { rch = "n" }
                                                                                                      rch == "O" ==> { rch = "o" }
                                                                                                      rch == "P" ==> { rch = "p" }
                                                                                                      rch == "Q" ==> { rch = "q" }
                                                                                                      rch == "R" ==> { rch = "r" }
                                                                                                      rch == "S" ==> { rch = "s" }
                                                                                                      rch == "T" ==> { rch = "t" }
                                                                                                      rch == "U" ==> { rch = "u" }
                                                                                                      rch == "V" ==> { rch = "v" }
                                                                                                      rch == "W" ==> { rch = "w" }
                                                                                                      rch == "X" ==> { rch = "x" }
                                                                                                      rch == "Y" ==> { rch = "y" }
                                                                                                      rch == "Z" ==> { rch = "z" }
                                                                                                      _ ==> {}
                                                                                                }
                                                                                                rn_low = rn_low + rch
                                                                                                rni = rni + 1
                                                                                          }
                                                                                    }
                                                                              }
                                                                              mut as bool: match_sa = false
                                                                              route {
                                                                                    filtro_lower == "" ==> { match_sa = true }
                                                                                    _ ==> {
                                                                                          route {
                                                                                                rnlen >= flen ==> {
                                                                                                      mut as int64: mi = 1
                                                                                                      infinite {
                                                                                                            route {
                                                                                                                  mi + flen - 1 > rnlen ==> { break }
                                                                                                                  _ ==> {
                                                                                                                        mut as string: sub = rn_low[mi..(mi + flen - 1)]
                                                                                                                        route {
                                                                                                                              sub == filtro_lower ==> {
                                                                                                                                    match_sa = true
                                                                                                                                    break
                                                                                                                              }
                                                                                                                              _ ==> { mi = mi + 1 }
                                                                                                                        }
                                                                                                                  }
                                                                                                            }
                                                                                                      }
                                                                                                }
                                                                                                _ ==> {}
                                                                                          }
                                                                                    }
                                                                              }
                                                                              route {
                                                                                    match_sa ==> {
                                                                                          n_sa = n_sa + 1
                                                                                          sa_files[n_sa] = fname
                                                                                          sa_files_lower[n_sa] = rn_low
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      sei = sei + 1
                                                }
                                          }
                                    }
                                    mut as int64: ssi = 1
                                    infinite {
                                          route {
                                                ssi >= n_sa ==> { break }
                                                _ ==> {
                                                      mut as int64: ssj = ssi + 1
                                                      infinite {
                                                            route {
                                                                  ssj > n_sa ==> { break }
                                                                  _ ==> {
                                                                        mut as string: a_low = "" + sa_files_lower[ssi]
                                                                        mut as string: b_low = "" + sa_files_lower[ssj]
                                                                        mut as bool: swap = false
                                                                        route {
                                                                              a_low > b_low ==> { swap = true }
                                                                              a_low == b_low ==> {
                                                                                    mut as string: a_orig = "" + sa_files[ssi]
                                                                                    mut as string: b_orig = "" + sa_files[ssj]
                                                                                    route {
                                                                                          a_orig > b_orig ==> { swap = true }
                                                                                          _ ==> {}
                                                                                    }
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                        route {
                                                                              swap ==> {
                                                                                    mut as data: tmp = sa_files[ssi]
                                                                                    sa_files[ssi] = sa_files[ssj]
                                                                                    sa_files[ssj] = tmp
                                                                                    mut as data: tmp_low = sa_files_lower[ssi]
                                                                                    sa_files_lower[ssi] = sa_files_lower[ssj]
                                                                                    sa_files_lower[ssj] = tmp_low
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                        ssj = ssj + 1
                                                                  }
                                                            }
                                                      }
                                                      ssi = ssi + 1
                                                }
                                          }
                                    }
                                    mut as int64: sti = 1
                                    infinite {
                                          route {
                                                sti > n_sa ==> { break }
                                                _ ==> {
                                                      mut as string: nome = "" + sa_files[sti]
                                                      mut as string: path = dom_dir + "\\" + nome
                                                      mut as string: rel_name = dom + "\\" + nome
                                                      mut as int64: nlen = stdCollectionLength(nome)
                                                      mut as string: stdin_file = "t_stdin.tmp"
                                                      mut as string: stem = nome
                                                      route {
                                                            nlen > 5 ==> {
                                                                  mut as string: sext = nome[(nlen - 4)..nlen]
                                                                  route {
                                                                        sext == ".flux" ==> { stem = nome[1..(nlen - 5)] }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      mut as string: src_code = stdIoReadFile(path)
                                                      mut as int64: src_len = stdCollectionLength(src_code)
                                                      mut as bool: is_err = false
                                                      route {
                                                            src_len >= 17 ==> {
                                                                  mut as string: exp_pref = src_code[1..17]
                                                                  route {
                                                                        exp_pref == "#L EXPECT_ERROR: " ==> { is_err = true }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      mut as bool: is_ok = false
                                                      mut as string: out_vm = "t_fvmbc\\" + stem
                                                      mut as string: fvmbc_file = "t_fvmbc\\" + stem + ".fvmbc"
                                                      mut as string: cmd = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vm \"" + path + "\" -o \"" + out_vm + "\" --no-run < " + stdin_file + " > nul 2>&1\""
                                                      mut as int64: rc = stdOsExec(cmd)
                                                      route {
                                                            is_err ==> { is_ok = (rc != 0) }
                                                            _      ==> {
                                                                  route {
                                                                        rc == 0 and stdIoFileExists(fvmbc_file) ==> { is_ok = true }
                                                                        _ ==> { is_ok = false }
                                                                  }
                                                            }
                                                      }
                                                      route {
                                                            is_ok ==> {
                                                                  grand_certos = grand_certos + 1
                                                                  println("Certo --> " + rel_name)
                                                            }
                                                            _ ==> {
                                                                  grand_falhas = grand_falhas + 1
                                                                  println("Falha --> " + rel_name)
                                                            }
                                                      }
                                                      sti = sti + 1
                                                }
                                          }
                                    }
                                    sai = sai + 1
                              }
                        }
                  }
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
      mut as list of data: cl_fin_root_tmps = ["t_stdin.tmp", "t_input_interactive.txt", "t_input_contract.txt", "t_in.tmp", "t_vm.tmp", "t_vm_c.tmp", "t_vmr.tmp", "t_lv.tmp", "t_lv_c.tmp", "t_wat.tmp", "t_wat_c.tmp", "t_was.tmp", "t_was_c.tmp"]
      mut as int64: cl_fin_ri = 1
      infinite {
            route {
                  cl_fin_ri > 13 ==> { break }
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

      #L 8. Totalizador final em 2 linhas e codigo de saida
      println("")
      println("Certos: " + grand_certos)
      println("Falhas: " + grand_falhas)
      route {
            grand_falhas == 0 ==> { stdOsExit(0) }
            _                 ==> { stdOsExit(1) }
      }
}
