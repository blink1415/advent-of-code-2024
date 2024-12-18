import day3
import gleam/option
import gleeunit/should

const input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

const input2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

pub fn day2_part1_test() {
  let want = Ok("161")

  let got = day3.solution(input, "1")

  should.equal(got, want)
}

pub fn parse_leading_int_test() {
  should.equal(
    day3.parse_leading_int(["1", "2", "3", "a", "b"], ""),
    #(option.Some(123), ["a", "b"]),
  )

  should.equal(day3.parse_leading_int(["1"], ""), #(option.Some(1), []))

  should.equal(
    day3.parse_leading_int(["a", "1", "2", "3", "a", "b"], ""),
    #(option.None, ["a", "1", "2", "3", "a", "b"]),
  )
}

pub fn day2_part2_test() {
  let want = Ok("48")

  let got = day3.solution(input2, "2")

  should.equal(want, got)
}
