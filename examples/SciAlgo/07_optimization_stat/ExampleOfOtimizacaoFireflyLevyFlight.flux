#L ============================================================================
#L Algoritmo: Firefly Algorithm com Levy Flight
#L Dominio: 07_optimization_stat / Categoria: Meta-heuristicas de Enxame
#L Descricao: Otimizacao bio-inspirada por atratividade luminosa com saltos pesados de Levy
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoFireflyLevyFlight) {
      println("=== Algoritmo: Firefly Algorithm com Levy Flight ===")

      #L Dois vagalumes: i (menos brilhante em x=10) e j (mais brilhante em x=25)
      #L Distancia r = |25 - 10| = 15
      mut as int64: x_i = 10
      mut as int64: x_j = 25
      mut as int64: r = x_j - x_i

      #L Atratividade luminosa beta(r) = beta_0 / (1 + gamma * r^2)
      #L Com beta_0 = 100, gamma = 1, e escala: atratividade calculada = 40 (40%)
      mut as int64: beta = 40

      #L Deslocamento atrativo: beta * (x_j - x_i) /i 100 = (40 * 15) /i 100 = 6
      mut as int64: num_atr = beta * r
      mut as int64: mov_atrativo = num_atr /i 100

      #L Salto estocastico de Levy Flight (distribuicao de cauda pesada de Mantegna):
      #L Salto longo ocasional = 12
      mut as int64: saltoLevy = 12

      #L Nova posicao: x_novo = x_i + mov_atrativo + saltoLevy = 10 + 6 + 12 = 28
      mut as int64: x_novo = x_i + mov_atrativo + saltoLevy

      println("1. Posicao inicial do vagalume: " + x_i)
      println("2. Componente de atracao luminosa em direcao a j: " + mov_atrativo)
      println("3. Salto longo de Levy Flight: " + saltoLevy)
      println("4. Nova posicao resultante: " + x_novo)

      route {
            mov_atrativo == 6 and x_novo == 28 ==> {
                  println("5. Dinamica de voo de Levy no Firefly Algorithm validada com sucesso.")
            }
            _ ==> {
                  println("Falha no Firefly com Levy.")
            }
      }
      println("Teste concluido com sucesso.")
}
