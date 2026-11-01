#L ============================================================================
#L Algoritmo: Zuker Minimum Free Energy RNA Folding (Modelo de Turner)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica Estrutural
#L Descricao: Predicao de enovelamento termodinamico de RNA por minimizacao de Delta G
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaZukerFreeEnergyRNA) {
      println("=== Algoritmo: Zuker RNA Minimum Free Energy (MFE) ===")

      #L Micro-grampo de RNA (Hairpin loop com haste empilhada):
      #L Sequencia: 5'-G C A A A G C-3' (7 nucleotideos)
      #L Haste terminal (par 1-7: G-C, par 2-6: C-G)
      #L Loop terminal fechado: 3 adeninas "AAA" (tamanho de loop L = 3)
      mut as int64: seq_len = 7
      println("Sequencia avaliada: 5'-GCAAAGC-3' (comprimento " + seq_len + ")")

      #L Contribuicoes de Energia Livre de Gibbs Delta G (em kcal/mol x10):
      #L 1. Energia de empilhamento (base stacking) entre o par (G1-C7) e (C2-G6):
      #L De acordo com a tabela termodinamica de Turner:
      #L Empilhamento GC/CG confere forte estabilidade favoravel: -34 (-3.4 kcal/mol)
      mut as int64: delta_g_stacking = -34

      #L 2. Penalidade de entropia conformacional para fechar o hairpin loop de tamanho 3:
      #L Fechamento de triloop desfavoravel: +45 (+4.5 kcal/mol)
      mut as int64: delta_g_hairpin_loop = 45

      #L 3. Bonus de terminacao de triloop ou correcao de extremidade:
      #L Bonus de ligacao de hidrogenio terminal: -12 (-1.2 kcal/mol)
      mut as int64: delta_g_bonus = -12

      #L Energia Livre Total do estado enovelado MFE:
      #L Delta G_total = Delta G_stacking + Delta G_loop + Delta G_bonus
      #L Delta G_total = -34 + 45 - 12 = -1 (escala x10)
      mut as int64: total_delta_g_x10 = delta_g_stacking + delta_g_hairpin_loop + delta_g_bonus
      println("Energia de empilhamento (stacking): " + delta_g_stacking + " (x10 kcal/mol)")
      println("Penalidade de hairpin loop: " + delta_g_hairpin_loop + " (x10 kcal/mol)")
      println("Bonus estrutural adicional: " + delta_g_bonus + " (x10 kcal/mol)")

      #L Exibicao direta da energia em deca-calorias (x10) e classificacao termodinamica
      println("Energia Livre Minima MFE Delta G (x10 kcal/mol): " + total_delta_g_x10)

      route {
            total_delta_g_x10 < 0 ==> {
                  println("Estado conformacional termodinamicamente favoravel e espontaneo (Delta G < 0)")
            }
            total_delta_g_x10 >= 0 ==> {
                  println("Estado desfavoravel na temperatura fisiologica")
            }
      }

      println("Zuker RNA Minimum Free Energy concluido com sucesso.")
}
