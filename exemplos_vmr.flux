#L ==============================================================================
#L TheFlux Runner: Exemplos VMR (Execução da Suíte Canônica pela VM TheFlux)
#L Arquivo: exemplos_vmr.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib
use IoStdLib

program (ExemplosVmr) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)

      #L 1. Garante existencia da pasta t_fvmbc e cria arquivos de stdin estaticos
      stdIoCreateDir("t_fvmbc")
      stdIoWriteFile("t_fvmbc\\_input_interactive.txt", "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n")
      stdIoWriteFile("t_fvmbc\\_input_contract.txt", "andre\nluiz\n")

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
                        mut as bool: is_self = (a == "exemplos_vmr.flux" or a == ".\\exemplos_vmr.flux" or a == "./exemplos_vmr.flux" or a == "exemplos_vmr.exe" or a == ".\\exemplos_vmr.exe" or a == "bin\\exemplos_vmr.exe" or a == ".\\bin\\exemplos_vmr.exe" or a == "--")
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

      #L 4. Listagem de todos os arquivos de bytecode na pasta t_fvmbc/
      mut as list of data: entries = stdIoListDir("t_fvmbc")
      mut as int64: total_entries = stdCollectionLength(entries)
      mut as list of data: fvmbc_files = []
      mut as int64: n_files = 0
      mut as int64: ei = 1
      infinite {
            route {
                  ei > total_entries ==> { break }
                  _ ==> {
                        mut as string: fname = "" + entries[ei]
                        mut as int64: fn_len = stdCollectionLength(fname)
                        route {
                              fn_len >= 6 ==> {
                                    mut as string: ext = fname[(fn_len - 5)..fn_len]
                                    route {
                                          ext == ".fvmbc" ==> {
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
                                                            n_files = n_files + 1
                                                            fvmbc_files[n_files] = fname
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
                  si >= n_files ==> { break }
                  _ ==> {
                        mut as int64: sj = si + 1
                        infinite {
                              route {
                                    sj > n_files ==> { break }
                                    _ ==> {
                                          mut as string: a_str = "" + fvmbc_files[si]
                                          mut as string: b_str = "" + fvmbc_files[sj]
                                          route {
                                                a_str > b_str ==> {
                                                      mut as data: tmp = fvmbc_files[si]
                                                      fvmbc_files[si] = fvmbc_files[sj]
                                                      fvmbc_files[sj] = tmp
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

      #L 6. Execucao de cada arquivo de bytecode diretamente com bin/fluxc.exe --target vmr
      mut as int64: acertos = 0
      mut as int64: erros = 0
      mut as int64: ti = 1
      infinite {
            route {
                  ti > n_files ==> { break }
                  _ ==> {
                        mut as string: nome = "" + fvmbc_files[ti]
                        mut as string: path = "t_fvmbc\\" + nome
                        mut as int64: nlen = stdCollectionLength(nome)

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

                        #L 6.2 Montagem do comando chamando bin/fluxc.exe --target vmr
                        mut as string: cmd = ""
                        route {
                              nome == "ExampleOfInput.fvmbc" ==> {
                                    cmd = "cmd /c \"set FLUX_CI=1 && type t_fvmbc\\_input_interactive.txt | " + fluxc_bin + " --target vmr \"" + path + "\"\""
                              }
                              nome == "ExampleOfUseIoStdLib_IoInputContract.fvmbc" ==> {
                                    cmd = "cmd /c \"set FLUX_CI=1 && type t_fvmbc\\_input_contract.txt | " + fluxc_bin + " --target vmr \"" + path + "\"\""
                              }
                              _ ==> {
                                    cmd = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vmr \"" + path + "\"\""
                              }
                        }

                        #L 6.3 Execucao
                        mut as int64: rc = stdOsExec(cmd)

                        #L 6.4 Validacao do resultado
                        route {
                              rc == 0 ==> {
                                    acertos = acertos + 1
                                    println("  OK  " + nome)
                              }
                              _ ==> {
                                    erros = erros + 1
                                    println("FALHA  " + nome)
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
