#L ==============================================================================
#L TheFlux Backend Driver: VMR (Bytecode Loader & VM Runner via bin/fluxc.exe)
#L Arquivo: flux_vmr.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib
use IoStdLib

program (FluxVmr) {
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

      mut as string: cmd = fluxc_bin + " --target vmr"
      mut as int64: user_args_count = 0
      mut as string: first_file = ""

      #L 2. Coleta e filtragem dos argumentos do usuario
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        mut as bool: is_self = (a == "flux_vmr.flux" or a == ".\\flux_vmr.flux" or a == "./flux_vmr.flux" or a == "flux_vmr.exe" or a == ".\\flux_vmr.exe" or a == "bin\\flux_vmr.exe" or a == ".\\bin\\flux_vmr.exe" or a == "--")
                        route {
                              is_self ==> {}
                              _ ==> {
                                    user_args_count = user_args_count + 1
                                    mut as int64: alen = stdCollectionLength(a)
                                    route {
                                          alen > 0 and a[1] != "-" and first_file == "" ==> {
                                                first_file = a
                                          }
                                          _ ==> {}
                                    }
                                    cmd = cmd + " \"" + a + "\""
                              }
                        }
                        i = i + 1
                  }
            }
      }

      #L 3. Zero-Process Guard: se nenhum argumento foi passado, exibe uso sem criar subprocesso
      route {
            user_args_count == 0 ==> {
                  println("TheFlux Backend Driver: VMR (Executor de Bytecode)")
                  println("Uso: fluxc flux_vmr.flux <arquivo.fvmbc> [opcoes]")
                  println("     flux_vmr <arquivo.fvmbc> [opcoes]")
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

      #L 5. Execucao direta do alvo
      mut as int64: rc = stdOsExec(cmd)
      stdOsExit(rc)
}
