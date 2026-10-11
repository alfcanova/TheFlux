#L ============================================================================
#L Algoritmo: Ramachandran Plot Backbone Dihedral Angle Validation
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N) tempo para N residuos proteicos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaRamachandranPlot) {
      println("==================================================")
      println("  SciAlgo: Ramachandran Plot Dihedral Validation")
      println("==================================================")

      #L Amostra de angulos diedricos da cadeia principal de residuos (phi, psi) em graus:
      #L Residuo 1: (-60, -45) -> regiao alfa-helice
      #L Residuo 2: (-120, 130) -> regiao folha-beta
      #L Residuo 3: (-55, -50) -> regiao alfa-helice
      #L Residuo 4: (60, 40) -> alfa-helice canhota (favorecida para glicina)
      #L Residuo 5: (0, 0) -> conformacao impedida estericamente (outlier)
      mut as list of int64: phi_ang = [0 - 60, 0 - 120, 0 - 55, 60, 0]
      mut as list of int64: psi_ang = [0 - 45, 130, 0 - 50, 40, 0]
      mut as int64: n_residuos = listLength(phi_ang)

      mut as int64: favoured = 0
      mut as int64: allowed = 0
      mut as int64: outliers = 0

      mut as int64: i = 1
      infinite (i <= n_residuos) {
            mut as int64: phi = phi_ang[i]
            mut as int64: psi = psi_ang[i]

            #L Verificacao de regiao alfa (-100 a -40, -70 a -20)
            mut as int64: is_alpha = 0
            route {
                  phi >= (0 - 100) and phi <= (0 - 40) and psi >= (0 - 70) and psi <= (0 - 20) ==> {
                        is_alpha = 1
                  }
                  _ ==> {}
            }

            #L Verificacao de regiao beta (-150 a -90, 90 a 160)
            mut as int64: is_beta = 0
            route {
                  phi >= (0 - 150) and phi <= (0 - 90) and psi >= 90 and psi <= 160 ==> {
                        is_beta = 1
                  }
                  _ ==> {}
            }

            route {
                  is_alpha == 1 or is_beta == 1 ==> { favoured = favoured + 1 }
                  phi == 60 and psi == 40 ==> { allowed = allowed + 1 }
                  _ ==> { outliers = outliers + 1 }
            }

            i = i + 1
      }

      mut as int64: qualidade_pct = (favoured * 100) /i n_residuos

      println("1. Residuos avaliados: " + n_residuos)
      println("2. Residuos em regioes favorecidas: " + favoured + " (" + qualidade_pct + "%)")
      println("3. Residuos em regioes permitidas: " + allowed)
      println("4. Residuos outliers estericos: " + outliers)
      println("5. Validacao de Ramachandran concluida com sucesso.")
}
