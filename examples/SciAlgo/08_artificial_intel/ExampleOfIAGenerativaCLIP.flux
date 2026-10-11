#L ============================================================================
#L Algoritmo: CLIP (Contrastive Language-Image Pre-training)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaCLIP) {
      println("=== Algoritmo: CLIP Multi-Modal Alignment ===")
      mut as list of int64: imgEmb = [50, 50]
      mut as list of int64: txtEmb = [48, 52]
      mut as int64: dotProduct = (imgEmb[1] * txtEmb[1] + imgEmb[2] * txtEmb[2]) /i 100
      println("1. Alinhamento multimodal Imagem-Texto: " + dotProduct)
      println("Teste concluido com sucesso.")
}
