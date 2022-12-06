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
  
  for i in 0..<rawInput.count {
    let from = i
    let toEndOfMarker = from + startOfPacketMarkerLen
    let toEndOfMessage = from + startOfMessageMarkerLen
    
    let start = rawInput.index(rawInput.startIndex, offsetBy: from, limitedBy: rawInput.endIndex) ?? rawInput.endIndex
    let endMarker = rawInput.index(rawInput.startIndex, offsetBy: toEndOfMarker, limitedBy: rawInput.endIndex) ?? rawInput.endIndex
    let endMessage = rawInput.index(rawInput.startIndex, offsetBy: toEndOfMessage, limitedBy: rawInput.endIndex) ?? rawInput.endIndex
    
    let marker = Set(rawInput[start..<endMarker])
    let message = Set(rawInput[start..<endMessage])
    
    if !markerFound {
      markerFound = (marker.count == startOfPacketMarkerLen)
      startOfPacketCount += 1
    }
    
    if !messageFound {
      messageFound = (message.count == startOfMessageMarkerLen)
      startOfMessageCount += 1
    }
    
    if markerFound && messageFound { break }
  }
  
  return (startOfPacketCount,startOfMessageCount)
}
