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
                              #L 1. Parsing do arquivo de entrada
                              mut as map: parse_res = CompilerLib::parseFile(input_file)
                              route {
                                    not parse_res["success"] ==> {
                                          print("Parse Error: " + parse_res["error"])
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
                                                }
                                                _ ==> {
                                                      #L 3. Construcao do FMIR
                                                      mut as map: fmir_mod = CompilerLib::fmirBuildFromAst(arena, root_id)

                                                      route {
                                                            flag_emit_fmir ==> {
                                                                  mut as string: fmir_text = CompilerLib::fmirDumpText(fmir_mod)
                                                                  print(fmir_text)
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
