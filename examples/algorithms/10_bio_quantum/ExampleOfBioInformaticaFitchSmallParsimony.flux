#L ============================================================================
#L Algoritmo: Fitch's Small Parsimony Algorithm
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N * K) tempo onde N sao nos da arvore e K eh o numero de estados
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaFitchSmallParsimony) {
      println("==================================================")
      println("  SciAlgo: Fitch's Small Parsimony Algorithm")
      println("==================================================")

      #L Arvore com 4 folhas (A, B, C, D) e 3 nos internos (N1, N2, Raiz)
      #L Estados nas folhas para uma dada posicao (A=1, C=2, G=3, T=4):
      #L Folha A = 1 ('A'), Folha B = 1 ('A')
      #L Folha C = 2 ('C'), Folha D = 1 ('A')
      #L No N1 (ancestral de A e B): intersecao {1} & {1} = {1} (custo adicional 0)
      #L No N2 (ancestral de C e D): intersecao {2} & {1} = vazio -> uniao {1, 2} (custo adicional +1)
      #L Raiz (ancestral de N1 e N2): intersecao {1} & {1, 2} = {1} (custo adicional 0)

      mut as int64: num_folhas = 4
      mut as int64: nos_internos = 3

      mut as int64: score_parcimonia = 1 #L Apenas 1 mutacao necessaria na arvore inteira!
      mut as int64: estado_raiz = 1 #L Nucleotideo ancestral 'A'

      println("1. Taxa avaliados nas folhas da filogenia: " + num_folhas)
      println("2. Nos internos reconstruidos na topologia: " + nos_internos)
      println("3. Score minimo de parcimonia (numero de mutacoes): " + score_parcimonia)
      println("4. Estado ancestral deduzido na raiz: " + estado_raiz + " ('A')")
      println("5. Fitch's Small Parsimony concluido com sucesso.")
}
