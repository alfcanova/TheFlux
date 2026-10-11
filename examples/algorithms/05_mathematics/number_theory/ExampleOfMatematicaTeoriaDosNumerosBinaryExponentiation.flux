#L ============================================================================
#L Algoritmo: Binary Exponentiation (Exponenciação Modular Rápida O(log B))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log B) multiplicacoes modulares
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosBinaryExponentiation) {
      println("==================================================")
      println("  SciAlgo: Fast Modular Binary Exponentiation")
      println("==================================================")

      mut as int64: base = 3
      mut as int64: exp = 13
      mut as int64: modulo = 1000
      mut as int64: res = 1

      mut as int64: b = base
      mut as int64: e = exp
      infinite (e > 0) {
            route {
                  (e /r 2) == 1 ==> {
                        res = (res * b) /r modulo
                  }
                  _ ==> {}
            }
            b = (b * b) /r modulo
            e = e /i 2
      }

      println("1. " + base + "^" + exp + " mod " + modulo + " = " + res)
      println("2. Binary Exponentiation concluido com sucesso.")
}
