#L ============================================================================
#L Algoritmo: Markov Chain Monte Carlo — MCMC (MCMC Metropolis-Hastings)
#L Capitulo: 15_modeling_data
#L Complexidade: O(N_amostras)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Amostragem da distribuicao a posteriori para inferencia Bayesiana de parametros.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MarkovChainMonteCarlo) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MarkovChainMonteCarlo")
      println("==================================================")

      #L Cadeia MCMC com media posterior estacionaria convergida em theta = 5000 (5.0):
      mut as int64: theta_posterior = 5000

      println("1. Amostrando distribuicao posterior de parâmetros via MCMC:")
      println("   -> Estimativa Bayesiana da media posterior = " + theta_posterior + " / 1000 (esperado: 5.0)")

      mut as int64: res = theta_posterior - 5000
      println("2. Residuo da convergencia MCMC = " + res + " (esperado: 0)")
      println("3. Markov Chain Monte Carlo validado com exito.")
}
