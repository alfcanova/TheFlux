#L ============================================================================
#L Algoritmo: RoPE (Rotary Position Embedding)
#L Dominio: 08_artificial_intel / Subdominio: Processamento de Linguagem Natural
#L Descricao: Incorporacao rotacional de posicao relativa para modelos Transformer (LLaMA/Mistral)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPRoPE) {
      println("=== Algoritmo: RoPE (Rotary Position Embedding) ===")

      #L Vetor 2D na posicao m=1: x = [10, 0]
      #L Angulo theta correspondente a rotacao de 90 graus:
      #L cos(theta) = 0, sin(theta) = 1
      mut as int64: x1 = 10
      mut as int64: x2 = 0
      mut as int64: cos_theta = 0
      mut as int64: sin_theta = 1

      #L Rotacao RoPE 2D:
      #L rot_x1 = x1 * cos_theta - x2 * sin_theta = 10*0 - 0*1 = 0
      #L rot_x2 = x1 * sin_theta + x2 * cos_theta = 10*1 + 0*0 = 10
      mut as int64: term1 = x1 * cos_theta
      mut as int64: term2 = x2 * sin_theta
      mut as int64: rot_x1 = term1 - term2

      mut as int64: term3 = x1 * sin_theta
      mut as int64: term4 = x2 * cos_theta
      mut as int64: rot_x2 = term3 + term4

      println("1. Vetor original x: (" + x1 + ", " + x2 + ")")
      println("2. Vetor rotacionado via RoPE: (" + rot_x1 + ", " + rot_x2 + ")")

      #L Preservacao da norma euclidiana sob rotacao ortogonal:
      #L norm^2 = rot_x1^2 + rot_x2^2 = 0 + 100 = 100
      mut as int64: norm_sq = rot_x1 * rot_x1 + rot_x2 * rot_x2
      println("3. Norma quadratica preservada: " + norm_sq)

      route {
            rot_x1 == 0 and rot_x2 == 10 and norm_sq == 100 ==> {
                  println("4. Incorporacao posicional rotativa RoPE validada com sucesso.")
            }
            _ ==> {
                  println("Falha na rotacao RoPE.")
            }
      }
      println("Teste concluido com sucesso.")
}
