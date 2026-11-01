#L ============================================================================
#L Algoritmo: Two-Tower DSSM Recommendation
#L Dominio: 08_artificial_intel / Subdominio: Sistemas de Recomendacao
#L Descricao: Arquitetura de duas torres (Usuario e Item) para recuperacao de candidatos em larga escala
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoTwoTowerModel) {
      println("=== Algoritmo: Two-Tower DSSM Recommendation ===")

      #L Torre 1: Torre do Usuario (projecao de features demograficas e historico)
      #L Embedding resultante do usuario u = [10, 20, 5]
      mut as int64: u1 = 10
      mut as int64: u2 = 20
      mut as int64: u3 = 5

      #L Torre 2: Torre do Item (projecao offline de metadados e catalogo)
      #L Embedding do Item A (conteudo altamente relevante): [12, 18, 6]
      #L Embedding do Item B (conteudo irrelevante): [1, 2, 20]
      mut as int64: ia1 = 12
      mut as int64: ia2 = 18
      mut as int64: ia3 = 6

      mut as int64: ib1 = 1
      mut as int64: ib2 = 2
      mut as int64: ib3 = 20

      #L Produto escalar Torre-a-Torre (Maximum Inner Product Search - MIPS):
      #L Score(u, Item A) = 10*12 + 20*18 + 5*6 = 120 + 360 + 30 = 510
      #L Score(u, Item B) = 10*1  + 20*2  + 5*20 = 10  + 40  + 100 = 150
      mut as int64: scoreA = u1 * ia1 + u2 * ia2 + u3 * ia3
      mut as int64: scoreB = u1 * ib1 + u2 * ib2 + u3 * ib3

      println("1. Score de afinidade com Item A: " + scoreA)
      println("2. Score de afinidade com Item B: " + scoreB)

      #L Selecao de candidato pelo indice vetorial:
      mut as int64: melhorItem = 0
      route {
            scoreA > scoreB ==> {
                  melhorItem = 1
            }
            _ ==> {
                  melhorItem = 2
            }
      }

      println("3. Item selecionado no estagio de geracao de candidatos: Item " + melhorItem)

      route {
            melhorItem == 1 and scoreA == 510 ==> {
                  println("4. Modelo Two-Tower DSSM validado com sucesso.")
            }
            _ ==> {
                  println("Falha na recomendacao Two-Tower.")
            }
      }
      println("Teste concluido com sucesso.")
}
