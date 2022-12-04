//
//  firecrestHORIZON.uk
//  
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

struct CleaningAssignment {
  var section: ClosedRange<Int>
}

@available(macOS 13.0, *)
extension CleaningAssignment {
  func containsSections(for otherCleaningAssignment: CleaningAssignment) -> Bool {
    return self.section.contains(otherCleaningAssignment.section)
  }
  
  func overlaps(with otherCleaningAssignment: CleaningAssignment) -> Bool {
    return self.section.overlaps(otherCleaningAssignment.section)
  }
}

struct CleaningPair {
  var elf1: CleaningAssignment
  var elf2: CleaningAssignment
}

@available(macOS 13.0, *)
public func AoC2022_D4(inputFile: String) -> (puzzle1: Int, puzzle2: Int) {
  var rawInput = [String]()
  do {
    rawInput = try String(contentsOfFile: inputFile).components(separatedBy: "\n")
  } catch {
    print(error.localizedDescription)
  }
   
  var cleaningTeam = [CleaningPair]()
  
  for elfPairs in rawInput {
    let sectionPair = elfPairs.components(separatedBy: ",")
    let section1 = sectionPair[0].components(separatedBy: "-").compactMap { Int($0) }
    let section2 = sectionPair[1].components(separatedBy: "-").compactMap { Int($0) }
    
    let area1 = CleaningAssignment(section: section1[0]...section1[1])
    let area2 = CleaningAssignment(section: section2[0]...section2[1])
        
    cleaningTeam.append(CleaningPair(elf1: area1, elf2: area2))
  }
    
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
    
  return (fullyContainedSections, overlappingSections)
}
