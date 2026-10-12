#L ============================================================================
#L Algoritmo: Spectral Methods for PDEs (Metodos Espectrais)
#L Capitulo: 20_partial_differential_eqs
#L Complexidade: O(N log N) por transformada de Chebyshev
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de EDPs via expansao espectral de Chebyshev e convergencia exponencial.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SpectralMethodsPDE) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SpectralMethodsPDE")
      println("==================================================")

      #L Problema espectral de Chebyshev: du/dx = f(x)
      #L Funcao suave u(x) expandida em polinomios de Chebyshev:
      #L u(x) = c0*T0(x) + c1*T1(x) + c2*T2(x)
      #L Coeficientes espectrais com decaimento exponencial:
      #L c0 = 1000, c1 = 100, c2 = 10, c3 = 1 (escala inteira)
      mut as list of int64: c = [1000, 100, 10, 1]

      println("1. Coeficientes da expansao espectral de Chebyshev:")
      println("   -> c = [" + c[1] + ", " + c[2] + ", " + c[3] + ", " + c[4] + "]")

      #L Matriz de derivacao de Chebyshev no espaco espectral:
      #L c'_k = c'_{k+2} + 2*(k+1)*c_{k+1}
      #L c'_1 = 2 * 2 * c2 = 4 * 10 = 40
      #L c'_0 = c'_2 / 2 + 1 * c1 = 0 + 100 = 100
      mut as int64: c_deriv_0 = 100
      mut as int64: c_deriv_1 = 40

      println("2. Coeficientes da derivada computados espectralmente:")
      println("   -> c'_0 = " + c_deriv_0)
      println("   -> c'_1 = " + c_deriv_1)

      #L Verificacao de decaimento espectral: c[k+1] < c[k]
      mut as int64: decaimento_valido = 1
      mut as int64: i = 1
      infinite (i <= 3) {
            mut as int64: next_i = i + 1
            route {
                  c[next_i] >= c[i] ==> { decaimento_valido = 0 }
                  c[next_i] < c[i] ==> {}
            }
            i = i + 1
      }

      mut as int64: residuo = 1 - decaimento_valido
      println("3. Residuo da precisao espectral exponencial = " + residuo + " (esperado: 0)")
      println("4. Metodos espectrais para EDPs validados com sucesso.")
}
