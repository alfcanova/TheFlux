#L ==============================================================================
#L TheFlux Runner: Exemplos WAT (Compilação WebAssembly Text e Execução Wasmer)
#L Arquivo: exemplos_wat.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib
use IoStdLib

program (ExemplosWat) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)

      #L 1. Garante existencia da pasta t_wat e cria arquivos de stdin estaticos
      stdIoCreateDir("t_wat")
      stdIoWriteFile("t_wat\\_input_interactive.txt", "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n")
      stdIoWriteFile("t_wat\\_input_contract.txt", "andre\nluiz\n")

      #L 2. Localizacao dinamica do binario fluxc
      mut as string: fluxc_bin = ".\\bin\\fluxc.exe"
      route {
            stdIoFileExists(".\\bin\\fluxc.exe") ==> { fluxc_bin = ".\\bin\\fluxc.exe" }
            stdIoFileExists("bin\\fluxc.exe")    ==> { fluxc_bin = "bin\\fluxc.exe" }
            stdIoFileExists("fluxc.exe")        ==> { fluxc_bin = "fluxc.exe" }
            _                                    ==> { fluxc_bin = "fluxc" }
      }

      #L 3. Coleta de filtro opcional de linha de comando
      mut as string: filtro = ""
      mut as int64: ai = 1
      infinite {
            route {
                  ai > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[ai]
                        mut as bool: is_self = (a == "exemplos_wat.flux" or a == ".\\exemplos_wat.flux" or a == "./exemplos_wat.flux" or a == "exemplos_wat.exe" or a == ".\\exemplos_wat.exe" or a == "bin\\exemplos_wat.exe" or a == ".\\bin\\exemplos_wat.exe" or a == "--")
                        route {
                              is_self ==> {}
                              _ ==> {
                                    mut as int64: alen = stdCollectionLength(a)
                                    route {
                                          alen > 0 and a[1] != "-" ==> {
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

      #L 4. Listagem de todos os arquivos na pasta flux/
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
                                                            #L Converte fname para minusculo e verifica substring
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

      #L 5. Ordenacao deterministica (A-Z)
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

      #L 6. Execucao de cada arquivo de teste
      mut as int64: acertos = 0
      mut as int64: erros = 0
      mut as int64: ti = 1
      infinite {
            route {
                  ti > n_flux ==> { break }
                  _ ==> {
                        mut as string: nome = "" + flux_files[ti]
                        mut as string: path = "flux\\" + nome
                        mut as int64: nlen = stdCollectionLength(nome)

                        #L Extrai o stem do arquivo (sem extensao .flux)
                        mut as string: stem = nome
                        route {
                              nlen > 5 and nome[(nlen - 4)..nlen] == ".flux" ==> {
                                    stem = nome[1..(nlen - 5)]
                              }
                              _ ==> {}
                        }
                        mut as string: out_target = "t_wat\\" + stem

                        #L 6.1 Limpeza de DBs scratch para testes DbStdLib
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

                        #L 6.2 Montagem do comando chamando bin/fluxc.exe --target wat com --no-run
                        mut as string: cmd = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target wat \"" + path + "\" -o \"" + out_target + "\" --no-run\""

                        #L 6.3 Execucao da compilacao
                        mut as int64: rc = stdOsExec(cmd)

                        #L 6.4 Classificacao e execucao via wasmer run
                        mut as string: src_code = stdIoReadFile(path)
                        mut as int64: src_len = stdCollectionLength(src_code)
                        mut as bool: has_exp_err = false
                        route {
                              src_len >= 17 ==> {
                                    mut as string: exp_pref = src_code[1..17]
                                    route {
                                          exp_pref == "#L EXPECT_ERROR: " ==> {
                                                has_exp_err = true
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }

                        route {
                              has_exp_err ==> {
                                    route {
                                          rc != 0 ==> {
                                                acertos = acertos + 1
                                                println("  OK  " + nome)
                                          }
                                          _ ==> {
                                                erros = erros + 1
                                                println("FALHA  " + nome + ": esperava erro")
                                          }
                                    }
                              }
                              _ ==> {
                                    route {
                                          rc != 0 ==> {
                                                erros = erros + 1
                                                println("FALHA  " + nome + ": erro na compilacao")
                                          }
                                          _ ==> {
                                                mut as string: wat_file = out_target + ".wat"
                                                mut as bool: wat_exists = stdIoFileExists(wat_file)
                                                route {
                                                      not wat_exists ==> {
                                                            erros = erros + 1
                                                            println("FALHA  " + nome + ": .wat nao gerado")
                                                      }
                                                      _ ==> {
                                                            #L 6.5 Execucao direta do bytecode WebAssembly com wasmer run
                                                            mut as string: run_cmd = ""
                                                            route {
                                                                  nome == "ExampleOfInput.flux" ==> {
                                                                        run_cmd = "cmd /c \"type t_wat\\_input_interactive.txt | wasmer run \"" + wat_file + "\"\""
                                                                  }
                                                                  nome == "ExampleOfUseIoStdLib_IoInputContract.flux" ==> {
                                                                        run_cmd = "cmd /c \"type t_wat\\_input_contract.txt | wasmer run \"" + wat_file + "\"\""
                                                                  }
                                                                  _ ==> {
                                                                        run_cmd = "cmd /c \"wasmer run \"" + wat_file + "\"\""
                                                                  }
                                                            }
                                                            mut as int64: run_rc = stdOsExec(run_cmd)
                                                            route {
                                                                  run_rc == 0 ==> {
                                                                        acertos = acertos + 1
                                                                        println("  OK  " + nome)
                                                                  }
                                                                  _ ==> {
                                                                        erros = erros + 1
                                                                        println("FALHA  " + nome + ": erro na execucao com wasmer")
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }

                        ti = ti + 1
                  }
            }
      }

      #L 7. Relatorio consolidado e codigo de saida
      println("")
      println("" + acertos + " sucesso, " + erros + " falha(s)")
      route {
            erros == 0 ==> { stdOsExit(0) }
            _           ==> { stdOsExit(1) }
      }
}
