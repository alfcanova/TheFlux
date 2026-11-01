use ListStdLib

function (insertionSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as int64: i = 2
      mut as int64: key = 0
      mut as int64: j = 0
      mut as bool: running = true
      infinite (i <= n) {
            key = temp[i]
            j = i - 1
            running = true
            infinite (running) {
                  route {
                        j >= 1 ==> {
                              route {
                                    temp[j] > key ==> {
                                          temp[j + 1] = temp[j]
                                          j = j - 1
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
            temp[j + 1] = key
            i = i + 1
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortInsertion) {
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

      mut as list of int64: sorted = insertionSort(arr)

      print("")
      print("=== INSERTION SORT ===")
      print(sorted)
}
