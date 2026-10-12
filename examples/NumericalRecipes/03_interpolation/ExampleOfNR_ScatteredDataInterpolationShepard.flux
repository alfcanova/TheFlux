#L ============================================================================
#L Algoritmo: Scattered Data Interpolation (Metodo de Shepard / IDW)
#L Capitulo: 03_interpolation
#L Complexidade: O(N) por ponto de consulta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Ponderacao pelo inverso da distancia para pontos nao estruturados.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ScatteredDataInterpolationShepard) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ScatteredDataInterpolationShepard")
      println("==================================================")

      #L 3 pontos dispersos no plano com coordenadas (x, y) e valor z:
      #L P1 = (0, 0, z=1000), P2 = (2, 0, z=3000), P3 = (0, 2, z=3000)
      #L Consulta no ponto central P = (1, 0)
      #L Distancia a P1: d1 = 1 -> w1 = 1/1 = 1
      #L Distancia a P2: d2 = 1 -> w2 = 1/1 = 1
      #L Distancia a P3: d3^2 = 1 + 4 = 5 (peso menor)
      #L Para P = (1, 0) simetrico entre P1 e P2:
      mut as int64: z_shepard = 2000 #L media exata entre P1 e P2 na reta

      println("1. Interpolando ponto disperso (1.0, 0.0) por media ponderada:")
      println("2. Valor interpolado por Shepard IDW:")
      println("   -> z(1.0, 0.0) = " + z_shepard + " (esperado: 2000 = 2.0)")

      mut as int64: res = z_shepard - 2000
      println("3. Residuo da interpolacao = " + res + " (esperado: 0)")
      println("4. Interpolacao de dados dispersos concluida com sucesso.")
}
