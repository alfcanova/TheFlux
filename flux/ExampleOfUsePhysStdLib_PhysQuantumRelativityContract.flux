#L Exemplo de Uso: PhysQuantumRelativityContract (Fisica Quantica e Relatividade)
use PhysStdLib as Phys

program (ExampleOfUsePhysStdLib_PhysQuantumRelativityContract) {
      println("==================================================")
      println("  Exemplo: PhysQuantumRelativityContract          ")
      println("==================================================")

      #L 1. Energia do Foton (E = h * nu)
      #L Luz visivel verde: frequencia = 5.5e14 Hz
      mut as float64: e_foton = physPhotonEnergy(550000000000000.0)
      println("1. Energia do foton verde (Joule): " + e_foton)

      #L 2. Equivalencia Massa-Energia de Einstein (E = m * c^2)
      #L 1 grama de materia = 0.001 kg
      mut as float64: e_repouso = physMassEnergyEquivalence(0.001)
      println("2. Energia de repouso de 1g de massa (J): " + e_repouso)

      #L 3. Fator de Lorentz (gamma = 1 / sqrt(1 - v^2/c^2))
      #L v = 0.8 * c
      mut as float64: v_rel = 0.8 * speedOfLight64()
      mut as float64: gamma = physLorentzGamma(v_rel)
      mut as float64: gamma_fmt = ((gamma * 10000.0 + 0.5) as int64) /f 10000.0
      println("3. Fator gamma de Lorentz (v = 0.8c): " + gamma_fmt)

      #L 4. Dilatacao Temporal (t = gamma * t0)
      #L 1 hora propria na nave espacial (3600s)
      mut as float64: t_dilatado = physTimeDilation(3600.0, v_rel)
      mut as float64: t_dil_fmt = ((t_dilatado * 10000.0 + 0.5) as int64) /f 10000.0
      println("4. Tempo medido na Terra (segundos): " + t_dil_fmt)

      #L 5. Contracao do Comprimento de Lorentz (L = L0 / gamma)
      #L Nave com comprimento proprio de 100 metros
      mut as float64: l_contraido = physLengthContraction(100.0, v_rel)
      mut as float64: l_cont_fmt = ((l_contraido * 10000.0 + 0.5) as int64) /f 10000.0
      println("5. Comprimento medido na Terra (metros): " + l_cont_fmt)
}
