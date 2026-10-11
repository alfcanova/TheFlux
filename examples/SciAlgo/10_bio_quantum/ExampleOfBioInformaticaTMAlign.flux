#L ============================================================================
#L Algoritmo: TM-align Structural Similarity (Comparacao Estrutural de Proteinas)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica Estrutural
#L Descricao: Metrica TM-score independente do tamanho para sobreposicao estrutural
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaTMAlign) {
      println("=== Algoritmo: TM-align Structural Similarity ===")

      #L Comprimento da proteina alvo L_target = 100 residuos
      #L Comprimento alinhado L_ali = 4 residuos representativos dos centros de dominios
      mut as int64: l_target = 100
      mut as int64: l_ali = 4

      #L Parametro de escala d0 (x10 para precisao): para L=100, d0 ~ 3.8 Angstroms (d0_x10 = 38)
      #L d0_sq_x100 = 38 * 38 = 1444
      mut as int64: d0_sq = 1444

      #L Distancias entre atomos C-alfa sobrepostos (em Angstroms x10):
      #L Residuo 1: d1 = 1.0 A (10) -> d1^2 = 100
      #L Residuo 2: d2 = 1.5 A (15) -> d2^2 = 225
      #L Residuo 3: d3 = 2.0 A (20) -> d3^2 = 400
      #L Residuo 4: d4 = 3.0 A (30) -> d4^2 = 900
      #L Termo para cada residuo: 1 / (1 + (di/d0)^2) = d0^2 / (d0^2 + di^2)
      #L Em escala x1000: (1000 * d0_sq) /i (d0_sq + di^2)

      #L Termo 1: (1000 * 1444) /i (1444 + 100) = 1444000 /i 1544 = 935
      mut as int64: num_scale = 1000 * d0_sq
      mut as int64: den1 = d0_sq + 100
      mut as int64: t1 = num_scale /i den1

      #L Termo 2: (1000 * 1444) /i (1444 + 225) = 1444000 /i 1669 = 865
      mut as int64: den2 = d0_sq + 225
      mut as int64: t2 = num_scale /i den2

      #L Termo 3: (1000 * 1444) /i (1444 + 400) = 1444000 /i 1844 = 783
      mut as int64: den3 = d0_sq + 400
      mut as int64: t3 = num_scale /i den3

      #L Termo 4: (1000 * 1444) /i (1444 + 900) = 1444000 /i 2344 = 616
      mut as int64: den4 = d0_sq + 900
      mut as int64: t4 = num_scale /i den4

      mut as int64: sum_terms = t1 + t2 + t3 + t4
      println("Soma ponderada dos residuos alinhados: " + sum_terms)

      #L TM-score medio normalizado pelo comprimento do alvo (escalado x1000):
      #L tm_score_x1000 = sum_terms /i l_ali
      mut as int64: tm_score_x1000 = sum_terms /i l_ali
      mut as int64: tm_int = tm_score_x1000 /i 1000
      mut as int64: tm_dec = tm_score_x1000 /r 1000

      println("TM-score (x1000): " + tm_score_x1000)
      println("TM-score calculado: " + tm_int + "." + tm_dec)

      #L Criterio canonico da literatura cientifica:
      #L TM-score > 0.5 (500) indica que as duas estruturas possuem a mesma topologia global de enovelamento
      route {
            tm_score_x1000 >= 500 ==> {
                  println("Classificacao SCOP: Mesma topologia e arquitetura estrutural global (TM-score > 0.50)")
            }
            tm_score_x1000 < 500 ==> {
                  println("Classificacao: Estruturas com conformacoes divergentes")
            }
      }

      println("TM-align Structural Similarity concluido com sucesso.")
}
