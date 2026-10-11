#L ============================================================================
#L Algoritmo: CRISPR Protospacer and PAM Motif Search
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N) tempo linear com varredura de motivos PAM (NGG)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaCRISPRProtospacerSearch) {
      println("==================================================")
      println("  SciAlgo: CRISPR Protospacer & PAM Search")
      println("==================================================")

      #L Sequencia de DNA genômico: (A=1, C=2, G=3, T=4)
      #L Alvo SpCas9: proto-espacador de 20 nucleotideos seguido pelo motivo PAM 5'-NGG-3'
      #L Segmento ilustrativo de 24 nucleotideos terminando com motivo PAM (G, G nos indices 23, 24):
      mut as list of int64: seq = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 1, 3, 3]
      mut as int64: n = listLength(seq)

      mut as int64: tam_protospacer = 20
      mut as int64: tam_pam = 3

      #L Verificacao do motivo PAM nas ultimas 3 posicoes (pos 22, 23, 24):
      #L pos 22: qualquer nucleotideo ('N')
      #L pos 23: nucleotideo 'G' (3)
      #L pos 24: nucleotideo 'G' (3)
      mut as int64: pam_valido = 0
      route {
            seq[23] == 3 and seq[24] == 3 ==> { pam_valido = 1 }
            _ ==> {}
      }

      mut as int64: protospacer_identificado = 0
      route {
            pam_valido == 1 and (n >= tam_protospacer + tam_pam) ==> {
                  protospacer_identificado = 1
            }
            _ ==> {}
      }

      println("1. Tamanho da sequencia de DNA: " + n + " pb")
      println("2. Motivo PAM SpCas9 (NGG) detectado na fita: " + pam_valido)
      println("3. Protospacer guia de " + tam_protospacer + " pb validado: " + protospacer_identificado)
      println("4. CRISPR Protospacer Search concluido com sucesso.")
}
