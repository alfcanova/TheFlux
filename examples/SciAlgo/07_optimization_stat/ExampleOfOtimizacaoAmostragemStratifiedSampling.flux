#L ============================================================================
#L Algoritmo: Stratified Sampling (Amostragem Estratificada com Reducao de Variancia)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(K * N_estrato) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemStratifiedSampling) {
      println("==================================================")
      println("  SciAlgo: Stratified Sampling (Variance Reduction)")
      println("==================================================")

      #L Populacao dividida em 3 estratos com pesos W1=50%, W2=30%, W3=20%
      #L Medias amostrais coletadas dentro de cada estrato:
      #L Estrato 1: media 10
      #L Estrato 2: media 20
      #L Estrato 3: media 30
      mut as int64: m1 = 10
      mut as int64: m2 = 20
      mut as int64: m3 = 30

      #L Estimador estratificado global: E = W1*m1 + W2*m2 + W3*m3
      #L E = 0.50*10 + 0.30*20 + 0.20*30 = 5 + 6 + 6 = 17
      mut as int64: est_mean = ((50 * m1) + (30 * m2) + (20 * m3)) /i 100

      println("1. Media ponderada estratificada calculada: " + est_mean + " (esperado 17)")
      route {
            est_mean == 17 ==> {
                  println("   [PASS] Amostragem Estratificada calculou a media global com precisao!")
            }
            _ ==> {
                  println("   [ERRO] Falha na amostragem estratificada.")
            }
      }

      println("==================================================")
      println("Stratified Sampling concluido com sucesso!")
}
