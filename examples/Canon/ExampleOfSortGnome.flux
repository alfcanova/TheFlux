use ListStdLib

function (gnomeSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as int64: index = 1
      infinite (index <= n) {
            route {
                  index == 1 ==> {
                        index = index + 1
                  }
                  _ ==> {
                        route {
                              temp[index] >= temp[index - 1] ==> {
                                    index = index + 1
                              }
                              _ ==> {
                                    mut as int64: swap = temp[index]
                                    temp[index] = temp[index - 1]
                                    temp[index - 1] = swap
                                    index = index - 1
                              }
                        }
                  }
            }
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortGnome) {
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

      mut as list of int64: sorted = gnomeSort(arr)

      print("")
      print("=== GNOME SORT ===")
      print(sorted)
}
