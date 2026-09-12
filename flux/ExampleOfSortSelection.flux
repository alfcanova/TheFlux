use ListStdLib

function (selectionSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as int64: i = 1
      mut as int64: min_idx = 1
      mut as int64: j = 1
      mut as int64: swap = 0
      infinite (i <= n - 1) {
            min_idx = i
            j = i + 1
            infinite (j <= n) {
                  route {
                        temp[j] < temp[min_idx] ==> {
                              min_idx = j
                        }
                  }
                  j = j + 1
            }
            route {
                  min_idx != i ==> {
                        swap = temp[i]
                        temp[i] = temp[min_idx]
                        temp[min_idx] = swap
                  }
            }
            i = i + 1
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortSelection) {
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

      mut as list of int64: sorted = selectionSort(arr)

      print("")
      print("=== SELECTION SORT ===")
      print(sorted)
}
