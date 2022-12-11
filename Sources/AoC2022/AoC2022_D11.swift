//
//  firecrestHORIZON.uk
//  
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

class MyItem {
  var wLev: Int
  
  init(wLev: Int) {
    self.wLev = wLev
  }
}

enum InspectOperation {
  case add(Int)
  case mult(Int)
  case square
}

class Monkey: CustomStringConvertible {
  var id: Int
  var itemCollection = [MyItem]()
  var inspectOp: InspectOperation
  let testDivisibleVal: Int
  var testPassMonkey: Monkey? = nil
  var testFailMonkey: Monkey? = nil
  var itemsInspected: Int = 0
  var reduceWorry: Bool
  
  init(id: Int, items: [MyItem], op: InspectOperation, testDivisor: Int, reduceWorry: Bool) {
    self.id = id
    self.itemCollection = items
    self.inspectOp = op
    self.testDivisibleVal = testDivisor
    self.reduceWorry = reduceWorry
  }
  
  func setThrowToMonkeys(onTestPass: Monkey, onTestFail: Monkey) {
    self.testPassMonkey = onTestPass
    self.testFailMonkey = onTestFail
  }
  
  func add(worry w: Int, val: Int) -> Int {
    return w + val
  }
  
  func mult(worry w: Int, by val: Int) -> Int {
    return w * val
  }
  
  func square(worry w: Int) -> Int {
    return w * w
  }
  
  func catchItem(item: MyItem) {
    itemCollection.append(item)
  }
    
  func playRound() {
    print(self)
    
    while !itemCollection.isEmpty {
      let playItem = itemCollection.removeFirst()
      self.itemsInspected += 1
      var w = playItem.wLev
      
      switch self.inspectOp {
      case let .add(n): w = add(worry: w, val: n)
      case let .mult(n): w = mult(worry: w, by: n)
      case .square: w = square(worry: w)
      }
      
      if reduceWorry {
        w /= 3
      }
      
      playItem.wLev = w
      (w % testDivisibleVal == 0) ? testPassMonkey!.catchItem(item: playItem) : testFailMonkey!.catchItem(item: playItem)
    }
  }
  
  var description: String {
    get {
      var s =  ""
      s += "Monkey \(id):\n"
      s += "  Starting items: \(itemCollection.reduce(" ") { $0 + "  \($1.wLev)"  } )\n"
      s += "  Operation: new = old  \(inspectOp)\n"
      s += "  Test: divisible by \(testDivisibleVal)\n"
      s += "    If true: throw to monkey \(testPassMonkey?.id ?? 99)\n"
      s += "    If false: throw to monkey \(testFailMonkey?.id ?? 99)\n"
      
      return s
    }
  }
}

struct ThrowAwayGame {
  var round = 0
  var monkeys = [Monkey]()
  var monkeyItemList: String {
    get {
      var s = ""
      for monkey in monkeys {
        s += "\nMonkey \(monkey.id): "
        for item in monkey.itemCollection {
          s += "\(item.wLev) "
        }
      }
      return s
    }
  }
  
  mutating func addMonkey(monkey: Monkey) {
    self.monkeys.append(monkey)
  }
  
  mutating func playRound() {
    for monkey in monkeys {
      monkey.playRound()
    }
  }
  
  mutating func activeMonkeyScore() -> Int {
    var activeScores = [Int]()
    for monkey in monkeys {
      activeScores.append(monkey.itemsInspected)
    }
    activeScores.sort { $0 > $1 }
    return activeScores[0] * activeScores[1]
  }
}

