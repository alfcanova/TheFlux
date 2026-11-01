#L Exemplo de Uso: PhysKinematicsContract (Cinematica e Movimento)
use PhysStdLib as Phys

program (ExampleOfUsePhysStdLib_PhysKinematicsContract) {
      println("==================================================")
      println("  Exemplo: PhysKinematicsContract (Cinematica)    ")
      println("==================================================")

      #L 1. Movimento Uniformemente Variado (MRUV)
      #L v0 = 10 m/s, a = 2 m/s^2, t = 5 s
      mut as float64: v = physVelocity(10.0, 2.0, 5.0)
      println("1. Velocidade final (v0=10, a=2, t=5): " + v)

      #L s0 = 0 m, v0 = 10 m/s, a = 2 m/s^2, t = 5 s
      mut as float64: s = physDisplacement(0.0, 10.0, 2.0, 5.0)
      println("2. Espaco percorrido (s0=0, v0=10, a=2, t=5): " + s)

      #L 2. Equacao de Torricelli
      #L v0 = 0 m/s, a = 9.8 m/s^2, delta_s = 20 m
      mut as float64: vt = physTorricelli(0.0, 9.8, 20.0)
      mut as float64: vt_fmt = ((vt * 10000.0 + 0.5) as int64) /f 10000.0
      println("3. Velocidade Torricelli (queda de 20m com g=9.8): " + vt_fmt)

      #L 3. Velocidade Media
      mut as float64: vm = physAverageSpeed(100.0, 9.58)
      println("4. Velocidade media 100m em 9.58s: " + vm)

      #L 4. Movimento Circular e Aceleracao Centripeta
      #L v = 20 m/s, r = 50 m
      mut as float64: ac = physCentripetalAcceleration(20.0, 50.0)
      println("5. Aceleracao centripeta (v=20, r=50): " + ac)

      #L 5. Periodo do Movimento Harmonico Simples (MHS)
      #L m = 2 kg, k = 200 N/m
      mut as float64: t_mhs = physSimpleHarmonicPeriod(2.0, 200.0)
      mut as float64: t_mhs_fmt = ((t_mhs * 10000.0 + 0.5) as int64) /f 10000.0
      println("6. Periodo MHS massa-mola (m=2kg, k=200N/m): " + t_mhs_fmt)

      #L 6. Periodo do Pendulo Simples
      #L L = 1 m, g = 9.80665 m/s^2
      mut as float64: t_pend = physPendulumPeriod(1.0, standardGravity64())
      mut as float64: t_pend_fmt = ((t_pend * 10000.0 + 0.5) as int64) /f 10000.0
      println("7. Periodo do pendulo simples (L=1m): " + t_pend_fmt)
}
