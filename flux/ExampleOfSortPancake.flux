use ListStdLib

function (flip) (as list of int64: arr, as int64: i) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: start_idx = 1
      mut as int64: end_idx = i
      mut as int64: swap = 0
      infinite (start_idx < end_idx) {
            swap = temp[start_idx]
            temp[start_idx] = temp[end_idx]
            temp[end_idx] = swap
            start_idx = start_idx + 1
            end_idx = end_idx - 1
      }
      emit(nice, temp, "ok")
}

function (findMaxIndex) (as list of int64: arr, as int64: n) as int64 {
      mut as list of int64: temp = arr
      mut as int64: mi = 1
      mut as int64: i = 1
      infinite (i <= n) {
            route {
                  temp[i] > temp[mi] ==> {
                        mi = i
                  }
            }
            i = i + 1
      }
      emit(nice, mi, "ok")
}

function (pancakeSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as int64: curr_size = n
      mut as int64: mi = 0
      infinite (curr_size > 1) {
            mi = findMaxIndex(temp, curr_size)
            route {
                  mi != curr_size ==> {
                        route {
                              mi != 1 ==> {
                                    temp = flip(temp, mi)
                              }
                        }
                        temp = flip(temp, curr_size)
                  }
            }
            curr_size = curr_size - 1
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortPancake) {
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

      print("=== DADOS ORIGINAIS (Somente 10 itens para Pancake Sort) ===")
      print(arr)

      mut as list of int64: sorted = pancakeSort(arr)

      print("")
      print("=== PANCAKE SORT ===")
      print(sorted)
}
