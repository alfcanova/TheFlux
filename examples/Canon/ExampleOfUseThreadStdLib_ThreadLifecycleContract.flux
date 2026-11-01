use ThreadStdLib

program (ExampleOfUseThreadStdLib_ThreadLifecycleContract) {
      println("==================================================")
      println("  Exemplo: ThreadLifecycleContract (Ciclo de Vida)")
      println("==================================================")

      #L 1. Operacoes canonicas
      mut as int64: cur_id = threadCurrentId()
      println("1. Current Thread ID (> 0): " + (cur_id > 0))

      mut as int64: tid = threadSpawn("Worker", "run", "payload1")
      println("2. Thread criada com sucesso: " + (tid > 0))

      mut as bool: alive = threadIsAlive(tid)
      println("3. Thread isAlive verificado: " + (alive == true or alive == false))

      mut as data: res = threadJoin(tid)
      println("4. Thread Join concluido: " + (res != ""))

      mut as int64: tid2 = threadSpawn("Worker", "run", "payload2")
      mut as bool: det_ok = threadDetach(tid2)
      println("5. Thread Detach: " + det_ok)

      #L 2. Aliases universais
      mut as int64: cur_alias = currentThreadId()
      println("6. Alias currentThreadId (> 0): " + (cur_alias > 0))

      mut as int64: tid3 = spawnTask("Task", "compute", "payload3")
      println("7. Alias spawnTask: " + (tid3 > 0))

      mut as bool: alive_alias = isAlive(tid3)
      println("8. Alias isAlive: " + (alive_alias == true or alive_alias == false))

      mut as data: res_alias = joinTask(tid3)
      println("9. Alias joinTask concluido: " + (res_alias != ""))
}
