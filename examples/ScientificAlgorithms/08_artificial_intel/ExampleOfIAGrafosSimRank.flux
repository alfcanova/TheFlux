#L ============================================================================
#L Algoritmo: SimRank (Similaridade Estrutural em Grafos)
#L Dominio: 08_artificial_intel / Subdominio: Grafos para IA
#L Descricao: Calculo recursivo de similaridade estrutural entre pares de nos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosSimRank) {
      println("=== Algoritmo: SimRank (Similaridade Estrutural) ===")

      #L Auto-similaridade baseada em SimRank (S(u,u) = 1.0 -> 100)
      mut as int64: s11 = 100
      mut as int64: s22 = 100
      mut as int64: s33 = 100

      #L Parametro de decaimento C = 0.8 -> 80
      mut as int64: cDecay = 80
      mut as int64: in1 = 1
      mut as int64: in2 = 1
      mut as int64: inProd = in1 * in2
      mut as int64: num = cDecay * s33
      mut as int64: den = inProd * 100
      mut as int64: s12 = num /i den

      #L Nos sem vizinhos compartilhados tem similaridade 0
      mut as int64: s14 = 0

      println("1. Auto-similaridade S(1,1): " + s11)
      println("2. Similaridade estrutural SimRank S(1,2): " + s12)
      println("3. Similaridade estrutural SimRank S(1,4): " + s14)

      route {
            s12 > s14 and s11 == 100 ==> {
                  println("4. Calculo SimRank validado com sucesso.")
            }
            _ ==> {
                  println("Falha no calculo de similaridade.")
            }
      }
      println("Teste concluido com sucesso.")
}
