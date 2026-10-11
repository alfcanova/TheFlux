#L ============================================================================
#L Algoritmo: Bidirectional Path Tracing (BDPT)
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaBidirectionalPathTracing) {
      println("==================================================")
      println("  SciAlgo: Bidirectional Path Tracing (BDPT)")
      println("==================================================")

      mut as int64: eye_weight = 80
      mut as int64: light_weight = 60
      mut as int64: throughput = (eye_weight * light_weight) /i 100

      println("1. Conexao de sub-caminhos BDPT throughput: " + throughput)
      println("2. Bidirectional Path Tracing (BDPT) concluido com sucesso.")
}
