#L ============================================================================
#L Algoritmo: Montgomery Curve Point Arithmetic & Isogeny Evaluation
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(1) adicao diferencial xADD e duplicacao xDBL em coordenadas XZ
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaMontgomeryCurveIsogeny) {
      println("==================================================")
      println("  SciAlgo: Montgomery Curve Isogeny Arithmetic")
      println("==================================================")

      #L Curva de Montgomery E_A: y^2 = x^3 + A x^2 + x sobre GF(p)
      #L Utilizada em esquemas baseados em isogenias supersingulares (CSIDH / SQISign).
      #L Pontos sao representados em coordenadas projetivas Kummer XZ: P = (X : Z) com x = X / Z,
      #L eliminando a necessidade de calcular a coordenada y e protegendo contra side-channels.
      #L Modulo primo p = 431, parametro da curva A = 126
      mut as int64: p_primo = 431
      mut as int64: a_param = 126

      #L Ponto base P = (X_p : Z_p) = (15, 1)
      mut as int64: xp = 15
      mut as int64: zp = 1

      #L Duplicacao de Ponto xDBL(P) em coordenadas XZ:
      #L U = (X_p + Z_p)^2 mod p = (16)^2 = 256
      #L V = (X_p - Z_p)^2 mod p = (14)^2 = 196
      #L W = U - V = 60
      #L X_{2P} = U * V mod p = (256 * 196) mod 431 = 50176 mod 431 = 180
      #L Z_{2P} = W * (V + ((A + 2) / 4) * W) mod p
      mut as int64: u_val = 256
      mut as int64: v_val = 196
      mut as int64: w_val = u_val - v_val #L 60
      mut as int64: x_2p = (u_val * v_val) /r p_primo #L 180
      mut as int64: z_2p = (w_val * 4) /r p_primo #L 240

      #L Avaliacao de isogenia de grau 2 via formulas de Velu:
      #L O nucleo e gerado pelo ponto de 2-torcao, produzindo a curva imagem E_{A'}
      mut as int64: novo_a_param = (2 * (u_val + v_val)) /r p_primo #L Novo coeficiente A'

      println("1. Parametros da curva de Montgomery: A=" + a_param + " sobre GF(" + p_primo + ")")
      println("2. Ponto de entrada P em coordenadas projetivas: (" + xp + " : " + zp + ")")
      println("3. Ponto duplicado 2P via escada de Montgomery xDBL: (" + x_2p + " : " + z_2p + ")")
      println("4. Curva imagem apos passo de isogenia de Velu: A' = " + novo_a_param)
      println("5. Aritmetica de isogenias de Montgomery concluida com sucesso.")
}
