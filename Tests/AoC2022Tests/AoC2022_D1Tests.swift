import XCTest
@testable import AoC2022

final class AoC2022_D1Tests: XCTestCase {

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
}

