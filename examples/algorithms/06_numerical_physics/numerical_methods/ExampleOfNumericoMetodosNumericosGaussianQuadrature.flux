#L ============================================================================
#L Algoritmo: Gaussian Quadrature
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosGaussianQuadrature) {
      println("==================================================")
      println("  SciAlgo: Gaussian Quadrature")
      println("==================================================")

      mut as int64: w1 = 1
      mut as int64: f1 = 25
      mut as int64: w2 = 1
      mut as int64: f2 = 35
      mut as int64: quad = w1 * f1 + w2 * f2

      println("1. Quadratura de Gauss em 2 pontos amostrais: " + quad)
      println("2. Gaussian Quadrature concluido com sucesso.")
}
