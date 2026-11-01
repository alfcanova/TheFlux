use ListStdLib

function (stoogeSortImpl) (as list of int64: arr, as int64: l, as int64: h) as list of int64 {
      mut as list of int64: temp = arr
      route {
            temp[l] > temp[h] ==> {
                  mut as int64: swap = temp[l]
                  temp[l] = temp[h]
                  temp[h] = swap
            }
      }
      
      route {
            h - l + 1 > 2 ==> {
                  mut as int64: t = (h - l + 1) /i 3
                  temp = stoogeSortImpl(temp, l, h - t)
                  temp = stoogeSortImpl(temp, l + t, h)
                  temp = stoogeSortImpl(temp, l, h - t)
            }
      }
      emit(nice, temp, "ok")
}

function (stoogeSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      temp = stoogeSortImpl(temp, 1, n)
      emit(nice, temp, "ok")
}

program (ExampleOfSortStooge) {
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

      print("=== DADOS ORIGINAIS (Somente 10 itens para Stooge Sort) ===")
      print(arr)

      mut as list of int64: sorted = stoogeSort(arr)

      print("")
      print("=== STOOGE SORT ===")
      print(sorted)
}
