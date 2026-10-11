#L ============================================================================
#L Algoritmo: Normalizing Flows (Transformacoes Bijetoras Inversiveis)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaNormalizingFlows) {
      println("=== Algoritmo: Normalizing Flows ===")
      mut as int64: z = 10
      mut as int64: scale = 2
      mut as int64: shift = 5
      mut as int64: x = z * scale + shift
      mut as int64: logDetJ = scale
      println("1. Variavel transformada x: " + x)
      println("2. Log-Determinante Jacobiano: " + logDetJ)
      println("Teste concluido com sucesso.")
}
