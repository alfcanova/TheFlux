#L ============================================================================
#L Algoritmo: Cinematica Inversa DLS (Damped Least Squares / Inversa Amortecida)
#L Dominio: 12_robotics_control / Categoria: Manipuladores Roboticos e Cinematica
#L Descricao: Resolucao diferencial robusta a singularidades com amortecimento de Levenberg
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaCinematicaInversaJacobianDLS) {
      println("=== Algoritmo: Cinematica Inversa Jacobian DLS ===")

      #L Braco robotico em configuracao proxima de singularidade (elo quase estendido):
      #L Jacobiano escalar de 1 grau de liberdade J = 2 (valor proximo de zero na singularidade)
      #L Erro de posicao desejado do efetuador e = 100
      mut as int64: j_val = 2
      mut as int64: error_pos = 100

      #L Pseudoinversa nao-amortecida de Moore-Penrose:
      #L delta_theta_pinv = e / J = 100 / 2 = 50 (velocidade articular excessiva/violenta)
      mut as int64: delta_theta_pinv = error_pos /i j_val
      println("Pseudoinversa padrao (sem amortecimento): delta_theta = " + delta_theta_pinv)

      #L Metodo Damped Least Squares (DLS):
      #L J_dls = J / (J^2 + lambda^2)
      #L Fator de amortecimento lambda = 4 -> lambda^2 = 16
      #L Denominador amortecido = J^2 + lambda^2 = 2^2 + 16 = 4 + 16 = 20
      mut as int64: lambda_sq = 16
      mut as int64: j_sq = j_val * j_val
      mut as int64: denom_dls = j_sq + lambda_sq

      #L Atualizacao angular amortecida:
      #L delta_theta_dls = (J * error_pos) / (J^2 + lambda^2)
      #L delta_theta_dls = (2 * 100) / 20 = 200 / 20 = 10 (velocidade controlada e suave!)
      mut as int64: num_dls = j_val * error_pos
      mut as int64: delta_theta_dls = num_dls /i denom_dls

      println("Damped Least Squares (lambda^2 = " + lambda_sq + "):")
      println("  Denominador amortecido: " + denom_dls)
      println("  Velocidade angular amortecida delta_theta = " + delta_theta_dls)

      #L Eficacia contra singularidade:
      route {
            delta_theta_dls < delta_theta_pinv and delta_theta_dls == 10 ==> {
                  println("Estabilidade cinematica garantida: Velocidade de junta contida na regiao singular!")
            }
            _ ==> {
                  println("Instabilidade cinematica")
            }
      }

      println("Cinematica Inversa Jacobian DLS concluido com sucesso.")
}
