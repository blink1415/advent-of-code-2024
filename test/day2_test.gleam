import day2
import gleeunit/should

const input = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

pub fn day2_part1_test() {
  let want = "2"

  let got = day2.solution(input, "1")

  should.equal(want, got)
}

pub fn day2_part2_test() {
  let want = "todo"

  let got = day2.solution(input, "2")

  should.equal(want, got)
}
