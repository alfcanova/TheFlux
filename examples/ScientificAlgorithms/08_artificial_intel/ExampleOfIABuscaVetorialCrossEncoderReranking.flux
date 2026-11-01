#L ============================================================================
#L Algoritmo: Cross-Encoder Re-Ranking
#L Dominio: 08_artificial_intel / Subdominio: Busca Vetorial e RAG
#L Descricao: Reordenacao de alta precisao baseada em atencao cruzada conjunta pergunta-documento
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIABuscaVetorialCrossEncoderReranking) {
      println("=== Algoritmo: Cross-Encoder Re-Ranking ===")

      #L Estagio 1 (Recuperacao rapida Bi-Encoder):
      #L Candidato 1: Score esparso/denso = 80
      #L Candidato 2: Score esparso/denso = 78
      #L Candidato 3: Score esparso/denso = 75

      #L Estagio 2 (Classificacao profunda com Cross-Encoder):
      #L O modelo avalia a atencao mutua entre todos os tokens da consulta e do documento
      #L Doc 1: pontuacao refinada = 65 (relevancia superficial)
      #L Doc 2: pontuacao refinada = 94 (relevancia semantica exata ao contexto)
      #L Doc 3: pontuacao refinada = 40
      mut as int64: ce_score1 = 65
      mut as int64: ce_score2 = 94
      mut as int64: ce_score3 = 40

      println("1. Score Bi-Encoder Doc 1: 80 | Score Cross-Encoder: " + ce_score1)
      println("2. Score Bi-Encoder Doc 2: 78 | Score Cross-Encoder: " + ce_score2)
      println("3. Score Bi-Encoder Doc 3: 75 | Score Cross-Encoder: " + ce_score3)

      #L Reordenacao com base nos scores Cross-Encoder:
      #L Top-1 apos reclassificacao: Doc 2
      mut as int64: top1_doc = 1
      route {
            ce_score2 > ce_score1 ==> {
                  top1_doc = 2
            }
            _ ==> {}
      }

      println("4. Documento promovido para Top-1 apos Re-Ranking: Doc " + top1_doc)

      route {
            top1_doc == 2 and ce_score2 == 94 ==> {
                  println("5. Segundo estagio Cross-Encoder validado com sucesso.")
            }
            _ ==> {
                  println("Falha no Re-Ranking.")
            }
      }
      println("Teste concluido com sucesso.")
}
