#L ==============================================================================
#L TheFlux Compliance: BE (Matriz Canônica de Conformidade 6-Backend)
#L Arquivo: compliance_BE.flux
#L ==============================================================================

use RuntimeStdLib
use OsStdLib

program (ComplianceBe) {
      mut as list of data: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)
      mut as string: cmd = "python scripts\\compliance_BE.py"
      mut as int64: i = 1
      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: a = "" + args[i]
                        route {
                              a == "compliance_BE.flux" or a == ".\\compliance_BE.flux" or a == "./compliance_BE.flux" or a == "--" ==> {}
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
