#L ============================================================================
#L Algoritmo: Wavelet Matrix on Strings (Rank, Select e Access em Alfabeto Arbitrario)
#L Dominio: 04_strings / Subdominio: indices
#L Complexidade: O(log Sigma) para rank/select/access
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsIndicesWaveletMatrix) {
      println("==================================================")
      println("  SciAlgo: Wavelet Matrix on Strings")
      println("==================================================")

      #L Sequencia de simbolos no alfabeto Sigma={0, 1, 2, 3} (2 bits por simbolo)
      #L Sequencia original T: [3, 1, 0, 2, 3, 1, 2, 0] (tam 8)
      mut as list of int64: texto = [3, 1, 0, 2, 3, 1, 2, 0]
      mut as int64: n = listLength(texto)
      mut as int64: niveis = 2 #L log2(4) = 2 niveis de decomposicao de bits

      #L Nivel 1 (bit mais significativo MSB):
      #L 3=(11)->1, 1=(01)->0, 0=(00)->0, 2=(10)->1, 3->1, 1->0, 2->1, 0->0
      #L Bitvector Nivel 1: [1, 0, 0, 1, 1, 0, 1, 0]
      #L Zeros: posicoes onde bit eh 0. Total de zeros z1 = 4.
      mut as list of int64: b1 = [1, 0, 0, 1, 1, 0, 1, 0]
      mut as int64: z1 = 4

      #L Reordenacao para o nivel 2:
      #L Primeiro todos os elementos com bit 0 (na ordem estavel), depois com bit 1.
      #L Elementos com MSB=0: 1, 0, 1, 0. Seus LSBs: 1, 0, 1, 0.
      #L Elementos com MSB=1: 3, 2, 3, 2. Seus LSBs: 1, 0, 1, 0.
      #L Bitvector Nivel 2: [1, 0, 1, 0, 1, 0, 1, 0]
      mut as list of int64: b2 = [1, 0, 1, 0, 1, 0, 1, 0]
      mut as int64: z2 = 4

      #L Consulta de Rank do simbolo 3 (bits: 11) no prefixo ate pos=5
      #L Nivel 1: rank_1(b1, 5) -> quantos 1s em b1[1..5]?
      mut as int64: r1 = 0
      mut as int64: i = 1
      infinite (i <= 5) {
            route {
                  b1[i] == 1 ==> { r1 = r1 + 1 }
                  _ ==> {}
            }
            i = i + 1
      }
      #L Nova posicao mapeada no nivel 2 para 1s: z1 + r1 = 4 + 3 = 7
      mut as int64: pos_nivel2 = z1 + r1

      #L Nivel 2: rank_1(b2, pos_nivel2) a partir de z1+1 ate pos_nivel2
      mut as int64: r2 = 0
      mut as int64: j = z1 + 1
      infinite (j <= pos_nivel2) {
            route {
                  b2[j] == 1 ==> { r2 = r2 + 1 }
                  _ ==> {}
            }
            j = j + 1
      }

      println("1. Tamanho da sequencia: " + n + ", niveis de profundidade: " + niveis)
      println("2. Zeros no nivel 1: " + z1 + ", nivel 2: " + z2)
      println("3. Rank do simbolo 3 no prefixo de tamanho 5: " + r2)
      println("4. Wavelet Matrix concluida com sucesso.")
}
