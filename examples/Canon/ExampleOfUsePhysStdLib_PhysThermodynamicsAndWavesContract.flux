#L Exemplo de Uso: PhysThermodynamicsAndWavesContract (Termodinamica e Ondas)
use PhysStdLib as Phys

program (ExampleOfUsePhysStdLib_PhysThermodynamicsAndWavesContract) {
      println("==================================================")
      println("  Exemplo: PhysThermodynamicsAndWavesContract     ")
      println("==================================================")

      #L 1. Conversoes de Temperatura
      mut as float64: k = physCelsiusToKelvin(100.0)
      println("1. 100 C em Kelvin: " + k)

      mut as float64: c_voltou = physKelvinToCelsius(k)
      println("2. Kelvin de volta a Celsius: " + c_voltou)

      mut as float64: f = physCelsiusToFahrenheit(100.0)
      println("3. 100 C em Fahrenheit: " + f)

      mut as float64: c_de_f = physFahrenheitToCelsius(f)
      println("4. Fahrenheit de volta a Celsius: " + c_de_f)

      #L 2. Equacao dos Gases Ideais (P = n * R * T / V)
      #L 1 mol de gas a 273.15 K (0 C) em 0.022414 m^3 (22.414 L)
      mut as float64: p_gas = physIdealGasPressure(1.0, 273.15, 0.022414)
      println("5. Pressao gas ideal a CNTP (Pa): " + p_gas)

      #L 3. Calor Sensivel (Q = m * c * delta_T)
      #L 1 kg de agua (c=4184 J/kg*K) aquecida em 50 C
      mut as float64: q_sens = physSensibleHeat(1.0, 4184.0, 50.0)
      println("6. Calor sensivel 1kg agua (50C delta): " + q_sens)

      #L 4. Ondulatoria (v = f * lambda)
      #L Som no ar (v = 340 m/s), f = 440 Hz (Nota La)
      mut as float64: lambda_som = 340.0 /f 440.0
      mut as float64: v_onda = physWaveSpeed(440.0, lambda_som)
      println("7. Velocidade da onda sonica: " + v_onda)

      mut as float64: t_periodo = physWavePeriod(440.0)
      println("8. Periodo da onda de 440Hz (s): " + t_periodo)
}
