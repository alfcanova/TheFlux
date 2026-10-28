#L ==============================================================================
#L TheFlux Compliance: NR (Matriz 6-Backend de Numerical Recipes)
#L Arquivo: compliance_NR.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib

program (ComplianceNr) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as string: cmd = "python scripts\\compliance_NR.py"
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        route {
                              a == "compliance_NR.flux" or a == ".\\compliance_NR.flux" or a == "./compliance_NR.flux" or a == "--" ==> {}
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
