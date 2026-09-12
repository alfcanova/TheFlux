use ListStdLib

function (oddEvenSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as bool: is_sorted = false
      mut as int64: i = 2
      mut as int64: swap = 0
      mut as int64: j = 1
      mut as int64: swap2 = 0
      
      infinite (not is_sorted) {
            is_sorted = true
            
            i = 2
            infinite (i <= n - 1) {
                  route {
                        temp[i] > temp[i + 1] ==> {
                              swap = temp[i]
                              temp[i] = temp[i + 1]
                              temp[i + 1] = swap
                              is_sorted = false
                        }
                  }
                  i = i + 2
            }
            
            j = 1
            infinite (j <= n - 1) {
                  route {
                        temp[j] > temp[j + 1] ==> {
                              swap2 = temp[j]
                              temp[j] = temp[j + 1]
                              temp[j + 1] = swap2
                              is_sorted = false
                        }
                  }
                  j = j + 2
            }
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortOddEven) {
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

      mut as list of int64: sorted = oddEvenSort(arr)

      print("")
      print("=== ODD EVEN SORT ===")
      print(sorted)
}
