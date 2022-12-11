//
//  firecrestHORIZON.uk
//  
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

enum InstructionSet {
  case addx(Int)
  case noop
}

typealias Register = Int

struct CPU {
  private var X: Register = 1
  private var cycle = 1
  var sigStrengthSum: Int {
    get { return regCache.reduce(0) { $0 + ($1.key * $1.value) } }
  }
  
  var crt = CRT()
  
  private let idxCycles: Set<Int> = [20, 60, 100, 140, 180, 220]
  private var regCache: [Int: Int] = [:]
  
  private mutating func noop() {
    cycle += 1
  }

  private mutating func addX(_ val: Int) {
    cycle += 1
    update()
    cycle += 1
    X += val
  }
  
  private mutating func update() {
    if idxCycles.contains(cycle) {
      regCache[cycle] = X
    }
    crt.update(cycle: cycle, spriteLocn: X)
  }

  mutating func run(instr: InstructionSet) {
    update()
    switch instr {
    case let .addx(n) : addX(n)
    case .noop :        noop()
    }
  }
}


struct CRTLine {
  var buffer = Array(repeating: String("."), count: 40)
}

struct CRT: CustomStringConvertible {
  var screen = Array(repeating: CRTLine(), count: 6)
  var crtLine = 0
  
  var description: String {
    return self.screen.reduce("") { $0 + ($1.buffer.reduce("") { $0 + String($1) } + "\n") }
    }
  
  mutating func update(cycle: Int, spriteLocn: Int) {
    let scanLine = (cycle - 1) / 40
    let scanPixel = (cycle - 1) % 40
    let spriteRange = (spriteLocn-1)...(spriteLocn+1)

    screen[scanLine].buffer[scanPixel] = ( spriteRange.contains(scanPixel) ) ? String("#") : String(" ")
  }
}


public func AoC2022_D10(inputFile: String) -> (puzzle1: Int, puzzle2: String) {
  var rawInput = [String]()
  do {
    rawInput = try String(contentsOfFile: inputFile).components(separatedBy: "\n")
  } catch {
    print(error.localizedDescription)
  }
  
  var cpu = CPU()
  for instruction in rawInput {
    let args = instruction.components(separatedBy: " ")

    switch args[0] {
    case "addx" :
      cpu.run(instr: .addx(Int(args[1])!))
    case "noop":
      cpu.run(instr: .noop)
    default:
      break
    }
  }
    
  let ans1 = cpu.sigStrengthSum
  
  print()
  print(cpu.crt)
  print()

  return (ans1, "Check console output for CRT display.")
}
