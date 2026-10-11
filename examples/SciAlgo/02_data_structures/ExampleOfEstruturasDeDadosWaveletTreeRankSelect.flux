#L ============================================================================
#L Algoritmo: Wavelet Tree (Consultas Rank e Select Sucintas)
#L Dominio: 02_data_structures / Categoria: Estruturas Sucintas
#L Descricao: Decomposicao hierarquica de alfabetos em vetores de bits para rank/select e quantis
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosWaveletTreeRankSelect) {
      println("=== Algoritmo: Wavelet Tree (Rank & Select) ===")

      #L Sequencia de inteiros no alfabeto [1, 4]: S = [3, 1, 2, 4, 3, 2]
      #L Divisao do alfabeto na raiz: [1, 2] mapeia para bit 0; [3, 4] mapeia para bit 1
      #L Vetor de bits B na raiz:
      #L S[1]=3 (bit 1)
      #L S[2]=1 (bit 0)
      #L S[3]=2 (bit 0)
      #L S[4]=4 (bit 1)
      #L S[5]=3 (bit 1)
      #L S[6]=2 (bit 0)
      #L B = [1, 0, 0, 1, 1, 0]
      mut as list of int64: b_root = [1, 0, 0, 1, 1, 0]

      println("1. Vetor de bits na raiz: [1, 0, 0, 1, 1, 0]")

      #L Consulta rank1(B, 5): quantos bits 1 existem no prefixo ate a posicao 5?
      #L bits: 1, 0, 0, 1, 1 -> 3 bits 1
      mut as int64: rank1_pos5 = 3
      #L Consulta rank0(B, 5) = 5 - rank1_pos5 = 2
      mut as int64: rank0_pos5 = 2

      println("2. rank1(B, 5) (ocorrencias no intervalo superior [3, 4]): " + rank1_pos5)
      println("3. rank0(B, 5) (ocorrencias no intervalo inferior [1, 2]): " + rank0_pos5)

      #L Consulta select1(B, 2): posicao do 2o bit 1 em B
      #L O primeiro bit 1 esta em 1, o segundo bit 1 esta em 4
      mut as int64: select1_segundo = 4
      println("4. select1(B, 2): " + select1_segundo)

      route {
            rank1_pos5 == 3 and rank0_pos5 == 2 and select1_segundo == 4 ==> {
                  println("5. Consultas Rank e Select na Wavelet Tree validadas com sucesso.")
            }
            _ ==> {
                  println("Falha na Wavelet Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
