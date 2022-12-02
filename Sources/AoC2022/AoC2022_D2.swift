//
//  firecrestHORIZON.uk
//  
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

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

let oppCode       = ["A": RPSPlay.ROCK, "B": RPSPlay.PAPER, "C": RPSPlay.SCISSORS]
let  myCode       = ["X": RPSPlay.ROCK, "Y": RPSPlay.PAPER, "Z": RPSPlay.SCISSORS]
let riggedResult  = ["X": RPSResult.LOSE, "Y": RPSResult.DRAW, "Z": RPSResult.WIN]

public func AoC2022_D2(inputFile: String) -> (puzzle1: Int, puzzle2: Int) {
  var rawInput = [String]()
  do {
    rawInput = try String(contentsOfFile: inputFile).components(separatedBy: "\n")
  } catch {
    print(error.localizedDescription)
  }
  
  var rpsContest = RPSContest()
  var rpsContest_Rigged = RPSContest_Rigged()

  for gameRound in rawInput {
    let shapes = gameRound.components(separatedBy: " ")
    
    if shapes.count == 2 {
      rpsContest.newGame(oppPlay: oppCode[shapes[0]]!, myPlay: myCode[shapes[1]]!)
      rpsContest_Rigged.newGame(oppPlay: oppCode[shapes[0]]!, outcome: riggedResult[shapes[1]]!)
    }
  }
  
  let d2p1Ans = rpsContest.score
  let d2p2Ans = rpsContest_Rigged.score

  
  return (d2p1Ans, d2p2Ans)
}
