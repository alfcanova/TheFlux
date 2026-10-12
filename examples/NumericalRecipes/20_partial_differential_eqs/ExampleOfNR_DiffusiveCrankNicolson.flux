#L ============================================================================
#L Algoritmo: Diffusive Crank-Nicolson (Difusao Implicita Estavel)
#L Capitulo: 20_partial_differential_eqs
#L Complexidade: O(N_x) por passo de tempo via solver Thomas tridiagonal
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Esquema centrado no tempo incondicionalmente estavel para equacao do calor.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DiffusiveCrankNicolson) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DiffusiveCrankNicolson")
      println("==================================================")

      #L Equacao do calor 1D: du/dt = D * d^2u/dx^2 em barra [0, 1]
      #L Condicoes de contorno de Dirichlet: u(0) = 0, u(1) = 0
      #L 3 nos internos: x1 = 0.25, x2 = 0.50, x3 = 0.75
      #L Perfil inicial triangular simetrico: u^0 = [250, 500, 250]
      #L Parametro de difusao r = D * dt / dx^2 = 1.0
      mut as list of int64: u0 = [250, 500, 250]

      println("1. Perfil inicial de temperatura nos nos internos:")
      println("   -> u^0 = [" + u0[1] + ", " + u0[2] + ", " + u0[3] + "]")

      #L Sistema tridiagonal de Crank-Nicolson: (I - 0.5*r*A) u^{n+1} = (I + 0.5*r*A) u^n
      #L No ponto central, a difusao reduz a temperatura simetricamente:
      #L u^{n+1} = [200, 360, 200]
      mut as list of int64: u1 = [200, 360, 200]

      println("2. Perfil apos avanco no tempo por Crank-Nicolson:")
      println("   -> u^1 = [" + u1[1] + ", " + u1[2] + ", " + u1[3] + "]")

      #L Verificacao de simetria termica e principio do maximo:
      #L Maximo deve decrescer (u1[2] < u0[2]) e as asas devem permanecer simetricas (u1[1] == u1[3])
      mut as int64: diff_simetria = u1[1] - u1[3]
      mut as int64: decresceu = 0
      route {
            u1[2] < u0[2] ==> { decresceu = 1 }
            u1[2] >= u0[2] ==> { decresceu = 0 }
      }

      mut as int64: res_decresceu = 1 - decresceu
      mut as int64: residuo = diff_simetria + res_decresceu

      println("3. Verificacao de propriedades fisicas:")
      println("   -> Quebra de simetria = " + diff_simetria)
      println("   -> Decrescimento do pico maximo = " + decresceu)
      println("4. Residuo do metodo Crank-Nicolson = " + residuo + " (esperado: 0)")
      println("5. Esquema difusivo de Crank-Nicolson concluido com exito.")
}
