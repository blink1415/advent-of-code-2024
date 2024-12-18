import gleam/function
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util.{drop_index, with_index}

pub fn solution(input: String, part: String) -> Result(String, String) {
  use parsed <- result.try(parse(input))
  case part {
    "1" -> Ok(solve1(parsed))
    "2" -> Ok(solve2(parsed))
    _ -> Error("invalid part")
  }
}

type Input =
  List(List(Int))

fn parse(input: String) -> Result(Input, String) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.trim
    |> string.split(" ")
    |> list.map(int.parse)
    |> result.all
  })
  |> result.all
  |> result.map_error(fn(_) { "failed to parse input" })
}

fn ascending_filter(n: Int) -> Bool {
  n > -4 && n < 0
}

fn descending_filter(n: Int) -> Bool {
  n > 0 && n < 4
}

fn is_safe(l: List(Int)) -> Bool {
  l
  |> list.window_by_2
  |> list.map(fn(t) { t.0 - t.1 })
  |> fn(l) { list.all(l, ascending_filter) || list.all(l, descending_filter) }
}

fn solve1(input: Input) -> String {
  input
  |> list.map(is_safe)
  |> list.filter(function.identity)
  |> list.length
  |> int.to_string
}

fn solve2(input: Input) -> String {
  input
  |> list.map(is_safe_part2)
  |> list.filter(function.identity)
  |> list.length
  |> int.to_string
}

fn is_safe_part2(original: List(Int)) -> Bool {
  case original {
    [a, b, ..l] -> {
      let diffs =
        list.zip([a, b, ..l], [b, ..l])
        |> list.map(fn(t) { t.0 - t.1 })
        |> with_index
      case
        list.find(diffs, fn(t) { !ascending_filter(t.0) }),
        list.find(diffs, fn(t) { !descending_filter(t.0) })
      {
        Ok(#(_, i)), Ok(#(_, j)) -> {
          let safe_without = fn(index) { is_safe(drop_index(original, index)) }
          safe_without(i)
          || safe_without(i + 1)
          || { i != j && safe_without(j) }
          || { i != j && safe_without(j + 1) }
        }
        _, _ -> True
      }
    }
    _ -> True
  }
}
