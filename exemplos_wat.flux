#L ==============================================================================
#L TheFlux Runner: Exemplos WAT (Emissão da Suíte Canônica em WebAssembly Text)
#L Arquivo: exemplos_wat.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib

program (ExemplosWat) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as string: cmd = "python scripts\\exemplos_wat.py"
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        route {
                              a == "exemplos_wat.flux" or a == ".\\exemplos_wat.flux" or a == "./exemplos_wat.flux" or a == "--" ==> {}
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
