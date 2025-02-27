import gleam/bool
import gleam/dict
import gleam/function
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util.{to_dict}

pub fn solution(input: String, part: String) -> Result(String, String) {
  use parsed <- result.try(parse(input))
  case part {
    "1" -> Ok(solve1(parsed))
    "2" -> Ok(solve2(parsed))
    _ -> Error("invalid part")
  }
}

fn parse(input: String) -> Result(Input, String) {
  Ok(
    input
    |> string.split("\n")
    |> list.map(string.split(_, "")),
  )
}

type Input =
  List(List(String))

fn solve1(input: Input) -> String {
  let height = list.length(input)
  input
  // Vertical
  |> list.append(
    input
    |> list.transpose,
  )
  // NW->SE diagonal
  |> list.append(
    input
    |> list.zip(list.range(0, list.length(input) - 1))
    |> list.map(fn(l) {
      l.0
      |> list.append(list.repeat(".", l.1))
      |> list.reverse
      |> list.append(list.repeat(".", { height - l.1 - 1 }))
      |> list.reverse
    })
    |> list.transpose,
  )
  // NE->SW diagonal
  |> list.append(
    input
    |> list.zip(list.range(0, list.length(input) - 1))
    |> list.map(fn(l) {
      l.0
      |> list.reverse
      |> list.append(list.repeat(".", l.1))
      |> list.reverse
      |> list.append(list.repeat(".", { height - l.1 - 1 }))
    })
    |> list.transpose,
  )
  |> list.map(list.filter(_, fn(c) { c != "." }))
  |> list.map(fn(l) { count_xmas(l) + count_xmas(list.reverse(l)) })
  |> int.sum
  |> int.to_string
}

fn count_xmas(l: List(String)) -> Int {
  case l {
    ["X", "M", "A", "S", ..xs] -> 1 + count_xmas(xs)
    [_, ..xs] -> count_xmas(xs)
    _ -> 0
  }
}

fn shift(pos: #(Int, Int), dir: #(Int, Int)) -> #(Int, Int) {
  #(pos.0 + dir.0, pos.1 + dir.1)
}

fn solve2(input: Input) -> String {
  let grid_dict = to_dict(input)

  let directions = [[#(-1, -1), #(1, 1), #(1, -1), #(-1, 1)]]

  {
    use c, k, v <- dict.fold(grid_dict, 0)
    // Only "A"s can be the center of an X-MAS
    use <- bool.guard(v != "A", c)

    c
    + {
      directions
      |> list.map(fn(dirs) {
        case
          dirs
          |> list.map(fn(dir) {
            dir
            |> shift(k, _)
            |> dict.get(grid_dict, _)
          })
          |> result.values
        {
          ["S", "M", "S", "M"]
          | ["S", "M", "M", "S"]
          | ["M", "S", "S", "M"]
          | ["M", "S", "M", "S"] -> True
          _ -> False
        }
      })
      |> list.count(function.identity)
    }
  }
  |> int.to_string
}
