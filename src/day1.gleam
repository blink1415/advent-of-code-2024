import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn solution(input: String, part: String) -> String {
  case parse(input) {
    Ok(parsed) ->
      case part {
        "1" -> solve1(parsed)
        "2" -> solve2(parsed)
        _ -> "invalid part"
      }
    Error(e) -> e
  }
}

fn parse(input: String) -> Result(#(List(Int), List(Int)), String) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(s) {
    case string.split(s, "   ") {
      [a, b] ->
        case int.parse(a), int.parse(b) {
          Ok(n1), Ok(n2) -> Ok(#(n1, n2))
          _, _ -> Error("failed parsing ints " <> a <> " " <> "b")
        }
      _ -> Error("more than two values per line: " <> s)
    }
  })
  |> result.all
  |> result.map(list.unzip)
}

fn solve1(input: #(List(Int), List(Int))) -> String {
  let l1 = list.sort(input.0, int.compare)
  let l2 = list.sort(input.1, int.compare)

  list.zip(l1, l2)
  |> list.map(fn(t) { int.absolute_value(t.0 - t.1) })
  |> int.sum
  |> int.to_string
}

fn solve2(input: #(List(Int), List(Int))) -> String {
  input.0
  |> list.map(fn(x) { x * list.count(input.1, fn(y) { y == x }) })
  |> int.sum
  |> int.to_string
}
