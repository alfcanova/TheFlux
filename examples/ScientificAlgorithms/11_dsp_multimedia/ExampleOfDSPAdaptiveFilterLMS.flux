#L ============================================================================
#L Algoritmo: Filtro Adaptativo LMS (Least Mean Squares - Widrow-Hoff)
#L Dominio: 11_dsp_multimedia / Categoria: Filtragem Adaptativa
#L Descricao: Atualizacao estocastica de gradiente para cancelamento adaptativo de ruido
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPAdaptiveFilterLMS) {
      println("=== Algoritmo: Filtro Adaptativo LMS (Widrow-Hoff) ===")

      #L Identificacao de sistema: Queremos aprender um peso de filtro w que se aproxime do alvo w* = 500
      #L Peso adaptativo inicial: w = 0
      #L Taxa de convergencia (step size mu x1000): mu = 50 (0.05)
      mut as int64: w = 0
      mut as int64: mu = 50

      println("Peso inicial w = " + w + ", passo de adaptacao mu = " + mu + "/1000")

      #L Iteracao 1:
      #L Entrada x = 1000, Saida desejada d = 500
      #L Estimativa y = (w * x) / 1000 = (0 * 1000) / 1000 = 0
      #L Erro e = d - y = 500 - 0 = 500
      #L Gradiente estocastico dw = (mu * e * x) / (1000 * 1000)
      #L dw = (50 * 500 * 1000) / 1000000 = 25000000 / 1000000 = 25
      #L w_novo = w + dw = 0 + 25 = 25
      mut as int64: x1 = 1000
      mut as int64: d1 = 500
      mut as int64: y1 = (w * x1) /i 1000
      mut as int64: e1 = d1 - y1
      mut as int64: dw1 = (mu * e1) /i 1000
      w = w + dw1
      println("Iteracao 1: Erro e = " + e1 + ", Novo peso adaptado w = " + w)

      #L Iteracao 2:
      #L Entrada x = 1000, Saida desejada d = 500
      #L y2 = (25 * 1000) / 1000 = 25
      #L e2 = 500 - 25 = 475
      #L dw2 = (mu * e2) / 1000 = (50 * 475) / 1000 = 23750 / 1000 = 23
      #L w_novo = 25 + 23 = 48
      mut as int64: y2 = (w * x1) /i 1000
      mut as int64: e2 = d1 - y2
      mut as int64: dw2 = (mu * e2) /i 1000
      w = w + dw2
      println("Iteracao 2: Erro e = " + e2 + ", Novo peso adaptado w = " + w)

      #L Reducao estrita do erro quadratico (convergencia LMS garantida):
      route {
            e2 < e1 and w > 0 ==> {
                  println("Convergencia LMS em direcao a solucao de Wiener observada com sucesso!")
            }
            _ ==> {
                  println("Divergencia adaptativa")
            }
      }

      println("Filtro Adaptativo LMS concluido com sucesso.")
}
