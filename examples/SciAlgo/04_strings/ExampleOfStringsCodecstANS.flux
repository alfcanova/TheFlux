#L ============================================================================
#L Algoritmo: tANS (Tabled Asymmetric Numeral Systems)
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(1) tempo por operacao via tabela
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecstANS) {
      println("==================================================")
      println("  SciAlgo: tANS (Tabled ANS State Transitions)")
      println("==================================================")

      #L Tabela pré-computada de transição para 4 estados e 2 símbolos
      mut as list of int64: trans_0 = [2, 3, 1, 2]
      mut as list of int64: trans_1 = [3, 4, 4, 1]

      mut as int64: estado = 1
      mut as list of int64: bits = [0, 1, 1, 0, 1]
      mut as int64: n = listLength(bits)

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: b = bits[i]
            route {
                  b == 0 ==> { estado = trans_0[estado] }
                  _ ==> { estado = trans_1[estado] }
            }
            i = i + 1
      }

      println("1. Bits processados: " + n)
      println("2. Estado terminal tANS: " + estado)
      println("3. tANS concluido com sucesso.")
}
