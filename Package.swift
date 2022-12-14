// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AoC2022",
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "AoC2022",
      targets: ["AoC2022"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "AoC2022",
      dependencies: [],
      resources: [.process("Resources/D1/inputD1.txt"),
                  .process("Resources/D2/inputD2.txt"),
                  .process("Resources/D3/inputD3.txt"),
                  .process("Resources/D4/inputD4.txt"),
                  .process("Resources/D5/inputD5.txt"),
                  .process("Resources/D6/inputD6.txt"),
                  .process("Resources/D7/inputD7.txt"),
                  .process("Resources/D8/inputD8.txt"),
                  .process("Resources/D9/inputD9.txt"),
                  .process("Resources/D10/inputD10.txt"),
                  .process("Resources/D11/inputD11.txt")
      ]
    ),
    .testTarget(
      name: "AoC2022Tests",
      dependencies: ["AoC2022"]
    ),
  ]
)
