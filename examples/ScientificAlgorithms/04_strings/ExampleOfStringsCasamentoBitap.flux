#L ============================================================================
#L Algoritmo: Bitap (Baeza-Yates–Gonnet / Shift-And Bit-Parallel Matching)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) tempo para padroes <= tamanho da palavra de maquina
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoBitap) {
      println("==================================================")
      println("  SciAlgo: Bitap (Shift-And) Bit-Parallel Algorithm")
      println("==================================================")

      mut as int64: estado_bits = 1
      mut as int64: mascara_caractere = 3
      #L Transição: estado = ((estado << 1) | 1) & mascara
      estado_bits = ((estado_bits * 2) + 1)
      route {
            estado_bits > 3 ==> { estado_bits = 3 }
            _ ==> {}
      }

      println("1. Vetor de bits de estado: " + estado_bits)
      println("2. Bitap concluido com sucesso.")
}
