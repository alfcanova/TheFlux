#L Exemplo de Uso: PhysElectromagnetismContract (Eletromagnetismo)
use PhysStdLib as Phys

program (ExampleOfUsePhysStdLib_PhysElectromagnetismContract) {
      println("==================================================")
      println("  Exemplo: PhysElectromagnetismContract           ")
      println("==================================================")

      #L 1. Lei de Coulomb (F = ke * q1 * q2 / r^2)
      #L Duas cargas de 1 microCoulomb separadas por 1 metro
      mut as float64: q1 = 0.000001
      mut as float64: q2 = 0.000001
      mut as float64: dist = 1.0
      mut as float64: f_coulomb = physCoulombForce(q1, q2, dist)
      println("1. Forca de Coulomb (1uC a 1m): " + f_coulomb)

      #L 2. Campo Eletrico (E = ke * q / r^2)
      mut as float64: e_field = physElectricField(q1, dist)
      println("2. Campo eletrico a 1m: " + e_field)

      #L 3. Potencial Eletrico (V = ke * q / r)
      mut as float64: v_pot = physElectricPotential(q1, dist)
      println("3. Potencial eletrico a 1m: " + v_pot)

      #L 4. Primeira Lei de Ohm (I = V / R, V = R * I)
      #L V = 120 V, R = 24 Ohm -> I = 5 A
      mut as float64: i_curr = physOhmCurrent(120.0, 24.0)
      println("4. Corrente eletrica (120V, 24 Ohm): " + i_curr)

      mut as float64: v_tens = physOhmVoltage(i_curr, 24.0)
      println("5. Tensao recuperada: " + v_tens)

      #L 5. Potencia Eletrica (P = V * I)
      mut as float64: p_elec = physElectricPower(120.0, i_curr)
      println("6. Potencia dissipada no circuito: " + p_elec)

      #L 6. Energia em Capacitor (U = 0.5 * C * V^2)
      #L C = 100 uF = 0.0001 F, V = 12 V
      mut as float64: u_cap = physCapacitorEnergy(0.0001, 12.0)
      println("7. Energia armazenada em capacitor (100uF a 12V): " + u_cap)
}
