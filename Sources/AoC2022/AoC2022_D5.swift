//
//  firecrestHORIZON.uk
//  
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

typealias Crate = Character

struct CrateStack: CustomStringConvertible {
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
  
  var description: String {
    return String(crates.reduce("") { $0 + "\($1) " }.reversed())
  }
}

class ShipYard: CustomStringConvertible {
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
  
  var description: String {
    var s = ""
    for i in 1...crateStacks.count {
      s += "\(i):\(crateStacks[i]!.description)\n"
    }
    return s
  }
}

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

public func AoC2022_D5(inputFile: String) -> (puzzle1: String, puzzle2: String) {
  var rawInput = [String]()
  do {
    rawInput = try String(contentsOfFile: inputFile).components(separatedBy: "\n")
  } catch {
    print(error.localizedDescription)
  }
  
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
  
  print("Crate stack arrangement using CrateMover 9000:")
  print(shipyard)
  print()
  print("Crate stack arrangement using CrateMover 9001:")
  print(shipyard9001)
  
  let topCrates = String(shipyard.getTopCrates())
  let topCrates9001 = String(shipyard9001.getTopCrates())

  
  return (topCrates, topCrates9001)
}
