#L ============================================================================
#L Algoritmo: Phong Shading
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaPhongShading) {
      println("==================================================")
      println("  SciAlgo: Phong Shading")
      println("==================================================")

      mut as int64: ambient = 20
      mut as int64: diffuse = 80
      mut as int64: specular = 50
      mut as int64: n_dot_l = 70
      mut as int64: r_dot_v = 60
      mut as int64: diff_term = (diffuse * n_dot_l) /i 100
      mut as int64: spec_term = (specular * r_dot_v) /i 100
      mut as int64: total_shade = ambient + diff_term + spec_term

      println("1. Iluminacao Phong calculada: " + total_shade)
      println("2. Phong Shading concluido com sucesso.")
}
