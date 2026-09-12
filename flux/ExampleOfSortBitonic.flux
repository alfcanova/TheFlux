use ListStdLib

function (compAndSwap) (as list of int64: arr, as int64: i, as int64: j, as int64: dir) as list of int64 {
      mut as list of int64: temp = arr
      route {
            dir == 1 ==> {
                  route {
                        temp[i] > temp[j] ==> {
                              mut as int64: swap = temp[i]
                              temp[i] = temp[j]
                              temp[j] = swap
                        }
                  }
            }
            _ ==> {
                  route {
                        temp[i] < temp[j] ==> {
                              mut as int64: swap2 = temp[i]
                              temp[i] = temp[j]
                              temp[j] = swap2
                        }
                  }
            }
      }
      emit(nice, temp, "ok")
}

function (bitonicMerge) (as list of int64: arr, as int64: low, as int64: cnt, as int64: dir) as list of int64 {
      mut as list of int64: temp = arr
      route {
            cnt > 1 ==> {
                  mut as int64: k = cnt /i 2
                  mut as int64: i = low
                  infinite (i < low + k) {
                        temp = compAndSwap(temp, i, i + k, dir)
                        i = i + 1
                  }
                  temp = bitonicMerge(temp, low, k, dir)
                  temp = bitonicMerge(temp, low + k, k, dir)
            }
      }
      emit(nice, temp, "ok")
}

function (bitonicSortImpl) (as list of int64: arr, as int64: low, as int64: cnt, as int64: dir) as list of int64 {
      mut as list of int64: temp = arr
      route {
            cnt > 1 ==> {
                  mut as int64: k = cnt /i 2
                  temp = bitonicSortImpl(temp, low, k, 1)
                  temp = bitonicSortImpl(temp, low + k, k, 0)
                  temp = bitonicMerge(temp, low, cnt, dir)
            }
      }
      emit(nice, temp, "ok")
}

function (bitonicSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      temp = bitonicSortImpl(temp, 1, n, 1)
      emit(nice, temp, "ok")
}

program (ExampleOfSortBitonic) {
      mut as list of int64: arr = []
      mut as int64: i = 1
      mut as int64: seed = 12345
      mut as int64: a = 1664525
      mut as int64: c = 1013904223
      mut as int64: m = 2147483647
      mut as int64: val = 0

      infinite (i <= 8) {
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

      mut as list of int64: sorted = bitonicSort(arr)

      print("")
      print("=== BITONIC SORT ===")
      print(sorted)
}
