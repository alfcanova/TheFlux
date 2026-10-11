#L ============================================================================
#L Algoritmo: Reciprocal Rank Fusion (RRF)
#L Dominio: 08_artificial_intel / Subdominio: Busca Vetorial e RAG
#L Descricao: Fusao hibrida robusta e livre de escala entre rankings lexicos e densos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIABuscaVetorialReciprocalRankFusion) {
      println("=== Algoritmo: Reciprocal Rank Fusion (RRF) ===")

      #L Constante de suavizacao padrao k = 60
      mut as int64: k_const = 60

      #L Documento A:
      #L Posicao no ranking lexico (BM25): rank_lex = 1
      #L Posicao no ranking denso (vetorial): rank_dense = 4
      #L RRF(A) = 1/(60 + 1) + 1/(60 + 4) = 1/61 + 1/64 (escala x100000 -> 1639 + 1562 = 3201)
      mut as int64: denA1 = k_const + 1
      mut as int64: denA2 = k_const + 4
      mut as int64: rrfA1 = 100000 /i denA1
      mut as int64: rrfA2 = 100000 /i denA2
      mut as int64: rrfA = rrfA1 + rrfA2

      #L Documento B:
      #L Posicao no ranking lexico: rank_lex = 5
      #L Posicao no ranking denso: rank_dense = 2
      #L RRF(B) = 1/(60 + 5) + 1/(60 + 2) = 1/65 + 1/62 (escala x100000 -> 1538 + 1612 = 3150)
      mut as int64: denB1 = k_const + 5
      mut as int64: denB2 = k_const + 2
      mut as int64: rrfB1 = 100000 /i denB1
      mut as int64: rrfB2 = 100000 /i denB2
      mut as int64: rrfB = rrfB1 + rrfB2

      println("1. Score RRF Documento A (x100000): " + rrfA)
      println("2. Score RRF Documento B (x100000): " + rrfB)

      #L Documento A apresenta pontuacao combinada superior
      mut as int64: vencedor = 0
      route {
            rrfA > rrfB ==> {
                  vencedor = 1
            }
            _ ==> {
                  vencedor = 2
            }
      }

      println("3. Vencedor da busca hibrida: Documento " + vencedor)

      route {
            vencedor == 1 and rrfA == 3201 ==> {
                  println("4. Fusao Reciprocal Rank Fusion validada com sucesso.")
            }
            _ ==> {
                  println("Falha na fusao RRF.")
            }
      }
      println("Teste concluido com sucesso.")
}
