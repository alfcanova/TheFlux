#L ==============================================================================
#L TheFlux Runner: Exemplos VM (Compilação da Suíte Canônica para Bytecode .fvmbc)
#L Arquivo: exemplos_vm.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib

program (ExemplosVm) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as string: cmd = "python scripts\\exemplos_vm.py"
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        route {
                              a == "exemplos_vm.flux" or a == ".\\exemplos_vm.flux" or a == "./exemplos_vm.flux" or a == "--" ==> {}
                              _ ==> {
                                    cmd = cmd + " \"" + a + "\""
                              }
                        }
                        i = i + 1
                  }
            }
      }
      mut as int64: rc = stdOsExec(cmd)
      stdOsExit(rc)
}
