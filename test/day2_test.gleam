import day2
import gleeunit/should

const input = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

// 1 is added to beginning of the first line to have
// a test case for an unsafe report where the first number is
// removable.
const input2 = "1 7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

pub fn part1_test() {
  should.equal(day2.solution(input, "1"), Ok("2"))
}

pub fn part2_test() {
  should.equal(day2.solution(input2, "2"), Ok("4"))
}
