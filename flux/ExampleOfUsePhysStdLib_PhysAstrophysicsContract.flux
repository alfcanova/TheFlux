#L Exemplo de Uso: PhysAstrophysicsContract (Gravitacao e Astrofisica)
use PhysStdLib as Phys

program (ExampleOfUsePhysStdLib_PhysAstrophysicsContract) {
      println("==================================================")
      println("  Exemplo: PhysAstrophysicsContract (Astrofisica) ")
      println("==================================================")

      #L Constantes aproximadas do sistema Terra-Lua
      #L Massa da Terra = 5.972e24 kg
      #L Raio da Terra = 6.371e6 m
      #L Massa da Lua = 7.342e22 kg
      #L Distancia Terra-Lua = 3.844e8 m
      mut as float64: m_terra = 5.972e24
      mut as float64: r_terra = 6371000.0
      mut as float64: m_lua = 7.342e22
      mut as float64: d_terra_lua = 384400000.0

      #L 1. Forca Gravitacional Terra-Lua
      mut as float64: fg = physGravitationalForce(m_terra, m_lua, d_terra_lua)
      mut as float64: fg_scaled = fg /f 1.0e20
      mut as float64: fg_fmt = ((fg_scaled * 10000.0 + 0.5) as int64) /f 10000.0
      println("1. Forca gravitacional Terra-Lua (x10^20 N): " + fg_fmt)

      #L 2. Energia Potencial Gravitacional
      mut as float64: u = physGravitationalPotentialEnergy(m_terra, m_lua, d_terra_lua)
      mut as float64: u_scaled = u /f 1.0e28
      mut as float64: u_fmt = ((u_scaled * 10000.0 - 0.5) as int64) /f 10000.0
      println("2. Potencial gravitacional Terra-Lua (x10^28 J): " + u_fmt)

      #L 3. Velocidade de Escape da Terra (aprox 11.2 km/s)
      mut as float64: ve = physEscapeVelocity(m_terra, r_terra)
      mut as float64: ve_fmt = ((ve * 10000.0 + 0.5) as int64) /f 10000.0
      println("3. Velocidade de escape da Terra (m/s): " + ve_fmt)

      #L 4. Velocidade Orbital em orbita baixa (aprox 7.9 km/s)
      mut as float64: vo = physOrbitalVelocity(m_terra, r_terra)
      mut as float64: vo_fmt = ((vo * 10000.0 + 0.5) as int64) /f 10000.0
      println("4. Velocidade orbital na superficie da Terra (m/s): " + vo_fmt)

      #L 5. Periodo orbital (Terceira Lei de Kepler)
      #L Lua ao redor da Terra (aprox 27.3 dias = 2.36e6 s)
      mut as float64: t_orb = physKeplerPeriod(d_terra_lua, m_terra)
      mut as float64: t_orb_fmt = ((t_orb * 100.0 + 0.5) as int64) /f 100.0
      println("5. Periodo orbital da Lua (segundos): " + t_orb_fmt)
}
