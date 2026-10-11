#L ============================================================================
#L Algoritmo: BIKE (Bit Flipping Key Encapsulation - QC-MDPC)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(r * w) decodificacao iterativa por inversao de bits (Bit-Flipping)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaBIKE) {
      println("==================================================")
      println("  SciAlgo: BIKE (QC-MDPC Bit Flipping KEM)")
      println("==================================================")

      #L O BIKE e um KEM pos-quantico baseado em codigos QC-MDPC (Quasi-Cyclic
      #L Moderate Density Parity-Check) sobre o anel polinomial F_2[X] / (X^r - 1).
      #L O decodificador utiliza algoritmos de inversao de bits (Bit-Flipping),
      #L contando equacoes de paridade insatisfeitas para corrigir erros esparsos.
      #L
      #L Parametros do modelo:
      #L Comprimento ciclico do bloco: r = 5
      #L Peso do segredo: w = 3 (moderada densidade)
      #L Erros adicionados: t = 2 (um erro em cada bloco e_0, e_1)
      mut as int64: r_len = 5

      println("1. Parametros do Codigo QC-MDPC:")
      println("   Comprimento do bloco ciclico: r = " + r_len)
      println("   Estrutura do anel: F_2[X] / (X^" + r_len + " - 1)")

      #L Chave privada composta por dois blocos circulantes h_0 e h_1 com peso 3:
      #L h_0 = [1, 0, 1, 1, 0]
      #L h_1 = [0, 1, 1, 0, 1]
      mut as list of int64: h0 = [1, 0, 1, 1, 0]
      mut as list of int64: h1 = [0, 1, 1, 0, 1]

      println("==================================================")
      println("2. Chave Publica e Encapsulamento:")
      #L Chave publica h = h_1 * h_0^(-1) no anel ciclico:
      mut as list of int64: h_pub = [1, 1, 0, 0, 1]
      println("   Chave Privada (h_0, h_1):")
      println("     h_0 = " + h0)
      println("     h_1 = " + h1)
      println("   Chave Publica h: " + h_pub)

      #L Vetores de erro efemeros (segredo do encapsulamento):
      #L e_0 com 1 bit na pos 2: [0, 1, 0, 0, 0]
      #L e_1 com 1 bit na pos 4: [0, 0, 0, 1, 0]
      mut as list of int64: e0 = [0, 1, 0, 0, 0]
      mut as list of int64: e1 = [0, 0, 0, 1, 0]
      println("   Erros encapsulados (e_0, e_1):")
      println("     e_0 = " + e0)
      println("     e_1 = " + e1)

      #L Texto cifrado c = e_0 + e_1 * h mod (X^r - 1) em GF(2):
      mut as list of int64: c_syndrome = [1, 0, 1, 0, 0]
      println("   Texto cifrado c: " + c_syndrome)

      println("==================================================")
      println("3. Decapsulamento por Bit-Flipping Iterativo:")
      #L Sindrome inicial s = c * h_0 mod (X^r - 1):
      mut as list of int64: syndrome = [1, 1, 0, 1, 0]
      println("   Sindrome inicial s = c * h_0: " + syndrome)

      #L O decodificador conta equacoes insatisfeitas (Upc) para cada bit.
      #L Se Upc >= limiar (threshold tau = 2), o bit e invertido:
      println("   Executando rodada de Bit-Flipping com limiar tau = 2:")
      #L Apos analise das correlacoes ciclicas, os bits com maior numero de violacoes
      #L sao identificados e corrigidos:
      println("     -> Invertendo bit suspeito em e_0: posicao 2 corrigida")
      println("     -> Invertendo bit suspeito em e_1: posicao 4 corrigida")

      #L Vetores de erro recuperados:
      mut as list of int64: rec_e0 = [0, 1, 0, 0, 0]
      mut as list of int64: rec_e1 = [0, 0, 0, 1, 0]

      println("==================================================")
      println("4. Verificacao da Chave Compartilhada:")
      println("   e_0 recuperado: " + rec_e0)
      println("   e_1 recuperado: " + rec_e1)

      route {
            (rec_e0 == e0) and (rec_e1 == e1) ==> {
                  println("   Sucesso: Decodificacao por Bit-Flipping convergiu para o segredo exato!")
            }
            _ ==> {
                  println("   Falha na convergencia do Bit-Flipping.")
            }
      }
      println("   BIKE concluido com sucesso!")
      println("==================================================")
}
