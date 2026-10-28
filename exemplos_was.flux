#L ==============================================================================
#L TheFlux Runner: Exemplos WAS (Emissão da Suíte Canônica em WebAssembly Binário)
#L Arquivo: exemplos_was.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib

program (ExemplosWas) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as string: cmd = "python scripts\\exemplos_was.py"
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        route {
                              a == "exemplos_was.flux" or a == ".\\exemplos_was.flux" or a == "./exemplos_was.flux" or a == "--" ==> {}
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
