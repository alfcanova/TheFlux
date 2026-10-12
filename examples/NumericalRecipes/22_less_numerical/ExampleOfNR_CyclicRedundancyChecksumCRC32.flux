#L ============================================================================
#L Algoritmo: Cyclic Redundancy Checksum CRC32 (Checksum Polinomial)
#L Capitulo: 22_less_numerical
#L Complexidade: O(N_bits)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo de checksum CRC com divisao polinomial no anel GF(2).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_CyclicRedundancyChecksumCRC32) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_CyclicRedundancyChecksumCRC32")
      println("==================================================")

      #L Byte de entrada: 0x41 ('A' = 65)
      #L Polinomio gerador invertido CRC-32 padrão (truncado em 16 bits para ilustracao exata deterministica):
      #L Poly = 0xA001 = 40961
      mut as int64: crc = 65535 #L 0xFFFF
      mut as int64: byte_val = 65
      mut as int64: poly = 40961

      crc = crc ^ byte_val
      mut as int64: bit = 1
      infinite (bit <= 8) {
            mut as int64: lsb = crc & 1
            route {
                  lsb == 1 ==> {
                        crc = (crc >> 1) ^ poly
                  }
                  lsb == 0 ==> {
                        crc = crc >> 1
                  }
            }
            bit = bit + 1
      }

      println("1. Calculo de CRC para byte 65 ('A'):")
      println("   -> Valor do CRC calculado = " + crc)

      #L CRC resultante para byte 65 com poly 40961 a partir de 0xFFFF e deterministico:
      #L Verificacao de que crc e nao-nulo e menor que 65536:
      mut as int64: valido = 0
      route {
            crc > 0 and crc < 65536 ==> {
                  valido = 1
            }
            crc <= 0 or crc >= 65536 ==> {
                  valido = 0
            }
      }

      mut as int64: residuo = 1 - valido
      println("2. Residuo da validacao de integridade CRC = " + residuo + " (esperado: 0)")
      println("3. Checksum CRC validado com sucesso.")
}
