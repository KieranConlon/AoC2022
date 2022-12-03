//
//  firecrestHORIZON.uk
//
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

struct FoodItem {
  var calories: Int
}

struct Backpack {
  var foods: [FoodItem]
  var totalFoodCalories: Int {
    get { return foods.reduce(0) { $0 + $1.calories } }
  }
  
  init() {
    self.foods = [FoodItem]()
  }
}

struct Elf {
  var elfNum: Int
  var backpack: Backpack
  
  init(elfNum: Int) {
    self.elfNum = elfNum
    self.backpack = Backpack()
  }
}

struct ElfExpedition {
  var elves: [Elf]
  
  init() {
    self.elves = [Elf]()
  }
}

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
  
  mutating func sortByElfNumber(sortOrder: SortOrder) {
    if sortOrder == .ASC {
      elves.sort { $0.elfNum < $1.elfNum }
    } else {
      elves.sort { $0.elfNum > $1.elfNum }
    }
  }
}



public func AoC2022_D1(inputFile: String) -> (puzzle1: Int, puzzle2: Int) {
  var rawInput = [String]()
  do {
    rawInput = try String(contentsOfFile: inputFile).components(separatedBy: "\n\n")
  } catch {
    print(error.localizedDescription)
  }
  
  var elfExpedition = ElfExpedition()
  
  for elfBackpack in rawInput {
    var elf = Elf(elfNum: elfExpedition.elves.count + 1)
    let foodData = elfBackpack.components(separatedBy: "\n").map { Int($0)! }
    for foodItem in foodData {
      let f = FoodItem(calories: foodItem)
      elf.backpack.foods.append(f)
    }
    
    elfExpedition.elves.append(elf)
  }
  
  elfExpedition.sortByBackpackCalories(sortOrder: .DESC)
  
  let d1p1Ans = elfExpedition.elves.first?.backpack.totalFoodCalories ?? 0
  
  let top3 = elfExpedition.elves.count > 3 ? Array(elfExpedition.elves.prefix(3)) : elfExpedition.elves
  let d1p2Ans = top3.reduce(0) { $0 + $1.backpack.totalFoodCalories}

  return (d1p1Ans, d1p2Ans)
}
