#L ============================================================================
#L Algoritmo: TrustRank (Propagacao de Confianca em Grafos Web)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosTrustRank) {
      println("=== Algoritmo: TrustRank ===")
      mut as list of int64: seedTrust = [1000, 0, 0, 0]
      mut as list of int64: trust = [1000, 0, 0, 0]
      mut as int64: alpha = 80
      mut as int64: it = 0
      infinite (it < 10) {
            mut as int64: t1 = trust[1]
            mut as int64: t2 = trust[2]
            mut as int64: t3 = trust[3]
            mut as int64: t4 = trust[4]
            mut as int64: base1 = ((100 - alpha) * seedTrust[1]) /i 100
            mut as int64: base2 = ((100 - alpha) * seedTrust[2]) /i 100
            mut as int64: base3 = ((100 - alpha) * seedTrust[3]) /i 100
            mut as int64: base4 = ((100 - alpha) * seedTrust[4]) /i 100
            mut as int64: n1 = base1 + (alpha * (t2 /i 2 + t3 /i 1)) /i 100
            mut as int64: n2 = base2 + (alpha * (t1 /i 2 + t3 /i 1)) /i 100
            mut as int64: n3 = base3 + (alpha * (t1 /i 2 + t4 /i 1)) /i 100
            mut as int64: n4 = base4 + (alpha * (t2 /i 2)) /i 100
            trust = [n1, n2, n3, n4]
            it = it + 1
      }
      println("1. Confianca Node 1: " + trust[1])
      println("2. Confianca Node 2: " + trust[2])
      println("3. Confianca Node 3: " + trust[3])
      println("4. Confianca Node 4: " + trust[4])
      println("Teste concluido com sucesso.")
}
