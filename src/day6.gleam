import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
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

fn add(a: Pt, b: Pt) -> Pt {
  Pt(x: a.x + b.x, y: a.y + b.y)
}

type State {
  State(
    visited: dict.Dict(#(Pt, Direction), Nil),
    guard: Guard,
    obstacles: dict.Dict(Pt, Nil),
    dimensions: Pt,
    loop_positions: Int,
  )
}

type Guard {
  Guard(pos: Pt, facing: Direction)
}

type Direction {
  Up
  Down
  Left
  Right
}

fn from_string(s: String) -> Result(Direction, Nil) {
  case s {
    "^" -> Ok(Up)
    "v" -> Ok(Down)
    "<" -> Ok(Left)
    ">" -> Ok(Right)
    _ -> Error(Nil)
  }
}

fn turn_90degrees(dir: Direction) -> Direction {
  case dir {
    Up -> Right
    Right -> Down
    Down -> Left
    Left -> Up
  }
}

fn to_vec(dir: Direction) -> Pt {
  case dir {
    Up -> Pt(x: 0, y: -1)
    Right -> Pt(x: 1, y: 0)
    Down -> Pt(x: 0, y: 1)
    Left -> Pt(x: -1, y: 0)
  }
}

fn parse(input: String) -> Result(State, String) {
  let grid =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(string.split(_, ""))

  let assert [first, ..] = grid

  let initial_state =
    State(
      visited: dict.new(),
      guard: Guard(Pt(0, 0), facing: Up),
      obstacles: dict.new(),
      dimensions: Pt(x: grid |> list.length, y: first |> list.length),
      loop_positions: 0,
    )

  Ok({
    use outer_state, l, y <- list.index_fold(grid, initial_state)
    use state, char, x <- list.index_fold(l, outer_state)

    use <- bool.guard(char == ".", state)
    use <- bool.guard(
      char == "#",
      State(..state, obstacles: dict.insert(state.obstacles, Pt(x, y), Nil)),
    )

    let assert Ok(dir) = from_string(char)

    let pos = Pt(x: x, y: y)
    State(
      ..state,
      visited: dict.insert(state.visited, #(pos, dir), Nil),
      guard: Guard(pos: pos, facing: dir),
    )
  })
}

fn solve1(input: State) -> String {
  let final_state = step(input)

  final_state.visited
  |> dict.keys
  |> list.map(pair.first)
  |> list.unique
  |> list.length
  |> int.to_string
}

fn step(state: State) -> State {
  use <- bool.guard(state.guard.pos.x < 0, state)
  use <- bool.guard(state.guard.pos.y < 0, state)
  use <- bool.guard(state.guard.pos.x >= state.dimensions.x, state)
  use <- bool.guard(state.guard.pos.y >= state.dimensions.y, state)

  step(
    State(
      ..state,
      visited: dict.insert(
        state.visited,
        #(state.guard.pos, state.guard.facing),
        Nil,
      ),
      guard: {
        let new_pos = add(state.guard.pos, to_vec(state.guard.facing))
        case dict.get(state.obstacles, new_pos) {
          Ok(_) ->
            Guard(..state.guard, facing: turn_90degrees(state.guard.facing))
          Error(_) -> Guard(..state.guard, pos: new_pos)
        }
      },
    ),
  )
}

fn solve2(input: State) -> String {
  let final_state = step2(input)

  final_state.loop_positions
  |> int.to_string
}

fn step2(state: State) -> State {
  use <- bool.guard(state.guard.pos.x < 0, state)
  use <- bool.guard(state.guard.pos.y < 0, state)
  use <- bool.guard(state.guard.pos.x >= state.dimensions.x, state)
  use <- bool.guard(state.guard.pos.y >= state.dimensions.y, state)

  let next_visited =
    dict.insert(state.visited, #(state.guard.pos, state.guard.facing), Nil)

  let next_guard = {
    let new_pos = add(state.guard.pos, to_vec(state.guard.facing))
    case dict.get(state.obstacles, new_pos) {
      Ok(_) -> Guard(..state.guard, facing: turn_90degrees(state.guard.facing))
      Error(_) -> Guard(..state.guard, pos: new_pos)
    }
  }

  let can_loop = {
    state.guard.pos != next_guard.pos
    && result.is_ok(
      dict.get(next_visited, #(
        state.guard.pos,
        turn_90degrees(state.guard.facing),
      )),
    )
  }

  let next_loop_positions = case can_loop {
    True -> {
      // io.debug(#(state.guard))
      state.loop_positions + 1
    }
    False -> state.loop_positions
  }

  step2(
    State(
      ..state,
      visited: next_visited,
      guard: next_guard,
      loop_positions: next_loop_positions,
    ),
  )
}
