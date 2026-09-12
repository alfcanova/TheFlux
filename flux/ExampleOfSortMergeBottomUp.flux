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

function (mergeSortBottomUp) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as int64: width = 1
      mut as int64: i = 1

      infinite (width < n) {
            i = 1
            infinite (i <= n) {
                  mut as int64: mid = i + width - 1
                  route {
                        mid < n ==> {
                              mut as int64: r = i + 2 * width - 1
                              route {
                                    r > n ==> {
                                          r = n
                                    }
                              }
                              mut as list of int64: left = listSlice(temp, i, mid)
                              mut as list of int64: right = listSlice(temp, mid + 1, r)
                              mut as list of int64: result = mergeLists(left, right)
                              
                              mut as int64: m = 1
                              infinite (m <= listLength(result)) {
                                    temp[i + m - 1] = result[m]
                                    m = m + 1
                              }
                        }
                  }
                  i = i + 2 * width
            }
            width = width * 2
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortMergeBottomUp) {
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

      mut as list of int64: sorted = mergeSortBottomUp(arr)

      print("")
      print("=== MERGE SORT (BOTTOM-UP) ===")
      print(sorted)
}
