use ListStdLib

function (quickSort) (as list of int64: arr) as list of int64 {
      mut as int64: n = listLength(arr)
      route {
            n <= 1 ==> {
                  emit(nice, arr, "ok")
            }
            _ ==> {
                  mut as int64: pivot_idx = (n /i 2) + 1
                  mut as int64: pivot = arr[pivot_idx]
                  mut as list of int64: left = []
                  mut as list of int64: middle = []
                  mut as list of int64: right = []
                  
                  mut as int64: i = 1
                  mut as int64: val = 0
                  infinite (i <= n) {
                        val = arr[i]
                        route {
                              val < pivot ==> {
                                    left = listPushBack(left, val)
                              }
                              val == pivot ==> {
                                    middle = listPushBack(middle, val)
                              }
                              _ ==> {
                                    right = listPushBack(right, val)
                              }
                        }
                        i = i + 1
                  }
                  
                  mut as list of int64: sorted_left = quickSort(left)
                  mut as list of int64: sorted_right = quickSort(right)
                  
                  mut as list of int64: result = []
                  mut as int64: j = 1
                  mut as int64: len_left = listLength(sorted_left)
                  infinite (j <= len_left) {
                        result = listPushBack(result, sorted_left[j])
                        j = j + 1
                  }
                  
                  j = 1
                  mut as int64: len_middle = listLength(middle)
                  infinite (j <= len_middle) {
                        result = listPushBack(result, middle[j])
                        j = j + 1
                  }
                  
                  j = 1
                  mut as int64: len_right = listLength(sorted_right)
                  infinite (j <= len_right) {
                        result = listPushBack(result, sorted_right[j])
                        j = j + 1
                  }
                  
                  emit(nice, result, "ok")
            }
      }
}

program (ExampleOfSortQuick) {
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

      mut as list of int64: sorted = quickSort(arr)

      print("")
      print("=== QUICK SORT ===")
      print(sorted)
}
