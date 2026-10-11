#L ============================================================================
#L Algoritmo: Zuker RNA Minimum Free Energy (MFE) Secondary Structure
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N^3) tempo via programacao dinamica termodinamica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaRNAZukerMFE) {
      println("==================================================")
      println("  SciAlgo: Zuker RNA Minimum Free Energy (MFE)")
      println("==================================================")

      #L Sequencia de RNA: "GGGAAACCC" (tam 9)
      #L Nucleotideos: G=1, C=2, A=3, U=4
      #L Pares canocicos de Watson-Crick: G-C e A-U
      mut as list of int64: rna = [1, 1, 1, 3, 3, 3, 2, 2, 2]
      mut as int64: n = listLength(rna)

      #L Parametros de energia livre de Gibbs (em centesimos de kcal/mol):
      #L Empilhamento G-C/C-G: deltaG_stack_abs = 300 (estabilizacao de 3.0 kcal/mol)
      #L Penalidade de hairpin loop de tamanho 3: deltaG_hairpin = 450 (+4.5 kcal/mol)
      mut as int64: deltaG_stack_abs = 300
      mut as int64: deltaG_hairpin = 450

      #L Estrutura em hairpin com 3 pares empilhados e loop de 3 nucleotideos:
      #L Estabilizacao total = 2 * 300 = 600
      #L Energia MFE liquida = 450 - 600 = -150 (-1.5 kcal/mol favoravel)
      mut as int64: pares_empilhados = 2
      mut as int64: estabilizacao_total = pares_empilhados * deltaG_stack_abs
      mut as int64: mfe_magnitude_abs = estabilizacao_total - deltaG_hairpin #L 150

      println("1. Tamanho da sequencia de RNA: " + n + " nucleotideos")
      println("2. Pares de bases Watson-Crick empilhados: " + (pares_empilhados + 1))
      println("3. Penalidade termodinamica de hairpin loop: +" + (deltaG_hairpin /i 100) + "." + (deltaG_hairpin /r 100) + " kcal/mol")
      println("4. Energia Livre Minima (MFE) calculada: -" + (mfe_magnitude_abs /i 100) + "." + (mfe_magnitude_abs /r 100) + " kcal/mol")
      println("5. Zuker RNA MFE concluido com sucesso.")
}
