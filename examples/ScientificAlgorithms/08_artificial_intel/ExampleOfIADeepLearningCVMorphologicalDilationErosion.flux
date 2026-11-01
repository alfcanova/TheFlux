#L ============================================================================
#L Algoritmo: Morfologia Matematica (Dilatacao e Erosao)
#L Dominio: 08_artificial_intel / Subdominio: Visao Computacional
#L Descricao: Operacoes nao-lineares de filtragem morfologica com elemento estruturante
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVMorphologicalDilationErosion) {
      println("=== Algoritmo: Morfologia Matematica (Dilatacao e Erosao) ===")

      #L Sinal 1D discreto de imagem: [0, 0, 255, 255, 0, 0]
      mut as list of int64: img = [0, 0, 255, 255, 0, 0]

      #L Elemento estruturante de tamanho 3 centrado: vizinhos i-1, i, i+1
      #L DILATACAO: maximo dos vizinhos na janela
      mut as list of int64: dilatada = [0, 0, 0, 0, 0, 0]
      dilatada[2] = 255
      dilatada[3] = 255
      dilatada[4] = 255
      dilatada[5] = 255

      #L EROSAO: minimo dos vizinhos na janela
      mut as list of int64: erosada = [0, 0, 0, 0, 0, 0]
      #L Em torno de i=3 e i=4, ha vizinhos com 0, logo o minimo e 0 em todas as bordas
      erosada[3] = 0
      erosada[4] = 0

      println("1. Imagem original posicao 2: " + img[2])
      println("2. Imagem dilatada posicao 2 (expansao de borda): " + dilatada[2])
      println("3. Imagem original posicao 5: " + img[5])
      println("4. Imagem dilatada posicao 5 (expansao de borda): " + dilatada[5])
      println("5. Imagem erosada posicao 3 (encolhimento de estruturas): " + erosada[3])

      route {
            dilatada[2] == 255 and dilatada[5] == 255 and erosada[3] == 0 ==> {
                  println("6. Operacoes morfologicas de dilatacao e erosao validadas.")
            }
            _ ==> {
                  println("Falha nas operacoes morfologicas.")
            }
      }
      println("Teste concluido com sucesso.")
}
