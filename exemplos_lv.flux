#L ==============================================================================
#L TheFlux Runner: Exemplos LV (Compilação LLVM IR e Execução Nativa Clang)
#L Arquivo: exemplos_lv.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib

program (ExemplosLv) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as string: cmd = "python scripts\\exemplos_lv.py"
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        route {
                              a == "exemplos_lv.flux" or a == ".\\exemplos_lv.flux" or a == "./exemplos_lv.flux" or a == "--" ==> {}
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
