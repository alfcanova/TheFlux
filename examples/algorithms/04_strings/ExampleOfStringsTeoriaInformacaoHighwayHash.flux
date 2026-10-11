#L ============================================================================
#L Algoritmo: HighwayHash (SIMD 4-Lane High Speed Hash Function)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N) tempo ultra-rapido via paralelismo de instrucoes SIMD
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoHighwayHash) {
      println("==================================================")
      println("  SciAlgo: HighwayHash 4-Lane High Speed Hash")
      println("==================================================")

      #L HighwayHash processa pacotes de 32 bytes paralelamente em 4 lanes de 64 bits:
      #L v0[4], v1[4], mul0[4], mul1[4]
      mut as list of int64: v0 = [11, 22, 33, 44]
      mut as list of int64: v1 = [55, 66, 77, 88]

      #L Bloco de entrada dividido em 4 palavras de 64 bits
      mut as list of int64: packet = [100, 200, 300, 400]

      #L Rodada de atualizacao HighwayTree:
      #L v1 = v1 + packet; v0 = v0 + (v1 * mul)
      mut as int64: lanes = 4
      mut as int64: i = 1
      infinite (i <= lanes) {
            v1[i] = (v1[i] + packet[i]) /r 1000000000
            v0[i] = (v0[i] + v1[i] * 3) /r 1000000000
            i = i + 1
      }

      #L Permutacao e permutacao modular entre lanes:
      mut as int64: digest_64 = (v0[1] + v0[2] + v0[3] + v0[4] + v1[1] + v1[2] + v1[3] + v1[4]) /r 1000000000
      route {
            digest_64 < 0 ==> { digest_64 = 0 - digest_64 }
            _ ==> {}
      }

      println("1. Largura de processamento paralelo: " + lanes + " lanes de 64 bits")
      println("2. Tamanho do pacote por rodada: 32 bytes")
      println("3. Digest final de 64 bits: " + digest_64)
      println("4. HighwayHash concluido com sucesso.")
}
