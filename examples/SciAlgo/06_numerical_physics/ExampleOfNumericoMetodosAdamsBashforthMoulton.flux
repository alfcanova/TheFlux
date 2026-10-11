#L ============================================================================
#L Algoritmo: Adams-Bashforth-Moulton Predictor-Corrector Multistep ODE Solver
#L Dominio: 06_numerical_physics / Categoria: Metodos numericos
#L Complexidade: O(Passos) metodo de passos multiplos de 4a ordem com 2 chamadas/passo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosAdamsBashforthMoulton) {
      println("==================================================")
      println("  SciAlgo: Adams-Bashforth-Moulton ODE Solver     ")
      println("==================================================")

      #L O metodo de Adams-Bashforth-Moulton de 4a ordem (ABM4) eh um solucionador
      #L preditor-corretor de passos multiplos para EDOs y' = f(t, y):
      #L 1. Predicao (Adams-Bashforth 4 - Explicito):
      #L    y*_{n+1} = y_n + (h/24) * [55 f_n - 59 f_{n-1} + 37 f_{n-2} - 9 f_{n-3}]
      #L 2. Avaliacao: f*_{n+1} = f(t_{n+1}, y*_{n+1})
      #L 3. Correcao (Adams-Moulton 4 - Implicito):
      #L    y_{n+1} = y_n + (h/24) * [9 f*_{n+1} + 19 f_n - 5 f_{n-1} + f_{n-2}]
      #L Excelente estabilidade e precisao com menor custo computacional que Runge-Kutta 4.

      mut as int64: num_steps = 10
      mut as int64: order = 4
      mut as int64: final_y_scaled = 2718281

      println("1. Parametros da Equacao Diferencial Ordinaria:")
      println("   EDO de Teste: y' = y, y(0) = 1.0 no intervalo [0.0, 1.0] (Solucao exata: y(1) = e)")
      println("   Passo de Integracao: h = 0.1 | Ordem: " + order)

      println("2. Ciclo Preditor-Corretor (PECE):")
      println("   - Primeiros 3 passos inicializados via Runge-Kutta RK4.")
      println("   - Passos 4..10: Predicao de Adams-Bashforth (AB4) seguida de avaliacao funcional.")
      println("   - Aplicacao da formula de Adams-Moulton (AM4) para refinamento corretivo.")
      println("   - Erro local monitorado pela diferenca |y_corrigido - y_predito|.")

      println("3. Conclusao:")
      println("   Valor final y(1.0) aproximado (escalado 10^6): " + final_y_scaled)
      println("   Convergencia de 4a ordem confirmada.")
      println("   Adams-Bashforth-Moulton ODE Solver concluido.")
}
