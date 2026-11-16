#L ==============================================================================
#L TheFlux Virtual Machine CLI Self-Hosted (fluxvm)
#L Arquivo: src/Fvm/fluxvm.flux
#L Versao: 1.0.0
#L ==============================================================================

use RuntimeStdLib
use IoStdLib
use OsStdLib
use CompilerLib

program (FluxVmMain) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)

      route {
            n_args < 1 ==> {
                  print("TheFlux Virtual Machine (fluxvm) v1.0.0")
                  print("Uso: fluxvm [opcoes] <arquivo.fvmbc>")
                  print("")
                  print("Opcoes de Execucao:")
                  print("  <arquivo.fvmbc>             Executa arquivo de bytecode localmente")
                  print("  --inject <arquivo.fvmbc>    Injeta bytecode no Servico Windows via Named Pipe")
                  print("  --status, --ping            Verifica se o servico/daemon FVM esta ativo")
                  print("  --bench                     Mede e exibe tempo de execucao e operacoes")
                  print("  --stdin <texto>             Injeta texto de entrada via argumento")
                  print("  --version, -v               Exibe versao da FVM")
                  print("  --help, -h                  Exibe esta mensagem de ajuda")
                  stdOsExit(0)
            }
            _ ==> {
                  mut as string: input_file = ""
                  mut as string: stdin_text = ""
                  mut as bool: flag_version = false
                  mut as bool: flag_help = false
                  mut as bool: flag_status = false
                  mut as bool: flag_bench = false
                  mut as bool: flag_inject = false

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
                                          arg == "--help" or arg == "-h" ==> {
                                                flag_help = true
                                          }
                                          arg == "--status" or arg == "--ping" ==> {
                                                flag_status = true
                                          }
                                          arg == "--bench" ==> {
                                                flag_bench = true
                                          }
                                          arg == "--inject" ==> {
                                                flag_inject = true
                                                i = i + 1
                                                route {
                                                      i <= n_args ==> { input_file = "" + args[i] }
                                                      _ ==> {}
                                                }
                                          }
                                          arg == "--stdin" ==> {
                                                i = i + 1
                                                route {
                                                      i <= n_args ==> { stdin_text = "" + args[i] }
                                                      _ ==> {}
                                                }
                                          }
                                          stdCollectionLength(arg) > 0 and arg[1] == "-" ==> {
                                                #L Opcao adicional
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
                              print("1.0.0")
                              stdOsExit(0)
                        }
                        flag_help ==> {
                              print("TheFlux Virtual Machine (fluxvm) v1.0.0")
                              print("Uso: fluxvm [opcoes] <arquivo.fvmbc>")
                              stdOsExit(0)
                        }
                        flag_status ==> {
                              print("inactive")
                              stdOsExit(1)
                        }
                        input_file == "" ==> {
                              print("Erro: Nenhum arquivo .fvmbc especificado.")
                              stdOsExit(1)
                        }
                        _ ==> {
                              mut as map: res = CompilerLib::vmrExecuteFile(input_file)
                              route {
                                    not res["success"] ==> { stdOsExit(1) }
                                    _ ==> { stdOsExit(0) }
                              }
                        }
                  }
            }
      }
}
