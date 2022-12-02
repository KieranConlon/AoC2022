import XCTest
@testable import AoC2022

final class AoC2022_Tests: XCTestCase {

  func testAoC_D1() throws {
    let d1Answer = AoC2022_D1(inputFile: "/Users/kieran/codeProjects/AoC2022/Sources/AoC2022/Resources/D1/inputD1.txt")


    print("""
          ---+++
          AoC2022 Day-1 Part 1:
              Find the Elf carrying the most Calories.
              How many total Calories is that Elf carrying?
                  A: The elf carrying the most food calories has: \(d1Answer.puzzle1) calories.

          AoC2022 Day-1 Part 2:
              Find the top three Elves carrying the most Calories.
              How many total Calories those elves carrying in total?
                  A: Three elves carrying the most food calories have: \(d1Answer.puzzle2) calories.
          ---+++
          """)
  }
  
  func testAoC_D2() throws {
    let d2Answer = AoC2022_D2(inputFile: "/Users/kieran/codeProjects/AoC2022/Sources/AoC2022/Resources/D2/inputD2.txt")

    print("""
          ---+++
          AoC2022 Day-2 Part 1:
              What would your total score if X=ROCK, Y=PAPER, Z=SCISSORS?
                  A: Total score is: \(d2Answer.puzzle1) calories.

          AoC2022 Day-2 Part 2:
              What would your total score be if X=LOSE, Y=DRAW, Z=WIN?
                  A: Total score is: \(d2Answer.puzzle2) calories.
          ---+++
          """)
  }
}

