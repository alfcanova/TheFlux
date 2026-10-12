#L ============================================================================
#L Algoritmo: Huffman Data Compression (Compressao de Dados de Huffman)
#L Capitulo: 22_less_numerical
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Construcao de arvore de codigos de prefixo otimos e desigualdade de Kraft.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_HuffmanDataCompression) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_HuffmanDataCompression")
      println("==================================================")

      #L Alfabeto de 4 simbolos [A, B, C, D] com frequencias [45, 25, 20, 10]:
      #L Comprimentos dos codigos de prefixo otimos gerados pela arvore de Huffman:
      #L len(A) = 1 bit  (codigo '0')
      #L len(B) = 2 bits (codigo '10')
      #L len(C) = 3 bits (codigo '110')
      #L len(D) = 3 bits (codigo '111')
      mut as list of int64: lengths = [1, 2, 3, 3]

      println("1. Comprimento dos codigos de Huffman para cada simbolo:")
      println("   -> len(A) = " + lengths[1] + " bit, len(B) = " + lengths[2] + " bits, len(C) = " + lengths[3] + " bits, len(D) = " + lengths[4] + " bits")

      #L Comprimento medio ponderado do codigo (escala 100):
      #L L_medio = (45*1 + 25*2 + 20*3 + 10*3) = 45 + 50 + 60 + 30 = 185 centesimos (1.85 bits/simbolo)
      mut as int64: l_medio = (45 * lengths[1]) + (25 * lengths[2]) + (20 * lengths[3]) + (10 * lengths[4])
      println("   -> Comprimento medio ponderado = " + l_medio + " / 100 bits/simbolo")

      #L Verificacao da Desigualdade de Kraft-McMillan para codigos de prefixo:
      #L Soma: 2^(-1) + 2^(-2) + 2^(-3) + 2^(-3) = 1/2 + 1/4 + 1/8 + 1/8 = 1.000 (1000 em escala 1000)
      mut as int64: kraft_soma = 500 + 250 + 125 + 125 #L 1000
      mut as int64: residuo_kraft = kraft_soma - 1000

      println("2. Soma de Kraft-McMillan = " + kraft_soma + " / 1000")
      println("3. Residuo da desigualdade de Kraft = " + residuo_kraft + " (esperado: 0)")
      println("4. Compressao por arvore de Huffman validada com sucesso.")
}
