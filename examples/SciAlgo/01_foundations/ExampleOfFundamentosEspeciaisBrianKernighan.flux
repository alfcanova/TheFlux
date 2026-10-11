#L ============================================================================
#L Algoritmo: Brian Kernighan's Bit-Counting Algorithm
#L Dominio: 01_foundations / Algoritmos Especiais
#L Complexidade: O(bits set) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisBrianKernighan) {
      println("==================================================")
      println("  SciAlgo: Brian Kernighan's Bit Counting         ")
      println("==================================================")

      #L Numero 455 = 256 + 128 + 64 + 4 + 2 + 1 (6 bits setados)
      mut as int64: n = 455
      println("1. Numero de Entrada: " + n)

      mut as int64: count = 0
      mut as int64: temp = n

      #L Limpa iterativamente o bit menos significativo setado
      infinite (temp > 0) {
            #L Encontra a menor potencia de 2 que divide temp
            mut as int64: p = 1
            infinite (temp /r (p * 2) == 0 and p * 2 <= temp) {
                  p = p * 2
            }
            #L Subtrai o bit menos significativo (equivalente a temp = temp & (temp - 1))
            temp = temp - p
            count = count + 1
      }

      println("2. Total de Bits Setados (Popcount): " + count)
      mut as bool: ok = (count == 6)
      println("3. Validacao (Popcount esperado == 6): " + ok)
      println("==================================================")
}
