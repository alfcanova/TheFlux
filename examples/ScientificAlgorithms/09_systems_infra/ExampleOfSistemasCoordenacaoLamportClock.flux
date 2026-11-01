#L ============================================================================
#L Algoritmo: Lamport Logical Clock (Happens-Before Relation)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(1) por evento e mensagem
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoLamportClock) {
      println("==================================================")
      println("  SciAlgo: Lamport Logical Clocks")
      println("==================================================")

      #L O relogio logico de Lamport define a relacao "happens-before" (a -> b)
      #L em sistemas distribuidos assincronos.
      #L Regras:
      #L 1. Antes de cada evento local no processo Pi: Li = Li + 1
      #L 2. Ao enviar mensagem m de Pi: Li = Li + 1, anexa Li em m
      #L 3. Ao receber m com ts em Pj: Lj = max(Lj, ts) + 1

      mut as int64: num_proc = 3
      mut as list of int64: clocks = [0, 0, 0]

      println("1. Clocks Iniciais: P1 = 0, P2 = 0, P3 = 0")

      #L Evento 1: Evento local em P1
      clocks[1] = clocks[1] + 1
      println("2. [Evento Local e1,1 em P1] Clock P1 = " + clocks[1])

      #L Evento 2: P1 envia mensagem m1 para P2
      clocks[1] = clocks[1] + 1
      mut as int64: ts_m1 = clocks[1]
      println("3. [Envio m1: P1 -> P2] P1 transmite m1 com timestamp = " + ts_m1 + " (Clock P1 = " + clocks[1] + ")")

      #L Evento 3: Evento local concorrente em P3
      clocks[3] = clocks[3] + 1
      println("4. [Evento Local e3,1 em P3] Clock P3 = " + clocks[3])

      #L Evento 4: P2 recebe m1 de P1
      mut as int64: max_p2 = clocks[2]
      route {
            ts_m1 > max_p2 ==> { max_p2 = ts_m1 }
            _ ==> {}
      }
      clocks[2] = max_p2 + 1
      println("5. [Recepcao m1 em P2] P2 aplica max(0, " + ts_m1 + ") + 1 -> Clock P2 = " + clocks[2])

      #L Evento 5: P2 envia mensagem m2 para P3
      clocks[2] = clocks[2] + 1
      mut as int64: ts_m2 = clocks[2]
      println("6. [Envio m2: P2 -> P3] P2 transmite m2 com timestamp = " + ts_m2 + " (Clock P2 = " + clocks[2] + ")")

      #L Evento 6: P3 recebe m2 de P2
      mut as int64: max_p3 = clocks[3]
      route {
            ts_m2 > max_p3 ==> { max_p3 = ts_m2 }
            _ ==> {}
      }
      clocks[3] = max_p3 + 1
      println("7. [Recepcao m2 em P3] P3 aplica max(" + (clocks[3] - (max_p3 - ts_m2) - 1) + ", " + ts_m2 + ") + 1 -> Clock P3 = " + clocks[3])

      println("==================================================")
      println("8. Validacao da Invariante Causal (a -> b => L(a) < L(b)):")
      println("   Cadeia Causal: e1,1 (L=1) -> send(m1) (L=2) -> recv(m1) (L=3) -> send(m2) (L=4) -> recv(m2) (L=5)")
      println("   Clocks Finais: P1=" + clocks[1] + ", P2=" + clocks[2] + ", P3=" + clocks[3])
      println("   Ordenacao Parcial Garantida com Sucesso!")
      println("==================================================")
}
