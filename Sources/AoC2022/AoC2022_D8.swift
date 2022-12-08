//
//  firecrestHORIZON.uk
//  
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

struct Tree: CustomStringConvertible {
  var h: Int
  var visibleFromN: Bool = false
  var visibleFromS: Bool = false
  var visibleFromW: Bool = false
  var visibleFromE: Bool = false
  var isVisible: Bool {
    get { self.visibleFromN || self.visibleFromS || self.visibleFromW || self.visibleFromE }
  }

  var viewN: Int = 0
  var viewS: Int = 0
  var viewW: Int = 0
  var viewE: Int = 0
  var scenicScore: Int {
    get { viewN * viewS * viewW * viewE }
  }

  var description: String {
    let s = "h: \(self.h) v: \(self.viewN)\(self.viewS)\(self.viewW)\(self.viewE)-\(scenicScore)"
    
    return s
  }
}

struct Forest: CustomStringConvertible {
  var treeArray = [[Tree]]()

  var visibleCount: Int {
    get {
      var c = 0
      for row in self.treeArray {
        c += row.reduce(0) { $0 + ($1.isVisible ? 1 : 0)}
      }
      return c
    }
  }
  
  var scenicScore: Int {
    get {
      var v = 0
      for row in self.treeArray {
        for col in row {
          v = (col.scenicScore > v) ? col.scenicScore : v
        }
      }
      return v
    }
  }
  
  var description: String {
    var s = ""
    for r in treeArray {
      s += r.description + "\n"
    }
    
    return s
  }
}


public func AoC2022_D8(inputFile: String) -> (puzzle1: Int, puzzle2: Int) {
  var rawInput = [String]()
  do {
    rawInput = try String(contentsOfFile: inputFile).components(separatedBy: "\n")
  } catch {
    print(error.localizedDescription)
  }
  
  var forest = Forest()
  for row in rawInput {
    forest.treeArray.append(row.map { Tree(h: Int(String($0))!) } )
  }
  
  for row in 0..<forest.treeArray.count {
    var maxHeight = -1
    for col in 0..<forest.treeArray[row].count {
      if forest.treeArray[row][col].h > maxHeight {
        forest.treeArray[row][col].visibleFromW = true
        maxHeight = forest.treeArray[row][col].h
      }
    }
  }

  for row in 0..<forest.treeArray.count {
    var maxHeight = -1
    for col in (0..<forest.treeArray[row].count).reversed() {
      if forest.treeArray[row][col].h > maxHeight {
        forest.treeArray[row][col].visibleFromE = true
        maxHeight = forest.treeArray[row][col].h
      }
    }
  }

  for col in 0..<forest.treeArray[0].count {
    var maxHeight = -1
    for row in 0..<forest.treeArray[col].count {
      if forest.treeArray[row][col].h > maxHeight {
        forest.treeArray[row][col].visibleFromN = true
        maxHeight = forest.treeArray[row][col].h
      }
    }
  }

  for col in 0..<forest.treeArray[0].count {
    var maxHeight = -1
    for row in (0..<forest.treeArray[col].count).reversed() {
      if forest.treeArray[row][col].h > maxHeight {
        forest.treeArray[row][col].visibleFromS = true
        maxHeight = forest.treeArray[row][col].h
      }
    }
  }
  
  let totalRows = forest.treeArray.count
  for row in 0..<totalRows {
    let totalCols = forest.treeArray[row].count
    for col in 0..<totalCols {
      let extentW = col
      let extentE = (totalCols - col) - 1
      let extentN = row
      let extentS = (totalRows - row) - 1
      
      let myHeight = forest.treeArray[row][col].h
      
      var dist = 0
      var blocked = false
      for dc in 0..<extentW {
        dist += 1
        let treeHeight = forest.treeArray[row][col - dc - 1].h
        if !blocked {
          blocked = (myHeight <= treeHeight)
        }
        if blocked { break }
      }
      forest.treeArray[row][col].viewW = dist
      
      dist = 0
      blocked = false
      for dc in 0..<extentE {
        dist += 1
        let treeHeight = forest.treeArray[row][col + dc + 1].h
        if !blocked {
          blocked = (myHeight <= treeHeight)
        }
        if blocked { break }
      }
      forest.treeArray[row][col].viewE = dist
      
      dist = 0
      blocked = false
      for dr in 0..<extentN {
        dist += 1
        let treeHeight = forest.treeArray[row - dr - 1][col].h
        if !blocked {
          blocked = (myHeight <= treeHeight)
        }
        if blocked { break }
      }
      forest.treeArray[row][col].viewN = dist

      dist = 0
      blocked = false
      for dr in 0..<extentS {
        dist += 1
        let treeHeight = forest.treeArray[row + dr + 1][col].h
        if !blocked {
          blocked = (myHeight <= treeHeight)
        }
        if blocked { break }
      }
      forest.treeArray[row][col].viewS = dist
    }
  }

  print("Vis Count: \(forest.visibleCount)")
  print("Scenic Score: \(forest.scenicScore)")

  return (forest.visibleCount, forest.scenicScore)
}
