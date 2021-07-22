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
}

// MARK: - Connecting to Instruments
public extension PrinterController {
  func connectToWaveform(configuration: WaveformConfiguration) async throws {
    do {
      await setState(instrument: .waveform, state: .connecting)
      sleep(1)
      waveformController = try await configuration.makeInstrument()
      await setState(instrument: .waveform, state: .ready)
    } catch {
      await setState(instrument: .waveform, state: .notConnected)
      throw error
    }
  }
  
  func connectToXPSQ8(configuration: XPSQ8Configuration) async throws {
    do {
      await setState(instrument: .xpsq8, state: .connecting)
      xpsq8Controller = try await configuration.makeInstrument()
      await setState(instrument: .xpsq8, state: .ready)
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

// MARK: - Instrument State
extension PrinterController {
  func with(
    _ instruments: Set<Instrument>,
    blocking blocked: Set<Instrument> = [],
    perform action: () async throws -> ()
  ) async {
    for instrument in instruments {
      await setState(instrument: instrument, state: .busy)
    }
    
    for instrument in blocked {
      await setState(instrument: instrument, state: .blocked)
    }
    
    try? await action()
    
    for instrument in instruments {
      await setState(instrument: instrument, state: .ready)
    }
    
    for instrument in blocked {
      await setState(instrument: instrument, state: .ready)
    }
  }
  
  func with(
    _ instrument: Instrument,
    blocking blocked: Set<Instrument> = [],
    perform action: () async throws -> ()
  ) async {
    await with([instrument], blocking: blocked, perform: action)
  }
  
  func with(
    _ instrument: Instrument,
    blocking blocked: Instrument,
    perform action: () async throws -> ()
  ) async {
    await with([instrument], blocking: [blocked], perform: action)
  }
  
  func with(
    _ instruments: Set<Instrument>,
    blocking blocked: Instrument,
    perform action: () async throws -> ()
  ) async {
    await with(instruments, blocking: [blocked], perform: action)
  }
}
