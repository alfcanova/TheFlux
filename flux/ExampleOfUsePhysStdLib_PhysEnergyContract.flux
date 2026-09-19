#L Exemplo de Uso: PhysEnergyContract (Energia, Trabalho e Potencia)
use PhysStdLib as Phys

program (ExampleOfUsePhysStdLib_PhysEnergyContract) {
      println("==================================================")
      println("  Exemplo: PhysEnergyContract (Energia e Trabalho)")
      println("==================================================")

      #L 1. Energia Cinetica (Ek = 0.5 * m * v^2)
      mut as float64: ek = physKineticEnergy(1200.0, 20.0)
      println("1. Energia cinetica (m=1200kg, v=20m/s): " + ek)

      #L 2. Energia Potencial Gravitacional (Ep = m * g * h)
      mut as float64: ep = physPotentialEnergy(1200.0, 15.0, 9.8)
      println("2. Energia potencial gravitacional (h=15m): " + ep)

      #L 3. Energia Potencial Elastica (Epe = 0.5 * k * x^2)
      mut as float64: epe = physElasticPotentialEnergy(400.0, 0.2)
      println("3. Energia potencial elastica (k=400, x=0.2m): " + epe)

      #L 4. Energia Mecanica Total
      mut as float64: em = physMechanicalEnergy(ek, ep)
      println("4. Energia mecanica total: " + em)

      #L 5. Trabalho de uma Forca (W = F * d)
      mut as float64: w = physWork(300.0, 50.0)
      println("5. Trabalho realizado (F=300N, d=50m): " + w)

      #L 6. Potencia Media (P = W / t)
      mut as float64: p = physPower(w, 10.0)
      println("6. Potencia media (t=10s): " + p)

      #L 7. Rendimento / Eficiencia (eta = Pu / Pt)
      mut as float64: eff = physEfficiency(1200.0, 1500.0)
      println("7. Rendimento utilitario: " + eff)
}
