use NetStdLib

program (ExampleOfUseNetStdLib_NetIpContract) {
      println("==================================================")
      println("  Exemplo: NetIpContract (Validacao de IPs e DNS)")
      println("==================================================")

      mut as string: ip4 = "192.168.1.100"
      mut as string: ip6 = "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
      mut as string: loop = "127.0.0.1"
      mut as string: pub = "8.8.8.8"

      println("1. IPv4 Valido (192.168.1.100): " + netIpIsValid(ip4))
      println("2. E IPv4 (192.168.1.100): " + netIpIsV4(ip4))
      println("3. IPv6 Valido (2001:...): " + netIpIsValid(ip6))
      println("4. E IPv6 (2001:...): " + netIpIsV6(ip6))
      println("5. IP Invalido (999.999.999.999): " + netIpIsValid("999.999.999.999"))
      println("6. Loopback (127.0.0.1): " + netIpIsLoopback(loop))
      println("7. Loopback (8.8.8.8): " + netIpIsLoopback(pub))
      println("8. Privado RFC1918 (192.168.1.100): " + netIpIsPrivate(ip4))
      println("9. Privado (8.8.8.8): " + netIpIsPrivate(pub))
      println("10. Resolucao Localhost: " + netResolveHost("localhost"))
      println("11. Resolucao Reversa Nao Vazia: " + (netResolveIp("127.0.0.1") != ""))
}
