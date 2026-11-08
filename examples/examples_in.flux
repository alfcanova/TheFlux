#L ==============================================================================
#L TheFlux Runner: Examples IN (Interpretador)
#L Arquivo: examples/examples_in.flux
#L ==============================================================================

use RuntimeStdLib
use IoStdLib
use OsStdLib

program (ExamplesIn) {
      mut as string: fluxc_bin = ".\\bin\\fluxc.exe"
      route {
            stdIoFileExists(".\\bin\\fluxc.exe") ==> { fluxc_bin = ".\\bin\\fluxc.exe" }
            stdIoFileExists("bin\\fluxc.exe")    ==> { fluxc_bin = "bin\\fluxc.exe" }
            stdIoFileExists("..\\bin\\fluxc.exe")==> { fluxc_bin = "..\\bin\\fluxc.exe" }
            stdIoFileExists("fluxc.exe")        ==> { fluxc_bin = "fluxc.exe" }
            _                                    ==> { fluxc_bin = "fluxc" }
      }

      mut as string: canon_dir = "examples\\Canon"
      route {
            stdIoFileExists("examples\\Canon") ==> { canon_dir = "examples\\Canon" }
            stdIoFileExists(".\\examples\\Canon") ==> { canon_dir = ".\\examples\\Canon" }
            stdIoFileExists("..\\examples\\Canon") ==> { canon_dir = "..\\examples\\Canon" }
            stdIoFileExists("Canon") ==> { canon_dir = "Canon" }
            _ ==> { canon_dir = "examples\\Canon" }
      }

      stdOsExec("cmd /c if not exist dbs mkdir dbs")

      stdIoWriteFile("t_stdin_interactive.tmp", "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n")
      stdIoWriteFile("t_stdin_contract.tmp", "andre\nluiz\n")
      stdIoWriteFile("t_stdin_dado.tmp", "dado\n")
      stdIoWriteFile("t_stdin_empty.tmp", "")

      stdOsExec("cmd /c dir /b /on " + canon_dir + "\\*.flux > t_canon_list.tmp")
      mut as string: list_content = stdIoReadFile("t_canon_list.tmp")
      mut as int64: lclen = stdCollectionLength(list_content)
      route {
            lclen > 0 and list_content[lclen..lclen] != "\n" ==> {
                  list_content = list_content + "\n"
                  lclen = lclen + 1
            }
            _ ==> {}
      }

      mut as int64: acertos = 0
      mut as int64: erros = 0

      mut as string: cur_fname = ""
      mut as int64: li = 1
      infinite {
            route {
                  li > lclen ==> { break }
                  _ ==> {
                        mut as string: ch = list_content[li..li]
                        route {
                              ch == "\r" ==> {}
                              ch == "\n" ==> {
                                    route {
                                          cur_fname != "" ==> {
                                                mut as string: nome = cur_fname
                                                mut as string: filepath = canon_dir + "\\" + nome

                                                mut as string: stdin_file = "t_stdin_empty.tmp"
                                                route {
                                                      nome == "input.flux" ==> { stdin_file = "t_stdin_dado.tmp" }
                                                      nome == "ExampleOfInput.flux" ==> { stdin_file = "t_stdin_interactive.tmp" }
                                                      nome == "ExampleOfUseIoStdLib_IoInputContract.flux" ==> { stdin_file = "t_stdin_contract.tmp" }
                                                      _ ==> {}
                                                }

                                                mut as int64: nlen = stdCollectionLength(nome)
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

                                                mut as string: expected_code = ""
                                                mut as string: tag_err = "#L EXPECT_ERROR:"
                                                mut as int64: tag_len = stdCollectionLength(tag_err)
                                                mut as string: src_content = stdIoReadFile(filepath)
                                                mut as int64: slen = stdCollectionLength(src_content)
                                                route {
                                                      slen >= tag_len ==> {
                                                            mut as int64: si = 1
                                                            infinite {
                                                                  route {
                                                                        si + tag_len - 1 > slen ==> { break }
                                                                        src_content[si..(si + tag_len - 1)] == tag_err ==> {
                                                                              mut as int64: ri = si + tag_len
                                                                              infinite {
                                                                                    route {
                                                                                          ri > slen ==> { break }
                                                                                          src_content[ri..ri] == " " or src_content[ri..ri] == "\t" ==> { ri = ri + 1 }
                                                                                          _ ==> { break }
                                                                                    }
                                                                              }
                                                                              mut as string: tok = ""
                                                                              infinite {
                                                                                    route {
                                                                                          ri > slen ==> { break }
                                                                                          src_content[ri..ri] == " " or src_content[ri..ri] == "\t" or src_content[ri..ri] == "\r" or src_content[ri..ri] == "\n" ==> { break }
                                                                                          _ ==> {
                                                                                                tok = tok + src_content[ri..ri]
                                                                                                ri = ri + 1
                                                                                          }
                                                                                    }
                                                                              }
                                                                              expected_code = tok
                                                                              route {
                                                                                    stdCollectionLength(expected_code) >= 2 and expected_code[1..2] == "RT" ==> {
                                                                                          expected_code = ""
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                              break
                                                                        }
                                                                        _ ==> { si = si + 1 }
                                                                  }
                                                            }
                                                      }
                                                      _ ==> {}
                                                }

                                                mut as string: cmd_in = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target in " + filepath + " < " + stdin_file + " > t_in.tmp 2>&1\""
                                                mut as int64: ec = stdOsExec(cmd_in)

                                                mut as string: out_full = stdIoReadFile("t_in.tmp")
                                                mut as int64: out_len = stdCollectionLength(out_full)

                                                #L Extract last non-empty line
                                                mut as string: last_line = ""
                                                mut as int64: ci = 1
                                                mut as string: cur_chunk = ""
                                                infinite {
                                                      route {
                                                            ci > out_len ==> { break }
                                                            _ ==> {
                                                                  mut as string: ch_out = out_full[ci..ci]
                                                                  route {
                                                                        ch_out == "\r" ==> {}
                                                                        ch_out == "\n" ==> {
                                                                              route {
                                                                                    cur_chunk != "" ==> { last_line = cur_chunk }
                                                                                    _ ==> {}
                                                                              }
                                                                              cur_chunk = ""
                                                                        }
                                                                        _ ==> {
                                                                              cur_chunk = cur_chunk + ch_out
                                                                        }
                                                                  }
                                                                  ci = ci + 1
                                                            }
                                                      }
                                                }
                                                route {
                                                      cur_chunk != "" ==> { last_line = cur_chunk }
                                                      _ ==> {}
                                                }
                                                mut as string: error_msg = last_line
                                                route {
                                                      error_msg == "" ==> { error_msg = "Sem erro emitido" }
                                                      _ ==> {}
                                                }

                                                route {
                                                      expected_code != "" ==> {
                                                            mut as bool: match_code = false
                                                            mut as bool: match_dica = false
                                                            mut as string: code_needle = "[" + expected_code + " - "
                                                            mut as int64: cn_len = stdCollectionLength(code_needle)

                                                            route {
                                                                  out_len >= cn_len ==> {
                                                                        mut as int64: msi = 1
                                                                        infinite {
                                                                              route {
                                                                                    msi + cn_len - 1 > out_len ==> { break }
                                                                                    out_full[msi..(msi + cn_len - 1)] == code_needle ==> {
                                                                                          match_code = true
                                                                                          break
                                                                                    }
                                                                                    _ ==> { msi = msi + 1 }
                                                                              }
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                            route {
                                                                  out_len >= 5 ==> {
                                                                        mut as int64: msi = 1
                                                                        infinite {
                                                                              route {
                                                                                    msi + 4 > out_len ==> { break }
                                                                                    out_full[msi..(msi + 4)] == "Dica:" ==> {
                                                                                          match_dica = true
                                                                                          break
                                                                                    }
                                                                                    _ ==> { msi = msi + 1 }
                                                                              }
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }

                                                            route {
                                                                  ec != 0 and match_code and match_dica ==> {
                                                                        erros = erros + 1
                                                                        println("FALHA  " + nome + ": " + error_msg)
                                                                  }
                                                                  _ ==> {
                                                                        erros = erros + 1
                                                                        println("FALHA  " + nome + ": " + error_msg)
                                                                  }
                                                            }
                                                      }
                                                      _ ==> {
                                                            route {
                                                                  ec == 0 ==> {
                                                                        acertos = acertos + 1
                                                                        #L Print output lines with prefix
                                                                        ci = 1
                                                                        cur_chunk = ""
                                                                        infinite {
                                                                              route {
                                                                                    ci > out_len ==> { break }
                                                                                    _ ==> {
                                                                                          mut as string: ch_out = out_full[ci..ci]
                                                                                          route {
                                                                                                ch_out == "\r" ==> {}
                                                                                                ch_out == "\n" ==> {
                                                                                                      println("  | " + cur_chunk)
                                                                                                      cur_chunk = ""
                                                                                                }
                                                                                                _ ==> {
                                                                                                      cur_chunk = cur_chunk + ch_out
                                                                                                }
                                                                                          }
                                                                                          ci = ci + 1
                                                                                    }
                                                                              }
                                                                        }
                                                                        route {
                                                                              cur_chunk != "" ==> { println("  | " + cur_chunk) }
                                                                              _ ==> {}
                                                                        }
                                                                        println("  OK  " + nome)
                                                                  }
                                                                  _ ==> {
                                                                        erros = erros + 1
                                                                        println("FALHA  " + nome + ": " + error_msg)
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    cur_fname = ""
                              }
                              _ ==> {
                                    cur_fname = cur_fname + ch
                              }
                        }
                        li = li + 1
                  }
            }
      }

      stdOsExec("cmd /c del /q /f t_stdin_*.tmp t_in.tmp t_canon_list.tmp 2>nul")

      println("")
      println("" + acertos + " sucesso, " + erros + " falha(s)")

      route {
            erros == 0 ==> { stdOsExit(0) }
            _ ==> { stdOsExit(1) }
      }
}
