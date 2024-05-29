// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PrinterController",
  platforms: [.macOS("12.0")],
  products: [
    .library(
      name: "PrinterController",
      targets: ["PrinterController"]),
  ],
  dependencies: [
    .package(url: "https://github.com/SwiftVISA/SwiftVISASwift.git", .branch("actor")),
    .package(url: "https://github.com/HildrethResearchGroup/XPSQ8Kit.git", .branch("actor")),
//    .package(name: "XPSQ8Kit", path: "../XPSQ8Kit"),
    //.package(url: "https://github.com/apple/swift-collections", .branch("release/1.1"))//,
    //.package(url: "https://github.com/armadsen/ORSSerialPort.git", branch: "master"),
  ],
  targets: [
    .target(
      name: "PrinterController",
      dependencies: [
        "SwiftVISASwift",
        "XPSQ8Kit"
        //.product(name: "Collections", package: "swift-collections")//,
        //.product(name: "ORSSerial", package: "ORSSerialPort")
      ]) /*,
    .testTarget(
      name: "PrinterControllerTests",
      dependencies: ["PrinterController"]), */
  ]
)
