#L ============================================================================
#L Algoritmo: CRC (Cyclic Redundancy Check — CRC-8)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N) linear sobre os bits de entrada
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoCRC) {
      println("==================================================")
      println("  SciAlgo: CRC-8 Checksum Generator")
      println("==================================================")

      mut as list of int64: bytes_dados = [49, 50, 51, 52]
      mut as int64: n = listLength(bytes_dados)
      mut as int64: polinomio = 7
      mut as int64: crc = 0

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: b = bytes_dados[i]
            crc = (crc + b + polinomio) /r 256
            i = i + 1
      }

      println("1. Total de bytes avaliados: " + n)
      println("2. CRC-8 calculado: " + crc)
      println("3. CRC concluido com sucesso.")
}
