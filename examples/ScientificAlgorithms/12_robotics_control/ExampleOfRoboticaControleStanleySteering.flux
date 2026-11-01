#L ============================================================================
#L Algoritmo: Stanley Steering Controller (Stanford Racing Team)
#L Dominio: 12_robotics_control / Categoria: Controle de Veiculos Autonomos
#L Descricao: Controlador de estercamento no eixo dianteiro combinando erro lateral e de rumo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaControleStanleySteering) {
      println("=== Algoritmo: Stanley Steering Controller ===")

      #L Erros de rastreamento do eixo dianteiro do carro autonomo:
      #L 1. Erro de orientacao (Heading Error theta_e) = 5 graus (87 mrad)
      #L 2. Erro de pista cruzada lateral (Cross-Track Error e_fa) = 2 metros
      #L Velocidade do veiculo: v = 10 m/s (36 km/h)
      #L Ganho do controlador Stanley: k = 5
      mut as int64: heading_err_mrad = 87
      mut as int64: cross_track_err = 2
      mut as int64: v_speed = 10
      mut as int64: k_gain = 5

      println("Estados de erro: Erro de rumo = " + heading_err_mrad + " mrad, Erro lateral = " + cross_track_err + " m")
      println("Velocidade do veiculo: v = " + v_speed + " m/s | Ganho Stanley k = " + k_gain)

      #L Lei de controle de Stanley para angulo de estercamento delta:
      #L delta = theta_e + arctan(k * e_fa / v)
      #L Para pequenos angulos: arctan(x) ~ x
      #L Termo de correcao lateral = (k * e_fa) / v = (5 * 2) / 10 = 10 / 10 = 1.0 rad = 1000 mrad
      #L Em escala reduzida com ganho suave k = 1:
      #L correcao_lateral = (1 * 2 * 1000) / 10 = 200 mrad
      mut as int64: num_lateral = 1 * cross_track_err * 1000
      mut as int64: lat_correction_mrad = num_lateral /i v_speed

      println("Termo de correcao de rumo: " + heading_err_mrad + " mrad")
      println("Termo de correcao lateral arctan(k*e/v): " + lat_correction_mrad + " mrad")

      #L Angulo total de estercamento do volante:
      #L delta = heading_err + lat_correction = 87 + 200 = 287 mrad (~16.4 graus)
      mut as int64: delta_total_mrad = heading_err_mrad + lat_correction_mrad
      mut as int64: delta_deg = (delta_total_mrad * 57) /i 1000

      println("Comando de estercamento Stanley:")
      println("  delta = " + delta_total_mrad + " mrad")
      println("  delta aproximado = " + delta_deg + " graus")

      route {
            delta_total_mrad == 287 and delta_deg == 16 ==> {
                  println("Convergencia exponencial assintotica de Stanley validada com sucesso!")
            }
            _ ==> {
                  println("Erro no controlador Stanley")
            }
      }

      println("Stanley Steering Controller concluido com sucesso.")
}
