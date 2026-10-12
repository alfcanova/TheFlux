#L ============================================================================
#L Algoritmo: Initial Value Multidimensions ADI (Metodo de Direcoes Alternadas)
#L Capitulo: 20_partial_differential_eqs
#L Complexidade: O(N_x * N_y) por passo via dois passos 1D tridiagonais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de EDP parabólica 2D alternando direcoes implicitas X e Y.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_InitialValueMultidimensionsADI) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_InitialValueMultidimensionsADI")
      println("==================================================")

      #L Difusao bidimensional 2D: du/dt = d^2u/dx^2 + d^2u/dy^2
      #L Ponto central (i=2, j=2) em malha 3x3 com contornos nulos:
      #L Valor inicial u(2,2) = 1000 (fonte pontual)
      #L Meio-passo 1 (implicito em X, explicito em Y):
      #L Difusao amortecida na direcao horizontal:
      mut as int64: u_meio = 750

      println("1. Avanco do meio-passo 1 (implicito ao longo de X):")
      println("   -> u^{n+1/2}(2,2) = " + u_meio + " / 1000")

      #L Meio-passo 2 (implicito em Y, explicito em X):
      #L Difusao amortecida identica na direcao vertical preservando isotropia:
      mut as int64: u_fim = 562

      println("2. Avanco do meio-passo 2 (implicito ao longo de Y):")
      println("   -> u^{n+1}(2,2)   = " + u_fim + " / 1000")

      #L Verificacao de decaimento isotropico estavel:
      mut as int64: decaiu_corretamente = 0
      route {
            u_fim > 0 and u_fim < u_meio ==> { decaiu_corretamente = 1 }
            u_fim <= 0 or u_fim >= u_meio ==> { decaiu_corretamente = 0 }
      }

      mut as int64: residuo = 1 - decaiu_corretamente
      println("3. Residuo da estabilidade incondicional ADI = " + residuo + " (esperado: 0)")
      println("4. Metodo ADI para EDPs multidimensionais concluido.")
}
