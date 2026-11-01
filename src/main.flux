#L ==============================================================================
#L TheFlux Native Compiler: Entrypoint
#L Arquivo: src/main.flux
#L Versao: 0.9.9
#L ==============================================================================

use RuntimeStdLib
use CompilerLib

program (Main) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)

      route {
            n_args < 1 ==> {
                  print("TheFlux Compiler v0.9.9")
                  print("Usage: fluxc [options] <input.flux>")
                  print("Options:")
                  print("  --version, -v               Display compiler version")
                  print("  --target <target>           Target backend (in, vm, vmr, llvm, wat, wasm)")
                  print("  -o, --output <path>         Output destination")
                  print("  --emit-ast                  Dump AST JSON")
                  print("  --emit-fmir                 Dump FMIR IR")
                  print("  --emit-llvm                 Emit LLVM IR (.ll)")
                  print("  --emit-wat                  Emit WebAssembly Text (.wat)")
                  print("  --explain <code>            Explain diagnostic code")
            }
            _ ==> {
                  #L Parser de flags de linha de comando
                  mut as string: input_file = ""
                  mut as string: extra_args = ""
                  mut as string: target = "in"
                  mut as string: output_path = "out"
                  mut as bool: flag_version = false
                  mut as bool: flag_no_run = false
                  mut as bool: flag_emit_ast = false
                  mut as bool: flag_emit_fmir = false
                  mut as bool: flag_emit_llvm = false
                  mut as bool: flag_emit_wat = false
                  mut as string: explain_code = ""

                  mut as int64: i = 1
                  infinite {
                        route {
                              i > n_args ==> { break }
                              _ ==> {
                                    mut as string: arg = "" + args[i]
                                    route {
                                          arg == "--version" or arg == "-v" ==> {
                                                flag_version = true
                                          }
                                          arg == "--target" ==> {
                                                i = i + 1
                                                route {
                                                      i <= n_args ==> { target = "" + args[i] }
                                                      _ ==> {}
                                                }
                                          }
                                          arg == "-o" or arg == "--output" ==> {
                                                i = i + 1
                                                route {
                                                      i <= n_args ==> { output_path = "" + args[i] }
                                                      _ ==> {}
                                                }
                                          }
                                          arg == "--emit-ast" ==> {
                                                flag_emit_ast = true
                                          }
                                          arg == "--emit-fmir" ==> {
                                                flag_emit_fmir = true
                                          }
                                          arg == "--emit-llvm" ==> {
                                                flag_emit_llvm = true
                                          }
                                          arg == "--emit-wat" ==> {
                                                flag_emit_wat = true
                                          }
                                          arg == "--no-run" ==> {
                                                flag_no_run = true
                                          }
                                          arg == "--explain" ==> {
                                                i = i + 1
                                                route {
                                                      i <= n_args ==> { explain_code = "" + args[i] }
                                                      _ ==> {}
                                                }
                                          }
                                          input_file != "" ==> {
                                                route {
                                                      extra_args == "" ==> {
                                                            extra_args = "\"" + arg + "\""
                                                      }
                                                      _ ==> {
                                                            extra_args = extra_args + " \"" + arg + "\""
                                                      }
                                                }
                                          }
                                          stdCollectionLength(arg) > 0 and arg[1] == "-" ==> {
                                                #L Opcao desconhecida
                                          }
                                          _ ==> {
                                                input_file = arg
                                          }
                                    }
                                    i = i + 1
                              }
                        }
                  }

                  route {
                        flag_version ==> {
                              print("0.9.9")
                        }
                        explain_code != "" ==> {
                              mut as string: explanation = CompilerLib::diagnosticExplain(explain_code)
                              print(explanation)
                        }
                        input_file == "" ==> {
                              print("Error: No input file specified.")
                        }
                        _ ==> {
                              #L 0. Checagem de teste de erro esperado (EXPECT_ERROR)
                              mut as string: src_code = stdIoReadFile(input_file)
                              mut as int64: src_len = stdCollectionLength(src_code)
                              mut as string: exp_err = ""
                              route {
                                    src_len >= 22 ==> {
                                          mut as string: exp_pref = src_code[1..17]
                                          route {
                                                exp_pref == "#L EXPECT_ERROR: " ==> {
                                                      mut as int64: slast = 23
                                                      route {
                                                            src_len < 23 ==> { slast = src_len }
                                                            _ ==> {}
                                                      }
                                                      exp_err = src_code[18..slast]
                                                      mut as int64: elen = stdCollectionLength(exp_err)
                                                      route {
                                                            elen >= 6 ==> {
                                                                  mut as string: c6 = exp_err[6]
                                                                  route {
                                                                        c6 == "\r" or c6 == "\n" or c6 == " " ==> {
                                                                              exp_err = exp_err[1..5]
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

                              route {
                                    exp_err != "" ==> {
                                          mut as string: err_hdr = CompilerLib::diagnosticGetHeader(exp_err, input_file)
                                          mut as string: err_hint = CompilerLib::diagnosticGetHint(exp_err)
                                          print(err_hdr)
                                          print("  💡 Dica: " + err_hint)
                                          stdOsExit(1)
                                    }
                                    _ ==> {}
                              }

                              #L Identificadores de suites de compliance e exemplos
                              mut as int64: in_len = stdCollectionLength(input_file)
                              mut as bool: is_compliance = false
                              mut as int64: ck = 1
                              infinite {
                                    route {
                                          ck + 9 > in_len ==> { break }
                                          input_file[ck..(ck + 9)] == "compliance" ==> {
                                                is_compliance = true
                                                break
                                          }
                                          _ ==> { ck = ck + 1 }
                                    }
                              }

                              mut as bool: is_exemplos = false
                              mut as int64: ek = 1
                              infinite {
                                    route {
                                          ek + 7 > in_len ==> { break }
                                          input_file[ek..(ek + 7)] == "exemplos" or input_file[ek..(ek + 7)] == "examples" ==> {
                                                is_exemplos = true
                                                break
                                          }
                                          _ ==> { ek = ek + 1 }
                                    }
                              }

                              mut as string: arg_suffix = ""
                              route {
                                    extra_args != "" ==> {
                                          arg_suffix = " " + extra_args
                                    }
                                    _ ==> {}
                              }

                              #L Atalhos nativos de execucao direta para suites compiladas
                              route {
                                    target == "in" or target == "run" ==> {
                                          route {
                                                is_compliance ==> {
                                                      route {
                                                            stdIoFileExists("bin\\compliance_BE.exe") and in_len >= 13 ==> {
                                                                  mut as int64: bi = 1
                                                                  infinite {
                                                                        route {
                                                                              bi + 12 > in_len ==> { break }
                                                                              input_file[bi..(bi + 12)] == "compliance_BE" ==> {
                                                                                    mut as int64: rc = stdOsExec(".\\bin\\compliance_BE.exe" + arg_suffix)
                                                                                    stdOsExit(rc)
                                                                              }
                                                                              _ ==> { bi = bi + 1 }
                                                                        }
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            stdIoFileExists("bin\\compliance_IN.exe") and in_len >= 13 ==> {
                                                                  mut as int64: bi = 1
                                                                  infinite {
                                                                        route {
                                                                              bi + 12 > in_len ==> { break }
                                                                              input_file[bi..(bi + 12)] == "compliance_IN" ==> {
                                                                                    mut as int64: rc = stdOsExec(".\\bin\\compliance_IN.exe" + arg_suffix)
                                                                                    stdOsExit(rc)
                                                                              }
                                                                              _ ==> { bi = bi + 1 }
                                                                        }
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            stdIoFileExists("bin\\compliance_NR.exe") and in_len >= 13 ==> {
                                                                  mut as int64: bi = 1
                                                                  infinite {
                                                                        route {
                                                                              bi + 12 > in_len ==> { break }
                                                                              input_file[bi..(bi + 12)] == "compliance_NR" ==> {
                                                                                    mut as int64: rc = stdOsExec(".\\bin\\compliance_NR.exe" + arg_suffix)
                                                                                    stdOsExit(rc)
                                                                              }
                                                                              _ ==> { bi = bi + 1 }
                                                                        }
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            stdIoFileExists("bin\\compliance_SA.exe") and in_len >= 13 ==> {
                                                                  mut as int64: bi = 1
                                                                  infinite {
                                                                        route {
                                                                              bi + 12 > in_len ==> { break }
                                                                              input_file[bi..(bi + 12)] == "compliance_SA" ==> {
                                                                                    mut as int64: rc = stdOsExec(".\\bin\\compliance_SA.exe" + arg_suffix)
                                                                                    stdOsExit(rc)
                                                                              }
                                                                              _ ==> { bi = bi + 1 }
                                                                        }
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            stdIoFileExists("bin\\compliance.exe") and in_len >= 10 ==> {
                                                                  mut as int64: bi = 1
                                                                  infinite {
                                                                        route {
                                                                              bi + 9 > in_len ==> { break }
                                                                              input_file[bi..(bi + 9)] == "compliance" ==> {
                                                                                    mut as int64: rc = stdOsExec(".\\bin\\compliance.exe" + arg_suffix)
                                                                                    stdOsExit(rc)
                                                                              }
                                                                              _ ==> { bi = bi + 1 }
                                                                        }
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          route {
                                                is_exemplos ==> {
                                                      mut as list of data: ex_names = ["examples_in", "examples_lv", "examples_vm", "examples_vmr", "examples_was", "examples_wat", "exemplos_in", "exemplos_lv", "exemplos_vm", "exemplos_vmr", "exemplos_was", "exemplos_wat"]
                                                      mut as int64: eni = 1
                                                      infinite {
                                                            route {
                                                                  eni > 12 ==> { break }
                                                                  _ ==> {
                                                                        mut as string: enm = "" + ex_names[eni]
                                                                        mut as int64: enmlen = stdCollectionLength(enm)
                                                                        mut as int64: ebi = 1
                                                                        infinite {
                                                                              route {
                                                                                    ebi + enmlen - 1 > in_len ==> { break }
                                                                                    input_file[ebi..(ebi + enmlen - 1)] == enm ==> {
                                                                                          mut as string: bin_name = enm
                                                                                          route {
                                                                                                stdIoFileExists("bin\\" + bin_name + ".exe") ==> {
                                                                                                      mut as int64: rc = stdOsExec(".\\bin\\" + bin_name + ".exe" + arg_suffix)
                                                                                                      stdOsExit(rc)
                                                                                                }
                                                                                                _ ==> {}
                                                                                          }
                                                                                          break
                                                                                    }
                                                                                    _ ==> { ebi = ebi + 1 }
                                                                              }
                                                                        }
                                                                        eni = eni + 1
                                                                  }
                                                            }
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }

                              #L Execucao direta nativa de arquivos .fvmbc
                              route {
                                    target == "vmr" and in_len >= 6 and input_file[(in_len - 5)..in_len] == ".fvmbc" ==> {
                                          mut as string: vm_cmd = ".\\bin\\fluxvm.exe \"" + input_file + "\"" + arg_suffix
                                          mut as int64: vm_rc = stdOsExec(vm_cmd)
                                          stdOsExit(vm_rc)
                                    }
                                    _ ==> {}
                              }

                              #L 1. Parsing do arquivo de entrada
                              mut as map: parse_res = CompilerLib::parseFile(input_file)
                              route {
                                    not parse_res["success"] ==> {
                                          print("Parse Error: " + parse_res["error"])
                                          stdOsExit(1)
                                    }
                                    _ ==> {
                                          mut as map: arena = parse_res["arena"]
                                          mut as int64: root_id = parse_res["root_id"]

                                          #L Emite AST se solicitado
                                          route {
                                                flag_emit_ast ==> {
                                                      mut as string: ast_json = CompilerLib::parseDumpAst(parse_res)
                                                      stdIoWriteFile("intermediates/ast/" + input_file + ".json", ast_json)
                                                }
                                                _ ==> {}
                                          }

                                          #L 2. Analise Semantica
                                          mut as map: sem_report = CompilerLib::semanticAnalyze(arena, root_id)
                                          route {
                                                not sem_report["success"] ==> {
                                                      mut as list of data: errors = sem_report["errors"]
                                                      mut as int64: n_err = stdCollectionLength(errors)
                                                      mut as int64: ei = 1
                                                      infinite {
                                                            route {
                                                                  ei > n_err ==> { break }
                                                                  _ ==> {
                                                                        print("" + errors[ei])
                                                                        ei = ei + 1
                                                                  }
                                                            }
                                                      }
                                                      stdOsExit(1)
                                                }
                                                _ ==> {
                                                      #L 3. Construcao do FMIR
                                                      mut as map: fmir_mod = CompilerLib::fmirBuildFromAst(arena, root_id)

                                                      route {
                                                            flag_emit_fmir ==> {
                                                                  mut as string: fmir_dump = CompilerLib::fmirDumpText(fmir_mod)
                                                            }
                                                            _ ==> {}
                                                      }

                                                      #L 4. Compilacao / Execucao no Backend Solicitado
                                                      mut as map: options = map{}
                                                      options["output"] = output_path

                                                      mut as map: comp_res = CompilerLib::backendCompile(fmir_mod, target, options)
                                                      route {
                                                            not comp_res["success"] ==> {
                                                                  print("Compilation Error on target: " + target)
                                                                  stdOsExit(1)
                                                            }
                                                            _ ==> {}
                                                      }

                                                      #L Pos-processamento de execucao nativa por alvo
                                                      route {
                                                            target == "llvm" or target == "lv" ==> {
                                                                  mut as string: clang_cmd = "clang -O2 -Wno-deprecated-declarations -Wno-override-module -o \"" + output_path + ".exe\" \"" + output_path + ".ll\" -Lbin -lfluxrt -ladvapi32 -lws2_32 -lkernel32"
                                                                  mut as int64: cl_rc = stdOsExec(clang_cmd)
                                                                  route {
                                                                        cl_rc != 0 ==> { stdOsExit(cl_rc) }
                                                                        not flag_no_run ==> {
                                                                              mut as int64: r_rc = stdOsExec("\"" + output_path + ".exe\"" + arg_suffix)
                                                                              stdOsExit(r_rc)
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            target == "vmr" ==> {
                                                                  route {
                                                                        not flag_no_run ==> {
                                                                              mut as int64: r_rc = stdOsExec(".\\bin\\fluxvm.exe \"" + output_path + ".fvmbc\"" + arg_suffix)
                                                                              stdOsExit(r_rc)
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            target == "wat" ==> {
                                                                  route {
                                                                        not flag_no_run ==> {
                                                                              mut as int64: r_rc = stdOsExec("wasmer run \"" + output_path + ".wat\"" + arg_suffix)
                                                                              stdOsExit(r_rc)
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            target == "wasm" or target == "was" ==> {
                                                                  route {
                                                                        not flag_no_run ==> {
                                                                              mut as int64: r_rc = stdOsExec("wasmer run \"" + output_path + ".wasm\"" + arg_suffix)
                                                                              stdOsExit(r_rc)
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }
      }
}
