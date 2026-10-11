#L ============================================================================
#L Algoritmo: PageRank (Power Iteration com Fator de Amortecimento)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosPageRank) {
      println("=== Algoritmo: PageRank para IA em Grafos ===")
      mut as int64: n = 4
      mut as int64: d = 85
      mut as int64: base = (100 - d) * 10 /i n
      mut as list of int64: pr = [250, 250, 250, 250]
      mut as int64: iter = 0
      infinite (iter < 10) {
            mut as int64: p1 = pr[1]
            mut as int64: p2 = pr[2]
            mut as int64: p3 = pr[3]
            mut as int64: p4 = pr[4]
            mut as int64: n1 = base + (d * (p2 /i 2 + p3 /i 1)) /i 100
            mut as int64: n2 = base + (d * (p1 /i 2 + p3 /i 1)) /i 100
            mut as int64: n3 = base + (d * (p1 /i 2 + p4 /i 1)) /i 100
            mut as int64: n4 = base + (d * (p2 /i 2)) /i 100
            pr = [n1, n2, n3, n4]
            iter = iter + 1
      }
      println("1. Pontuacao Node 1: " + pr[1])
      println("2. Pontuacao Node 2: " + pr[2])
      println("3. Pontuacao Node 3: " + pr[3])
      println("4. Pontuacao Node 4: " + pr[4])
      println("Teste concluido com sucesso.")
}
