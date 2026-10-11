#L ============================================================================
#L Algoritmo: DALI Protein Structural Alignment (Distance Alignment Matrix)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N^2 * M^2) comparacao de matrizes de contato intra-moleculares
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaDALIProteinAlignment) {
      println("==================================================")
      println("  SciAlgo: DALI Protein Structural Alignment")
      println("==================================================")

      #L Duas proteinas representadas por matrizes de distancias intra-moleculares C-alfa:
      #L Proteina A (4 residuos) e Proteina B (4 residuos)
      #L Matriz A de distancias inter-residuos (em Angstroms inteiros):
      #L d_A[1,2]=5, d_A[1,3]=8, d_A[1,4]=12, d_A[2,3]=4, d_A[2,4]=9, d_A[3,4]=6
      #L Matriz B de distancias inter-residuos da proteina homologa:
      #L d_B[1,2]=5, d_B[1,3]=9, d_B[1,4]=11, d_B[2,3]=4, d_B[2,4]=9, d_B[3,4]=5
      mut as list of int64: da = [5, 8, 12, 4, 9, 6]
      mut as list of int64: db = [5, 9, 11, 4, 9, 5]
      mut as int64: n_pares = listLength(da)

      #L O score de DALI penaliza diferencas relativas |d_A - d_B| com peso maior para contatos proximos:
      #L Envelope de contato envelope = 10 Angstroms
      mut as int64: score_dali = 0
      mut as int64: desvio_total = 0

      mut as int64: i = 1
      infinite (i <= n_pares) {
            mut as int64: diff = da[i] - db[i]
            route {
                  diff < 0 ==> { diff = 0 - diff }
                  _ ==> {}
            }
            desvio_total = desvio_total + diff

            #L Pontuacao positiva para contatos similares: 10 - diff
            mut as int64: pontuacao_par = 10 - diff
            route {
                  pontuacao_par < 0 ==> { pontuacao_par = 0 }
                  _ ==> {}
            }
            score_dali = score_dali + pontuacao_par

            i = i + 1
      }

      mut as int64: rmsd_angstrom_x10 = (desvio_total * 10) /i n_pares

      println("1. Pares de contatos intra-moleculares comparados: " + n_pares)
      println("2. Desvio acumulado de distancias: " + desvio_total + " Angstroms")
      println("3. RMSD medio de matriz de contato: " + (rmsd_angstrom_x10 /i 10) + "." + (rmsd_angstrom_x10 /r 10) + " A")
      println("4. DALI Alignment Score final: " + score_dali)
      println("5. Alinhamento estrutural DALI concluido com sucesso.")
}
