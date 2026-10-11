#L ============================================================================
#L Algoritmo: Parity Check (Checagem de Paridade Par/Ímpar)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N) contagem de bits ativos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoParityCheck) {
      println("==================================================")
      println("  SciAlgo: Parity Check (Bit Parity Verification)")
      println("==================================================")

      mut as list of int64: bits = [1, 0, 1, 1, 0, 0, 1]
      mut as int64: n = listLength(bits)
      mut as int64: count_ones = 0

      mut as int64: i = 1
      infinite (i <= n) {
            route {
                  bits[i] == 1 ==> { count_ones = count_ones + 1 }
                  _ ==> {}
            }
            i = i + 1
      }

      mut as int64: paridade_par = count_ones /r 2

      println("1. Bits avaliados: " + n)
      println("2. Quantidade de bits 1: " + count_ones)
      println("3. Bit de paridade par: " + paridade_par)
      println("4. Parity Check concluido com sucesso.")
}
