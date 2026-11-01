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

program (ExampleOfSortMerge) {
      mut as list of int64: valores = [38, 27, 43, 3, 9, 82]
      mut as int64: indice = 1

      mut as list of int64: valores_bu = mergeSortBottomUp(valores)

      print("=== MERGE SORT (BOTTOM-UP) ===")

      print("Valores ordenados")
      indice = 1
      infinite (indice <= 6) {
            print("Item: " + valores_bu[indice])
            indice =+ 1
      }

      mut as list of int64: valores_td = mergeSortTopDown(valores)

      print("")
      print("=== MERGE SORT (TOP-DOWN) ===")

      print("Valores ordenados")
      indice = 1
      infinite (indice <= 6) {
            print("Item: " + valores_td[indice])
            indice =+ 1
      }
}
