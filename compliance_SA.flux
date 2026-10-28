#L ==============================================================================
#L TheFlux Compliance: SA (Matriz 6-Backend de Algoritmos Científicos SciAlgo)
#L Arquivo: compliance_SA.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib

program (ComplianceSa) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as string: cmd = "python scripts\\compliance_SA.py"
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        route {
                              a == "compliance_SA.flux" or a == ".\\compliance_SA.flux" or a == "./compliance_SA.flux" or a == "--" ==> {}
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
