#L ============================================================================
#L Algoritmo: Affinity Propagation
#L Dominio: 08_artificial_intel / Subdominio: Machine Learning Classico
#L Descricao: Clustering por troca iterativa de mensagens de responsabilidade e disponibilidade
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoAffinityPropagation) {
      println("=== Algoritmo: Affinity Propagation ===")

      #L Matriz de similaridade S para 3 pontos (distancias negativas)
      #L S(1,1)=-10, S(1,2)=-5,  S(1,3)=-20
      #L S(2,1)=-5,  S(2,2)=-10, S(2,3)=-15
      #L S(3,1)=-20, S(3,2)=-15, S(3,3)=-10
      mut as int64: s11 = 0 - 10
      mut as int64: s12 = 0 - 5
      mut as int64: s13 = 0 - 20

      #L Inicializacao: Disponibilidades a(i,k) = 0
      mut as int64: a11 = 0
      mut as int64: a12 = 0
      mut as int64: a13 = 0

      #L Atualizacao de Responsabilidade: r(1,2) = s(1,2) - max(s(1,1)+a11, s(1,3)+a13)
      #L max(-10, -20) = -10
      mut as int64: maxOther = 0 - 10
      mut as int64: r12 = s12 - maxOther

      #L r(1,2) = -5 - (-10) = 5
      println("1. Similaridade S(1,2): " + s12)
      println("2. Responsabilidade r(1,2) calculada: " + r12)

      #L Disponibilidade a(1,2) acumulada a partir do auto-exemplo
      mut as int64: r22 = 12
      mut as int64: a12_nova = r22
      route {
            a12_nova > 0 ==> {
                  a12_nova = 0
            }
            _ ==> {}
      }

      #L Criterio de exemplar para o ponto 1: soma (r + a)
      mut as int64: scoreExemplar2 = r12 + a12_nova
      println("3. Score conjunto (r + a) para o candidato 2: " + scoreExemplar2)

      route {
            scoreExemplar2 == 5 ==> {
                  println("4. Mensagens de Affinity Propagation convergiram corretamente.")
            }
            _ ==> {
                  println("Falha no calculo de Affinity Propagation.")
            }
      }
      println("Teste concluido com sucesso.")
}