public func AoC2022_D11(inputFile: String) -> (puzzle1: Int, puzzle2: Int) {
//  var rawInput = [String]()
//  do {
//    rawInput = try String(contentsOfFile: inputFile).components(separatedBy: "\n")
//  } catch {
//    print(error.localizedDescription)
//  }
  
  //print(rawInput)
  
  var monkeyGame = ThrowAwayGame()
  let monkey_0 = Monkey(id: 0, items: [MyItem(wLev: 71),
                                       MyItem(wLev: 56),
                                       MyItem(wLev: 50),
                                       MyItem(wLev: 73)],
                        op: .mult(11), testDivisor: 13, reduceWorry: true)

  let monkey_1 = Monkey(id: 1, items: [MyItem(wLev: 70),
                                       MyItem(wLev: 89),
                                       MyItem(wLev: 82)],
                        op: .add(1), testDivisor: 7, reduceWorry: true)
  let monkey_2 = Monkey(id: 2, items: [MyItem(wLev: 52),
                                       MyItem(wLev: 95)],
                        op: .square, testDivisor: 3, reduceWorry: true)
  let monkey_3 = Monkey(id: 3, items: [MyItem(wLev: 94),
                                       MyItem(wLev: 64),
                                       MyItem(wLev: 69),
                                       MyItem(wLev: 87),
                                       MyItem(wLev: 70)],
                        op: .add(2), testDivisor: 19, reduceWorry: true)
  let monkey_4 = Monkey(id: 4, items: [MyItem(wLev: 98),
                                       MyItem(wLev: 72),
                                       MyItem(wLev: 98),
                                       MyItem(wLev: 53),
                                       MyItem(wLev: 97),
                                       MyItem(wLev: 51)],
                        op: .add(6), testDivisor: 5, reduceWorry: true)
  let monkey_5 = Monkey(id: 5, items: [MyItem(wLev: 79)],
                        op: .add(7), testDivisor: 2, reduceWorry: true)
  let monkey_6 = Monkey(id: 6, items: [MyItem(wLev: 77),
                                       MyItem(wLev: 55),
                                       MyItem(wLev: 63),
                                       MyItem(wLev: 93),
                                       MyItem(wLev: 66),
                                       MyItem(wLev: 90),
                                       MyItem(wLev: 88),
                                       MyItem(wLev: 71)],
                        op: .mult(7), testDivisor: 11, reduceWorry: true)
  let monkey_7 = Monkey(id: 7, items: [MyItem(wLev: 54),
                                       MyItem(wLev: 97),
                                       MyItem(wLev: 87),
                                       MyItem(wLev: 70),
                                       MyItem(wLev: 59),
                                       MyItem(wLev: 82),
                                       MyItem(wLev: 59)],
                        op: .add(8), testDivisor: 17, reduceWorry: true)
  
  monkey_0.setThrowToMonkeys(onTestPass: monkey_1, onTestFail: monkey_7)
  monkey_1.setThrowToMonkeys(onTestPass: monkey_3, onTestFail: monkey_6)
  monkey_2.setThrowToMonkeys(onTestPass: monkey_5, onTestFail: monkey_4)
  monkey_3.setThrowToMonkeys(onTestPass: monkey_2, onTestFail: monkey_6)
  monkey_4.setThrowToMonkeys(onTestPass: monkey_0, onTestFail: monkey_5)
  monkey_5.setThrowToMonkeys(onTestPass: monkey_7, onTestFail: monkey_0)
  monkey_6.setThrowToMonkeys(onTestPass: monkey_2, onTestFail: monkey_4)
  monkey_7.setThrowToMonkeys(onTestPass: monkey_1, onTestFail: monkey_3)

  monkeyGame.addMonkey(monkey: monkey_0)
  monkeyGame.addMonkey(monkey: monkey_1)
  monkeyGame.addMonkey(monkey: monkey_2)
  monkeyGame.addMonkey(monkey: monkey_3)
  monkeyGame.addMonkey(monkey: monkey_4)
  monkeyGame.addMonkey(monkey: monkey_5)
  monkeyGame.addMonkey(monkey: monkey_6)
  monkeyGame.addMonkey(monkey: monkey_7)

  //print(monkeyGame.monkeyItemList)

  let rounds = 20
  for i in 1...rounds {
    monkeyGame.playRound()
    
    if (i % 5) == 0 {
      print("Round: \(i)")
      print(monkeyGame.monkeyItemList)
    }
  }
  
  //print(monkeyGame.monkeyItemList)
  
  let ans1 = monkeyGame.activeMonkeyScore()
  
  return (ans1,0)
}
