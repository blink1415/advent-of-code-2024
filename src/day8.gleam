import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
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

type Pt {
  Pt(x: Int, y: Int)
}

type Grid {
  Grid(points: dict.Dict(String, List(Pt)), dimensions: Pt)
}

type Input =
  Grid

fn insert_append(
  d: dict.Dict(a, List(b)),
  key: a,
  value: b,
) -> dict.Dict(a, List(b)) {
  let l = dict.get(d, key) |> result.unwrap([])
  dict.insert(d, key, [value, ..l])
}

fn parse(input: String) -> Result(Input, String) {
  let grid =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(line) {
      line
      |> string.trim
      |> string.split("")
    })

  let assert Ok(row) = list.first(grid)
  let dimensions = Pt(x: list.length(row), y: list.length(grid))

  Ok(Grid(
    points: {
      use outer_dict, row, y <- list.index_fold(grid, dict.new())
      use inner_dict, char, x <- list.index_fold(row, outer_dict)

      case char {
        "." -> inner_dict
        _ -> insert_append(inner_dict, char, Pt(x: x, y: y))
      }
    },
    dimensions: dimensions,
  ))
}

fn find_antinode(a: Pt, b: Pt) -> #(Pt, Pt) {
  #(add(a, sub(a, b)), add(b, sub(b, a)))
}

fn add(a: Pt, b: Pt) -> Pt {
  Pt(x: a.x + b.x, y: a.y + b.y)
}

fn sub(a: Pt, b: Pt) -> Pt {
  Pt(x: a.x - b.x, y: a.y - b.y)
}

fn solve1(input: Input) -> String {
  input.points
  |> dict.map_values(fn(_, l) {
    let t =
      l
      |> list.combination_pairs
      |> list.map(fn(t) { find_antinode(t.0, t.1) })
      |> list.unzip

    list.flatten([t.0, t.1])
  })
  |> dict.values
  |> list.flatten
  |> list.filter(fn(pt) {
    pt.x >= 0
    && pt.y >= 0
    && pt.x < input.dimensions.x
    && pt.y < input.dimensions.y
  })
  |> list.unique
  |> list.length
  |> int.to_string
}

fn find_antinode2(a: Pt, b: Pt, dimensions: Pt) -> List(Pt) {
  let within = fn(pt: Pt) -> Bool {
    pt.x >= 0 && pt.y >= 0 && pt.x < dimensions.x && pt.y < dimensions.y
  }
  [find_antinode2_loop(a, b, [], within), find_antinode2_loop(b, a, [], within)]
  |> list.flatten
}

fn find_antinode2_loop(
  a: Pt,
  b: Pt,
  acc: List(Pt),
  within: fn(Pt) -> Bool,
) -> List(Pt) {
  let next = add(a, sub(a, b))
  use <- bool.guard(!within(next), acc)
  find_antinode2_loop(next, a, [next, ..acc], within)
}

fn solve2(input: Input) -> String {
  input.points
  |> dict.map_values(fn(_, l) {
    l
    |> list.combination_pairs
    |> list.map(fn(t) { find_antinode2(t.0, t.1, input.dimensions) })
    |> list.flatten
  })
  |> dict.values
  |> list.flatten
  |> io.debug
  |> list.filter(fn(pt) {
    pt.x >= 0
    && pt.y >= 0
    && pt.x < input.dimensions.x
    && pt.y < input.dimensions.y
  })
  |> list.unique
  |> list.length
  |> int.to_string
}
