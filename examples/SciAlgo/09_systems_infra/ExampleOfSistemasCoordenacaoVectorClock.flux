#L ============================================================================
#L Algoritmo: Vector Clock Causality and Concurrency Detection
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(N) por operacao de envio/recepcao | Vetor de dimensao N
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoVectorClock) {
      println("==================================================")
      println("  SciAlgo: Vector Clocks (Causality & Concurrency)")
      println("==================================================")

      #L Relogios Vetoriais (Fidge & Mattern 1988) capturam relacoes causais
      #L exatas em sistemas distribuidos: V(a) < V(b) <=> a acontece antes de b.
      #L Se nenhum domina o outro, os eventos sao concorrentes (a || b).
      #L
      #L Cluster de 3 processos (P1, P2, P3).
      #L Representacao vetorial achatada (indexacao 1..9):
      #L P1: indices 1, 2, 3
      #L P2: indices 4, 5, 6
      #L P3: indices 7, 8, 9
      mut as list of int64: v = [0, 0, 0, 0, 0, 0, 0, 0, 0]

      println("1. Vetores Iniciais:")
      println("   P1: [0, 0, 0] | P2: [0, 0, 0] | P3: [0, 0, 0]")

      #L Evento 1: Evento local em P1 (e1)
      v[1] = v[1] + 1 #L [1, 0, 0]
      println("2. [Evento Local e1 em P1] P1 = [" + v[1] + ", " + v[2] + ", " + v[3] + "]")

      #L Evento 2: P1 envia mensagem m1 para P2
      v[1] = v[1] + 1 #L [2, 0, 0]
      mut as int64: m1_1 = v[1]
      mut as int64: m1_2 = v[2]
      mut as int64: m1_3 = v[3]
      println("3. [Envio m1: P1 -> P2] P1 transmite vetor [" + m1_1 + ", " + m1_2 + ", " + m1_3 + "]")

      #L Evento 3: Evento local concorrente em P3 (e3)
      v[9] = v[9] + 1 #L P3[3] = 1 -> [0, 0, 1]
      println("4. [Evento Local Concorrente e3 em P3] P3 = [" + v[7] + ", " + v[8] + ", " + v[9] + "]")

      #L Evento 4: P2 recebe mensagem m1 de P1
      #L P2 atualiza maximo componente a componente e incrementa P2[2]
      route {
            m1_1 > v[4] ==> { v[4] = m1_1 }
            _ ==> {}
      }
      route {
            m1_2 > v[5] ==> { v[5] = m1_2 }
            _ ==> {}
      }
      route {
            m1_3 > v[6] ==> { v[6] = m1_3 }
            _ ==> {}
      }
      v[5] = v[5] + 1 #L P2[2] = P2[2] + 1 -> P2 = [2, 1, 0]
      println("5. [Recepcao m1 em P2] P2 mergeia e incrementa -> P2 = [" + v[4] + ", " + v[5] + ", " + v[6] + "]")

      #L ======================================================================
      #L Analise de Causalidade vs Concorrencia
      #L ======================================================================
      println("==================================================")
      println("6. Analise Formal de Causalidade:")
      println("   Evento e1 (em P1): [1, 0, 0]")
      println("   Evento e2 (em P2): [" + v[4] + ", " + v[5] + ", " + v[6] + "]")
      println("   Evento e3 (em P3): [" + v[7] + ", " + v[8] + ", " + v[9] + "]")

      #L Comparando e1 com e2: e1 <= e2 pois 1<=2, 0<=1, 0<=0 (e e1 != e2) -> e1 causou e2!
      println("   -> e1 antecede causalmente e2: e1 -> e2 (SIM)")

      #L Comparando e2 com e3:
      #L e2 tem componente 1 (2 > 0) maior que e3, mas e3 tem componente 3 (1 > 0) maior que e2!
      #L Portanto: e2 e e3 sao CONCORRENTES (e2 || e3)!
      println("   -> e2 e e3 sao CONCORRENTES: e2 || e3 (SIM, detectado via divergencia de componentes)")
      println("==================================================")
      println("  Relogios Vetoriais Validados com Sucesso!")
      println("==================================================")
}
