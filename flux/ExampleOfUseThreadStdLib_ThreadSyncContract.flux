use ThreadStdLib

program (ExampleOfUseThreadStdLib_ThreadSyncContract) {
      println("==================================================")
      println("  Exemplo: ThreadSyncContract (Mutex, Atomics, WG)")
      println("==================================================")

      #L 1. Mutex
      mut as int64: m = mutexCreate()
      println("1. Mutex criado: " + (m > 0))

      mut as bool: l1 = mutexLock(m)
      println("2. Mutex bloqueado: " + l1)

      mut as bool: u1 = mutexUnlock(m)
      println("3. Mutex desbloqueado: " + u1)

      mut as bool: tl = mutexTryLock(m)
      println("4. Mutex TryLock: " + tl)
      mutexUnlock(m)
      mutexDestroy(m)

      #L 2. Atomics
      mut as int64: a = atomicCreate(10)
      println("5. Atomic criado: " + (a > 0))
      println("6. Atomic valor inicial (> 0): " + (atomicGet(a) > 0))

      mut as int64: a_add = atomicAdd(a, 5)
      println("7. Atomic Add resultado (> 0): " + (a_add > 0))

      mut as bool: cas_ok = atomicCas(a, 15, 20)
      println("8. Atomic CAS (15 -> 20): " + cas_ok)
      atomicDestroy(a)

      #L 3. WaitGroup
      mut as int64: wg = waitGroupCreate()
      println("9. WaitGroup criado: " + (wg > 0))

      mut as bool: w_add = waitGroupAdd(wg, 2)
      println("10. WaitGroup Add: " + w_add)

      mut as bool: w_d1 = waitGroupDone(wg)
      mut as bool: w_d2 = waitGroupDone(wg)
      println("11. WaitGroup Done x2: " + (w_d1 and w_d2))

      mut as bool: w_wait = waitGroupWait(wg)
      println("12. WaitGroup Wait completado: " + w_wait)
      waitGroupDestroy(wg)

      #L 4. Aliases
      mut as int64: m2 = mutexCreate()
      mut as bool: l2 = lock(m2)
      mut as bool: u2 = unlock(m2)
      println("13. Aliases lock e unlock: " + (l2 and u2))
      mutexDestroy(m2)

      mut as int64: a2 = atomicCreate(50)
      println("14. Alias atomicLoad (> 0): " + (atomicLoad(a2) > 0))
      mut as bool: s_ok = atomicStore(a2, 100)
      println("15. Alias atomicStore: " + s_ok)
      atomicDestroy(a2)

      mut as int64: wg2 = waitGroupCreate()
      wgAdd(wg2, 1)
      wgDone(wg2)
      println("16. Aliases wgAdd, wgDone, wgWait: " + wgWait(wg2))
      waitGroupDestroy(wg2)
}
