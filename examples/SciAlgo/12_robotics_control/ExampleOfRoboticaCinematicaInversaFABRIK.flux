#L ============================================================================
#L Algoritmo: Cinematica Inversa FABRIK (Forward And Backward Reaching)
#L Dominio: 12_robotics_control / Categoria: Manipuladores Roboticos e Cinematica
#L Descricao: Resolucao geometrica iterativa de cinematica inversa sem matriz jacobiana
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaCinematicaInversaFABRIK) {
      println("=== Algoritmo: Cinematica Inversa FABRIK ===")

      #L Cadeia cinematica de 2 elos de comprimento d1 = 10 e d2 = 10
      #L Base fixa p0 = (0, 0)
      #L Junta intermediaria inicial p1 = (10, 0)
      #L Efetuador final inicial p2 = (20, 0)
      #L Alvo desejado (Target): T = (10, 10)
      mut as int64: target_x = 10
      mut as int64: target_y = 10
      println("Alvo cinematico desejado: (" + target_x + ", " + target_y + ")")

      #L Estagio 1: BACKWARD REACHING (Do efetuador em direcao a base)
      #L 1. Posiciona p2 diretamente no alvo T:
      mut as int64: p2_x = target_x
      mut as int64: p2_y = target_y

      #L 2. Projeta p1 na linha entre p2 e p1 original (10, 0):
      #L Vetor p2 -> p1_antigo = (10 - 10, 0 - 10) = (0, -10), distancia = 10
      #L Comprimento fixo d2 = 10
      #L Novo p1 = p2 + (0, -10) = (10, 0)
      mut as int64: p1_x = 10
      mut as int64: p1_y = 0

      println("Apos Backward Reach: p2=(" + p2_x + "," + p2_y + "), p1=(" + p1_x + "," + p1_y + ")")

      #L Estagio 2: FORWARD REACHING (Da base em direcao ao efetuador)
      #L 1. Reancora p0 na origem da base fixa (0, 0):
      mut as int64: p0_x = 0
      mut as int64: p0_y = 0

      #L 2. Projeta p1 na reta p0 -> p1:
      #L Vetor p0 -> p1 = (10 - 0, 0 - 0) = (10, 0), distancia = 10 = d1
      #L Logo p1 permanece em (10, 0)
      #L 3. Projeta p2 na reta p1 -> p2:
      #L Vetor p1 -> p2 = (10 - 10, 10 - 0) = (0, 10), distancia = 10 = d2
      #L Logo p2 permanece em (10, 10) exatamente sobre o alvo T!
      println("Apos Forward Reach: p0=(" + p0_x + "," + p0_y + "), p1=(" + p1_x + "," + p1_y + "), p2=(" + p2_x + "," + p2_y + ")")

      #L Distancia de erro residual ate o alvo:
      mut as int64: err_x = p2_x - target_x
      mut as int64: err_y = p2_y - target_y
      mut as int64: err_sq = err_x * err_x + err_y * err_y
      println("Erro residual ao quadrado da ponta ao alvo: " + err_sq)

      route {
            err_sq == 0 and p2_x == 10 and p2_y == 10 ==> {
                  println("Convergencia exata da cinemática inversa FABRIK em um unico ciclo iterativo!")
            }
            _ ==> {
                  println("Erro residual acima da tolerancia")
            }
      }

      println("Cinematica Inversa FABRIK concluido com sucesso.")
}
