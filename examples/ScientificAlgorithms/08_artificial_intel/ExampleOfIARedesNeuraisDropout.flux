#L ============================================================================
#L Algoritmo: Inverted Dropout Regularization
#L Dominio: 08_artificial_intel / Subdominio: Redes Neurais e Regularizacao
#L Descricao: Regularizacao estocastica com mascara de Bernoulli e escalonamento inverso 1/(1-p)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisDropout) {
      println("=== Algoritmo: Inverted Dropout Regularization ===")

      #L Taxa de dropout p = 0.5 (probabilidade de descarte 50%)
      #L Fator de escala inverso: 1 / (1 - p) = 2
      mut as int64: scale_factor = 2

      #L Vetor de ativacoes antes do dropout: x = [10, 20, 30, 40]
      mut as list of int64: x = [10, 20, 30, 40]

      #L Mascara binaria estocastica simulada: [1, 0, 1, 0]
      #L Neuronio 1 ativo, Neuronio 2 zerado, Neuronio 3 ativo, Neuronio 4 zerado
      mut as list of int64: mask = [1, 0, 1, 0]

      #L Aplicacao do Inverted Dropout: out[i] = (x[i] * mask[i]) * scale_factor
      mut as list of int64: out = [0, 0, 0, 0]
      out[1] = x[1] * mask[1] * scale_factor
      out[2] = x[2] * mask[2] * scale_factor
      out[3] = x[3] * mask[3] * scale_factor
      out[4] = x[4] * mask[4] * scale_factor

      println("1. Ativacao 1 escalada (10 * 1 * 2): " + out[1])
      println("2. Ativacao 2 mascarada (20 * 0 * 2): " + out[2])
      println("3. Ativacao 3 escalada (30 * 1 * 2): " + out[3])
      println("4. Ativacao 4 mascarada (40 * 0 * 2): " + out[4])

      #L Soma total esperada mantida (esperanca matematica preservada)
      mut as int64: soma_original = x[1] + x[2] + x[3] + x[4]
      mut as int64: soma_dropout = out[1] + out[2] + out[3] + out[4]

      println("5. Soma das ativacoes originais: " + soma_original)
      println("6. Soma das ativacoes sob Inverted Dropout: " + soma_dropout)

      route {
            out[1] == 20 and out[2] == 0 and out[3] == 60 and out[4] == 0 ==> {
                  println("7. Inverted Dropout validado com sucesso.")
            }
            _ ==> {
                  println("Falha na operacao de Dropout.")
            }
      }
      println("Teste concluido com sucesso.")
}
