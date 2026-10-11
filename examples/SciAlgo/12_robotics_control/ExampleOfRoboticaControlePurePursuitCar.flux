#L ============================================================================
#L Algoritmo: Pure Pursuit Path Tracking (Rastreamento Geometrico de Trajetorias)
#L Dominio: 12_robotics_control / Categoria: Controle de Veiculos Autonomos
#L Descricao: Calculo geometrico de angulo de estercamento baseado em ponto de mira a frente
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaControlePurePursuitCar) {
      println("=== Algoritmo: Pure Pursuit Path Tracking ===")

      #L Geometria do veiculo de Ackermann:
      #L Distancia entre eixos (Wheelbase L): L = 3 metros
      #L Distancia de visada a frente (Lookahead Distance Ld): Ld = 10 metros
      #L Ponto de mira (Lookahead Point) no referencial do veiculo:
      #L Coordenadas: x_ahead = 8 metros, y_lateral = 6 metros
      #L Ld^2 = 8^2 + 6^2 = 64 + 36 = 100 -> Ld = 10
      mut as int64: wheelbase_l = 3
      mut as int64: lookahead_ld = 10
      mut as int64: y_lateral = 6

      println("Parametros do veiculo: Wheelbase L = " + wheelbase_l + " m, Lookahead Ld = " + lookahead_ld + " m")
      println("Erro lateral do ponto de mira: y = " + y_lateral + " m")

      #L Formula geometrica de curvatura de arco do Pure Pursuit:
      #L Curvatura kappa = 2 * y_lateral / (Ld^2)
      #L kappa = 2 * 6 / 100 = 12 / 100 = 0.12 m^-1 (120 em escala x1000)
      mut as int64: num_kappa = 2 * y_lateral * 1000
      mut as int64: ld_sq = lookahead_ld * lookahead_ld
      mut as int64: kappa_x1000 = num_kappa /i ld_sq

      println("Curvatura do arco circular perseguido (x1000): " + kappa_x1000)

      #L Angulo de estercamento do volante delta:
      #L tan(delta) = L * kappa
      #L delta ~ L * kappa (para angulos moderados)
      #L delta_x1000 = (wheelbase_l * kappa_x1000) = 3 * 120 = 360 (0.36 rad ~ 20.6 graus)
      mut as int64: delta_rad_x1000 = wheelbase_l * kappa_x1000
      mut as int64: delta_deg = (delta_rad_x1000 * 57) /i 1000

      println("Angulo de estercamento calculado pelo Pure Pursuit:")
      println("  delta = " + delta_rad_x1000 + "/1000 rad")
      println("  delta aproximado: " + delta_deg + " graus")

      route {
            delta_deg >= 20 and delta_deg <= 22 ==> {
                  println("Comando de estercamento geometrico suave convergindo veiculo para a rota!")
            }
            _ ==> {
                  println("Erro no estercamento Pure Pursuit")
            }
      }

      println("Pure Pursuit Path Tracking concluido com sucesso.")
}
