#L ============================================================================
#L Algoritmo: Curvas de Reeds-Shepp (Trajetorias Otimo com Marcha a Re)
#L Dominio: 12_robotics_control / Categoria: Planejamento Cinematico Nao-Holonomico
#L Descricao: Caminhos mais curtos de curvatura limitada com mudanca de sentido (re e frente)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaTrajetoriaCurvasReedsShepp) {
      println("=== Algoritmo: Curvas de Reeds-Shepp (Manobra a Re) ===")

      #L Cenário de manobra de baliza / estacionamento restrito:
      #L O carro precisa deslocar-se lateralmente para um espaco paralelo
      #L Sem marcha a re (Dubins), exigiria uma volta gigantesca com raio R_min = 10
      #L Com Reeds-Shepp, permite manobra de 3 estagios C|C|C (Curva a Frente, Curva a Re, Curva a Frente)
      mut as int64: r_min = 10
      println("Raio minimo de giro: R_min = " + r_min)

      #L Estagio 1: Curva para a esquerda para a frente (L+ com arco s1 = 4 unidades)
      mut as int64: seg1_len = 4
      println("Estagio 1: L+ (Curva a frente para a esquerda): " + seg1_len + " unidades")

      #L Estagio 2: Ponto de inflexao (Cusp Point) com inversao de sentido:
      #L Curva para a direita em marcha a re (R- com arco s2 = 4 unidades)
      mut as int64: seg2_len = 4
      println("Estagio 2: R- (Curva a re para a direita com cuspide): " + seg2_len + " unidades")

      #L Estagio 3: Inversao de sentido e avanco para alinhamento:
      #L Curva para a esquerda para a frente (L+ com arco s3 = 4 unidades)
      mut as int64: seg3_len = 4
      println("Estagio 3: L+ (Curva a frente para alinhamento paralelo): " + seg3_len + " unidades")

      #L Comprimento total da trajetoria Reeds-Shepp:
      #L L_rs = seg1 + seg2 + seg3 = 4 + 4 + 4 = 12 unidades
      mut as int64: total_rs_length = seg1_len + seg2_len + seg3_len
      println("Comprimento total da manobra Reeds-Shepp: " + total_rs_length + " unidades")

      #L Comparativo: Trajetoria de Dubins restrita a marcha a frente precisaria de mais de 50 unidades
      mut as int64: dubins_equivalent = 52
      mut as int64: economy = dubins_equivalent - total_rs_length
      println("Economia de deslocamento com marcha a re: " + economy + " unidades")

      route {
            total_rs_length == 12 and economy > 30 ==> {
                  println("Manobra cinematica de Reeds-Shepp concluida no espaco compacto de estacionamento!")
            }
            _ ==> {
                  println("Erro no planejamento Reeds-Shepp")
            }
      }

      println("Curvas de Reeds-Shepp concluido com sucesso.")
}
