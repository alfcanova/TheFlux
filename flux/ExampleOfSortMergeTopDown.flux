use ListStdLib

function (mergeLists) (as list of int64: left, as list of int64: right) as list of int64 {
      mut as list of int64: result = []
      mut as int64: i = 1
      mut as int64: j = 1
      mut as int64: len_left = listLength(left)
      mut as int64: len_right = listLength(right)
      mut as int64: val_left = 0
      mut as int64: val_right = 0
      
      infinite (i <= len_left and j <= len_right) {
            val_left = left[i]
            val_right = right[j]
            route {
                  val_left < val_right ==> {
                        result = listPushBack(result, val_left)
                        i = i + 1
                  }
                  _ ==> {
                        result = listPushBack(result, val_right)
                        j = j + 1
                  }
            }
      }
      
      infinite (i <= len_left) {
            result = listPushBack(result, left[i])
            i = i + 1
      }
      
      infinite (j <= len_right) {
            result = listPushBack(result, right[j])
            j = j + 1
      }
      
      emit(nice, result, "ok")
}

function (mergeSortTopDown) (as list of int64: arr) as list of int64 {
      mut as int64: n = listLength(arr)
      route {
            n <= 1 ==> {
                  emit(nice, arr, "ok")
            }
            _ ==> {
                  mut as int64: mid = n /i 2
                  mut as list of int64: left = listSlice(arr, 1, mid)
                  mut as list of int64: right = listSlice(arr, mid + 1, n)
                  
                  left = mergeSortTopDown(left)
                  right = mergeSortTopDown(right)
                  
                  mut as list of int64: result = mergeLists(left, right)
                  emit(nice, result, "ok")
            }
      }
}

program (ExampleOfSortMergeTopDown) {
      mut as list of int64: arr = []
      mut as int64: i = 1
      mut as int64: seed = 12345
      mut as int64: a = 1664525
      mut as int64: c = 1013904223
      mut as int64: m = 2147483647
      mut as int64: val = 0

      infinite (i <= 6) {
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

      mut as list of int64: sorted = mergeSortTopDown(arr)

      print("")
      print("=== MERGE SORT (TOP-DOWN) ===")
      print(sorted)
}
