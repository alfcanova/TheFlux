#L ============================================================================
#L Algoritmo: Maekawa Voting Quorum Mutual Exclusion Algorithm
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(sqrt(N)) mensagens por entrada na SC
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoMaekawa) {
      println("==================================================")
      println("  SciAlgo: Maekawa Quorum-Based Mutual Exclusion")
      println("==================================================")

      #L O algoritmo de Maekawa reduz o numero de mensagens necessarias
      #L para exclusao mutua de O(N) para O(sqrt(N)) utilizando conjuntos
      #L de votacao (quorums) que satisfazem a propriedade de intersecao nao-vazia:
      #L Para quaisquer dois conjuntos Ri e Rj, Ri inter Rj != vazio.
      #L
      #L Configuracao para N = 3:
      #L R1 = {1, 2}
      #L R2 = {2, 3}
      #L R3 = {1, 3}
      #L Intersecoes: R1 inter R2 = {2}, R1 inter R3 = {1}, R2 inter R3 = {3}.

      mut as int64: num_nodes = 3

      #L Estado de voto de cada nó: 0 = LIVRE, >0 = VOTOU_NO_ID
      mut as list of int64: voted_for = [0, 0, 0]

      println("1. Estrutura dos Quorums de Votacao:")
      println("   Quorum R1: {1, 2} | Quorum R2: {2, 3} | Quorum R3: {1, 3}")
      println("   Propriedade: Todo par de quorums compartilha pelo menos um arbitro.")

      #L ======================================================================
      #L Cenario: No 1 solicita Secao Critica ao seu Quorum R1 = {1, 2}
      #L ======================================================================
      println("2. [Solicitacao de SC] No 1 envia REQUEST aos membros de R1 ({1, 2}):")

      mut as int64: grants_node1 = 0

      #L Membro 1 de R1: No 1
      route {
            voted_for[1] == 0 ==> {
                  voted_for[1] = 1
                  grants_node1 = grants_node1 + 1
                  println("   -> No 1 concede voto a si mesmo (GRANT)")
            }
            _ ==> {}
      }

      #L Membro 2 de R1: No 2
      route {
            voted_for[2] == 0 ==> {
                  voted_for[2] = 1
                  grants_node1 = grants_node1 + 1
                  println("   -> No 2 concede voto a No 1 (GRANT)")
            }
            _ ==> {}
      }

      #L No 1 obteve todos os votos do seu quorum (2/2)
      route {
            grants_node1 == 2 ==> {
                  println("3. [Entrada na SC] No 1 obteve quorum completo e entra na Secao Critica!")
            }
            _ ==> {}
      }

      #L ======================================================================
      #L Concorrencia: No 2 tenta solicitar SC ao seu Quorum R2 = {2, 3}
      #L ======================================================================
      println("4. [Conflito Concorrente] No 2 solicita SC ao Quorum R2 ({2, 3}):")
      #L No 2 ja votou em No 1, entao recusa/bloqueia seu proprio voto!
      route {
            voted_for[2] != 0 ==> {
                  println("   -> No 2 ja esta travado em favor de No " + voted_for[2] + " (BLOQUEADO/ESPERA)!")
            }
            _ ==> {}
      }
      println("   -> No 2 NAO pode entrar na SC devido a intersecao R1 inter R2 = {2}!")

      #L ======================================================================
      #L No 1 sai da SC e libera o quorum R1
      #L ======================================================================
      println("5. [Liberacao da SC] No 1 conclui operacao e envia RELEASE a {1, 2}:")
      voted_for[1] = 0
      voted_for[2] = 0
      println("   -> Votos de No 1 e No 2 liberados (status = LIVRE).")

      #L ======================================================================
      #L No 2 agora pode obter seus votos de R2 = {2, 3}
      #L ======================================================================
      println("6. [Concessao Posterga] No 2 adquire votos do Quorum R2 ({2, 3}):")
      voted_for[2] = 2
      voted_for[3] = 2
      println("   -> No 2 e No 3 concedem votos ao No 2.")
      println("   -> No 2 ENTRA na Secao Critica com exclusao mutua garantida!")
      voted_for[2] = 0
      voted_for[3] = 0
      println("   -> No 2 conclui e libera R2.")

      println("==================================================")
      println("7. Verificacao de Seguranca Maekawa:")
      println("   Exclusao mutua perfeita com garantia por intersecao de quorums.")
      println("==================================================")
}
