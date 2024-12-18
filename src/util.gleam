import gleam/dict
import gleam/list
import gleam/pair

pub fn to_dict(l: List(List(a))) -> dict.Dict(#(Int, Int), a) {
  use d, l, y <- list.index_fold(l, dict.new())
  use d2, s, x <- list.index_fold(l, d)
  dict.insert(d2, #(x, y), s)
}

pub fn with_index(l: List(a)) -> List(#(a, Int)) {
  l
  |> list.zip(list.range(0, list.length(l) - 1))
}

pub fn drop_index(l: List(a), i: Int) -> List(a) {
  l
  |> with_index
  |> list.filter(fn(t) { t.1 != i })
  |> list.map(pair.first)
}
