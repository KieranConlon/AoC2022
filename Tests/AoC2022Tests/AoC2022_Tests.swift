import XCTest
@testable import AoC2022

final class AoC2022_Tests: XCTestCase {
  
  let adventName = "AoC2022"
  
  private func printAnswer(day: Int, dayName: String, q1: String = "", a1: String = "", q2: String = "", a2: String = "") {
    print(
    """
    >
      \(adventName) Day-\(day): \(dayName)
      Puzzle-1:
         Q: \(q1)
         A: \(a1)
    
      Puzzle-2:
         Q: \(q2)
         A: \(a2)
    ------
    """)
  }
  
  private static let inputFilesPrefix = "/Users/kieran/codeProjects/AoC2022/Sources/AoC2022/Resources"
  private static let inputFiles: [String: String] = [
    "d1": "\(inputFilesPrefix)/D1/inputD1.txt",
    "d2": "\(inputFilesPrefix)/D2/inputD2.txt",
    "d3": "\(inputFilesPrefix)/D3/inputD3.txt",
    "d4": "\(inputFilesPrefix)/D4/inputD4.txt"
  ]
  
  func testAoC_D1() throws {
    let q1 = "Find the Elf carrying the most Calories.  How many total Calories is that Elf carrying?"
    let q2 = "Find the top three Elves carrying the most Calories.  How many total Calories those elves carrying in total?"
    
    let ans = AoC2022_D1(inputFile: AoC2022_Tests.inputFiles["d1"]!)
    
    let a1 = "The elf carrying the most food calories has: \(ans.puzzle1) calories."
    let a2 = "Three elves carrying the most food calories have: \(ans.puzzle2) calories."
    printAnswer(day: 1, dayName: "Calorie Counting", q1: q1, a1: a1, q2: q2, a2: a2)
  }
  
  func testAoC_D2() throws {
    let q1 = "What would your total score if X=ROCK, Y=PAPER, Z=SCISSORS?"
    let q2 = "What would your total score be if X=LOSE, Y=DRAW, Z=WIN?"
    
    let ans = AoC2022_D2(inputFile: AoC2022_Tests.inputFiles["d2"]!)
    let a1 = "Total score is: \(ans.puzzle1) calories."
    let a2 = "Total score is: \(ans.puzzle2) calories."
    printAnswer(day: 2, dayName: "Rock Paper Scissors", q1: q1, a1: a1, q2: q2, a2: a2)
  }
  
  func testAoC_D3() throws {
    let q1 = "Find the item type that appears in both compartments of each rucksack. What is the sum of the priorities of those item types?"
    let q2 = "Find the item type that corresponds to the badges of each three-Elf group. What is the sum of the priorities of those item types?"
    
    let ans = AoC2022_D3(inputFile: AoC2022_Tests.inputFiles["d3"]!)
    let a1 = "Sum of prorities for the items is: \(ans.puzzle1)"
    let a2 = "\(ans.puzzle2)"
    printAnswer(day: 3, dayName: "Rucksack Reorganisation", q1: q1, a1: a1, q2: q2, a2: a2)
  }
  
  @available(macOS 13.0, *)
  func testAoC_D4() throws {
    let q1 = "In how many assignment pairs does one range fully contain the other?"
    let q2 = "In how many assignment pairs do the ranges overlap?"
    
    let ans = AoC2022_D4(inputFile: AoC2022_Tests.inputFiles["d4"]!)
    let a1 = "\(ans.puzzle1)"
    let a2 = "\(ans.puzzle2)"
    printAnswer(day: 4, dayName: "Camp Cleanup", q1: q1, a1: a1, q2: q2, a2: a2)
  }
}

