#L ==============================================================================
#L TheFlux Backend Driver: WAT (WebAssembly Text via bin/fluxc.exe + Wasmer Runner)
#L Arquivo: flux_wat.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib
use IoStdLib

program (FluxWat) {
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

      mut as int64: user_args_count = 0
      mut as string: first_file = ""
      mut as bool: has_output_flag = false
      mut as string: custom_output = ""
      mut as bool: no_run = false
      mut as string: extra_args = ""

      #L 2. Coleta e filtragem dos argumentos do usuario
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        mut as bool: is_self = (a == "flux_wat.flux" or a == ".\\flux_wat.flux" or a == "./flux_wat.flux" or a == "flux_wat.exe" or a == ".\\flux_wat.exe" or a == "bin\\flux_wat.exe" or a == ".\\bin\\flux_wat.exe" or a == "--")
                        route {
                              is_self ==> {}
                              _ ==> {
                                    user_args_count = user_args_count + 1
                                    mut as int64: alen = stdCollectionLength(a)
                                    route {
                                          a == "--no-run" ==> {
                                                no_run = true
                                          }
                                          a == "-o" or a == "--output" ==> {
                                                has_output_flag = true
                                                extra_args = extra_args + " \"" + a + "\""
                                                i = i + 1
                                                route {
                                                      i <= n_args ==> {
                                                            custom_output = "" + args[i]
                                                            extra_args = extra_args + " \"" + custom_output + "\""
                                                            user_args_count = user_args_count + 1
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {
                                                mut as bool: is_opt = (a == "--target" or a == "-v" or a == "--version" or a == "--emit-ast" or a == "--emit-fmir" or a == "--emit-llvm" or a == "--emit-wat")
                                                route {
                                                      not is_opt ==> {
                                                            route {
                                                                  first_file == "" ==> {
                                                                        route {
                                                                              a[1] != "-" ==> {
                                                                                    first_file = a
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                                extra_args = extra_args + " \"" + a + "\""
                                          }
                                    }
                              }
                        }
                        i = i + 1
                  }
            }
      }

      #L 3. Zero-Process Guard: se nenhum argumento foi passado, exibe uso sem criar subprocesso
      route {
            user_args_count == 0 ==> {
                  println("TheFlux Backend Driver: WAT (Gerador WebAssembly Text + Wasmer Runner)")
                  println("Uso: fluxc flux_wat.flux <arquivo.flux> [opcoes]")
                  println("     flux_wat <arquivo.flux> [opcoes]")
                  stdOsExit(1)
            }
            _ ==> {}
      }

      #L 4. Validacao antecipada de existencia do arquivo
      route {
            first_file != "" ==> {
                  mut as bool: exists = stdIoFileExists(first_file)
                  route {
                        not exists ==> {
                              println("Erro: Arquivo nao encontrado: " + first_file)
                              stdOsExit(1)
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }

      #L 5. Determinacao do nome base para saida em t_wat
      mut as string: stem = ""
      route {
            first_file != "" ==> {
                  mut as int64: flen = stdCollectionLength(first_file)
                  mut as int64: last_slash = 0
                  mut as int64: k = 1
                  infinite {
                        route {
                              k > flen ==> { break }
                              _ ==> {
                                    mut as string: ch = first_file[k]
                                    route {
                                          ch == "\\" or ch == "/" ==> {
                                                last_slash = k
                                          }
                                          _ ==> {}
                                    }
                                    k = k + 1
                              }
                        }
                  }
                  mut as string: base = first_file
                  route {
                        last_slash > 0 and last_slash < flen ==> {
                              base = first_file[(last_slash + 1)..flen]
                        }
                        _ ==> {}
                  }
                  mut as int64: blen = stdCollectionLength(base)
                  stem = base
                  route {
                        blen > 5 and base[(blen - 4)..blen] == ".flux" ==> {
                              stem = base[1..(blen - 5)]
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }

      #L 6. Montagem do comando final de compilacao WAT
      mut as string: cmd = fluxc_bin + " --target wat"
      route {
            not has_output_flag and stem != "" ==> {
                  cmd = cmd + " -o \"t_wat\\" + stem + "\""
            }
            _ ==> {}
      }
      cmd = cmd + extra_args

      #L 7. Execucao da compilacao para WAT
      mut as int64: rc = stdOsExec(cmd)
      route {
            rc != 0 ==> {
                  stdOsExit(rc)
            }
            _ ==> {}
      }

      #L 8. Execucao via Wasmer Runner
      mut as string: wat_target = ""
      route {
            not has_output_flag and stem != "" ==> {
                  wat_target = "t_wat\\" + stem + ".wat"
            }
            _ ==> {}
      }
      route {
            custom_output != "" ==> {
                  mut as int64: colen = stdCollectionLength(custom_output)
                  route {
                        colen > 4 and custom_output[(colen - 3)..colen] == ".wat" ==> {
                              wat_target = custom_output
                        }
                        _ ==> {
                              wat_target = custom_output + ".wat"
                        }
                  }
            }
            _ ==> {}
      }

      route {
            (not no_run) and wat_target != "" ==> {
                  route {
                        stdIoFileExists(wat_target) ==> {
                              mut as string: wasmer_cmd = "wasmer \"" + wat_target + "\""
                              mut as int64: run_rc = stdOsExec(wasmer_cmd)
                              stdOsExit(run_rc)
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }

      stdOsExit(rc)
}
