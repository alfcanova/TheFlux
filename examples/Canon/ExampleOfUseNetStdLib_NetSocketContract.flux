use NetStdLib

program (ExampleOfUseNetStdLib_NetSocketContract) {
      println("==================================================")
      println("  Exemplo: NetSocketContract (Sockets e Conexoes)")
      println("==================================================")

      mut as string: lip = netLocalIp()
      println("1. IP Local Presente: " + (lip != ""))

      mut as bool: port_ok = netPortIsAvailable(8080)
      println("2. Verificacao de Porta (8080): " + port_ok)

      mut as bool: ping_local = netTcpPing("127.0.0.1", 80, 50)
      println("3. TCP Ping Local Executado: " + (ping_local == true or ping_local == false))

      mut as bool: host_ping = netPing("localhost")
      println("4. Ping Host (localhost): " + host_ping)
}
