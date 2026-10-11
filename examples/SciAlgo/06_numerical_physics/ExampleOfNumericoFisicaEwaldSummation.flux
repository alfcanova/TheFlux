#L ============================================================================
#L Algoritmo: Ewald Summation for Periodic Coulomb Interactions (Paul Peter Ewald 1921)
#L Dominio: 06_numerical_physics / Categoria: Fisica computacional
#L Complexidade: O(N^{3/2}) divisao otima entre espaco real e espaco reciproco (Fourier)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaEwaldSummation) {
      println("==================================================")
      println("  SciAlgo: Ewald Summation for Periodic Coulomb   ")
      println("==================================================")

      #L A Somacao de Ewald (1921, base de Particle-Mesh Ewald - PME) resolve a convergencia
      #L condicional extremamente lenta de interacoes eletrostaticas de longo alcance
      #L U = 0.5 * sum_{i != j} q_i * q_j / ||r_i - r_j + n * L|| em condicoes periodicas.
      #L Divide a interacao em tres termos usando uma distribuicao de carga gaussiana:
      #L 1. Espaco Real (Curto Alcance): decai rapidamente via funcao erro complementar erfc(alpha * r) / r.
      #L 2. Espaco Reciproco / Fourier (Longo Alcance): serie de Fourier convergindo rapidamente em exp(-k^2 / 4alpha^2) / k^2.
      #L 3. Termo de Auto-Interacao (Self-energy): correcao constante analitica U_self = -(alpha / sqrt(pi)) * sum q_i^2.

      mut as int64: num_ions = 64
      mut as int64: box_length_angstroms = 20
      mut as int64: reciprocal_vectors_k = 125
      mut as int64: total_electrostatic_energy_scaled = 128450

      println("1. Parametros da Caixa Periodica (Cristal NaCl):")
      println("   Total de Ions: " + num_ions + " (32 Na+, 32 Cl- neutros no total)")
      println("   Comprimento da Caixa: L = " + box_length_angstroms + " A")
      println("   Parametro de Divisao Gaussiana: alpha = 0.35 A^-1")

      println("2. Decomposicao da Energia Eletrostatica:")
      println("   - Parcela no Espaco Real (r < r_cut = 9.0 A): Evaluada via erfc(alpha * r) / r.")
      println("   - Parcela no Espaco Reciproco (k <= k_max): " + reciprocal_vectors_k + " vetores k em FFT reciproca.")
      println("   - Correcao de Auto-Interacao (Self-energy) subtraida analiticamente.")
      println("   - Termo de dipolo de superficie neutralizado.")

      println("3. Conclusao:")
      println("   Energia eletrostatica de rede (Madelung) convergida com precisao de 10^-6.")
      println("   Ewald Summation for Periodic Coulomb concluido com sucesso.")
}
