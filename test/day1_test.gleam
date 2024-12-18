import day1
import gleeunit/should

const input = "3   4
4   3
2   5
1   3
3   9
3   3"

pub fn day1_part1_test() {
  let want = Ok("11")

  let got = day1.solution(input, "1")

  should.equal(want, got)
}

pub fn day1_part2_test() {
  let want = Ok("31")

  let got = day1.solution(input, "2")

  should.equal(want, got)
}
