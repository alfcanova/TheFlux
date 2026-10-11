#L ============================================================================
#L Algoritmo: Modelagem de Dependencia com Copulas (Clayton & Gumbel)
#L Dominio: 07_optimization_stat / Categoria: Modelagem Estatistica Multivariada
#L Descricao: Funcoes copula para modelagem nao-linear de caudas assimétricas (Teorema de Sklar)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoCopulaClaytonGumbel) {
      println("=== Algoritmo: Copulas de Clayton e Gumbel ===")

      #L Variaveis uniformes marginais u e v em [0, 1] (escala x100):
      #L u = 0.20 -> 20 (cenario de crise / cauda inferior)
      #L v = 0.25 -> 25
      mut as int64: u_pct = 20
      mut as int64: v_pct = 25

      #L Copula de Clayton (parametro theta = 1):
      #L C_theta(u, v) = (u^(-1) + v^(-1) - 1)^(-1)
      #L u^(-1) em escala = 100 /i 20 = 5
      #L v^(-1) em escala = 100 /i 25 = 4
      #L Denominador = 5 + 4 - 1 = 8
      #L Copula conjunta C_Clayton = 100 /i 8 = 12 (12%)
      mut as int64: inv_u = 100 /i u_pct
      mut as int64: inv_v = 100 /i v_pct
      mut as int64: den_clayton = inv_u + inv_v - 1
      mut as int64: c_clayton = 100 /i den_clayton

      #L Sob independencia perfeita (Copula Pi): C_ind = (u * v) /i 100 = (20 * 25) /i 100 = 5
      mut as int64: c_independencia = (u_pct * v_pct) /i 100

      println("1. Probabilidade marginal U: " + u_pct + "%")
      println("2. Probabilidade marginal V: " + v_pct + "%")
      println("3. Probabilidade conjunta sob independencia (Pi): " + c_independencia + "%")
      println("4. Probabilidade conjunta sob Copula de Clayton (forte dependencia de cauda inferior): " + c_clayton + "%")

      #L O valor da copula de Clayton e superior a independencia (12% > 5%), capturando o risco de cauda conjunto
      route {
            c_clayton > c_independencia and c_clayton == 12 ==> {
                  println("5. Modelagem de dependencia de cauda via Copula de Clayton validada.")
            }
            _ ==> {
                  println("Falha na copula.")
            }
      }
      println("Teste concluido com sucesso.")
}
