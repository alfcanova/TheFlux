#L ==============================================================================
#L TheFlux Runner: Examples VMR (Bytecode VM Runtime)
#L Arquivo: examples/examples_vmr.flux
#L ==============================================================================

use RuntimeStdLib
use IoStdLib
use OsStdLib

program (ExamplesVmr) {
      mut as string: fluxc_bin = ".\\bin\\fluxc.exe"
      route {
            stdIoFileExists(".\\bin\\fluxc.exe") ==> { fluxc_bin = ".\\bin\\fluxc.exe" }
            stdIoFileExists("bin\\fluxc.exe")    ==> { fluxc_bin = "bin\\fluxc.exe" }
            stdIoFileExists("..\\bin\\fluxc.exe")==> { fluxc_bin = "..\\bin\\fluxc.exe" }
            stdIoFileExists("fluxc.exe")        ==> { fluxc_bin = "fluxc.exe" }
            _                                    ==> { fluxc_bin = "fluxc" }
      }

      mut as string: fvmbc_dir = "t_fvmbc"
      route {
            stdIoFileExists("t_fvmbc") ==> { fvmbc_dir = "t_fvmbc" }
            stdIoFileExists("..\\t_fvmbc") ==> { fvmbc_dir = "..\\t_fvmbc" }
            _ ==> {
                  stdOsExec("cmd /c if not exist t_fvmbc mkdir t_fvmbc")
                  fvmbc_dir = "t_fvmbc"
            }
      }

      stdIoWriteFile("t_stdin_interactive.tmp", "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n")
      stdIoWriteFile("t_stdin_contract.tmp", "andre\nluiz\n")
      stdIoWriteFile("t_stdin_dado.tmp", "dado\n")
      stdIoWriteFile("t_stdin_empty.tmp", "")

      stdOsExec("cmd /c dir /b /on " + fvmbc_dir + "\\*.fvmbc > t_fvmbc_list.tmp")
      mut as string: list_content = stdIoReadFile("t_fvmbc_list.tmp")
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
                                                mut as string: filepath = fvmbc_dir + "\\" + nome

                                                mut as string: stdin_file = "t_stdin_empty.tmp"
                                                route {
                                                      nome == "input.fvmbc" or nome == "input.flux" ==> { stdin_file = "t_stdin_dado.tmp" }
                                                      nome == "ExampleOfInput.fvmbc" or nome == "ExampleOfInput.flux" ==> { stdin_file = "t_stdin_interactive.tmp" }
                                                      nome == "ExampleOfUseIoStdLib_IoInputContract.fvmbc" or nome == "ExampleOfUseIoStdLib_IoInputContract.flux" ==> { stdin_file = "t_stdin_contract.tmp" }
                                                      _ ==> {}
                                                }

                                                mut as string: cmd_vmr = "cmd /c \"set FLUX_CI=1 && " + fluxc_bin + " --target vmr " + filepath + " < " + stdin_file + " > t_vmr.tmp 2>&1\""
                                                mut as int64: rc = stdOsExec(cmd_vmr)

                                                mut as string: out_full = stdIoReadFile("t_vmr.tmp")
                                                mut as int64: out_len = stdCollectionLength(out_full)

                                                route {
                                                      rc == 0 ==> {
                                                            acertos = acertos + 1
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
                                                                                          println("  | " + cur_chunk)
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
                                                                  cur_chunk != "" ==> { println("  | " + cur_chunk) }
                                                                  _ ==> {}
                                                            }
                                                            println("  OK  " + nome)
                                                      }
                                                      _ ==> {
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

      stdOsExec("cmd /c del /q /f t_stdin_*.tmp t_vmr.tmp t_fvmbc_list.tmp 2>nul")

      println("")
      println("" + acertos + " sucesso, " + erros + " falha(s)")

      route {
            erros == 0 ==> { stdOsExit(0) }
            _ ==> { stdOsExit(1) }
      }
}
