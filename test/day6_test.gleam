import day6
import gleeunit/should

const input = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."

pub fn day6_part1_test() {
  let want = Ok("41")

  let got = day6.solution(input, "1")

  should.equal(got, want)
}

pub fn day6_part2_test() {
  let want = Ok("6")

  let got = day6.solution(input, "2")

  should.equal(got, want)
}
