import day7
import gleeunit/should

const input = "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"

pub fn day7_part1_test() {
  let want = Ok("3749")

  let got = day7.solution(input, "1")

  should.equal(got, want)
}

pub fn day7_part2_test() {
  let want = Ok("11387")

  let got = day7.solution(input, "2")

  should.equal(got, want)
}
