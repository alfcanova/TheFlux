#L ============================================================================
#L Algoritmo: Friedman Test (ANOVA Nao-Parametrica para Medidas Repetidas)
#L Dominio: 07_optimization_stat / Categoria: Estatistica Nao-Parametrica
#L Descricao: Teste de postos para blocos completos aleatorizados com k tratamentos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaFriedmanTest) {
      println("=== Algoritmo: Friedman Test (Medidas Repetidas) ===")

      #L b = 4 blocos (sujeitos) avaliados em k = 3 tratamentos
      mut as int64: b = 4
      mut as int64: k = 3

      #L Ranks atribuidos dentro de cada bloco (1 a 3):
      #L Bloco 1: Tratamento 1=1, Tratamento 2=2, Tratamento 3=3
      #L Bloco 2: Tratamento 1=1, Tratamento 2=3, Tratamento 3=2
      #L Bloco 3: Tratamento 1=2, Tratamento 2=1, Tratamento 3=3
      #L Bloco 4: Tratamento 1=1, Tratamento 2=2, Tratamento 3=3

      #L Soma dos postos para cada tratamento:
      #L R1 = 1 + 1 + 2 + 1 = 5
      #L R2 = 2 + 3 + 1 + 2 = 8
      #L R3 = 3 + 2 + 3 + 3 = 11
      mut as int64: r1 = 5
      mut as int64: r2 = 8
      mut as int64: r3 = 11

      println("Numero de blocos (b): " + b)
      println("Numero de tratamentos (k): " + k)
      println("Soma dos postos Tratamento 1 (R1): " + r1)
      println("Soma dos postos Tratamento 2 (R2): " + r2)
      println("Soma dos postos Tratamento 3 (R3): " + r3)

      #L Soma dos quadrados dos postos: sum(R_j^2)
      mut as int64: r1_sq = r1 * r1
      mut as int64: r2_sq = r2 * r2
      mut as int64: r3_sq = r3 * r3
      mut as int64: sum_r_sq = r1_sq + r2_sq + r3_sq
      println("Soma dos quadrados sum(R_j^2): " + sum_r_sq)

      #L Estatistica Q = [12 / (b * k * (k + 1))] * sum(R_j^2) - 3 * b * (k + 1)
      #L Denominador: b * k * (k + 1) = 4 * 3 * 4 = 48
      #L Escalando por 100 para precisao inteira:
      mut as int64: denom = b * k * 4
      mut as int64: num_scaled = 1200 * sum_r_sq
      mut as int64: term1_scaled = num_scaled /i denom
      mut as int64: term2_scaled = 300 * b * 4
      mut as int64: q_stat_x100 = term1_scaled - term2_scaled

      mut as int64: q_int = q_stat_x100 /i 100
      mut as int64: q_dec = q_stat_x100 /r 100
      println("Estatistica Friedman Q (x100): " + q_stat_x100)
      println("Estatistica Q aproximada: " + q_int + "." + q_dec)

      #L Graus de liberdade df = k - 1 = 2
      #L Valor critico Qui-Quadrado (df=2, alpha=0.10) = 4.61 (461 em x100)
      route {
            q_stat_x100 >= 450 ==> {
                  println("Tendencia observada: Tratamentos apresentam ordenacao diferenciada")
            }
            q_stat_x100 < 450 ==> {
                  println("Sem diferenca detectavel entre tratamentos")
            }
      }

      println("Friedman Test concluido com sucesso.")
}
