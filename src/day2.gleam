import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/option
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

fn solve1(input: Input) -> String {
  let ascending_filter = fn(n) { n > -4 && n < 0 }
  let descending_filter = fn(n) { n > 0 && n < 4 }
  input
  |> list.map(fn(l) {
    case l {
      [a, b, ..l] ->
        list.zip([a, b, ..l], [b, ..l])
        |> list.map(fn(t) { t.0 - t.1 })
        |> fn(l) {
          list.all(l, ascending_filter) || list.all(l, descending_filter)
        }
      _ -> True
    }
  })
  |> list.filter(function.identity)
  |> list.length
  |> int.to_string
}

fn solve2(_input: Input) -> String {
  "todo"
}
