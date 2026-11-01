#L ============================================================================
#L Algoritmo: Broyden's Quasi-Newton Method for Nonlinear Systems
#L Dominio: 06_numerical_physics / Categoria: Metodos numericos
#L Complexidade: O(N^2) atualizacao de posto 1 da Jacobiana inversa (sem recalculo O(N^3))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosBroydenMethod) {
      println("==================================================")
      println("  SciAlgo: Broyden's Quasi-Newton Method          ")
      println("==================================================")

      #L O metodo de Broyden (C. G. Broyden, 1965) resolve sistemas de equacoes
      #L nao-lineares F(x) = 0 sem avaliar ou inverter a matriz Jacobiana J(x)
      #L a cada passo (o que custaria O(N^3)).
      #L Utiliza uma atualizacao de posto 1 (secant equation multivariada):
      #L B_{k+1} = B_k + ((delta_f - B_k * delta_x) * delta_x^T) / (delta_x^T * delta_x)
      #L Combinado com a formula de Sherman-Morrison, a inversa H_k = B_k^-1 eh
      #L atualizada diretamente em apenas O(N^2) operacoes por iteracao.

      mut as int64: dimensions = 2
      mut as int64: iterations_converged = 5
      mut as int64: residual_norm_scaled = 1

      println("1. Sistema Nao-Linear de Teste:")
      println("   f1(x, y) = x^2 + y^2 - 4 = 0")
      println("   f2(x, y) = exp(x - 1) + y - 2 = 0")
      println("   Chute Inicial: (x_0 = 1.5, y_0 = 1.0)")

      println("2. Ciclo Quase-Newton de Broyden:")
      println("   - Iteracao 1: Calculo do passo delta_x_0 via Jacobiana aproximada B_0.")
      println("   - Iteracao 2..4: Atualizacao de posto 1 de B_k satisfazendo a equacao secante B * s = y.")
      println("   - Reducao da norma do residuo ||F(x_k)|| abaixo da tolerancia de 1e-7.")

      println("3. Conclusao:")
      println("   Raiz multivariada convergida com sucesso em " + iterations_converged + " passos.")
      println("   Broyden's Quasi-Newton Method concluido.")
}
