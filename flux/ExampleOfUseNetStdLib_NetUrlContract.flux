use NetStdLib

program (ExampleOfUseNetStdLib_NetUrlContract) {
      println("==================================================")
      println("  Exemplo: NetUrlContract (Parsing e URLs)")
      println("==================================================")

      mut as string: u = "https://api.theflux.org:8080/v1/users?page=1#profile"

      println("1. Scheme: " + netUrlGetScheme(u))
      println("2. Host: " + netUrlGetHost(u))
      println("3. Port: " + netUrlGetPort(u))
      println("4. Path: " + netUrlGetPath(u))
      println("5. Query: " + netUrlGetQuery(u))
      println("6. Fragment: " + netUrlGetFragment(u))

      mut as string: raw = "hello world & flux!"
      mut as string: enc = netUrlEncode(raw)
      println("7. URL Encode: " + enc)
      println("8. URL Decode: " + netUrlDecode(enc))
      println("9. URL Valida (https://theflux.org): " + netUrlIsValid("https://theflux.org"))
      println("10. URL Invalida (texto_sem_scheme): " + netUrlIsValid("texto_sem_scheme"))
      println("11. URL Join: " + netUrlJoin("https://theflux.org/docs/", "guide.html"))
}
