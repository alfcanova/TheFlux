use ThreadStdLib

program (ExampleOfUseThreadStdLib_ThreadChannelContract) {
      println("==================================================")
      println("  Exemplo: ThreadChannelContract (Canais CSP)")
      println("==================================================")

      mut as map: ch = channelCreate()
      println("1. Canal criado com sucesso: " + (ch["send"] > 0))

      mut as bool: s_ok = channelSend(ch["send"], "Ola TheFlux Concorrente")
      println("2. Envio no canal: " + s_ok)

      mut as int64: len_c = channelLength(ch["recv"])
      println("3. Comprimento do canal (>= 0): " + (len_c >= 0))

      mut as data: msg = channelRecv(ch["recv"])
      println("4. Mensagem recebida: " + (msg != ""))

      mut as map: tr = channelTryRecv(ch["recv"])
      println("5. TryRecv em canal vazio: " + tr["ok"])

      mut as bool: c_ok = channelClose(ch["send"])
      println("6. Canal fechado: " + c_ok)
      println("7. Canal esta fechado: " + channelIsClosed(ch["recv"]))

      #L Bounded channel & Aliases
      mut as map: ch_bounded = channelCreateWithCapacity(10)
      println("8. Canal delimitado criado: " + (ch_bounded["send"] > 0))
      println("9. Capacidade do canal: " + (channelCapacity(ch_bounded["recv"]) >= 0))
      println("10. Alias chanLen: " + (chanLen(ch_bounded["recv"]) >= 0))
}
