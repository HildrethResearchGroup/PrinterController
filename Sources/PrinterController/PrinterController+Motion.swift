//
//  PrinterController+Motion.swift
//  
//
//  Created by Connor Barnes on 7/13/21.
//

import XPSQ8Kit

public extension PrinterController {
  func searchForHome() async throws {
    try await stageGroup?.searchForHome()
  }
  
  func moveAbsolute(in dimension: Dimension, to location: Double) async throws {
    try await stage(for: dimension)?.moveAbsolute(to: location)
  }
  
  func moveRelative(in dimension: Dimension, by displacement: Double) async throws {
    try await stage(for: dimension)?.moveRelative(by: displacement)
  }
}

// MARK: - Dimension
public extension PrinterController {
  enum Dimension: String {
    case x = "X"
    case y = "Y"
    case z = "Z"
  }
}

// MARK: Stage Groups
extension PrinterController {
  var stageGroup: StageGroup? {
    try? xpsq8Controller?.makeStageGroup(named: "M")
  }
  
  func stage(for dimension: Dimension) -> Stage? {
    try? stageGroup?.makeStage(named: dimension.rawValue)
  }
}
