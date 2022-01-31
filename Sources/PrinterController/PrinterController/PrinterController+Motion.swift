//
//  PrinterController+Motion.swift
//  
//
//  Created by Connor Barnes on 7/13/21.
//

import XPSQ8Kit

public extension PrinterController {
	func reenableMovement() async throws {
		// Perform a zero move, to change the state back to ready from motion
		try await writeStage(for: .x).moveRelative(by: 0.0)
	}
	
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
      // Make sure SGammaParameters are set
      if let mode = await xpsq8State.displacementMode(for: dimension) {
        if await mode != xpsq8State.lastSetDisplacementMode(for: dimension) {
          let parameters: Stage.SGammaParameters = {
            switch mode {
            case .large:
              return (10, 100, 0.2, 0.2)
            case .medium:
              return (1, 10, 0.2, 0.2)
            case .small:
              return (0.1, 5, 0.2, 0.2)
            case .fine:
              return (0.01, 1, 0.2, 0.2)
            }
          }()
          
          try await writeStage(for: dimension).setSGammaParameters(parameters)
          await setXPSQ8LastSetDisplacementMode(in: dimension, to: mode)
        }
      }
      try await writeStage(for: dimension).moveAbsolute(to: location)
//      try await untilSuccess(times: 5) { try await updateXPSQ8Status() }
//      await setXPSQ8Status(nil)
//      await until(await self.xpsq8State.groupStatus == .readyFromMotion)
    }
  }
  
  func moveRelative(in dimension: Dimension, by displacement: Double) async throws {
    try await with(.xpsq8) {
      // Make sure SGammaParameters are set
      if let mode = await xpsq8State.displacementMode(for: dimension) {
        if await mode != xpsq8State.lastSetDisplacementMode(for: dimension) {
          let parameters: Stage.SGammaParameters = {
            switch mode {
            case .large:
              return (10, 100, 0.2, 0.2)
            case .medium:
              return (1, 10, 0.2, 0.2)
            case .small:
              return (0.1, 5, 0.2, 0.2)
            case .fine:
              return (0.01, 1, 0.2, 0.2)
            }
          }()
          
          try await writeStage(for: dimension).setSGammaParameters(parameters)
          await setXPSQ8LastSetDisplacementMode(in: dimension, to: mode)
        }
      }
      try await writeStage(for: dimension).moveRelative(by: displacement)
    }
  }
  
  func position(in dimension: Dimension) async throws -> Double {
    try await reading(.xpsq8) {
      try await readStage(for: dimension).currentPosition
    }
  }
  
  func setSGammaParamaters(
    in dimension: Dimension,
    forDisplacementMode displacementMode: DisplacementMode
  ) async throws {
    try await with(.xpsq8) {
      let parameters: Stage.SGammaParameters = {
        switch displacementMode {
        case .large:
          return (10, 100, 0.2, 0.2)
        case .medium:
          return (1, 10, 0.2, 0.2)
        case .small:
          return (0.1, 5, 0.2, 0.2)
        case .fine:
          return (0.01, 1, 0.2, 0.2)
        }
      }()
      
      try await writeStage(for: dimension).setSGammaParameters(parameters)
    }
  }
  
  func abortAllMoves() async throws {
    try await with(.xpsq8) {
      try await stageGroup.abortAllMoves()
    }
  }
}

// MARK: - Dimension
public extension PrinterController {
  enum Dimension: String, CaseIterable, Codable, Hashable, Identifiable {
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
    get async throws {
			guard let controller = xpsq8CollectiveController else {
        throw Error.instrumentNotConnected
      }
      
			return try await controller.readController(for: "M").makeStageGroup(named: "M")
    }
  }
  
  func readStage(for dimension: Dimension) async throws -> Stage {
		guard let collectiveController = xpsq8CollectiveController else {
			throw Error.instrumentNotConnected
		}
		
		return try await collectiveController
			.readController(for: "M.\(dimension.rawValue)")
			.makeStageGroup(named: "M")
			.makeStage(named: dimension.rawValue)
  }
	
	func writeStage(for dimension: Dimension) async throws -> Stage {
		guard let collectiveController = xpsq8CollectiveController else {
			throw Error.instrumentNotConnected
		}
		
		return try await collectiveController
			.writeController(for: "M.\(dimension.rawValue)")
			.makeStageGroup(named: "M")
			.makeStage(named: dimension.rawValue)
	}
}
