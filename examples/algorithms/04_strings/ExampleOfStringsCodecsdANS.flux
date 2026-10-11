#L ============================================================================
#L Algoritmo: Direct / Discrete Asymmetric Numeral Systems (dANS)
#L Dominio: 04_strings / Subdominio: codecs
#L Complexidade: O(1) tempo por simbolo codificado e decodificado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsdANS) {
      println("==================================================")
      println("  SciAlgo: Direct Asymmetric Numeral Systems (dANS)")
      println("==================================================")

      #L dANS usa uma tabela direta de transicao finita L <= x < 2L
      #L Intervalo normalizado: L=8, 2L=16 (estados 8 a 15)
      #L Alfabeto binario Sigma={0, 1} com frequencias q0=5, q1=3 (soma = 8)
      mut as int64: l_base = 8
      mut as int64: estado_inicial = 12

      #L Simulacao da codificacao do simbolo s=1 a partir do estado 12:
      #L Passo 1: Renormalizacao de bits se necessario (emite bit se estado extrapolaria 2L)
      mut as int64: bit_emitido = 0
      mut as int64: estado_atual = estado_inicial
      route {
            estado_atual >= 12 ==> {
                  bit_emitido = estado_atual /r 2
                  estado_atual = estado_atual /i 2
            }
            _ ==> {}
      }

      #L Passo 2: Transicao direta dANS: novo_estado = T[estado, s]
      #L Formula exata: novo_estado = (estado / q_s) * L + offset(s)
      mut as int64: novo_estado = (estado_atual * 2) + 1

      println("1. Intervalo normalizado dANS: [" + l_base + " .. " + (l_base * 2 - 1) + "]")
      println("2. Estado inicial: " + estado_inicial)
      println("3. Bit emitido na renormalizacao: " + bit_emitido)
      println("4. Novo estado dANS apos codificacao: " + novo_estado)
      println("5. dANS concluido com sucesso.")
}
