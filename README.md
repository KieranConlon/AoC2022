# AoC2022

My code solutions for [Advent of Code 2022](https://adventofcode.com/)

---
- [AoC2022](#aoc2022)
  - [DAY-1: Calorie Counting](#day-1-calorie-counting)
    - [Puzzle-1: Elf with most food calories.](#puzzle-1-elf-with-most-food-calories)
    - [Puzzle-2: Three Elves with most food calories.](#puzzle-2-three-elves-with-most-food-calories)
  - [DAY-2: Rock Paper Scissors](#day-2-rock-paper-scissors)
    - [Puzzle-1: Calculate your ROCK-PAPER-SCISSORS (RPS) score assuming the code file provided contains your opponents shape and your shape for each game in the contest.](#puzzle-1-calculate-your-rock-paper-scissors-rps-score-assuming-the-code-file-provided-contains-your-opponents-shape-and-your-shape-for-each-game-in-the-contest)
    - [Puzzle-2: Calculate your RPS score assuming the code file provided contains your opponents shape and the required outcome for each game in the contest.](#puzzle-2-calculate-your-rps-score-assuming-the-code-file-provided-contains-your-opponents-shape-and-the-required-outcome-for-each-game-in-the-contest)
  - [DAY-3: Rucksack Reorganisation](#day-3-rucksack-reorganisation)
    - [Puzzle-1: Find the item type that appears in both compartments of each rucksack. What is the sum of the priorities of those item types?](#puzzle-1-find-the-item-type-that-appears-in-both-compartments-of-each-rucksack-what-is-the-sum-of-the-priorities-of-those-item-types)
    - [Puzzle-2: Find the item type that corresponds to the badges of each three-Elf group. What is the sum of the priorities of those item types?](#puzzle-2-find-the-item-type-that-corresponds-to-the-badges-of-each-three-elf-group-what-is-the-sum-of-the-priorities-of-those-item-types)
  - [Day-4: Camp Cleanup](#day-4-camp-cleanup)
    - [Puzzle-1: In how many assignment pairs does one range fully contain the other?](#puzzle-1-in-how-many-assignment-pairs-does-one-range-fully-contain-the-other)
    - [Puzzle-2: In how many assignment pairs do the ranges overlap?](#puzzle-2-in-how-many-assignment-pairs-do-the-ranges-overlap)
  - [Day-5: Supply Stacks](#day-5-supply-stacks)
    - [Puzzle-1: After the rearrangement procedure completes, what crate ends up on top of each stack?](#puzzle-1-after-the-rearrangement-procedure-completes-what-crate-ends-up-on-top-of-each-stack)
    - [Puzzle-2: After the rearrangement procedure completes (with CrateMover9001), what crate ends up on top of each stack?](#puzzle-2-after-the-rearrangement-procedure-completes-with-cratemover9001-what-crate-ends-up-on-top-of-each-stack)
  - [Day-6: Tuning Trouble](#day-6-tuning-trouble)
    - [Puzzle-1: How many characters need to be processed before the first start-of-packet marker is detected?](#puzzle-1-how-many-characters-need-to-be-processed-before-the-first-start-of-packet-marker-is-detected)
    - [Puzzle-2: How many characters need to be processed before the first start-of-message marker is detected?](#puzzle-2-how-many-characters-need-to-be-processed-before-the-first-start-of-message-marker-is-detected)
  - [Day-7: No Space Left on Device](#day-7-no-space-left-on-device)
    - [Puzzle-1: Find all of the directories with a total size of at most 100000. What is the sum of the total sizes of those directories?](#puzzle-1-find-all-of-the-directories-with-a-total-size-of-at-most-100000-what-is-the-sum-of-the-total-sizes-of-those-directories)
    - [Puzzle-2: Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update. What is the total size of that directory?](#puzzle-2-find-the-smallest-directory-that-if-deleted-would-free-up-enough-space-on-the-filesystem-to-run-the-update-what-is-the-total-size-of-that-directory)

---

## DAY-1: Calorie Counting

### Puzzle-1: Elf with most food calories.

Summary of solution

- Read the input file
  - initially by blocks separated by a double newline `\n\n`, store in a `[String]`, i.e. each elf's 'backpack' food items
  - then, for each backpack, get each individual item and convert to `Int`, this is the calorie value of the food item

Store the data in a set of structs...

``` swift
struct FoodItem {
  var calories: Int
}

struct Backpack {
  var foods: [FoodItem]
  var totalFoodCalories: Int {
    get { return foods.reduce(0) { $0 + $1.calories } }
  }
}

struct Elf {
  var elfNum: Int
  var backpack: Backpack
}
struct ElfExpedition {
  var elves: [Elf]
}
```

To find the elf who has the food items with the most calories, we could iterate over the entire array of elves in the expedition party, keeping a record of the elf with the highest number of calories.

This seemed a little cumbersome so I decided to create a custom sort for `ElfExpedition` and although not required for the solution, I allowed for the elf array to be sorted in `ASC` or `DESC` order.

``` swift
enum SortOrder {
  case ASC
  case DESC
}

extension ElfExpedition {
  mutating func sortByBackpackCalories(sortOrder: SortOrder) {
    if sortOrder == .ASC {
      elves.sort { $0.backpack.totalFoodCalories < $1.backpack.totalFoodCalories }
    }
    else {
      elves.sort { $0.backpack.totalFoodCalories > $1.backpack.totalFoodCalories }
    }
  }
}
```

The elf with the food items having the highest calories is found by...

``` swift
elfExpedition.sortByBackpackCalories(sortOrder: .DESC)
  
let d1p1Ans = elfExpedition.elves.first?.backpack.totalFoodCalories ?? 0
```

### Puzzle-2: Three Elves with most food calories.

Summary of solution

- Use the sorted array from puzzle-1, then simply add the backpack calories for the top three items in the array

``` swift
let top3 = elfExpedition.elves.count > 3 ? Array(elfExpedition.elves.prefix(3)) : elfExpedition.elves
let d1p2Ans = top3.reduce(0) { $0 + $1.backpack.totalFoodCalories}
```

> **NOTE:** Prior to starting today's puzzles, I did not know that puzzle-2 would ask for the top-X number of entries in the array; so by luck the custom sort that I created made the second part very easy.

---

## DAY-2: Rock Paper Scissors

### Puzzle-1: Calculate your ROCK-PAPER-SCISSORS (RPS) score assuming the code file provided contains your opponents shape and your shape for each game in the contest.

Summary of solution
- Read the input file, create a `rawInput` array with each line of the file as an element in the array
- For each game round in the `rawInput` array, read the pair of coded shape values and 'play' the game

Create some enumerations to help with game-play. An `RPSPlay` denotes the shape that each player makes for a game.  The `RPSResult` denotes the outcome of the game.  The enumerations are given default values, these are used make calculating the score easier.

``` swift
enum RPSPlay: Int {
  case ROCK = 1
  case PAPER = 2
  case SCISSORS = 3
}

enum RPSResult: Int {
  case WIN = 6
  case LOSE = 0
  case DRAW = 3
}
```

Next, create structs for a single instance of an RPS game and an RPS contest (multiple games).

``` swift
struct RPSGame {
  var opponentPlay: RPSPlay
  var myPlay: RPSPlay
  var score: Int {
    get {
      return myPlay.rawValue + outcome.rawValue
    }
  }
  
  var outcome: RPSResult {
    get {
      switch opponentPlay {
      case .ROCK:
        switch myPlay {
        case .ROCK:     return .DRAW
        case .PAPER:    return .WIN
        case .SCISSORS: return .LOSE
        }
      case .PAPER:
        switch myPlay {
        case .ROCK:     return .LOSE
        case .PAPER:    return .DRAW
        case .SCISSORS: return .WIN
        }
      case .SCISSORS:
        switch myPlay {
        case .ROCK:     return .WIN
        case .PAPER:    return .LOSE
        case .SCISSORS: return .DRAW
        }
      }
    }
  }
}

struct RPSContest {
  var rpsGame: [RPSGame]
  var score: Int {
    get {
      return rpsGame.reduce(0) { $0 + $1.score }
    }
  }
  
  mutating func newGame(oppPlay: RPSPlay, myPlay: RPSPlay) {
    self.rpsGame.append(RPSGame(opponentPlay: oppPlay, myPlay: myPlay))
  }
  
  init() {
    self.rpsGame = [RPSGame]()
  }
}
```

For `RPSGame`, a game has a 'play' for each player and the `outcome` of the game WIN/LOSE/DRAW is determined by simple logic.

For `RPSContest`, a contest is `init`'d with an empty games array, I added a convience function to add a `newGame` to the contest.  The total score is calculated by summing each game's score.

For processing the input file I created a simple dictionary so that the file's code value could be converted to a shape for both the opponents and you own shapes.

``` swift
let oppCode = ["A": RPSPlay.ROCK, "B": RPSPlay.PAPER, "C": RPSPlay.SCISSORS]
let  myCode = ["X": RPSPlay.ROCK, "Y": RPSPlay.PAPER, "Z": RPSPlay.SCISSORS]
```

Step through the file, create the games and calculate.

``` swift
var rpsContest = RPSContest()

for gameRound in rawInput {
  let shapes = gameRound.components(separatedBy: " ")
  
  if shapes.count == 2 {
    rpsContest.newGame(oppPlay: oppCode[shapes[0]]!, myPlay: myCode[shapes[1]]!)
  }
}

let d2p1Ans = rpsContest.score
```

### Puzzle-2: Calculate your RPS score assuming the code file provided contains your opponents shape and the required outcome for each game in the contest.

Using a similar approach as for puzzle-1, I adapted `RPSGame`, making an `RPSGame_Rigged` so that it is `init`'d with the opponents shape and the desired result; the shape to play for each game is then determined using simple logic.

``` swift
struct RPSGame_Rigged {
  var opponentPlay: RPSPlay
  var outcome: RPSResult
  var score: Int {
    get {
      return myPlay.rawValue + outcome.rawValue
    }
  }

  var myPlay: RPSPlay {
    get {
      switch opponentPlay {
      case .ROCK:
        switch outcome {
        case .WIN:  return .PAPER
        case .LOSE: return .SCISSORS
        case .DRAW: return .ROCK
        }
      case .PAPER:
        switch outcome {
        case .WIN:  return .SCISSORS
        case .LOSE: return .ROCK
        case .DRAW: return .PAPER
        }
      case .SCISSORS:
        switch outcome {
        case .WIN:  return .ROCK
        case .LOSE: return .PAPER
        case .DRAW: return .SCISSORS
        }
      }
    }
  }
}
```

Similar adaption of `RPSContest` to create an `RPSContest_Rigged` was needed...

``` swift
struct RPSContest_Rigged {
  var rpsGame: [RPSGame_Rigged]
  var score: Int {
    get {
      return rpsGame.reduce(0) { $0 + $1.score }
    }
  }
  
  mutating func newGame(oppPlay: RPSPlay, outcome: RPSResult) {
    self.rpsGame.append(RPSGame_Rigged(opponentPlay: oppPlay, outcome: outcome))
  }
  
  init() {
    self.rpsGame = [RPSGame_Rigged]()
  }
}
```

Decoding the desired outcome required a new dictionary...

``` swift
let riggedResult  = ["X": RPSResult.LOSE, "Y": RPSResult.DRAW, "Z": RPSResult.WIN]
```

As before, step through the input file, create the rigged games and calculate the score...

``` swift
  var rpsContest_Rigged = RPSContest_Rigged()

  for gameRound in rawInput {
    let shapes = gameRound.components(separatedBy: " ")
    
    if shapes.count == 2 {
      rpsContest_Rigged.newGame(oppPlay: oppCode[shapes[0]]!, outcome: riggedResult[shapes[1]]!)
    }
  }
  
  let d2p2Ans = rpsContest_Rigged.score
```

---

## DAY-3: Rucksack Reorganisation

### Puzzle-1: Find the item type that appears in both compartments of each rucksack. What is the sum of the priorities of those item types?

Summary of solution
- Process the input file line-by-line
- Split each line in half, store the two blocks of characters as items in each compartment in the rucksack
- Create a function to calculate each item's priority value
- Add the priority values

Create some structs, to keep things simple `RucksackItem` is just an alias to `Character`.  

When calculating the rucksack item's priority value is based on the character's ASCii value with approrite offsets such that 'a' = 1, 'b' = 2 etc. and 'A' = 27, 'B' = 28 etc.

``` swift
typealias RucksackItem = Character

fileprivate let lowercaseOffset = 96
fileprivate let uppercaseOffset = (64 - 26)

extension RucksackItem {
  var priority: Int {
    get { return self.isLowercase ? Int(self.asciiValue!) - lowercaseOffset : Int(self.asciiValue!) - uppercaseOffset }
  }
}

struct Rucksack {
  var compartmentA: [RucksackItem]
  var compartemntB: [RucksackItem]
  var items: [RucksackItem] {
    get {
      return compartmentA + compartemntB
    }
  }
  
  var duplicateItem: RucksackItem {
    get { return Array( Set(compartmentA).intersection(Set(compartemntB)) ).first! }
  }
}

struct Expedition {
  var rucksacks: [Rucksack]
  
  init() {
    self.rucksacks = [Rucksack]()
  }
}

```

Create an instance of `Expedition` then loop through the contents of the input file, splitting each line in half, then adding the 'items' to the rucksack.

Getting the sum of all the duplicate items priority values is done simply by calling `reduce` the rucksack array, adding each priority value.

The `Rucksack.duplicateItem` getter does much of the work, by converting the two items arrays to sets, then finding the `Set.intersection` and returning the first (only) value.


``` swift
  var expedition = Expedition()
  
  for contents in rawInput {
    let halfLen = Int(contents.count / 2)
    let idx = contents.index(contents.startIndex, offsetBy: halfLen)
    
    expedition.rucksacks.append(Rucksack(compartmentA: Array(String(contents[..<idx])),
                                         compartemntB: Array(String(contents[idx...]))))
  }
  
  let prioritySum = expedition.rucksacks.reduce(0) { $0 + $1.duplicateItem.priority}
```

### Puzzle-2: Find the item type that corresponds to the badges of each three-Elf group. What is the sum of the priorities of those item types?

To find the common item with each group of three rucksacks,...

- Iterate over the array of rucksacks using a `stride` of 3.  
- Convert each rucksack contents to a `Set`
- Use `Set.intersection()` to find the common item.
- The question tells us there should be only one common item, get the only (i.e. the first) element of the final intersection.
- As we loop through the rucksack groups, keep a record of the sum of the `groupPrioritySum` values.

``` swift
  var groupPrioritySum = 0
  let groupSize = 3
  var iter = stride(from: expedition.rucksacks.startIndex,
                    to: expedition.rucksacks.endIndex, by: groupSize).makeIterator()
  while let n = iter.next() {
    let e = min(n.advanced(by: groupSize), expedition.rucksacks.endIndex)
    let group = expedition.rucksacks[n..<e]
    
    let s1 = Set(group[n].items)
    let s2 = Set(group[n+1].items)
    let s3 = Set(group[n+2].items)
    
    let sA = s1.intersection(s2)
    let sB = sA.intersection(s3)
    groupPrioritySum += sB.first!.priority
  }
```

---

## Day-4: Camp Cleanup

Summary of solution:

- Process the input file line-by-line
- Split each line at the comma to get two number pairs, "a-b" and "c-d"
- Each number pair represents the start-end sections that each elf needs to clean
- Use `ClosedRange()`'s built-in methods and a custom extension to determine the answers.

### Puzzle-1: In how many assignment pairs does one range fully contain the other?

Create some suitable structs for the assigned cleaning areas and the pairs of elves.  

``` swift
struct CleaningAssignment {
  var section: ClosedRange<Int>
}

@available(macOS 13.0, *)
extension CleaningAssignment {
  func containsSections(for otherCleaningAssignment: CleaningAssignment) -> Bool {
    return self.section.contains(otherCleaningAssignment.section)
  }
}

struct CleaningPair {
  var elf1: CleaningAssignment
  var elf2: CleaningAssignment
}
```

The `CleaningAssignment` struct stores the section start-end numbers as a `ClosedRange`, this seems a simple way to hold the pair of numbers.  The `CleaningAssingment` extension makes a call to `ClosedRange().contains` which is only supported on macOS v13 or later.

Iterate through the input file and create the elf pairs and their assigned sections.

``` swift
for elfPairs in rawInput {
  let sectionPair = elfPairs.components(separatedBy: ",")
  let section1 = sectionPair[0].components(separatedBy: "-").compactMap { Int($0) }
  let section2 = sectionPair[1].components(separatedBy: "-").compactMap { Int($0) }
  
  let area1 = CleaningAssignment(section: section1[0]...section1[1])
  let area2 = CleaningAssignment(section: section2[0]...section2[1])
      
  cleaningTeam.append(CleaningPair(elf1: area1, elf2: area2))
}
```

To determine the number of fully contained ranges use the `ClosedRange.contains` function, available with `ClosedRange` since macOS_13.0.

``` swift
var fullyContainedSections = 0
for pair in cleaningTeam {
  if (pair.elf1.containsSections(for: pair.elf2)) || (pair.elf2.containsSections(for: pair.elf1)) {
    fullyContainedSections += 1
  }
}
```

### Puzzle-2: In how many assignment pairs do the ranges overlap?

To find any overlapping regions in the assigned sections, extend `CleaningAssingment` to create an `overlaps` function.  Essentially, if any element in one set exists in the other set then there is an overlap.

``` swift
extension CleaningAssignment {
  func containsSections(for otherCleaningAssignment: CleaningAssignment) -> Bool {
    return self.section.contains(otherCleaningAssignment.section)
  }
  
  func overlaps(with otherCleaningAssignment: CleaningAssignment) -> Bool {
    return self.section.overlaps(otherCleaningAssignment.section)
  }
}
```

Now update the code where we process the input file to check for any overlaps...

``` swift
var fullyContainedSections = 0
var overlappingSections = 0
for pair in cleaningTeam {
  if (pair.elf1.containsSections(for: pair.elf2)) || (pair.elf2.containsSections(for: pair.elf1)) {
    fullyContainedSections += 1
  }
  
  if pair.elf1.overlaps(with: pair.elf2) {
    overlappingSections += 1
  }
}
```

---

## Day-5: Supply Stacks

### Puzzle-1: After the rearrangement procedure completes, what crate ends up on top of each stack?

Summary of solution:

- Capture the initial (setup portion) of the input file manually (maybe as an extra bonus, I'll parse this part automatically)
- Automatically process the file line-by-line, starting from line 11, where the movement entries start
- Create a regex data capture to parse the crate movement data
- Implement a simple `stack.remove` and `stack.add` methods to handle moving crates between stacks.

Create suitable structs to represent a `CrateStack` and `ShipYard` objects.

``` swift
typealias Crate = Character

struct CrateStack {
  var crates = [Crate]()
  
  mutating func add(crate: Crate) {
    crates.insert(crate, at: crates.startIndex)
  }
  
  mutating func remove() -> Crate {
    return crates.removeFirst()
  }
  
  func getTop() -> Crate {
    return crates.first ?? " "
  }
}

struct ShipYard {
  var crateStacks = [Int: CrateStack]()
  
  mutating func add(crate: Crate, toStack to: Int) {
    self.crateStacks[to]!.add(crate: crate)
  }
  
  mutating func remove(fromStack from: Int) -> Crate {
    return self.crateStacks[from]!.remove()
  }
  
  mutating func move(fromStack from: Int, toStack to: Int) -> Crate {
    let c = self.remove(fromStack: from)
    self.add(crate: c, toStack: to)
    return c
  }
  
  func getTopCrateOnStack(stack s: Int) -> Crate {
    return self.crateStacks[s]!.getTop()
  }
  
  func getTopCrates() -> [Crate] {
    var c = [Crate]()
    for s in 1...crateStacks.count {
      c.append(getTopCrateOnStack(stack: s))
    }
    return c
  }
  
  func maxStackHeight() -> (stack: Int, height: Int) {
    var s = 0; var h = 0
    for stack in crateStacks {
      if stack.value.crates.count > h {
        s = stack.key
        h = stack.value.crates.count
      }
    }
    return (s, h)
  }
  
  init(withCrateStacks: [Int: [Crate]]) {
    for s in withCrateStacks {
      crateStacks[s.key] = CrateStack()
      for c in s.value {
        self.add(crate: c, toStack: s.key)
      }
    }
  }
}
```

`CrateStack` has functions `add(crate:)` and `remove() -> Crate` modify the crates in the stack; the basic premise for a crate stack is that crates are stacked FILO (first in, last out), also a function `getTop() -> Crate` find the crate on top of the stack.

Similarly, `ShipYard` has add & remove along with a `move(fromStack:, toStack:) -> Crate` which calls both `add` and `remove` for the relevant stack.  Funcs to get top crate on a single stack or all stacks plus an `init(withCrateStacks: )` to preload the initial state of the shipyard stacks.

The initial part of the input file has been parsed manually and captured as a constant dictionary ...

``` swift
let initialShipyardStacks: [Int: [Crate]] = [
  1: ["Z", "J", "G"],
  2: ["Q", "L", "R", "P", "W", "F", "V", "C"],
  3: ["F", "P", "M", "C", "L", "G", "R"],
  4: ["L", "F", "B", "W", "P", "H", "M"],
  5: ["G", "C", "F", "S", "V", "Q"],
  6: ["W", "H", "J", "Z", "M", "Q", "T", "L"],
  7: ["H", "F", "S", "B", "V"],
  8: ["F", "J", "Z", "S"],
  9: ["M", "C", "D", "P", "F", "H", "B", "T"]
]
```

> _**As a bonus exercise, I may return to this later to automate reading this data from the input file.**_

Each movement entry in the input file needs to be parsed, I created a regex,`"move (?<numMove>\d{1,2}) from (?<fromStack>\d{1}) to (?<toStack>\d{1})"`, with named data captures `numMove`, `fromStack` and `toStack` to do this...

``` swift
func captureData(inputStr movements: String) -> [String: Int] {
  let captureNames = ["numMove", "fromStack", "toStack"]
  let regexPattern = #"move (?<numMove>\d{1,2}) from (?<fromStack>\d{1}) to (?<toStack>\d{1})"#
  let regex = try! NSRegularExpression(pattern: regexPattern, options: [])

  let range = NSRange(movements.startIndex..<movements.endIndex, in: movements)
  let matches = regex.matches(in: movements, options: [], range: range)
  guard let match = matches.first else {
    print("RegEx match error on: \(movements)")
    return [:]
  }
  var captures: [String: Int] = [:]
  for name in captureNames {
    let matchRange = match.range(withName: name)
    if let substringRange = Range(matchRange, in: movements) {
      let capture = String(movements[substringRange])
      captures[name] = Int(capture)
    }
  }
  return captures
}
```

The function's return value will look like...

``` swift
[ "numMove"   : 1,
  "fromStack" : 2,
  "toStack"   : 5 ] 
```

Processing of the movement data is now quite straight forward.

``` swift
var shipyard = ShipYard(withCrateStacks: initialShipyardStacks)

let maxStack = shipyard.maxStackHeight()
var lineCount = 0
let movementsStartLine = maxStack.height + 2  // Initial stack settings plus two throw-away lines
var makeMovements = false

for movements in rawInput {
  lineCount += 1
  makeMovements = lineCount > movementsStartLine ? true : false
  
  if makeMovements {
    let captures = captureData(inputStr: movements)
    
    let _num  = captures["numMove"]!
    let _from = captures["fromStack"]!
    let _to   = captures["toStack"]!

    for _ in 1..._num {
      let _ = shipyard.move(fromStack: _from, toStack: _to)
    }
  }
}

let topCrates = String(shipyard.getTopCrates())
```

### Puzzle-2: After the rearrangement procedure completes (with CrateMover9001), what crate ends up on top of each stack?

With the CrateMover crane being the 9001 model that can move multiples crates in a single move, whereas CrateMover 9000 could only move one crate at a time, an easy solution would be to inherit the behaviour of CrateMover9000 and add the multi-crate move function in a new 9001 version.

To do this, I refactored my original `ShipYard` struct to become a class.  The only other change needed was to remove the `mutating` modifiers on some functions.

``` swift
class ShipYard {
  var crateStacks = [Int: CrateStack]()
  
  func add(crate: Crate, toStack to: Int) {
    self.crateStacks[to]!.add(crate: crate)
  }
  
  func remove(fromStack from: Int) -> Crate {
    return self.crateStacks[from]!.remove()
  }
  
  func move(fromStack from: Int, toStack to: Int) -> Crate {
    let c = self.remove(fromStack: from)
    self.add(crate: c, toStack: to)
    return c
  }
  
  func getTopCrateOnStack(stack s: Int) -> Crate {
    return self.crateStacks[s]!.getTop()
  }
  
  func getTopCrates() -> [Crate] {
    var c = [Crate]()
    for s in 1...crateStacks.count {
      c.append(getTopCrateOnStack(stack: s))
    }
    return c
  }
  
  func maxStackHeight() -> (stack: Int, height: Int) {
    var s = 0; var h = 0
    for stack in crateStacks {
      if stack.value.crates.count > h {
        s = stack.key
        h = stack.value.crates.count
      }
    }
    return (s, h)
  }
  
  init(withCrateStacks: [Int: [Crate]]) {
    for s in withCrateStacks {
      crateStacks[s.key] = CrateStack()
      for c in s.value {
        self.add(crate: c, toStack: s.key)
      }
    }
  }
}
```

Now we can create the `ShipYard9001` with a new `moveCrates(numCrates: fromStack: toStack: )` function as ...

``` swift
class ShipYard9001: ShipYard {
  func moveCrates(numCrates: Int, fromStack: Int, toStack: Int) {
    var crates = [Crate]()

    for _ in 1...numCrates {
      crates.insert(remove(fromStack: fromStack), at: crates.startIndex)
    }

    for c in crates {
      add(crate: c, toStack: toStack)
    }
  }
}
```

The main processing code now just needs three new lines of code to create the `Shipyard9001`, `moveCrates` and finally `getTopCrates` as stacked by Shipyard9001

``` swift
let shipyard = ShipYard(withCrateStacks: initialShipyardStacks)
let shipyard9001 = ShipYard9001(withCrateStacks: initialShipyardStacks)

let maxStack = shipyard.maxStackHeight()
var lineCount = 0
let movementsStartLine = maxStack.height + 2  // Initial stack settings plus two throw-away lines
var makeMovements = false

for movements in rawInput {
  lineCount += 1
  makeMovements = lineCount > movementsStartLine ? true : false
  
  if makeMovements {
    let captures = captureData(inputStr: movements)
    
    let _num  = captures["numMove"]!
    let _from = captures["fromStack"]!
    let _to   = captures["toStack"]!

    for _ in 1..._num {
      let _ = shipyard.move(fromStack: _from, toStack: _to)
    }
    
    shipyard9001.moveCrates(numCrates: _num, fromStack: _from, toStack: _to)
  }
}

let topCrates = String(shipyard.getTopCrates())
let topCrates9001 = String(shipyard9001.getTopCrates())
```

---

## Day-6: Tuning Trouble

### Puzzle-1: How many characters need to be processed before the first start-of-packet marker is detected?

Summary of solution:

- Read the entire content of the input file into a `String`
- Iterate through the input 
- Create `String.index` variables such that we have indeces to read sub-strings for the start-of-packet marker (len=4) and the start-of-message marker (len=14)
- For each of the extracted sub-strings, create a `Set()`; if the `Set()`.count` equals the marker lengths then we have found a match.

No special structs/classes required for this puzzle, just looping through the input.

``` swift
let startOfPacketMarkerLen = 4

var markerFound = false
var startOfPacketCount = startOfPacketMarkerLen - 1

for i in 0..<rawInput.count {
  let from = i
  let toEndOfMarker = from + startOfPacketMarkerLen
  
  let start = rawInput.index(rawInput.startIndex, offsetBy: from, limitedBy: rawInput.endIndex) ?? rawInput.endIndex
  let endMarker = rawInput.index(rawInput.startIndex, offsetBy: toEndOfMarker, limitedBy: rawInput.endIndex) ?? rawInput.endIndex
  
  let marker = Set(rawInput[start..<endMarker])
  
  if !markerFound {
    markerFound = (marker.count == startOfPacketMarkerLen)
    startOfPacketCount += 1
  }
  
  if markerFound { break }
}

return startOfPacketCount
```

### Puzzle-2: How many characters need to be processed before the first start-of-message marker is detected?

We can take exactly the same approach and find the solution in parallel with the puzzle-1.  Updated code ...

``` swift
let startOfPacketMarkerLen = 4
let startOfMessageMarkerLen = 14

var markerFound = false
var messageFound = false
var startOfPacketCount = startOfPacketMarkerLen - 1
var startOfMessageCount = startOfMessageMarkerLen - 1

for i in 0..<rawInput.count {
  let from = i
  let toEndOfMarker = from + startOfPacketMarkerLen
  let toEndOfMessage = from + startOfMessageMarkerLen
  
  let start = rawInput.index(rawInput.startIndex, offsetBy: from, limitedBy: rawInput.endIndex) ?? rawInput.endIndex
  let endMarker = rawInput.index(rawInput.startIndex, offsetBy: toEndOfMarker, limitedBy: rawInput.endIndex) ?? rawInput.endIndex
  let endMessage = rawInput.index(rawInput.startIndex, offsetBy: toEndOfMessage, limitedBy: rawInput.endIndex) ?? rawInput.endIndex
  
  let marker = Set(rawInput[start..<endMarker])
  let message = Set(rawInput[start..<endMessage])
  
  if !markerFound {
    markerFound = (marker.count == startOfPacketMarkerLen)
    startOfPacketCount += 1
  }
  
  if !messageFound {
    messageFound = (message.count == startOfMessageMarkerLen)
    startOfMessageCount += 1
  }
  
  if markerFound && messageFound { break }
}

return (startOfPacketCount,startOfMessageCount)
```

---

## Day-7: No Space Left on Device

### Puzzle-1: Find all of the directories with a total size of at most 100000. What is the sum of the total sizes of those directories?

Summary of solution:

- Read the input file, line by line, into a `[String]`
- Iterate through the file
- Interpret the commands and a structure to hold the required directories and files along with their names and sizes
- Create some utility functions to (recursively) parse the data structure to find the sum size of all directories <= 100,000 bytes

Create some classes to hold data for the files/directories. Using classes this time as I need to use the data by reference in order for my recursion to work.

``` swift
class File {
  var name: String
  var size: Int
  
  init(name: String, size: Int) {
    self.name = name
    self.size = size
  }
}

class Directory {
  var name: String
  var files: [File] = [File]()
  var subDirectories: [String: Directory] = [:]
  var dirLevel: Int
  var parent: Directory?
  var size: Int {
    get {
      var sz = 0
      for d in subDirectories {
        sz += d.value.size
      }
      return files.reduce(0) { $0 + $1.size} + sz
    }
  }
  
  init(name: String, parent: Directory?) {
    self.name = name
    self.parent = parent ?? nil
    self.dirLevel = (parent?.dirLevel ?? -1) + 1
  }
  
  func addFile(name: String, size: Int) {
    files.append(File(name: name, size: size))
  }
  
  func addSubDirectory(name: String) {
    subDirectories[name] = Directory(name: name, parent: self)
  }
  
  func sumSmallDirs(szLim: Int) {
    for d in subDirectories {
      if d.value.size <= szLim {
        dirSizeSum += d.value.size
      }
      d.value.sumSmallDirs(szLim: szLim)
    }
  }
}

class FileSystem {
  var systemName: String = "Elf Comms 3000"
  var tld = Directory(name: "/", parent: nil)
  lazy var cwd: Directory = tld
  
  func cd(subDir: String) {
    switch subDir {
    case "/":
      cwd = tld
    case "..":
      let tmp = cwd.parent!
      cwd = tmp
    default:
      cwd = cwd.subDirectories[subDir]!
    }
  }
  
  func addFile(name: String, size: Int) {
    cwd.addFile(name: name, size: size)
  }
  
  func addSubDirectory(name: String) {
    cwd.addSubDirectory(name: name)
  }
  
  func sumSmallDirs(szLim: Int) {
    tld.sumSmallDirs(szLim: szLim)
  }
}
```

The `File` class is self-explanatory; the `Directory` class itself contains a dictionary of subDirectories of type `Directory`.  This class stores the parent directory, this is useful later when having to navigate back up the directory tree when we have a `$ cd ..` command.

The `FileSystem` class creates a top-level directory, `tld` with it's `parent` set to `nil`; we also maintain a record of the current working directory `cwd` which is used for our recursion functions.

Simple utility functions to add files and directories are included, the `FileSystem` class also has a `cd` function to allow us to navigate the directory tree that we create.

For the main processing loop...

``` swift
var dirSizeSum = 0

let fs = FileSystem()

for cmd in rawInput {
  let cmdArgs = cmd.components(separatedBy: " ")
  
  switch cmdArgs[0] {
  case "$":
    if (cmdArgs[1] == "cd") && (cmdArgs[2] != "/") {
      fs.cd(subDir: cmdArgs[2])
    }
  case "dir":
    fs.cwd.addSubDirectory(name: cmdArgs[1])
  default:
    fs.cwd.addFile(name: cmdArgs[1], size: Int(cmdArgs[0])!)
  }
}

// this will modify the global var dirSizeSum
fs.sumSmallDirs(szLim: 100_000)

return dirSizeSum

```

### Puzzle-2: Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update. What is the total size of that directory?

Adding a `tree()` function to the `Directory` class will iterate through every directory / sub-directory, the size of each directory will be checked and the appropriate value stored in a global variable.  Additions to classes...

For `FileSystem`

``` swift
class FileSystem {

...

  func tree()  {
    tld.tree()
  }
}
```

For `Directory`, this will also print the directory structure to the console.

``` swift
// Global variables
var minSpaceToClear = 0
let hddSize = 70_000_000
var deletedDirSize = hddSize

class Directory {

...

  func tree() {
    let padding = String(repeating: "  ", count: self.dirLevel)
    print("\(padding)- \(name) (dir, \(size))")
    
    if size > minSpaceToClear && size < deletedDirSize {
      deletedDirSize = size
    }
    
    for d in subDirectories {
      d.value.tree()
    }
  }
}
```