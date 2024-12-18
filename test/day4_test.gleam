import day4
import gleeunit/should

const input = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

pub fn day4_part1_test() {
  let want = Ok("18")

  let got = day4.solution(input, "1")

  should.equal(got, want)
}

pub fn day4_part2_test() {
  let want = Ok("9")

  let got = day4.solution(input, "2")

  should.equal(got, want)
}
