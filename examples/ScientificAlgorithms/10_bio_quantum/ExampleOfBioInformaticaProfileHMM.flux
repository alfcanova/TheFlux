#L ============================================================================
#L Algoritmo: Profile HMM (HMMER - Hidden Markov Model de Perfil)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica de Proteinas
#L Descricao: Alinhamento de sequencia contra modelo de probabilidade de perfil
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaProfileHMM) {
      println("=== Algoritmo: Profile HMM (HMMER) ===")

      #L Perfil linear de modelo HMMER com L = 3 estados de Match (M1, M2, M3),
      #L estados de Delecao (D1, D2, D3) e Insercao (I0, I1, I2, I3).
      #L Sequencia de aminoacidos alvo: "V-L-A" (3 residuos)
      mut as int64: seq_len = 3
      println("Tamanho do perfil e sequencia alvo: " + seq_len)

      #L Log-odds scores de emissao em escala inteira (x10) para cada posicao:
      #L Posicao 1 (M1 para 'V'): score +8 (+0.8 bits)
      #L Posicao 2 (M2 para 'L'): score +12 (+1.2 bits)
      #L Posicao 3 (M3 para 'A'): score +10 (+1.0 bits)
      mut as int64: em_m1 = 8
      mut as int64: em_m2 = 12
      mut as int64: em_m3 = 10

      #L Log-odds scores de transicao entre estados (x10):
      #L Begin -> M1: score 0 (neutro)
      #L M1 -> M2: score +2 (transicao canônica preferencial)
      #L M2 -> M3: score +2
      #L M3 -> End: score 0
      #L Penalidade de abertura de gap (M -> D): -15
      #L Penalidade de extensao de gap (D -> D): -5
      #L Penalidade de insercao (M -> I): -12
      mut as int64: trans_m1_m2 = 2
      mut as int64: trans_m2_m3 = 2

      #L Programacao dinamica Viterbi para calcular o caminho de pontuacao maxima:
      #L V_M(1) = Begin + em_m1 = 8
      #L V_M(2) = V_M(1) + trans_m1_m2 + em_m2 = 8 + 2 + 12 = 22
      #L V_M(3) = V_M(2) + trans_m2_m3 + em_m3 = 22 + 2 + 10 = 34
      mut as int64: viterbi_score = em_m1 + trans_m1_m2 + em_m2 + trans_m2_m3 + em_m3

      #L Score Viterbi em bits (x10):
      mut as int64: score_int = viterbi_score /i 10
      mut as int64: score_dec = viterbi_score /r 10
      println("Score de alinhamento Viterbi (x10): " + viterbi_score)
      println("Pontuacao do dominio Pfam (bits): " + score_int + "." + score_dec)

      #L Limiar de inclusao de familia (Gathering Threshold de Trusted Cutoff = 25.0 bits)
      mut as int64: gathering_threshold = 25
      route {
            viterbi_score >= 250 ==> {
                  println("Classificacao: Sequencia pertence a familia proteica homologa (Confianca Alta)")
            }
            viterbi_score < 250 ==> {
                  println("Classificacao: Score abaixo do limiar de inclusao")
            }
      }

      println("Profile HMM concluido com sucesso.")
}
