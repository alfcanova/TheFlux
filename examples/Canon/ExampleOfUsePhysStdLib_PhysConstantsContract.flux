#L Exemplo de Uso: PhysConstantsContract (Constantes Fisicas Multi-Bit)
use PhysStdLib as Phys

program (ExampleOfUsePhysStdLib_PhysConstantsContract) {
      println("==================================================")
      println("  Exemplo: PhysConstantsContract (64, 32, 16 bits)")
      println("==================================================")

      #L 1. Luz, Gravitacao e Aceleracao Gravitacional
      println("1. Fundamentais:")
      println("   c64: " + speedOfLight64())
      println("   c32: " + speedOfLight32())
      println("   c16: " + speedOfLight16())
      println("   g64: " + standardGravity64())
      println("   g32: " + standardGravity32())
      println("   g16: " + standardGravity16())

      #L 2. Quantica e Eletromagnetismo
      println("2. Quantica e Eletromagnetismo:")
      println("   coulomb64: " + coulombConstant64())
      println("   coulomb32: " + coulombConstant32())
      println("   planck presente: " + (planckConstant64() > 0.0))
      println("   charge presente: " + (elementaryCharge64() > 0.0))

      #L 3. Termodinamica e Gases
      println("3. Termodinamica:")
      println("   gasConst64: " + gasConstant64())
      println("   gasConst32: " + gasConstant32())
      println("   absZero64: " + absoluteZeroCelsius64())
      println("   absZero32: " + absoluteZeroCelsius32())
      println("   stdAtm64: " + standardAtmosphere64())
      println("   boltzmann presente: " + (boltzmannConstant64() > 0.0))
      println("   avogadro presente: " + (avogadroNumber64() > 0.0))

      #L 4. Astronomia
      println("4. Astronomia:")
      println("   au64: " + astronomicalUnit64())
      println("   ly64: " + lightYear64())
}
