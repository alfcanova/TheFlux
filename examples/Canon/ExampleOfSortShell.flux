use ListStdLib

function (shellSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as int64: gap = n /i 2
      mut as int64: i = 1
      mut as int64: key_val = 0
      mut as int64: j = 0
      mut as bool: running = true
      
      infinite (gap > 0) {
            i = gap + 1
            infinite (i <= n) {
                  key_val = temp[i]
                  j = i
                  running = true
                  infinite (running) {
                        route {
                              j > gap ==> {
                                    route {
                                          temp[j - gap] > key_val ==> {
                                                temp[j] = temp[j - gap]
                                                j = j - gap
                                          }
                                          _ ==> {
                                                running = false
                                          }
                                    }
                              }
                              _ ==> {
                                    running = false
                              }
                        }
                  }
                  temp[j] = key_val
                  i = i + 1
            }
            gap = gap /i 2
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortShell) {
      mut as list of int64: arr = []
      mut as int64: i = 1
      mut as int64: seed = 12345
      mut as int64: a = 1664525
      mut as int64: c = 1013904223
      mut as int64: m = 2147483647
      mut as int64: val = 0

      infinite (i <= 10) {
            seed = (a * seed + c) /r m
            route {
                  seed < 0 ==> {
                        seed = seed * -1
                  }
            }
            val = seed /r 1000
            arr = listPushBack(arr, val)
            i = i + 1
      }

      print("=== DADOS ORIGINAIS ===")
      print(arr)

      mut as list of int64: sorted = shellSort(arr)

      print("")
      print("=== SHELL SORT ===")
      print(sorted)
}
