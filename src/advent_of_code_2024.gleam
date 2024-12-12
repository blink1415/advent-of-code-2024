import argv
import day1
import day2
import gleam/io
import glint
import simplifile

pub fn main() {
  glint.new()
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: run())
  |> glint.run(argv.load().arguments)
}

fn run() -> glint.Command(Nil) {
  use <- glint.command_help("Prints Hello, <NAME>!")
  use _, args, _ <- glint.command()

  case run_day(args) {
    Ok(s) -> io.println(s)
    Error(e) -> io.println_error(e)
  }
}

fn run_day(args: List(String)) -> Result(String, String) {
  case args {
    [] -> Error("No args")
    [_] -> Error("Missing part arg")
    [day, part, ..] -> {
      let input = case simplifile.read("data/" <> day <> ".txt") {
        Ok(s) -> s
        Error(_) -> ""
      }
      case day {
        "1" -> Ok(day1.solution(input, part))
        "2" -> Ok(day2.solution(input, part))
        s -> Error("No handler defined for " <> s)
      }
    }
  }
}
