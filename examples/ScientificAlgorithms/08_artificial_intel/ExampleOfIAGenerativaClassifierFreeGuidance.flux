#L ============================================================================
#L Algoritmo: Classifier-Free Guidance (CFG)
#L Dominio: 08_artificial_intel / Subdominio: Modelos Generativos e Difusao
#L Descricao: Ponderacao e extrapolacao entre predicoes condicionais e incondicionais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaClassifierFreeGuidance) {
      println("=== Algoritmo: Classifier-Free Guidance (CFG) ===")

      #L Predicao incondicional do modelo de difusao (eps_uncond): 20
      #L Predicao condicional com o prompt de texto (eps_cond): 35
      mut as int64: eps_uncond = 20
      mut as int64: eps_cond = 35

      #L Fator de escala de guidance s = 3 (amplificacao do direcionamento ao prompt)
      mut as int64: scale = 3

      #L Diferenca direcional (vetor de alinhamento ao texto):
      #L diff = eps_cond - eps_uncond = 35 - 20 = 15
      mut as int64: diff = eps_cond - eps_uncond

      #L Predicao final guiada via CFG:
      #L eps_cfg = eps_uncond + scale * diff = 20 + 3 * 15 = 20 + 45 = 65
      mut as int64: scaled_diff = scale * diff
      mut as int64: eps_cfg = eps_uncond + scaled_diff

      println("1. Predicao incondicional: " + eps_uncond)
      println("2. Predicao condicional: " + eps_cond)
      println("3. Vetor direcional do prompt: " + diff)
      println("4. Predicao resultante sob CFG (scale=" + scale + "): " + eps_cfg)

      route {
            eps_cfg == 65 and eps_cfg > eps_cond ==> {
                  println("5. Extrapolacao Classifier-Free Guidance validada com sucesso.")
            }
            _ ==> {
                  println("Falha na computacao CFG.")
            }
      }
      println("Teste concluido com sucesso.")
}
