import day5
import gleeunit/should

const input = "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"

pub fn day5_part1_test() {
  let want = Ok("143")

  let got = day5.solution(input, "1")

  should.equal(got, want)
}

pub fn day5_part2_test() {
  let want = Ok("123")

  let got = day5.solution(input, "2")

  should.equal(got, want)
}
