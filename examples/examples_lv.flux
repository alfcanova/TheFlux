#L ==============================================================================
#L TheFlux Runner: Examples LV (LLVM Backend)
#L Arquivo: examples/examples_lv.flux
#L ==============================================================================

use RuntimeStdLib
use IoStdLib
use OsStdLib

program (ExamplesLv) {
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

      stdOsExec("cmd /c if not exist t_llvm mkdir t_llvm")
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
                                                mut as int64: nlen = stdCollectionLength(nome)
                                                mut as string: stem = nome[1..(nlen - 5)]

                                                println("--- " + nome + " ---")

                                                mut as string: stdin_file = "t_stdin_empty.tmp"
                                                route {
                                                      nome == "input.flux" ==> { stdin_file = "t_stdin_dado.tmp" }
                                                      nome == "ExampleOfInput.flux" ==> { stdin_file = "t_stdin_interactive.tmp" }
                                                      nome == "ExampleOfUseIoStdLib_IoInputContract.flux" ==> { stdin_file = "t_stdin_contract.tmp" }
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

                                                mut as string: out_stem = "t_llvm\\" + stem
                                                mut as string: ll_file = "t_llvm\\" + stem + ".ll"
                                                mut as string: exe_file = "t_llvm\\" + stem + ".exe"

                                                mut as string: cmd_lv_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target lv " + filepath + " -o " + out_stem + " --no-run < " + stdin_file + " > t_lv_c.tmp 2>&1\""
                                                mut as int64: rc_c = stdOsExec(cmd_lv_c)

                                                mut as string: c_out = stdIoReadFile("t_lv_c.tmp")
                                                mut as int64: c_len = stdCollectionLength(c_out)

                                                mut as string: c_last_line = ""
                                                mut as int64: ci = 1
                                                mut as string: cur_chunk = ""
                                                infinite {
                                                      route {
                                                            ci > c_len ==> { break }
                                                            _ ==> {
                                                                  mut as string: ch_c = c_out[ci..ci]
                                                                  route {
                                                                        ch_c == "\r" ==> {}
                                                                        ch_c == "\n" ==> {
                                                                              route {
                                                                                    cur_chunk != "" ==> { c_last_line = cur_chunk }
                                                                                    _ ==> {}
                                                                              }
                                                                              cur_chunk = ""
                                                                        }
                                                                        _ ==> {
                                                                              cur_chunk = cur_chunk + ch_c
                                                                        }
                                                                  }
                                                                  ci = ci + 1
                                                            }
                                                      }
                                                }
                                                route {
                                                      cur_chunk != "" ==> { c_last_line = cur_chunk }
                                                      _ ==> {}
                                                }

                                                route {
                                                      rc_c != 0 ==> {
                                                            erros = erros + 1
                                                            println("FALHA  " + nome + " (LLVM IR): " + c_last_line)
                                                      }
                                                      not stdIoFileExists(ll_file) ==> {
                                                            erros = erros + 1
                                                            println("FALHA  " + nome + " (.ll nao gerado)")
                                                      }
                                                      _ ==> {
                                                            println("  [ir]   " + stem + ".ll")

                                                            route {
                                                                  not stdIoFileExists(exe_file) ==> {
                                                                        erros = erros + 1
                                                                        println("FALHA  " + nome + " (clang nao encontrado ou executavel nao gerado)")
                                                                  }
                                                                  _ ==> {
                                                                        println("  [exe]  " + stem + ".exe")

                                                                        mut as string: cmd_run = "cmd /c \"set FLUX_CI=1 && " + exe_file + " < " + stdin_file + " > t_lv.tmp 2>&1\""
                                                                        mut as int64: rc_run = stdOsExec(cmd_run)

                                                                        mut as string: r_out = stdIoReadFile("t_lv.tmp")
                                                                        mut as int64: r_len = stdCollectionLength(r_out)

                                                                        route {
                                                                              rc_run == 0 ==> {
                                                                                    acertos = acertos + 1
                                                                                    ci = 1
                                                                                    cur_chunk = ""
                                                                                    infinite {
                                                                                          route {
                                                                                                ci > r_len ==> { break }
                                                                                                _ ==> {
                                                                                                      mut as string: ch_r = r_out[ci..ci]
                                                                                                      route {
                                                                                                            ch_r == "\r" ==> {}
                                                                                                            ch_r == "\n" ==> {
                                                                                                                  println("  | " + cur_chunk)
                                                                                                                  cur_chunk = ""
                                                                                                            }
                                                                                                            _ ==> {
                                                                                                                  cur_chunk = cur_chunk + ch_r
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
                                                                                    println("  OK    " + nome)
                                                                              }
                                                                              _ ==> {
                                                                                    erros = erros + 1
                                                                                    mut as string: r_last = ""
                                                                                    ci = 1
                                                                                    cur_chunk = ""
                                                                                    infinite {
                                                                                          route {
                                                                                                ci > r_len ==> { break }
                                                                                                _ ==> {
                                                                                                      mut as string: ch_r = r_out[ci..ci]
                                                                                                      route {
                                                                                                            ch_r == "\r" ==> {}
                                                                                                            ch_r == "\n" ==> {
                                                                                                                  route {
                                                                                                                        cur_chunk != "" ==> { r_last = cur_chunk }
                                                                                                                        _ ==> {}
                                                                                                                  }
                                                                                                                  cur_chunk = ""
                                                                                                            }
                                                                                                            _ ==> {
                                                                                                                  cur_chunk = cur_chunk + ch_r
                                                                                                            }
                                                                                                      }
                                                                                                      ci = ci + 1
                                                                                                }
                                                                                          }
                                                                                    }
                                                                                    route {
                                                                                          cur_chunk != "" ==> { r_last = cur_chunk }
                                                                                          _ ==> {}
                                                                                    }
                                                                                    route {
                                                                                          r_last == "" ==> { r_last = "(exit code " + rc_run + ")" }
                                                                                          _ ==> {}
                                                                                    }
                                                                                    println("FALHA  " + nome + ": " + r_last)
                                                                              }
                                                                        }
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

      stdOsExec("cmd /c del /q /f t_stdin_*.tmp t_lv_c.tmp t_lv.tmp t_canon_list.tmp 2>nul")

      println("")
      println("" + acertos + " sucesso, " + erros + " falha(s)")

      route {
            erros == 0 ==> { stdOsExit(0) }
            _ ==> { stdOsExit(1) }
      }
}
