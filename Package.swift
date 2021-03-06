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
//    .package(url: "https://github.com/HildrethResearchGroup/XPSQ8Kit.git", .branch("actor")),
    .package(name: "XPSQ8Kit", path: "../XPSQ8Kit"),
    .package(url: "https://github.com/apple/swift-collections", from: "0.0.1"),
  ],
  targets: [
    .target(
      name: "PrinterController",
      dependencies: [
        "SwiftVISASwift",
        "XPSQ8Kit",
        .product(name: "Collections", package: "swift-collections")
      ]),
    .testTarget(
      name: "PrinterControllerTests",
      dependencies: ["PrinterController"]),
  ]
)
