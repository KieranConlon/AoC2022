//
//  firecrestHORIZON.uk
//  
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

public func AoC2022_D6(inputFile: String) -> (puzzle1: Int, puzzle2: Int) {
  var rawInput = ""
  do {
    rawInput = try String(contentsOfFile: inputFile)
  } catch {
    print(error.localizedDescription)
  }
  
  let startOfPacketMarkerLen = 4
  let startOfMessageMarkerLen = 14
  
  var markerFound = false
  var messageFound = false
  var startOfPacketCount = startOfPacketMarkerLen - 1
  var startOfMessageCount = startOfMessageMarkerLen - 1
  
  for from in 0..<rawInput.count {
    let start =       rawInput.index(rawInput.startIndex, offsetBy: from,                    limitedBy: rawInput.endIndex)!
    let endMarker =   rawInput.index(start,               offsetBy: startOfPacketMarkerLen,  limitedBy: rawInput.endIndex)!
    let endMessage =  rawInput.index(start,               offsetBy: startOfMessageMarkerLen, limitedBy: rawInput.endIndex)!

    if !markerFound {
      markerFound = (Set(rawInput[start..<endMarker]).count == startOfPacketMarkerLen)
      startOfPacketCount += 1
    }
    
    if !messageFound {
      messageFound = (Set(rawInput[start..<endMessage]).count == startOfMessageMarkerLen)
      startOfMessageCount += 1
    }
    
    if markerFound && messageFound { break }
  }
  
  return (startOfPacketCount,startOfMessageCount)
}
