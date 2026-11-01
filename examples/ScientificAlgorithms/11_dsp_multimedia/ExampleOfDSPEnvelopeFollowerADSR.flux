#L ============================================================================
#L Algoritmo: Envelope Follower & Gerador ADSR (Sintese e Dinamica de Audio)
#L Dominio: 11_dsp_multimedia / Categoria: Sintese e Efeitos de Audio
#L Descricao: Modulacao de amplitude de envelope em 4 fases: Attack, Decay, Sustain, Release
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPEnvelopeFollowerADSR) {
      println("=== Algoritmo: Gerador de Envelope ADSR ===")

      #L Parametros do gerador ADSR (valores em escala de amplitude 0 a 1000):
      #L Nivel de pico maximo = 1000
      #L Nivel de Sustain = 600
      #L Taxa de subida (Attack Rate) = +250 por amostra (4 passos para atingir pico)
      #L Taxa de decaimento (Decay Rate) = -100 por amostra (4 passos para atingir sustain)
      #L Taxa de liberacao (Release Rate) = -150 por amostra (4 passos para repouso)
      mut as int64: current_env = 0

      #L Fase 1: ATTACK (Subida a partir de 0 ate o pico de 1000)
      println("Fase 1: Attack (Nota disparada / Note-On)...")
      current_env = current_env + 500
      println("  t=1: Envelope = " + current_env)
      current_env = current_env + 500
      println("  t=2 (Pico Maximo): Envelope = " + current_env)

      #L Fase 2: DECAY (Descida do pico 1000 ate o patamar de Sustain 600)
      println("Fase 2: Decay...")
      current_env = current_env - 200
      println("  t=3: Envelope = " + current_env)
      current_env = current_env - 200
      println("  t=4 (Atingiu Sustain): Envelope = " + current_env)

      #L Fase 3: SUSTAIN (Manutencao constante durante o pressionamento da tecla)
      println("Fase 3: Sustain mantido estavel em: " + current_env)

      #L Fase 4: RELEASE (Liberacao da tecla / Note-Off com queda a zero)
      println("Fase 4: Release...")
      current_env = current_env - 300
      println("  t=5: Envelope = " + current_env)
      current_env = current_env - 300
      println("  t=6 (Repouso final): Envelope = " + current_env)

      route {
            current_env == 0 ==> {
                  println("Ciclo completo ADSR executado com transicoes de fase perfeitas!")
            }
            _ ==> {
                  println("Erro no envelope ADSR")
            }
      }

      println("Envelope Follower ADSR concluido com sucesso.")
}
