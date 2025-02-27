import gleam/int
import gleam/list
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

type Calculation {
  Calculation(result: Int, values: List(Int))
}

type Input =
  List(Calculation)

fn parse(input: String) -> Result(Input, String) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(line) {
    case line |> string.trim |> string.split(": ") {
      [res, vals] ->
        Ok(Calculation(
          result: parse_int(res),
          values: vals |> string.split(" ") |> list.map(parse_int),
        ))
      _ -> Error("failed")
    }
  })
  |> result.all
}

fn parse_int(input: String) -> Int {
  let assert Ok(n) = int.parse(input)
  n
}

fn solve1(input: Input) -> String {
  input
  |> list.zip({
    input
    |> list.map(do_solve1(_, 0))
  })
  |> list.filter(fn(t) { t.1 })
  |> list.map(fn(t) { { t.0 }.result })
  |> int.sum
  |> int.to_string
}

fn do_solve1(calc: Calculation, accumulator: Int) -> Bool {
  case calc.values {
    [] -> accumulator == calc.result
    [n, ..ns] ->
      do_solve1(Calculation(..calc, values: ns), n + accumulator)
      || do_solve1(Calculation(..calc, values: ns), n * accumulator)
  }
}

fn solve2(input: Input) -> String {
  input
  |> list.zip({
    input
    |> list.map(do_solve2(_, 0))
  })
  |> list.filter(fn(t) { t.1 })
  |> list.map(fn(t) { { t.0 }.result })
  |> int.sum
  |> int.to_string
}

fn do_solve2(calc: Calculation, accumulator: Int) -> Bool {
  case calc.values {
    [] -> accumulator == calc.result
    [n, ..ns] -> {
      let next = Calculation(..calc, values: ns)

      do_solve1(next, n + accumulator)
      || do_solve1(next, n * accumulator)
      || do_solve1(next, concat(n, accumulator))
    }
  }
}

fn concat(a: Int, b: Int) -> Int {
  let assert Ok(n) = {
    int.parse({ a |> int.to_string } <> { b |> int.to_string })
  }

  n
}
