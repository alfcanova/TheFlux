#L ============================================================================
#L Algoritmo: Blinn-Phong Shading
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaBlinnPhong) {
      println("==================================================")
      println("  SciAlgo: Blinn-Phong Shading")
      println("==================================================")

      mut as int64: ambient = 15
      mut as int64: diffuse = 60
      mut as int64: specular = 40
      mut as int64: n_dot_h = 80
      mut as int64: spec_term = (specular * n_dot_h * n_dot_h) /i 10000
      mut as int64: blinn_shade = ambient + diffuse + spec_term

      println("1. Iluminacao Blinn-Phong com vetor half-way: " + blinn_shade)
      println("2. Blinn-Phong Shading concluido com sucesso.")
}
