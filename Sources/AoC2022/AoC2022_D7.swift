//
//  firecrestHORIZON.uk
//  
//  e-Mail  : kieran.conlon@firecresthorizon.uk
//  Twitter : @firecrestHRZN and @Kieran_Conlon
//

import Foundation

class File {
  var name: String
  var size: Int
  
  init(name: String, size: Int) {
    self.name = name
    self.size = size
  }
}

class Directory {
  var name: String
  var files: [File] = [File]()
  var subDirectories: [String: Directory] = [:]
  var dirLevel: Int
  var parent: Directory?
  var size: Int {
    get {
      var sz = 0
      for d in subDirectories {
        sz += d.value.size
      }
      return files.reduce(0) { $0 + $1.size} + sz
    }
  }
  
  init(name: String, parent: Directory?) {
    self.name = name
    self.parent = parent ?? nil
    self.dirLevel = (parent?.dirLevel ?? -1) + 1
  }
  
  func addFile(name: String, size: Int) {
    files.append(File(name: name, size: size))
  }
  
  func addSubDirectory(name: String) {
    subDirectories[name] = Directory(name: name, parent: self)
  }
  
  func sumSmallDirs(szLim: Int) {
    for d in subDirectories {
      if d.value.size <= szLim {
        dirSizeSum += d.value.size
      }
      d.value.sumSmallDirs(szLim: szLim)
    }
  }
  
  func tree() {
    let padding = String(repeating: "  ", count: self.dirLevel)
    print("\(padding)- \(name) (dir, \(size))")
    
    if size > minSpaceToClear && size < deletedDirSize {
      deletedDirSize = size
    }
    
    for d in subDirectories {
      d.value.tree()
    }
  }
}

class FileSystem {
  var systemName: String = "Elf Comms 3000"
  var tld = Directory(name: "/", parent: nil)
  lazy var cwd: Directory = tld
  
  func cd(subDir: String) {
    switch subDir {
    case "/":
      cwd = tld
    case "..":
      let tmp = cwd.parent!
      cwd = tmp
    default:
      cwd = cwd.subDirectories[subDir]!
    }
  }
  
  func addFile(name: String, size: Int) {
    cwd.addFile(name: name, size: size)
  }
  
  func addSubDirectory(name: String) {
    cwd.addSubDirectory(name: name)
  }
  
  func tree()  {
    tld.tree()
  }
  
  func sumSmallDirs(szLim: Int) {
    tld.sumSmallDirs(szLim: szLim)
  }
}

var dirSizeSum = 0
var minSpaceToClear = 0
let hddSize = 70_000_000
var deletedDirSize = hddSize

public func AoC2022_D7(inputFile: String) -> (puzzle1: Int, puzzle2: Int) {
  var rawInput = [String]()
  do {
    rawInput = try String(contentsOfFile: inputFile).components(separatedBy: "\n")
  } catch {
    print(error.localizedDescription)
  }
  
  let fs = FileSystem()
  
  for cmd in rawInput {
    let cmdArgs = cmd.components(separatedBy: " ")
    
    switch cmdArgs[0] {
    case "$":
      if (cmdArgs[1] == "cd") && (cmdArgs[2] != "/") {
        fs.cd(subDir: cmdArgs[2])
      }
    case "dir":
      fs.cwd.addSubDirectory(name: cmdArgs[1])
    default:
      fs.cwd.addFile(name: cmdArgs[1], size: Int(cmdArgs[0])!)
    }
  }
  
  fs.sumSmallDirs(szLim: 100_000)
  
  let reqFreeSpace = 30_000_000
  let usedSpace = fs.tld.size
  minSpaceToClear = reqFreeSpace - (hddSize - usedSpace)

  fs.tree()
  
  print("HDD: \(hddSize) bytes  ReqSpace: \(reqFreeSpace) bytes  HDD UsedSpace: \(usedSpace) bytes  HDD SpaceToFind: \(minSpaceToClear)")
  
  return (puzzle1: dirSizeSum, puzzle2: deletedDirSize)
}
