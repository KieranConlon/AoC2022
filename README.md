# AoC2022

My code solutions for [Advent of Code 2022](https://adventofcode.com/)

---
- [AoC2022](#aoc2022)
  - [DAY-1](#day-1)
    - [Puzzle-1: Elf with most food calories.](#puzzle-1-elf-with-most-food-calories)
    - [Puzzle-2: Three Elves with most food calories.](#puzzle-2-three-elves-with-most-food-calories)
  - [DAY-2](#day-2)
    - [Puzzle-1: Calculate your ROCK-PAPER-SCISSORS (RPS) score assuming the code file provided contains your opponents shape and your shape for each game in the contest.](#puzzle-1-calculate-your-rock-paper-scissors-rps-score-assuming-the-code-file-provided-contains-your-opponents-shape-and-your-shape-for-each-game-in-the-contest)
    - [Puzzle-2: Calculate your RPS score assuming the code file provided contains your opponents shape and the required outcome for each game in the contest.](#puzzle-2-calculate-your-rps-score-assuming-the-code-file-provided-contains-your-opponents-shape-and-the-required-outcome-for-each-game-in-the-contest)

---

## DAY-1

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

## DAY-2

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
