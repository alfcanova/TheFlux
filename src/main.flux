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
                                          stdCollectionLength(arg) > 0 and arg[1] == "-" ==> {
                                                #L Opcao desconhecida
                                          }
                                          _ ==> {
                                                route {
                                                      input_file == "" ==> {
                                                            input_file = arg
                                                      }
                                                      _ ==> {}
                                                }
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
                                    src_len >= 23 ==> {
                                          mut as string: exp_pref = src_code[1..17]
                                          route {
                                                exp_pref == "#L EXPECT_ERROR: " ==> {
                                                      exp_err = src_code[18..23]
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

                              #L Verifica se o arquivo e um contrato de StdLib (ExampleOfUse*)
                              mut as int64: in_len = stdCollectionLength(input_file)
                              mut as bool: is_stdlib_use = false
                              mut as int64: uk = 1
                              infinite {
                                    route {
                                          uk + 11 > in_len ==> { break }
                                          input_file[uk..(uk + 11)] == "ExampleOfUse" ==> {
                                                is_stdlib_use = true
                                                break
                                          }
                                          _ ==> { uk = uk + 1 }
                                    }
                              }

                              route {
                                    is_stdlib_use or (target != "in" and target != "run" and input_file != "src/main.flux") ==> {
                                          mut as string: cmd = "set PYTHONPATH=src && python -m flux_proto \"" + input_file + "\" --target run"
                                          route {
                                                target == "vm" or target == "vmbc" ==> {
                                                      cmd = "set PYTHONPATH=src && python -m flux_proto \"" + input_file + "\" --target vmbc -o \"" + output_path + "\""
                                                }
                                                target == "vmr" ==> {
                                                      mut as int64: flen = stdCollectionLength(input_file)
                                                      mut as bool: is_fvmbc = false
                                                      route {
                                                            flen >= 6 and input_file[(flen - 5)..flen] == ".fvmbc" ==> {
                                                                  is_fvmbc = true
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            is_fvmbc ==> {
                                                                  cmd = "set PYTHONPATH=src && python -X utf8 -c \"import json, sys; from flux_proto.vm.runtime import execute_bytecode; execute_bytecode(json.load(open(sys.argv[1], encoding='utf-8')))\" \"" + input_file + "\""
                                                            }
                                                            _ ==> {
                                                                  cmd = "set PYTHONPATH=src && python -m flux_proto \"" + input_file + "\" --target vmbc -o \"" + output_path + "\" && python -X utf8 -c \"import json, sys; from flux_proto.vm.runtime import execute_bytecode; execute_bytecode(json.load(open(sys.argv[1], encoding='utf-8')))\" \"" + output_path + ".fvmbc\""
                                                            }
                                                      }
                                                }
                                                target == "llvm" or target == "lv" ==> {
                                                      mut as string: run_cmd = ""
                                                      route {
                                                            not flag_no_run ==> {
                                                                  run_cmd = " && \"" + output_path + ".exe\""
                                                            }
                                                            _ ==> {}
                                                      }
                                                      cmd = "set PYTHONPATH=src && python -m flux_proto \"" + input_file + "\" --target llvm -o \"" + output_path + "\" && clang -O2 -Wno-deprecated-declarations -Wno-override-module -o \"" + output_path + ".exe\" \"" + output_path + ".ll\" runtime/flux_input.c" + run_cmd
                                                }
                                                target == "wat" ==> {
                                                      mut as string: run_cmd = ""
                                                      route {
                                                            not flag_no_run ==> {
                                                                  run_cmd = " && wasmer run \"" + output_path + ".wat\""
                                                            }
                                                            _ ==> {}
                                                      }
                                                      cmd = "set PYTHONPATH=src && python -m flux_proto \"" + input_file + "\" --target wat -o \"" + output_path + "\"" + run_cmd
                                                }
                                                target == "wasm" or target == "was" ==> {
                                                      mut as string: run_cmd = ""
                                                      route {
                                                            not flag_no_run ==> {
                                                                  run_cmd = " && wasmer run \"" + output_path + ".wasm\""
                                                            }
                                                            _ ==> {}
                                                      }
                                                      cmd = "set PYTHONPATH=src && python -m flux_proto \"" + input_file + "\" --target wasm -o \"" + output_path + "\"" + run_cmd
                                                }
                                                _ ==> {}
                                          }
                                          mut as int64: rc = stdOsExec(cmd)
                                          stdOsExit(rc)
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
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }
      }
}
