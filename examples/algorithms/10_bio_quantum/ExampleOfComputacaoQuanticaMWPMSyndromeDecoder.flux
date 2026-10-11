#L ============================================================================
#L Algoritmo: Minimum Weight Perfect Matching (MWPM) Syndrome Decoder
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(V^3) tempo via emparelhamento de blossom para defeitos de sindrome
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaMWPMSyndromeDecoder) {
      println("==================================================")
      println("  SciAlgo: MWPM Surface Code Syndrome Decoder")
      println("==================================================")

      #L Na medicao de estabilizadores de um Surface Code, erros criam pares
      #L de defeitos de sindrome (anyons com medicao -1).
      #L O decodificador MWPM emparelha os defeitos minimizando a soma das distancias Manhattan:
      #L Defeitos observados: D1=(1, 1), D2=(1, 3), D3=(4, 1), D4=(4, 3)
      #L Distancias Manhattan entre defeitos:
      #L d(D1, D2) = |1-1| + |1-3| = 2
      #L d(D3, D4) = |4-4| + |1-3| = 2
      #L d(D1, D3) = |1-4| + |1-1| = 3
      #L d(D2, D4) = |1-4| + |3-3| = 3
      #L d(D1, D4) = |1-4| + |1-3| = 5
      #L d(D2, D3) = |1-4| + |3-1| = 5

      #L Opcoes de emparelhamento perfeito:
      #L Opcao 1: (D1, D2) e (D3, D4) -> peso total = 2 + 2 = 4 (Otimo!)
      #L Opcao 2: (D1, D3) e (D2, D4) -> peso total = 3 + 3 = 6
      #L Opcao 3: (D1, D4) e (D2, D3) -> peso total = 5 + 5 = 10
      mut as int64: peso_opcao1 = 4
      mut as int64: peso_opcao2 = 6
      mut as int64: peso_opcao3 = 10

      mut as int64: min_peso = peso_opcao1
      route {
            peso_opcao2 < min_peso ==> { min_peso = peso_opcao2 }
            _ ==> {}
      }
      route {
            peso_opcao3 < min_peso ==> { min_peso = peso_opcao3 }
            _ ==> {}
      }

      mut as int64: defeitos_totais = 4
      mut as int64: cadeias_correcao = 2

      println("1. Defeitos de sindrome detectados na malha: " + defeitos_totais)
      println("2. Peso do emparelhamento horizontal: " + peso_opcao1 + " (minimo otimo)")
      println("3. Peso do emparelhamento vertical: " + peso_opcao2)
      println("4. Cadeias de correcao unitaria geradas: " + cadeias_correcao + " (peso total " + min_peso + ")")
      println("5. Decodificador MWPM concluido com sucesso.")
}
