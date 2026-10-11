#L ============================================================================
#L Algoritmo: Felsenstein's Tree Pruning (Phylogenetic Maximum Likelihood)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N * K^2) tempo para N nos filogeneticos e K estados de nucleotideos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaFelsensteinPruning) {
      println("==================================================")
      println("  SciAlgo: Felsenstein's Tree Pruning")
      println("==================================================")

      #L Modelo de substituicao de Jukes-Cantor (JC69) com comprimento de ramo t:
      #L Probabilidade de conservacao: P(A|A) = 90% (900/1000)
      #L Probabilidade de substituicao: P(C|A) = P(G|A) = P(T|A) = 3.3% (33/1000)
      mut as int64: prob_conservacao = 900
      mut as int64: prob_mutacao = 33

      #L Topologia com 2 folhas irmas F1 e F2 derivadas do no ancestral N:
      #L Observacao: F1='A', F2='A'
      #L Verossimilhanca condicional L_N(A) = P(F1=A | N=A) * P(F2=A | N=A) = (0.90 * 0.90) = 0.81 (810/1000)
      #L Verossimilhanca condicional L_N(G) = P(F1=A | N=G) * P(F2=A | N=G) = (0.033 * 0.033) ~ 0.001
      mut as int64: l_a = (prob_conservacao * prob_conservacao) /i 1000 #L 810
      mut as int64: l_g = (prob_mutacao * prob_mutacao) /i 1000 #L 1

      #L Verossimilhanca total no no assumindo frequencias a priori iguais pi = 1/4:
      mut as int64: total_likelihood = (l_a + l_g + l_g + l_g) /i 4 #L ~ 203 (20.3%)

      println("1. Modelo evolutivo: Jukes-Cantor (JC69)")
      println("2. Verossimilhanca condicional ancestral L(A): " + (l_a /i 10) + "." + (l_a /r 10) + "%")
      println("3. Verossimilhanca condicional ancestral L(G): " + (l_g /i 10) + "." + (l_g /r 10) + "%")
      println("4. Verossimilhanca global calculada pela poda: " + (total_likelihood /i 10) + "." + (total_likelihood /r 10) + "%")
      println("5. Felsenstein's Pruning concluido com sucesso.")
}
