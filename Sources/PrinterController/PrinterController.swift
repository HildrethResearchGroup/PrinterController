//
//  PrinterController.swift
//  
//
//  Created by Connor Barnes on 7/13/21.
//

import XPSQ8Kit
import SwiftUI

public actor PrinterController: ObservableObject {
  var waveformController: WaveformController?
  var xpsq8Controller: XPSQ8Controller?
  
  @MainActor
  @Published public var xpsq8ConnectionState = CommunicationState.notConnected
  
  @MainActor
  @Published public var waveformConnectionState = CommunicationState.notConnected
  
  @MainActor
  @Published public var xpsq8State = XPSQ8State()
  
  public init() {
    Task {
      while true {
        if await xpsq8State.updateInterval != nil {
//          if await [CommunicationState.ready, .reading].contains(xpsq8ConnectionState) {
            try? await updateXPSQ8Status()
//          }
        }
        
        await Task.sleep(UInt64(1e9 * (xpsq8State.updateInterval ?? 1.0)))
      }
    }
  }
}

extension PrinterController {
  enum Instrument {
    case xpsq8
    case waveform
  }
  
  func updateXPSQ8Status() async throws {
    try await setXPSQ8Status(stageGroup.status)
    for dimension in Dimension.allCases {
      try await setXPSQ8Position(in: dimension, position(in: dimension))
    }
  }
  
  @MainActor
  func setXPSQ8Status(_ status: StageGroup.Status?) {
    xpsq8State.groupStatus = status
  }
  
  @MainActor
  func setXPSQ8Position(in dimension: Dimension, _ position: Double?) {
    switch dimension {
    case .x:
      xpsq8State.xPosition = position
    case .y:
      xpsq8State.yPosition = position
    case .z:
      xpsq8State.zPosition = position
    }
  }
  
  @MainActor
  fileprivate func setState(instrument: Instrument, state: CommunicationState) {
    switch instrument {
    case .xpsq8:
      xpsq8ConnectionState = state
    case .waveform:
      waveformConnectionState = state
    }
  }
  
  @MainActor
  fileprivate func state(for instrument: Instrument) -> CommunicationState {
    switch instrument {
    case .xpsq8:
      return xpsq8ConnectionState
    case .waveform:
      return waveformConnectionState
    }
  }
}

// MARK: - Connecting to Instruments
public extension PrinterController {
  func connectToWaveform(configuration: WaveformConfiguration) async throws {
    do {
      await setState(instrument: .waveform, state: .connecting)
      sleep(1)
      waveformController = try await configuration.makeInstrument()
      await setState(instrument: .waveform, state: .notInitialized)
    } catch {
      await setState(instrument: .waveform, state: .notConnected)
      throw error
    }
  }
  
  func connectToXPSQ8(configuration: XPSQ8Configuration) async throws {
    do {
      await setState(instrument: .xpsq8, state: .connecting)
      xpsq8Controller = try await configuration.makeInstrument()
      await setState(instrument: .xpsq8, state: .notInitialized)
    } catch {
      await setState(instrument: .xpsq8, state: .notConnected)
      throw error
    }
  }
  
  func disconnectFromWaveform() async {
    waveformController = nil
    await setState(instrument: .waveform, state: .notConnected)
  }
  
  func disconnectFromXPSQ8() async {
    xpsq8Controller = nil
    await setState(instrument: .waveform, state: .notConnected)
  }
}

// MARK: - Initializing Instruments
public extension PrinterController {
  func initializeWaveform() async throws {
    // TODO: Implement
    await setState(instrument: .waveform, state: .ready)
  }
  
  func initializeXPSQ8() async throws {
//    guard let xpsq8Controller = xpsq8Controller else { throw Error.instrumentNotConnected }
//		try await xpsq8Controller.restart()
//    try await stageGroup.waitForStatus(.readyFromFocus)
//    try await print("Restarted: ", stageGroup.status)
//		try await stageGroup.initialize()
//    
//    try await stageGroup.waitForStatus(.notReferenced)
//    try await print("Initialized: ", stageGroup.status)
//    try await searchForHome()
//    try await stageGroup.waitForStatus(.readyFromHoming)
//    try await print("Homed: ", stageGroup.status)
    await setState(instrument: .xpsq8, state: .ready)
  }
}

// MARK: - Instrument State
extension PrinterController {
  func reading<T>(
    _ instruments: Set<Instrument>,
    perform action: () async throws -> T
  ) async throws -> T {
    for instrument in instruments {
      switch await state(for: instrument) {
      case .notConnected, .connecting:
        throw Error.instrumentNotConnected
      case .notInitialized:
        throw Error.instrumentNotInitialized
      case .busy:
        throw Error.instrumentBusy
      case .blocked:
        throw Error.instrumentBlocked
      default:
        break
      }
    }
    
    for instrument in instruments {
      await setState(instrument: instrument, state: .reading)
    }
    
    let result: Result<T, Swift.Error>
    
    do {
      let value =  try await action()
      result = .success(value)
    } catch {
      result = .failure(error)
    }
    
    for instrument in instruments {
      await setState(instrument: instrument, state: .ready)
    }
    
    return try result.get()
  }
  
  func reading<T>(
    _ instrument: Instrument,
    perform action: () async throws -> T
  ) async throws -> T {
    try await reading([instrument], perform: action)
  }
  
  func with<T>(
    _ instruments: Set<Instrument>,
    blocking blocked: Set<Instrument> = [],
    perform action: () async throws -> T
  ) async throws -> T {
    for instrument in instruments {
      switch await state(for: instrument) {
      case .notConnected, .connecting:
        throw Error.instrumentNotConnected
      case .notInitialized:
        throw Error.instrumentNotInitialized
      case .busy:
        throw Error.instrumentBusy
      case .blocked:
        throw Error.instrumentBlocked
      default:
        break
      }
    }
    
    for instrument in instruments {
      await setState(instrument: instrument, state: .busy)
    }
    
    for instrument in blocked {
      await setState(instrument: instrument, state: .blocked)
    }
    
    let result: Result<T, Swift.Error>
    
    do {
      let value =  try await action()
      result = .success(value)
    } catch {
      result = .failure(error)
    }
    
    for instrument in instruments {
      await setState(instrument: instrument, state: .ready)
    }
    
    for instrument in blocked {
      await setState(instrument: instrument, state: .ready)
    }
    
    return try result.get()
  }
  
  func with<T>(
    _ instrument: Instrument,
    blocking blocked: Set<Instrument> = [],
    perform action: () async throws -> T
  ) async throws -> T {
    return try await with([instrument], blocking: blocked, perform: action)
  }
  
  func with<T>(
    _ instrument: Instrument,
    blocking blocked: Instrument,
    perform action: () async throws -> T
  ) async throws -> T {
    return try await with([instrument], blocking: [blocked], perform: action)
  }
  
  func with<T>(
    _ instruments: Set<Instrument>,
    blocking blocked: Instrument,
    perform action: () async throws -> T
  ) async throws -> T {
    return try await with(instruments, blocking: [blocked], perform: action)
  }
}
