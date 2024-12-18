import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub fn solution(input: String, part: String) -> Result(String, String) {
  use parsed <- result.try(parse(input))
  case part {
    "1" -> Ok(solve1(parsed))
    "2" -> Ok(solve2(parsed))
    _ -> Error("invalid part")
  }
}

type Input =
  String

fn parse(input: String) -> Result(Input, String) {
  Ok(input)
}

type Token {
  Mul
  OpenParenthesis
  CloseParenthesis
  Comma
  Number(Int)
  Invalid
  Do
  Dont
}

fn tail(l: List(a)) -> List(a) {
  case list.rest(l) {
    Ok(r) -> r
    Error(_) -> []
  }
}

fn to_tokens(l: List(String)) -> List(Token) {
  case l {
    [] -> []
    ["m", "u", "l", ..xs] -> [Mul, ..to_tokens(xs)]
    ["(", ..xs] -> [OpenParenthesis, ..to_tokens(xs)]
    [")", ..xs] -> [CloseParenthesis, ..to_tokens(xs)]
    [",", ..xs] -> [Comma, ..to_tokens(xs)]
    ["d", "o", "(", ")", ..xs] -> [Do, ..to_tokens(xs)]
    ["d", "o", "n", "'", "t", "(", ")", ..xs] -> [Dont, ..to_tokens(xs)]
    _ ->
      case parse_leading_int(l, "") {
        #(Some(x), xs) -> [Number(x), ..to_tokens(xs)]
        #(None, _) -> [Invalid, ..to_tokens(tail(l))]
      }
  }
}

// parses one char at a time from the head of l until they no longer compose a valid whole number
pub fn parse_leading_int(
  l: List(String),
  accumulated: String,
) -> #(Option(Int), List(String)) {
  case l {
    [x, ..xs] ->
      case int.parse(x) {
        Ok(_) -> parse_leading_int(xs, accumulated <> x)
        Error(_) ->
          case int.parse(accumulated) {
            Ok(n) -> #(Some(n), l)
            Error(_) -> #(None, l)
          }
      }
    [] ->
      case int.parse(accumulated) {
        Ok(n) -> #(Some(n), l)
        Error(_) -> #(None, l)
      }
  }
}

fn solve1(input: Input) -> String {
  input
  |> string.split("")
  |> to_tokens
  |> run1(0)
  |> int.to_string
}

fn run1(l: List(Token), accumulated: Int) -> Int {
  case l {
    [] -> accumulated
    [
      Mul,
      OpenParenthesis,
      Number(n1),
      Comma,
      Number(n2),
      CloseParenthesis,
      ..xs
    ] -> run1(xs, accumulated + { n1 * n2 })
    [_, ..xs] -> run1(xs, accumulated)
  }
}

fn solve2(input: Input) -> String {
  input
  |> string.split("")
  |> to_tokens
  |> run2(0, True)
  |> int.to_string
}

fn run2(l: List(Token), accumulated: Int, do: Bool) -> Int {
  case l {
    [] -> accumulated
    [
      Mul,
      OpenParenthesis,
      Number(n1),
      Comma,
      Number(n2),
      CloseParenthesis,
      ..xs
    ] ->
      run2(
        xs,
        accumulated
          + {
          case do {
            True -> n1 * n2
            False -> 0
          }
        },
        do,
      )

    [Do, ..xs] -> run2(xs, accumulated, True)
    [Dont, ..xs] -> run2(xs, accumulated, False)
    [_, ..xs] -> run2(xs, accumulated, do)
  }
}
