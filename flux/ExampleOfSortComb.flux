use ListStdLib

function (getNextGap) (as int64: gap) as int64 {
      mut as int64: next_gap = (gap * 10) /i 13
      route {
            next_gap < 1 ==> {
                  mut as int64: one = 1
                  emit(nice, one, "ok")
            }
            _ ==> {
                  emit(nice, next_gap, "ok")
            }
      }
}

function (combSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as int64: gap = n
      mut as bool: swapped = true
      mut as int64: i = 1
      mut as int64: swap = 0
      
      infinite (gap != 1 or swapped) {
            gap = getNextGap(gap)
            swapped = false
            i = 1
            infinite (i <= n - gap) {
                  route {
                        temp[i] > temp[i + gap] ==> {
                              swap = temp[i]
                              temp[i] = temp[i + gap]
                              temp[i + gap] = swap
                              swapped = true
                        }
                  }
                  i = i + 1
            }
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortComb) {
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

      mut as list of int64: sorted = combSort(arr)

      print("")
      print("=== COMB SORT ===")
      print(sorted)
}
