use ListStdLib

function (isSortedFunc) (as list of int64: arr, as int64: n) as bool {
      mut as list of int64: temp = arr
      mut as int64: i = 1
      mut as bool: is_sorted = true
      infinite (i <= n - 1) {
            route {
                  temp[i] > temp[i + 1] ==> {
                        is_sorted = false
                  }
            }
            i = i + 1
      }
      emit(nice, is_sorted, "ok")
}

function (shuffleArray) (as list of int64: arr, as int64: n, as int64: attempt) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: seed = 98765 + attempt * 1103515245
      mut as int64: a = 1664525
      mut as int64: c = 1013904223
      mut as int64: m = 2147483647
      mut as int64: rand_idx = 0
      mut as int64: swap = 0
      
      mut as int64: i = 1
      infinite (i <= n) {
            seed = (a * seed + c) /r m
            route {
                  seed < 0 ==> {
                        seed = seed * -1
                  }
            }
            rand_idx = (seed /r n) + 1
            route {
                  rand_idx > n ==> {
                        rand_idx = n
                  }
            }
            swap = temp[i]
            temp[i] = temp[rand_idx]
            temp[rand_idx] = swap
            i = i + 1
      }
      emit(nice, temp, "ok")
}

function (bogoSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as bool: is_sorted = false
      mut as int64: attempts = 0
      mut as int64: max_attempts = 20
      infinite (not is_sorted and attempts < max_attempts) {
            is_sorted = isSortedFunc(temp, n)
            route {
                  not is_sorted ==> {
                        attempts = attempts + 1
                        temp = shuffleArray(temp, n, attempts)
                  }
            }
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortBogo) {
      mut as list of int64: arr = []
      mut as int64: i = 1
      mut as int64: seed = 12345
      mut as int64: a = 1664525
      mut as int64: c = 1013904223
      mut as int64: m = 2147483647
      mut as int64: val = 0

      infinite (i <= 2) {
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

      print("=== DADOS ORIGINAIS (Somente 2 itens para Bogo Sort) ===")
      print(arr)

      mut as list of int64: sorted = bogoSort(arr)

      print("")
      print("=== BOGO SORT ===")
      print(sorted)
}
