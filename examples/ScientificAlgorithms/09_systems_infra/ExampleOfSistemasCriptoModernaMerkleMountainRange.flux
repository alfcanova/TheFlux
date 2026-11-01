#L ============================================================================
#L Algoritmo: Merkle Mountain Range (MMR - Acumulador Criptografico Append-Only)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaMerkleMountainRange) {
      println("==================================================")
      println("  SciAlgo: Merkle Mountain Range (MMR Accumulator)")
      println("==================================================")

      mut as int64: primeH = 2147483647

      #L MMR com 7 elementos append-only:
      #L 7 = 4 + 2 + 1 = 2^2 + 2^1 + 2^0
      #L Possui 3 picos (mountains):
      #L - Pico 1 (altura 2): cobre 4 folhas (L1, L2, L3, L4)
      #L - Pico 2 (altura 1): cobre 2 folhas (L5, L6)
      #L - Pico 3 (altura 0): cobre 1 folha  (L7)
      mut as list of int64: elements = [11, 22, 33, 44, 55, 66, 77]
      mut as int64: numElements = 7

      println("1. Elementos da MMR (7 folhas):")
      mut as int64: i = 1
      infinite (i <= numElements) {
            println("   Folha " + i + ": " + elements[i])
            i = i + 1
      }

      println("==================================================")
      println("2. Construcao das Montanhas e Descoberta dos Picos:")
      #L Pico 1: Arvore de 4 folhas
      #L Hashes de nivel 0
      mut as int64: h1 = (elements[1] * 16777619 + 1) /r primeH
      mut as int64: h2 = (elements[2] * 16777619 + 2) /r primeH
      mut as int64: h3 = (elements[3] * 16777619 + 3) /r primeH
      mut as int64: h4 = (elements[4] * 16777619 + 4) /r primeH
      #L Hashes de nivel 1
      mut as int64: h12 = ((h1 * 31 + h2) * 16777619 + 12) /r primeH
      mut as int64: h34 = ((h3 * 31 + h4) * 16777619 + 34) /r primeH
      #L Pico 1 (nivel 2)
      mut as int64: peak1 = ((h12 * 31 + h34) * 16777619 + 1234) /r primeH
      println("   Pico 1 (Cobre folhas 1..4, Altura 2): " + peak1)

      #L Pico 2: Arvore de 2 folhas (folhas 5 e 6)
      mut as int64: h5 = (elements[5] * 16777619 + 5) /r primeH
      mut as int64: h6 = (elements[6] * 16777619 + 6) /r primeH
      mut as int64: peak2 = ((h5 * 31 + h6) * 16777619 + 56) /r primeH
      println("   Pico 2 (Cobre folhas 5..6, Altura 1): " + peak2)

      #L Pico 3: Arvore de 1 folha (folha 7)
      mut as int64: peak3 = (elements[7] * 16777619 + 7) /r primeH
      println("   Pico 3 (Cobre folha 7,   Altura 0): " + peak3)

      println("==================================================")
      println("3. Empacotamento dos Picos (Bagging the Peaks -> MMR Root):")
      #L Em MMR, a raiz global e computada empacotando os picos da direita para a esquerda:
      #L Bag23 = H(peak2 || peak3)
      #L MMR_Root = H(peak1 || Bag23)
      mut as int64: bag23 = ((peak2 * 31 + peak3) * 16777619 + 23) /r primeH
      mut as int64: mmrRoot = ((peak1 * 31 + bag23) * 16777619 + 123) /r primeH
      println("   Bag intermediario (Pico 2 + Pico 3): " + bag23)
      println("   Raiz Global MMR (MMR Root):          " + mmrRoot)

      println("==================================================")
      println("4. Prova de Inclusao na MMR para Folha 3:")
      #L Para provar que a folha 3 esta na MMR, o provador fornece:
      #L - Caminho interno na montanha 1: irmao h4, irmao h12
      #L - Picos adicionais: peak2, peak3
      println("   Verificador valida Folha 3 (" + elements[3] + ") contra MMR Root:")

      #L 1. Sobe na montanha ate o Pico 1
      mut as int64: vH3 = (elements[3] * 16777619 + 3) /r primeH
      mut as int64: vH34 = ((vH3 * 31 + h4) * 16777619 + 34) /r primeH
      mut as int64: vPeak1 = ((h12 * 31 + vH34) * 16777619 + 1234) /r primeH
      println("   Pico 1 recalculado pelo Verificador: " + vPeak1)

      #L 2. Empacota com os picos restantes
      mut as int64: vBag23 = ((peak2 * 31 + peak3) * 16777619 + 23) /r primeH
      mut as int64: vRoot = ((vPeak1 * 31 + vBag23) * 16777619 + 123) /r primeH
      println("   Raiz recalculada pelo Verificador:   " + vRoot)

      route {
            vRoot == mmrRoot ==> {
                  println("   SUCESSO: Prova MMR verificada com sucesso!")
            }
            _ ==> {
                  println("   FALHA: Prova MMR rejeitada.")
            }
      }

      println("==================================================")
      println("5. Deteccao de Adulteracao na Folha 3:")
      mut as int64: badElem3 = 999
      mut as int64: badH3 = (badElem3 * 16777619 + 3) /r primeH
      mut as int64: badH34 = ((badH3 * 31 + h4) * 16777619 + 34) /r primeH
      mut as int64: badPeak1 = ((h12 * 31 + badH34) * 16777619 + 1234) /r primeH
      mut as int64: badRoot = ((badPeak1 * 31 + vBag23) * 16777619 + 123) /r primeH

      route {
            badRoot != mmrRoot ==> {
                  println("   SUCESSO: Adulteracao detectada! Prova MMR rejeitada (badRoot != mmrRoot).")
            }
            _ ==> {
                  println("   FALHA: Adulteracao passou despercebida.")
            }
      }
}
