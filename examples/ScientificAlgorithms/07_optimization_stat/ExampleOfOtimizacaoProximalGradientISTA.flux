#L ============================================================================
#L Algoritmo: Proximal Gradient Descent (ISTA)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao Nao-Suave e Esparsa
#L Descricao: Algoritmo iterativo de encolhimento e limiarizacao (Soft-Thresholding)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoProximalGradientISTA) {
      println("=== Algoritmo: Proximal Gradient Descent (ISTA) ===")

      #L Ponto atual x = 50, gradiente da parte suave grad_f = 20, taxa gamma = 1
      #L Passo de gradiente preliminar: z = x - gamma * grad_f = 50 - 20 = 30
      mut as int64: x = 50
      mut as int64: grad_f = 20
      mut as int64: z = x - grad_f

      #L Parametro de penalizacao L1 (regularizacao Lasso): lambda = 10
      #L Operador Proximal (Soft-Thresholding): S_lambda(z) = sign(z) * max(0, |z| - lambda)
      #L Como z = 30 > 0:
      #L S_lambda(30) = 30 - 10 = 20
      mut as int64: lambda_param = 10
      mut as int64: x_novo = z - lambda_param

      #L Teste com coeficiente pequeno que deve ser zerado (esparsidade):
      #L z2 = 8, lambda = 10 -> |z2| < lambda -> S_lambda(8) = 0!
      mut as int64: z2 = 8
      mut as int64: x2_novo = 0
      route {
            z2 > lambda_param ==> {
                  x2_novo = z2 - lambda_param
            }
            _ ==> {
                  x2_novo = 0
            }
      }

      println("1. Ponto intermediario apos passo de gradiente: " + z)
      println("2. Ponto atualizado apos Soft-Thresholding: " + x_novo)
      println("3. Coeficiente pequeno z2=" + z2 + " reduzido a zero (esparsidade): " + x2_novo)

      route {
            x_novo == 20 and x2_novo == 0 ==> {
                  println("4. Operador proximal de limiarizacao suave ISTA validado.")
            }
            _ ==> {
                  println("Falha no ISTA.")
            }
      }
      println("Teste concluido com sucesso.")
}
