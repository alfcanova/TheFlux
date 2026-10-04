use ListStdLib

function (bubbleSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as int64: i = 1
      mut as int64: j = 1
      mut as int64: swap = 0
      infinite (i <= n - 1) {
            j = 1
            infinite (j <= n - i) {
                  route {
                        temp[j] > temp[j + 1] ==> {
                              swap = temp[j]
                              temp[j] = temp[j + 1]
                              temp[j + 1] = swap
                        }
                  }
                  j = j + 1
            }
            i = i + 1
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortBubble) {
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

      mut as list of int64: sorted = bubbleSort(arr)

      print("")
      print("=== BUBBLE SORT ===")
      print(sorted)
}
