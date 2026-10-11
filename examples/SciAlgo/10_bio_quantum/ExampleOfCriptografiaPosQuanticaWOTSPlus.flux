#L ============================================================================
#L Algoritmo: Winternitz One-Time Signature (WOTS+ / Cadeias de Hashes)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(w * l) cadeias de hash unidirecionais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaWOTSPlus) {
      println("==================================================")
      println("  SciAlgo: Winternitz One-Time Signature (WOTS+)")
      println("==================================================")

      #L O WOTS+ e o esquema de assinatura de uso unico baseado em cadeias de hash
      #L que fundamenta os padroes XMSS e SPHINCS+ (SLH-DSA).
      #L Ao contrario do Lamport OTS que requer um par de chaves por bit, o WOTS+
      #L codifica digitos na base w (parametro de Winternitz), reduzindo o tamanho
      #L da chave e da assinatura por um fator de log2(w).
      #L
      #L Parametros do modelo:
      #L Parametro de Winternitz: w = 4 (digitos no intervalo 0..3)
      #L Numero de digitos de mensagem: l_1 = 2
      #L Digitos de checksum: l_2 = 1 (para impedir forja por extensao)
      #L Total de cadeias de hash: l = l_1 + l_2 = 3
      mut as int64: w = 4
      mut as int64: l_total = 3

      println("1. Parametros do WOTS+:")
      println("   Parametro de Winternitz: w = " + w + " (intervalo de digitos: 0.." + (w - 1) + ")")
      println("   Comprimento total das cadeias: l = " + l_total)

      #L Chaves secretas iniciais das 3 cadeias:
      mut as list of int64: sk_chains = [25, 42, 73]
      println("   Chave Secreta SK (inicio das cadeias): " + sk_chains)

      #L Funcao de passo da cadeia: chain_step(x) = (x * 31 + 7) mod 1000
      #L Chave publica PK obtida aplicando (w - 1) = 3 passos de hash a cada cadeia:
      mut as list of int64: pk_chains = [0, 0, 0]

      println("==================================================")
      println("2. Geracao de Chave Publica PK = Chain^(w-1)(SK):")
      mut as int64: c = 0
      infinite (c < l_total) {
            mut as int64: curr = sk_chains[c + 1]
            mut as int64: step = 0
            infinite (step < (w - 1)) {
                  curr = ((curr * 31) + 7) /r 1000
                  step = step + 1
            }
            pk_chains[c + 1] = curr
            c = c + 1
      }
      println("   Chave Publica PK (fim das cadeias): " + pk_chains)

      println("==================================================")
      println("3. Assinatura de Mensagem (Sign):")
      #L Mensagem codificada em base-4: [2, 1]
      mut as int64: m0 = 2
      mut as int64: m1 = 1
      #L Checksum: C = sum((w - 1) - m_i) = (3 - 2) + (3 - 1) = 1 + 2 = 3
      mut as int64: csum = (w - 1 - m0) + (w - 1 - m1)
      mut as list of int64: msg_digits = [m0, m1, csum]
      println("   Digitos da Mensagem com Checksum: " + msg_digits)

      #L A assinatura para o digito d e o estado da cadeia apos d aplicacoes de hash:
      mut as list of int64: signature = [0, 0, 0]
      c = 0
      infinite (c < l_total) {
            mut as int64: d_val = msg_digits[c + 1]
            mut as int64: curr2 = sk_chains[c + 1]
            mut as int64: s2 = 0
            infinite (s2 < d_val) {
                  curr2 = ((curr2 * 31) + 7) /r 1000
                  s2 = s2 + 1
            }
            signature[c + 1] = curr2
            c = c + 1
      }
      println("   Assinatura WOTS+ gerada: " + signature)

      println("==================================================")
      println("4. Verificacao da Assinatura (Verify):")
      #L O verificador avanca cada elemento da assinatura pelos restantes (w - 1 - d) passos:
      mut as list of int64: reconstructed_pk = [0, 0, 0]
      mut as bool: match_all = true

      c = 0
      infinite (c < l_total) {
            mut as int64: d_val = msg_digits[c + 1]
            mut as int64: remaining_steps = (w - 1) - d_val
            mut as int64: curr3 = signature[c + 1]
            mut as int64: s3 = 0
            infinite (s3 < remaining_steps) {
                  curr3 = ((curr3 * 31) + 7) /r 1000
                  s3 = s3 + 1
            }
            reconstructed_pk[c + 1] = curr3
            route {
                  curr3 != pk_chains[c + 1] ==> { match_all = false }
                  _ ==> {}
            }
            c = c + 1
      }

      println("   PK Reconstruida: " + reconstructed_pk)
      println("   PK Oficial:      " + pk_chains)

      route {
            match_all ==> {
                  println("   Sucesso: Assinatura WOTS+ autenticada com exatidao absoluta!")
            }
            _ ==> {
                  println("   Falha: Assinatura WOTS+ rejeitada.")
            }
      }
      println("   WOTS+ concluido com sucesso!")
      println("==================================================")
}
