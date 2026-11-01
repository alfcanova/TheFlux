#L Exemplo de Uso: GfxCollisionContract (Deteccao de Colisoes 2D para Motores de Jogos)
use GfxStdLib as Gfx

program (ExampleOfUseGfxStdLib_GfxCollisionContract) {
      println("==================================================")
      println("  Exemplo: GfxCollisionContract                   ")
      println("==================================================")

      #L 1. Colisao entre Retangulos (AABB)
      #L r1 em (10, 10, 50, 50), r2 em (40, 40, 50, 50) -> Colidem!
      println("1. Colisao Rec vs Rec:")
      mut as bool: col_rec1 = gfxCheckCollisionRecs(10.0, 10.0, 50.0, 50.0, 40.0, 40.0, 50.0, 50.0)
      println("   r1 e r2 sobrepostos: " + col_rec1)

      #L r3 em (100, 100, 20, 20) -> Nao colide com r1
      mut as bool: col_rec2 = gfxCheckCollisionRecs(10.0, 10.0, 50.0, 50.0, 100.0, 100.0, 20.0, 20.0)
      println("   r1 e r3 distantes: " + col_rec2)

      #L 2. Colisao entre Circulos
      #L c1 centro (100, 100) raio 20, c2 centro (130, 100) raio 15 -> dist=30 <= 35 -> Colidem!
      println("2. Colisao Circulo vs Circulo:")
      mut as bool: col_circ1 = gfxCheckCollisionCircles(100.0, 100.0, 20.0, 130.0, 100.0, 15.0)
      println("   c1 e c2 interceptando: " + col_circ1)

      #L c3 centro (200, 200) raio 10 -> dist > 35 -> Nao colide
      mut as bool: col_circ2 = gfxCheckCollisionCircles(100.0, 100.0, 20.0, 200.0, 200.0, 10.0)
      println("   c1 e c3 separados: " + col_circ2)

      #L 3. Ponto dentro de Retangulo (Ex: Clique do Mouse em Botao)
      println("3. Ponto em Retangulo:")
      println("   (25, 25) dentro de (10, 10, 50, 50): " + gfxCheckCollisionPointRec(25.0, 25.0, 10.0, 10.0, 50.0, 50.0))
      println("   (5, 25) dentro de (10, 10, 50, 50): " + gfxCheckCollisionPointRec(5.0, 25.0, 10.0, 10.0, 50.0, 50.0))

      #L 4. Ponto dentro de Circulo
      println("4. Ponto em Circulo:")
      println("   (110, 100) dentro de c1 (raio 20): " + gfxCheckCollisionPointCircle(110.0, 100.0, 100.0, 100.0, 20.0))
      println("   (130, 100) dentro de c1 (raio 20): " + gfxCheckCollisionPointCircle(130.0, 100.0, 100.0, 100.0, 20.0))
}
