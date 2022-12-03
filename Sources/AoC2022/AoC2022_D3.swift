//
//  firecrestHORIZON.uk
//  
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

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

public func AoC2022_D3(inputFile: String) -> (puzzle1: Int, puzzle2: Int) {
  var rawInput = [String]()
  do {
    rawInput = try String(contentsOfFile: inputFile).components(separatedBy: "\n")
  } catch {
    print(error.localizedDescription)
  }
  
  var expedition = Expedition()
  
  for contents in rawInput {
    let halfLen = Int(contents.count / 2)
    let idx = contents.index(contents.startIndex, offsetBy: halfLen)
    
    expedition.rucksacks.append(Rucksack(compartmentA: Array(String(contents[..<idx])),
                                         compartemntB: Array(String(contents[idx...]))))
  }
  
  let prioritySum = expedition.rucksacks.reduce(0) { $0 + $1.duplicateItem.priority}

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
  
  return (prioritySum, groupPrioritySum)
}
