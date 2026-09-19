use RegexStdLib

program (ExampleOfUseRegexStdLib_RegexPresetContract) {
      println("==================================================")
      println("  Exemplo: RegexPresetContract (Presets de Seguranca)")
      println("==================================================")

      #L 1. Validacao de Enderecos de E-mail (regexIsEmail)
      mut as string: email_valido = "desenvolvedor.flux@empresa.com.br"
      mut as string: email_invalido = "usuario@sem_dominio"
      println("1. Validacao de E-mail:")
      println("   '", email_valido, "': ", regexIsEmail(email_valido))
      println("   '", email_invalido, "': ", regexIsEmail(email_invalido))

      #L 2. Validacao de URLs Web (regexIsUrl)
      mut as string: url_https = "https://theflux.lang/docs/pt-br"
      mut as string: url_invalida = "ht!tp://dominio-invalido"
      println("2. Validacao de URL Web:")
      println("   '", url_https, "': ", regexIsUrl(url_https))
      println("   '", url_invalida, "': ", regexIsUrl(url_invalida))

      #L 3. Validacao de UUID v4 Canônico (regexIsUuid)
      mut as string: uuid_valido = "123e4567-e89b-12d3-a456-426614174000"
      mut as string: uuid_invalido = "123e4567-e89b-12d3-a456-42661417400Z"
      println("3. Validacao de UUID canônico:")
      println("   '", uuid_valido, "': ", regexIsUuid(uuid_valido))
      println("   '", uuid_invalido, "': ", regexIsUuid(uuid_invalido))

      #L 4. Validacao de Enderecos IPv4 Decimal Pontuado (regexIsIpv4)
      mut as string: ip_correto = "192.168.0.254"
      mut as string: ip_fora_faixa = "192.168.0.300"
      mut as string: ip_incompleto = "192.168.1"
      println("4. Validacao de IPv4:")
      println("   '", ip_correto, "': ", regexIsIpv4(ip_correto))
      println("   '", ip_fora_faixa, "': ", regexIsIpv4(ip_fora_faixa))
      println("   '", ip_incompleto, "': ", regexIsIpv4(ip_incompleto))

      #L 5. Validacao de Conteudo Estritamente Numerico (regexIsNumeric)
      mut as string: num_positivo = "+987654321"
      mut as string: num_letras = "1234a56"
      println("5. Validacao de Numerico:")
      println("   '", num_positivo, "': ", regexIsNumeric(num_positivo))
      println("   '", num_letras, "': ", regexIsNumeric(num_letras))

      #L 6. Validacao de Datas nos Formatos ISO e Brasil/Europa (regexIsDate)
      mut as string: data_iso = "2026-09-17"
      mut as string: data_br = "17/09/2026"
      mut as string: data_invalida = "2026-13-45"
      println("6. Validacao de Datas (ISO e BR):")
      println("   '", data_iso, "' (ISO): ", regexIsDate(data_iso))
      println("   '", data_br, "' (BR):  ", regexIsDate(data_br))
      println("   '", data_invalida, "' (Invalida): ", regexIsDate(data_invalida))
}
