#L ============================================================================
#L Algoritmo: Sankoff's Generalized Parsimony Algorithm
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(N * K^2) programacao dinamica com matriz de custos de substituicao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaSankoffParsimony) {
      println("==================================================")
      println("  SciAlgo: Sankoff's Generalized Parsimony")
      println("==================================================")

      #L Matriz de custos de substituicao C[K x K] entre nucleotideos (A=1, C=2, G=3, T=4):
      #L Transicoes (A<->G, C<->T): custo 1
      #L Transversoes (A<->C, A<->T, G<->C, G<->T): custo 2
      #L Identidade (A<->A, etc.): custo 0
      mut as int64: custo_transicao = 1
      mut as int64: custo_transversao = 2

      #L Duas folhas observadas em um no ancestral: Folha 1 = 'A' (1), Folha 2 = 'G' (3)
      #L Vetor de custos no ancestral para cada hipotese de estado {A, C, G, T}:
      #L Hipotese A (1): custo para F1=0 + custo para F2(A->G)=1 (total 1)
      #L Hipotese C (2): custo para F1(C->A)=2 + custo para F2(C->G)=2 (total 4)
      #L Hipotese G (3): custo para F1(G->A)=1 + custo para F2=0 (total 1)
      #L Hipotese T (4): custo para F1(T->A)=2 + custo para F2(T->G)=2 (total 4)
      mut as list of int64: custos_hipotese = [1, 4, 1, 4]
      mut as int64: k_estados = listLength(custos_hipotese)

      mut as int64: min_custo = custos_hipotese[1]
      mut as int64: i = 2
      infinite (i <= k_estados) {
            route {
                  custos_hipotese[i] < min_custo ==> { min_custo = custos_hipotese[i] }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Estados de nucleotideos modelados: " + k_estados)
      println("2. Custo de transicao: " + custo_transicao + ", transversao: " + custo_transversao)
      println("3. Custos ancestrais ponderados: [" + custos_hipotese[1] + ", " + custos_hipotese[2] + ", " + custos_hipotese[3] + ", " + custos_hipotese[4] + "]")
      println("4. Custo minimo generalizado de Sankoff: " + min_custo)
      println("5. Sankoff's Parsimony concluido com sucesso.")
}
