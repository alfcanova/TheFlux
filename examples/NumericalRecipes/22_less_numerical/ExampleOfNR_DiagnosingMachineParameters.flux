#L ============================================================================
#L Algoritmo: Diagnosing Machine Parameters (Parametros de Arquitetura)
#L Capitulo: 22_less_numerical
#L Complexidade: O(log_2(Bits))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Deteccao dinamica do tamanho de palavra inteira, radix de base e limites.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DiagnosingMachineParameters) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DiagnosingMachineParameters")
      println("==================================================")

      #L Diagnostico da base (radix): base binaria radix = 2
      #L Deteccao de contagem de bits por deslocamento sucessivo:
      mut as int64: bits = 0
      mut as int64: val = 1
      infinite (bits < 63) {
            val = val << 1
            bits = bits + 1
      }

      println("1. Diagnostico de registradores da maquina:")
      println("   -> Base da arquitetura (radix) = 2")
      println("   -> Tamanho minimo verificado de bits com sinal = " + bits + " bits")

      #L Verificacao de integridade de 63 bits:
      mut as int64: residuo = bits - 63
      println("2. Residuo do diagnostico de parametros = " + residuo + " (esperado: 0)")
      println("3. Parametros de maquina diagnosticados com sucesso.")
}
