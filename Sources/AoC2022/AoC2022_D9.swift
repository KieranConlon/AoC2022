//
//  firecrestHORIZON.uk
//  
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

struct Coord: Hashable {
  var x: Int
  var y: Int
}

struct Knot {
  var coord: Coord
  var x: Int { get { return self.coord.x } }
  var y: Int { get { return self.coord.y } }

  init(x: Int, y: Int) {
    self.coord = Coord(x: x, y: y)
  }
  
  func dist(to: Knot) -> Double {
    return sqrt( pow(Double(self.x - to.x), 2) + pow(Double(self.y - to.y), 2) )
  }
  
  mutating func moveTowards(other: Knot, elasticLim: Double) {
    if self.dist(to: other) > elasticLim {
      self.coord.x += (1 * (other.x - self.coord.x).signum())
      self.coord.y += (1 * (other.y - self.coord.y).signum())
    }
  }
}

class ChainKnot {
  var coord: Coord
  var x: Int { get { return self.coord.x } }
  var y: Int { get { return self.coord.y } }
  
  var leadKnot: ChainKnot?

  init(x: Int, y: Int, leadKnot: ChainKnot? = nil) {
    self.coord = Coord(x: x, y: y)
  }
  
  func dist(to: ChainKnot) -> Double {
    return sqrt( pow(Double(self.x - to.x), 2) + pow(Double(self.y - to.y), 2) )
  }
  
  func moveTowards(other: ChainKnot, elasticLim: Double) {
    if self.dist(to: other) > elasticLim {
      self.coord.x += (1 * (other.x - self.coord.x).signum())
      self.coord.y += (1 * (other.y - self.coord.y).signum())
    }
  }
}

struct Rope {
  var head = Knot(x: 0, y: 0)
  var tail = Knot(x: 0, y: 0)
  
  var tailLocations = Set<Coord>()
  
  let maxSeparationSquares: Int
  var permittedElasticDist: Double {
    get {
      return self.tail.dist(to: Knot(x: self.tail.x + maxSeparationSquares, y: self.tail.y + maxSeparationSquares))
    }
  }
  
  init(maxSeparationSquares: Int) {
    self.maxSeparationSquares = maxSeparationSquares
    self.tailLocations.insert(self.tail.coord)
  }
  
  mutating func moveHead(direction: String) {
    switch direction {
    case "L":
      self.head.coord.x -= 1
    case "R":
      self.head.coord.x += 1
    case "U":
      self.head.coord.y += 1
    case "D":
      self.head.coord.y -= 1
    default :
      break
    }
    
    tail.moveTowards(other: head, elasticLim: permittedElasticDist)
    tailLocations.insert(tail.coord)
  }
}

struct LongRope {
  private var head: ChainKnot {
    get {
      return knots[0]
    }
  }
  
  var knots = [ChainKnot]()
  
  var tailLocations = Set<Coord>()
  
  let maxSeparationSquares: Int
  var permittedElasticDist: Double {
    get {
      return self.knots[0].dist(to: ChainKnot(x: self.knots[0].x + maxSeparationSquares, y: self.knots[0].y + maxSeparationSquares))
    }
  }
  
  init(maxSeparationSquares: Int, numKnots: Int) {
    self.maxSeparationSquares = maxSeparationSquares
    
    for i in 0..<numKnots {
      if i == 0 {
        knots.append(ChainKnot(x: 0, y: 0, leadKnot: nil))
      } else {
        knots.append(ChainKnot(x: 0, y: 0, leadKnot: knots[i-1]))
      }
    }
    self.tailLocations.insert(knots[knots.endIndex-1].coord)

  }
  
  mutating func moveHead(direction: String) {
    switch direction {
    case "L":
      self.head.coord.x -= 1
    case "R":
      self.head.coord.x += 1
    case "U":
      self.head.coord.y += 1
    case "D":
      self.head.coord.y -= 1
    default :
      break
    }
    
    for i in 1..<knots.count {
      knots[i].moveTowards(other: knots[i-1], elasticLim: permittedElasticDist)
    }
    tailLocations.insert(knots[knots.endIndex-1].coord)
  }
}

public func AoC2022_D9(inputFile: String) -> (puzzle1: Int, puzzle2: Int) {
  var rawInput = [String]()
  do {
    rawInput = try String(contentsOfFile: inputFile).components(separatedBy: "\n")
  } catch {
    print(error.localizedDescription)
  }
  
  var rope = Rope(maxSeparationSquares: 1)
  for row in rawInput {
    let instruction = row.components(separatedBy: " ")
    let reps = Int(instruction[1])!
    for _ in 0..<reps {
      rope.moveHead(direction: instruction[0])
    }
  }
  let ans1 = rope.tailLocations.count
  
  var longRope = LongRope(maxSeparationSquares: 1, numKnots: 10)
  for row in rawInput {
    let instruction = row.components(separatedBy: " ")
    let reps = Int(instruction[1])!
    for _ in 0..<reps {
      longRope.moveHead(direction: instruction[0])
    }
  }
  let ans2 = longRope.tailLocations.count
  
  return (ans1, ans2)
}
