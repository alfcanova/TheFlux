#L Exemplo de Uso: PhysDynamicsContract (Dinamica e Leis de Newton)
use PhysStdLib as Phys

program (ExampleOfUsePhysStdLib_PhysDynamicsContract) {
      println("==================================================")
      println("  Exemplo: PhysDynamicsContract (Dinamica)        ")
      println("==================================================")

      #L 1. Segunda Lei de Newton (F = m * a)
      mut as float64: f = physForce(1500.0, 3.5)
      println("1. Forca necessaria (m=1500kg, a=3.5m/s^2): " + f)

      #L Aceleracao resultante (a = F / m)
      mut as float64: a = physAcceleration(5250.0, 1500.0)
      println("2. Aceleracao resultante: " + a)

      #L 2. Peso de um objeto na Terra (g=9.80665)
      mut as float64: p = physWeight(70.0, standardGravity64())
      println("3. Peso de 70kg na Terra: " + p)

      #L 3. Forca de Atrito (f = mu * N)
      #L N = 70 * 9.80665 = 686.4655 N, mu = 0.3
      mut as float64: fat = physFrictionForce(p, 0.3)
      println("4. Forca de atrito (mu=0.3): " + fat)

      #L 4. Forca Elastica de Hooke (F = -k * x)
      #L k = 500 N/m, x = 0.15 m
      mut as float64: fh = physHookeForce(500.0, 0.15)
      println("5. Forca restauradora de Hooke: " + fh)

      #L 5. Forca Centripeta (Fc = m * v^2 / r)
      mut as float64: fc = physCentripetalForce(1000.0, 25.0, 100.0)
      println("6. Forca centripeta curva (m=1000kg, v=25m/s, r=100m): " + fc)

      #L 6. Momento Linear (p = m * v) e Impulso (J = F * delta_t)
      mut as float64: q = physMomentum(1000.0, 25.0)
      println("7. Quantidade de movimento: " + q)

      mut as float64: j = physImpulse(6250.0, 4.0)
      println("8. Impulso de frenagem (F=6250N, t=4s): " + j)
}
