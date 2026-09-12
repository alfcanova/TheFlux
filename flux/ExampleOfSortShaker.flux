use ListStdLib

function (shakerSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as bool: swapped = true
      mut as int64: start_idx = 1
      mut as int64: end_idx = n - 1
      mut as int64: i = 1
      mut as int64: swap = 0
      mut as int64: j = 1
      mut as int64: swap2 = 0
      
      infinite (swapped) {
            swapped = false
            i = start_idx
            infinite (i <= end_idx) {
                  route {
                        temp[i] > temp[i + 1] ==> {
                              swap = temp[i]
                              temp[i] = temp[i + 1]
                              temp[i + 1] = swap
                              swapped = true
                        }
                  }
                  i = i + 1
            }
            
            route {
                  not swapped ==> {
                        break
                  }
            }
            
            swapped = false
            end_idx = end_idx - 1
            j = end_idx
            infinite (j >= start_idx) {
                  route {
                        temp[j] > temp[j + 1] ==> {
                              swap2 = temp[j]
                              temp[j] = temp[j + 1]
                              temp[j + 1] = swap2
                              swapped = true
                        }
                  }
                  j = j - 1
            }
            start_idx = start_idx + 1
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortShaker) {
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

      mut as list of int64: sorted = shakerSort(arr)

      print("")
      print("=== SHAKER SORT ===")
      print(sorted)
}
