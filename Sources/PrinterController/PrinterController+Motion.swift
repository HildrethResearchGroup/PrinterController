//
//  PrinterController+Motion.swift
//  
//
//  Created by Connor Barnes on 7/13/21.
//

import XPSQ8Kit

public extension PrinterController {
  func searchForHome() async throws {
		switch await xpsq8State {
		case .notConnected, .connecting:
			throw Error.instrumentNotConnected
		case .busy:
			throw Error.instrumentBusy
		case .blocked:
			throw Error.instrumentBlocked
		case .ready, .notInitialized:
			try await stageGroup.searchForHome()
		}
		
    try await with(.xpsq8) {
      try await stageGroup.searchForHome()
    }
  }
  
  func moveAbsolute(in dimension: Dimension, to location: Double) async throws {
    try await with(.xpsq8) {
      try await stage(for: dimension).moveAbsolute(to: location)
    }
  }
  
  func moveRelative(in dimension: Dimension, by displacement: Double) async throws {
    try await with(.xpsq8) {
      try await stage(for: dimension).moveRelative(by: displacement)
    }
  }
  
  func position(in dimension: Dimension) async throws -> Double {
    try await with(.xpsq8) {
      try await stage(for: dimension).currentPosition
    }
  }
}

// MARK: - Dimension
public extension PrinterController {
  enum Dimension: String, CaseIterable {
    case x = "X"
    case y = "Y"
    case z = "Z"
  }
}

// MARK: Stage Groups
extension PrinterController {
  var stageGroup: StageGroup {
    get throws {
      guard let controller = xpsq8Controller else {
        throw Error.instrumentNotConnected
      }
      
      return try controller.makeStageGroup(named: "M")
    }
  }
  
  func stage(for dimension: Dimension) throws -> Stage {
    try stageGroup.makeStage(named: dimension.rawValue)
  }
}
