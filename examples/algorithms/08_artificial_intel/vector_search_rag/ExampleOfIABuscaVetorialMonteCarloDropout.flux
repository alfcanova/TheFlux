#L ============================================================================
#L Algoritmo: Monte Carlo Dropout (Estimativa de Incerteza Epistemica)
#L Dominio: 08_artificial_intel / Subdominio: Busca Vetorial, RAG & Adaptacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIABuscaVetorialMonteCarloDropout) {
      println("=== Algoritmo: Monte Carlo Dropout ===")
      mut as list of int64: samples = [80, 84, 82, 86, 78]
      mut as int64: sumVal = 0
      mut as int64: i = 1
      infinite (i <= 5) {
            sumVal = sumVal + samples[i]
            i = i + 1
      }
      mut as int64: mean = sumVal /i 5
      mut as int64: sumVar = 0
      i = 1
      infinite (i <= 5) {
            mut as int64: diff = samples[i] - mean
            sumVar = sumVar + diff * diff
            i = i + 1
      }
      mut as int64: variance = sumVar /i 5
      println("1. Media preditiva MC: " + mean)
      println("2. Variancia epistemica: " + variance)
      println("Teste concluido com sucesso.")
}
