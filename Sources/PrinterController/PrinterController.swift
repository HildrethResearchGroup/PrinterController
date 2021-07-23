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
  @Published public var xpsq8State = InstrumentState.notConnected
  
  @MainActor
  @Published public var waveformState = InstrumentState.notConnected
  
  public init() {
    
  }
}

extension PrinterController {
  enum Instrument {
    case xpsq8
    case waveform
  }
  
  @MainActor
  fileprivate func setState(instrument: Instrument, state: InstrumentState) {
    switch instrument {
    case .xpsq8:
      xpsq8State = state
    case .waveform:
      waveformState = state
    }
  }
  
  @MainActor
  fileprivate func state(for instrument: Instrument) -> InstrumentState {
    switch instrument {
    case .xpsq8:
      return xpsq8State
    case .waveform:
      return waveformState
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
		try await xpsq8Controller?.restart()
		try await stageGroup.initialize()
    try await searchForHome()
    await setState(instrument: .xpsq8, state: .ready)
  }
}

// MARK: - Instrument State
extension PrinterController {
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
    
    let result = try await action()
    
    for instrument in instruments {
      await setState(instrument: instrument, state: .ready)
    }
    
    for instrument in blocked {
      await setState(instrument: instrument, state: .ready)
    }
    
    return result
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
