#L ============================================================================
#L Algoritmo: Ramer-Douglas-Peucker (Simplificacao de Polilinhas 2D)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(N log N) caso medio | O(N^2) pior caso
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisRamerDouglasPeucker) {
      println("==================================================")
      println("  SciAlgo: Ramer-Douglas-Peucker Algorithm")
      println("==================================================")

      #L Polilinha 2D original com 7 pontos (coordenadas X e Y):
      #L (0,0), (1,0.1), (2,-0.1), (3,5), (4,5.1), (5,5), (6,0)
      #L Escalados por 10 para inteiros:
      #L P1=(0,0), P2=(10,1), P3=(20,-1), P4=(30,50), P5=(40,51), P6=(50,50), P7=(60,0)
      mut as list of int64: px = [0, 10, 20, 30, 40, 50, 60]
      mut as list of int64: py = [0,  1, -1, 50, 51, 50,  0]
      mut as int64: n = listLength(px)

      println("1. Pontos originais (N = 7):")
      println("   X: " + px)
      println("   Y: " + py)

      #L Vetor de marcadores dos pontos mantidos (1 = mantido, 0 = simplificado/removido)
      #L Extremos P1 e P7 sao sempre mantidos
      mut as list of int64: kept = [1, 0, 0, 0, 0, 0, 1]

      #L Tolerancia epsilon de desvio perpendicular: limiar de area = 150
      mut as int64: epsilon_area = 150

      #L Pilha de intervalos a processar: [inicio, fim]
      mut as list of int64: st_start = [1]
      mut as list of int64: st_end = [n]

      infinite (listLength(st_start) > 0) {
            mut as int64: top_idx = listLength(st_start)
            mut as int64: s = st_start[top_idx]
            mut as int64: e = st_end[top_idx]

            #L Desempilha
            mut as list of int64: n_ss = []
            mut as list of int64: n_se = []
            mut as int64: si = 1
            infinite (si < top_idx) {
                  n_ss = listPushBack(n_ss, st_start[si])
                  n_se = listPushBack(n_se, st_end[si])
                  si = si + 1
            }
            st_start = n_ss
            st_end = n_se

            #L Encontra o ponto intermediario com maior desvio perpendicular ao segmento (s, e)
            mut as int64: max_dist = 0
            mut as int64: max_idx = 0

            mut as int64: x1 = px[s]
            mut as int64: y1 = py[s]
            mut as int64: x2 = px[e]
            mut as int64: y2 = py[e]

            mut as int64: p = s + 1
            infinite (p < e) {
                  mut as int64: x0 = px[p]
                  mut as int64: y0 = py[p]

                  #L Area do paralelogramo 2x triangulo = |(y2 - y1)*x0 - (x2 - x1)*y0 + x2*y1 - y2*x1|
                  mut as int64: num = (y2 - y1) * x0 - (x2 - x1) * y0 + (x2 * y1) - (y2 * x1)
                  route {
                        num < 0 ==> {
                              num = num * -1
                        }
                  }

                  route {
                        num > max_dist ==> {
                              max_dist = num
                              max_idx = p
                        }
                  }
                  p = p + 1
            }

            #L Se o desvio maximo for superior a tolerancia, preserva o ponto e divide
            route {
                  max_dist > epsilon_area ==> {
                        kept[max_idx] = 1
                        st_start = listPushBack(st_start, s)
                        st_end = listPushBack(st_end, max_idx)

                        st_start = listPushBack(st_start, max_idx)
                        st_end = listPushBack(st_end, e)
                  }
            }
      }

      mut as int64: kept_count = 0
      mut as int64: ki = 1
      infinite (ki <= n) {
            kept_count = kept_count + kept[ki]
            ki = ki + 1
      }

      println("2. Mascara de pontos preservados: " + kept)
      println("3. Total de pontos mantidos: " + kept_count + " de " + n)
      println("4. Pontos redundantes eliminados pelo algoritmo: " + (n - kept_count))
      println("5. Validacao: " + (kept[1] == 1 and kept[4] == 1 and kept[7] == 1 and kept[2] == 0))
      println("==================================================")
}
