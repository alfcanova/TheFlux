use OOStdLib

struct (ConexaoBanco) {
      mut: .url: string
      mut: .ativa: bool
}

program (ExampleOfUseOOStdLib_OOLifecycleContract) {
      println("==================================================")
      println("  Exemplo: OOLifecycleContract (Ciclo de Vida)")
      println("==================================================")

      mut as ConexaoBanco: conn = ConexaoBanco(
            .url: "postgres://localhost:5432/producao"
            .ativa: true
      )

      #L 1. Criacao do objeto polimorfico gerenciado
      mut as data: obj_conn = ooCastToContract(conn, "Recurso")
      println("1. Objeto criado. Valido: " + ooIsValid(obj_conn))
      println("   Ja esta descartado: " + ooIsDisposed(obj_conn))
      println("   Representacao textual: " + ooToString(obj_conn))

      #L 2. Clonagem polimorfica segura (ooClone)
      mut as data: obj_clone = ooClone(obj_conn)
      println("\n2. Clone criado com sucesso.")
      println("   Clone eh valido: " + ooIsValid(obj_clone))
      println("   Representacao do clone: " + ooToString(obj_clone))
      println("   Contrato preservado no clone: " + ooContractName(obj_clone))
      println("   Tipo preservado no clone: " + ooUnderlyingType(obj_clone))

      #L 3. Descarte deterministico do objeto original (ooDispose)
      mut as bool: descartou = ooDispose(obj_conn)
      println("\n3. Descarte do objeto original:")
      println("   Status do descarte: " + descartou)
      println("   Original continua valido: " + ooIsValid(obj_conn))
      println("   Original consta como descartado: " + ooIsDisposed(obj_conn))

      #L 4. Verificacao de isolamento: o clone permanece integro
      println("\n4. Verificacao de isolamento do clone:")
      println("   Clone permanece valido: " + ooIsValid(obj_clone))
      println("   Clone nao esta descartado: " + ooIsDisposed(obj_clone))
      println("   Validacao de contrato no clone: " + ooValidateContract(obj_clone))
}
