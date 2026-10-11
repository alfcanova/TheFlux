#L ============================================================================
#L Algoritmo: Jump Point Search (JPS - Harabor & Grastien 2011)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: Ordens de magnitude mais rapido que A* em grids uniformes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaJumpPoint) {
      println("==================================================")
      println("  SciAlgo: Jump Point Search (JPS)")
      println("==================================================")

      #L Grid 5x8: 0 = livre, 1 = obstaculo
      #L Linha 2 tem um obstaculo em (2, 5) gerando vizinho forcado
      mut as list of list of int64: grid = [
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0]
      ]

      mut as int64: start_r = 3
      mut as int64: start_c = 1
      mut as int64: goal_r = 3
      mut as int64: goal_c = 8

      println("1. Origem: (" + start_r + "," + start_c + ") | Destino: (" + goal_r + "," + goal_c + ")")

      #L JPS executa salto horizontal para a direita (dr=0, dc=1)
      #L Em vez de expandir no a no, salta em linha reta ate encontrar o objetivo ou vizinho forcado
      mut as int64: cr = start_r
      mut as int64: cc = start_c
      mut as int64: jump_steps = 0
      mut as int64: jump_point_c = 0
      mut as bool: reached_goal = false

      infinite (cc < 8) {
            jump_steps = jump_steps + 1
            cc = cc + 1

            route {
                  cr == goal_r and cc == goal_c ==> {
                        reached_goal = true
                        jump_point_c = cc
                        break
                  }
            }

            #L Detecta vizinho forcado: celula adjacente com obstaculo que requer contorno
            route {
                  grid[cr - 1][cc] == 1 ==> {
                        #L Encontrou ponto de inflexao / vizinho forcado
                        jump_point_c = cc
                        break
                  }
            }
      }

      println("2. Primeiro Jump Point identificado em coluna: " + jump_point_c)
      println("3. Celulas intermediarias puladas pelo salto: " + (jump_point_c - start_c - 1))
      println("4. Passos no salto horizontal continuo: " + jump_steps)
      println("5. Validacao: " + (jump_point_c == 5 and jump_steps == 4))
      println("==================================================")
}
