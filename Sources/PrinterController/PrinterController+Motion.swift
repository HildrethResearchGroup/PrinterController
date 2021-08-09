//
//  PrinterController+Motion.swift
//  
//
//  Created by Connor Barnes on 7/13/21.
//

import XPSQ8Kit

public extension PrinterController {
  func searchForHome() async throws {
		switch await xpsq8ConnectionState {
		case .notConnected, .connecting:
			throw Error.instrumentNotConnected
		case .busy:
			throw Error.instrumentBusy
		case .blocked:
			throw Error.instrumentBlocked
    case .ready, .notInitialized, .reading:
			try await stageGroup.searchForHome()
		}
		
    try await with(.xpsq8) {
      try await stageGroup.searchForHome()
    }
  }
  
  func moveAbsolute(in dimension: Dimension, to location: Double) async throws {
    try await with(.xpsq8) {
      try await stage(for: dimension).moveAbsolute(to: location)
//      try await untilSuccess(times: 5) { try await updateXPSQ8Status() }
//      await setXPSQ8Status(nil)
//      await until(await self.xpsq8State.groupStatus == .readyFromMotion)
    }
  }
  
  func moveRelative(in dimension: Dimension, by displacement: Double) async throws {
    try await with(.xpsq8) {
      try await stage(for: dimension).moveRelative(by: displacement)
    }
  }
  
  func position(in dimension: Dimension) async throws -> Double {
    try await reading(.xpsq8) {
      try await stage(for: dimension).currentPosition
    }
  }
}

// MARK: - Dimension
public extension PrinterController {
  enum Dimension: String, CaseIterable, Identifiable {
    case x = "X"
    case y = "Y"
    case z = "Z"
    
    public var id: String {
      rawValue
    }
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
