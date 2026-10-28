#L ==============================================================================
#L TheFlux Runner: Exemplos VMR (Execução da Suíte Canônica pela VM TheFlux)
#L Arquivo: exemplos_vmr.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib

program (ExemplosVmr) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as string: cmd = "python scripts\\exemplos_vmr.py"
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        route {
                              a == "exemplos_vmr.flux" or a == ".\\exemplos_vmr.flux" or a == "./exemplos_vmr.flux" or a == "--" ==> {}
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
