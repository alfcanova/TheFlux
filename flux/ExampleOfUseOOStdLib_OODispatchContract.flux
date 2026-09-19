use OOStdLib

struct (MotorEletrico) {
      mut: .potencia_cv: int64
      mut: .rpm: int64
}

program (ExampleOfUseOOStdLib_OODispatchContract) {
      println("==================================================")
      println("  Exemplo: OODispatchContract (Despacho Dinamico)")
      println("==================================================")

      mut as MotorEletrico: motor = MotorEletrico(.potencia_cv: 150, .rpm: 3200)
      mut as data: obj_motor = ooCastToContract(motor, "Propulsor")

      #L 1. Despacho dinamico de operacao sem argumentos
      mut as data: desp1 = ooDispatch(obj_motor, "ligar", [])
      println("1. Despacho de operacao ligar:")
      println("   Contrato alvo: " + desp1["contract"])
      println("   Tipo da instancia: " + desp1["type"])
      println("   Metodo invocado: " + desp1["method"])
      println("   Status do despacho: " + desp1["status"])

      #L 2. Despacho dinamico de operacao com argumentos
      mut as list of data: args_velocidade = [4500, "modo_turbo"]
      mut as data: desp2 = ooDispatch(obj_motor, "ajustarRpm", args_velocidade)
      println("\n2. Despacho com argumentos:")
      println("   Metodo: " + desp2["method"])
      println("   Argumentos passados: " + desp2["args"])

      #L 3. Tentativa de despacho em objeto descartado
      ooDispose(obj_motor)
      mut as data: desp3 = ooDispatch(obj_motor, "desligar", [])
      println("\n3. Status do despacho apos dispose: " + desp3.sta)
      println("   Motivo da rejeicao: " + desp3.msg)
}
