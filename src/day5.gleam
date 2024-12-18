import gleam/bool
import gleam/int
import gleam/list
import gleam/order
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

type Input {
  Input(rules: List(Rule), updates: List(List(Int)))
}

type Rule {
  Rule(before: Int, after: Int)
}

fn parse(input: String) -> Result(Input, String) {
  let assert [rules, updates] =
    input
    |> string.split("\n\n")

  let rules =
    rules
    |> string.split("\n")
    |> list.map(fn(s) {
      let assert [b, a] = string.split(s, "|")
      let assert #(Ok(b), Ok(a)) = #(int.parse(b), int.parse(a))
      Rule(before: b, after: a)
    })

  let assert Ok(updates) =
    updates
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(s) {
      s
      |> string.split(",")
      |> list.map(int.parse)
      |> result.all
    })
    |> result.all

  Ok(Input(rules, updates))
}

fn correctly_order(rules: List(Rule), l: List(Int)) {
  l
  |> list.sort(fn(a, b) {
    list.find_map(rules, fn(rule) {
      use <- bool.guard(rule.before == a && rule.after == b, Ok(order.Lt))
      use <- bool.guard(rule.before == b && rule.after == a, Ok(order.Gt))
      Error(Nil)
    })
    |> result.unwrap(order.Eq)
  })
}

fn middle_value(l: List(a)) -> Result(a, Nil) {
  l
  |> list.drop(list.length(l) / 2)
  |> list.first
}

fn solve1(input: Input) -> String {
  let is_correctly_ordered = fn(l) { l == correctly_order(input.rules, l) }

  input.updates
  |> list.map(fn(l) {
    use <- bool.guard(!is_correctly_ordered(l), 0)
    l
    |> middle_value
    |> result.unwrap(0)
  })
  |> int.sum
  |> int.to_string
}

fn solve2(input: Input) -> String {
  input.updates
  |> list.filter(fn(l) { l != correctly_order(input.rules, l) })
  |> list.map(correctly_order(input.rules, _))
  |> list.map(middle_value)
  |> result.values
  |> int.sum
  |> int.to_string
}
