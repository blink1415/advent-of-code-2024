import argv
import day1
import day2
import day3
import day4
import day5
import day6
import day7
import day8
import gleam/io
import gleam/result
import glint
import simplifile

pub fn main() {
  glint.new()
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: run())
  |> glint.run(argv.load().arguments)
}

fn run() -> glint.Command(Nil) {
  use <- glint.command_help("gleam run -- <day (1..25)> <part (1..2)>")
  use _, args, _ <- glint.command()

  let res = {
    use #(day, part) <- result.try(case args {
      [] -> Error("No args")
      [_] -> Error("Missing part arg")
      [day, part, ..] -> Ok(#(day, part))
    })

    use input <- result.try(
      result.map_error(simplifile.read("data/" <> day <> ".txt"), fn(_) {
        "error reading file: " <> day
      }),
    )

    case day {
      "1" -> day1.solution(input, part)
      "2" -> day2.solution(input, part)
      "3" -> day3.solution(input, part)
      "4" -> day4.solution(input, part)
      "5" -> day5.solution(input, part)
      "6" -> day6.solution(input, part)
      "7" -> day7.solution(input, part)
      "8" -> day8.solution(input, part)
      d -> Error("invalid day: " <> d)
    }
  }

  case res {
    Ok(s) -> io.println(s)
    Error(e) -> io.println_error(e)
  }
}
