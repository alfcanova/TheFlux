#L ==============================================================================
#L TheFlux Runner: Examples WAT (WebAssembly Textual Compiler)
#L Arquivo: examples/examples_wat.flux
#L ==============================================================================

use RuntimeStdLib
use IoStdLib
use OsStdLib

program (ExamplesWat) {
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

      stdOsExec("cmd /c if not exist t_wat mkdir t_wat")

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

                                                mut as string: stdin_file = "t_stdin_empty.tmp"
                                                route {
                                                      nome == "input.flux" ==> { stdin_file = "t_stdin_dado.tmp" }
                                                      nome == "ExampleOfInput.flux" ==> { stdin_file = "t_stdin_interactive.tmp" }
                                                      nome == "ExampleOfUseIoStdLib_IoInputContract.flux" ==> { stdin_file = "t_stdin_contract.tmp" }
                                                      _ ==> {}
                                                }

                                                mut as string: out_stem = "t_wat\\" + stem
                                                mut as string: wat_file = "t_wat\\" + stem + ".wat"

                                                mut as string: cmd_wat_c = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target wat " + filepath + " -o " + out_stem + " --no-run < " + stdin_file + " > t_wat_c.tmp 2>&1\""
                                                mut as int64: rc = stdOsExec(cmd_wat_c)

                                                mut as string: out_full = stdIoReadFile("t_wat_c.tmp")
                                                mut as int64: out_len = stdCollectionLength(out_full)

                                                route {
                                                      rc != 0 ==> {
                                                            erros = erros + 1
                                                            mut as string: last_line = ""
                                                            mut as int64: ci = 1
                                                            mut as string: cur_chunk = ""
                                                            infinite {
                                                                  route {
                                                                        ci > out_len ==> { break }
                                                                        _ ==> {
                                                                              mut as string: ch_o = out_full[ci..ci]
                                                                              route {
                                                                                    ch_o == "\r" ==> {}
                                                                                    ch_o == "\n" ==> {
                                                                                          route {
                                                                                                cur_chunk != "" ==> { last_line = cur_chunk }
                                                                                                _ ==> {}
                                                                                          }
                                                                                          cur_chunk = ""
                                                                                    }
                                                                                    _ ==> {
                                                                                          cur_chunk = cur_chunk + ch_o
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
                                                            route {
                                                                  last_line == "" ==> { last_line = "Sem erro emitido" }
                                                                  _ ==> {}
                                                            }
                                                            println("FALHA  " + nome + ": " + last_line)
                                                      }
                                                      _ ==> {
                                                            #L Print lines starting with WAT
                                                            mut as int64: ci = 1
                                                            mut as string: cur_chunk = ""
                                                            infinite {
                                                                  route {
                                                                        ci > out_len ==> { break }
                                                                        _ ==> {
                                                                              mut as string: ch_o = out_full[ci..ci]
                                                                              route {
                                                                                    ch_o == "\r" ==> {}
                                                                                    ch_o == "\n" ==> {
                                                                                          mut as int64: chk_len = stdCollectionLength(cur_chunk)
                                                                                          route {
                                                                                                chk_len >= 3 ==> {
                                                                                                      route {
                                                                                                            cur_chunk[1..3] == "WAT" ==> {
                                                                                                                  println("  " + cur_chunk)
                                                                                                            }
                                                                                                            _ ==> {}
                                                                                                      }
                                                                                                }
                                                                                                _ ==> {}
                                                                                          }
                                                                                          cur_chunk = ""
                                                                                    }
                                                                                    _ ==> {
                                                                                          cur_chunk = cur_chunk + ch_o
                                                                                    }
                                                                              }
                                                                              ci = ci + 1
                                                                        }
                                                                  }
                                                            }
                                                            mut as int64: chk_len = stdCollectionLength(cur_chunk)
                                                            route {
                                                                  chk_len >= 3 ==> {
                                                                        route {
                                                                              cur_chunk[1..3] == "WAT" ==> {
                                                                                    println("  " + cur_chunk)
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }

                                                            route {
                                                                  stdIoFileExists(wat_file) ==> {
                                                                        println("  [wat]  " + stem + ".wat")
                                                                        acertos = acertos + 1
                                                                        println("  OK    " + nome)
                                                                  }
                                                                  _ ==> {
                                                                        erros = erros + 1
                                                                        println("FALHA  " + nome + ": .wat nao gerado")
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

      stdOsExec("cmd /c del /q /f t_stdin_*.tmp t_wat_c.tmp t_canon_list.tmp 2>nul")

      println("")
      println("" + acertos + " sucesso, " + erros + " falha(s)")

      route {
            erros == 0 ==> { stdOsExit(0) }
            _ ==> { stdOsExit(1) }
      }
}
