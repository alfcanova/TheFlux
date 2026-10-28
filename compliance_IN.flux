#L ==============================================================================
#L TheFlux Compliance: IN (Auditoria de Conformidade Lado a Lado do Interpretador)
#L Arquivo: compliance_IN.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib

program (ComplianceIn) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as string: cmd = "python scripts\\compliance_IN.py"
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        route {
                              a == "compliance_IN.flux" or a == ".\\compliance_IN.flux" or a == "./compliance_IN.flux" or a == "--" ==> {}
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
