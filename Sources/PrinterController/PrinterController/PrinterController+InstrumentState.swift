//
//  PrinterController+InstrumentState.swift
//  PrinterController+InstrumentState
//
//  Created by Connor Barnes on 8/29/21.
//

import XPSQ8Kit

extension PrinterController {
  func updateXPSQ8State() async throws {
    try await setXPSQ8Status(stageGroup.status)
    for dimension in Dimension.allCases {
      try await setXPSQ8Position(in: dimension, position(in: dimension))
    }
  }
  
  func updateWaveformState() async throws {
    try await setWaveformState(\.voltage, to: waveformController?.voltage)
    try await setWaveformState(\.voltageOffset, to: waveformController?.voltageOffset)
    try await setWaveformState(\.frequency, to: waveformController?.frequency)
    try await setWaveformState(\.phase, to: waveformController?.phase)
    try await setWaveformState(\.waveFunction, to: waveformController?.waveFunction)
  }
  
  @MainActor
  func setWaveformState<T>(_ keypath: WritableKeyPath<WaveformState, T>, to value: T) {
    waveformState[keyPath: keypath] = value
  }
  
  @MainActor
  func setPrinterQueueState<T>(_ keypath: WritableKeyPath<PrinterQueueState, T>, to value: T) {
    printerQueueState[keyPath: keypath] = value
  }
  
  @MainActor
  func setXPSQ8LastSetDisplacementMode(in dimension: Dimension, to displacementMode: DisplacementMode) {
    switch dimension {
    case .x:
      xpsq8State.xLastSetDisplacementMode = displacementMode
    case .y:
      xpsq8State.yLastSetDisplacementMode = displacementMode
    case .z:
      xpsq8State.zLastSetDisplacementMode = displacementMode
    }
  }
  
  @MainActor
  func setXPSQ8Status(_ status: StageGroup.Status?) {
    if xpsq8State.canUpdateGroupStatus {
      xpsq8State.groupStatus = status
    }
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
  func setXPSQ8CanUpdateGroupState(_ value: Bool) {
    xpsq8State.canUpdateGroupStatus = value
  }
  
  @MainActor
  func setState(instrument: Instrument, state: CommunicationState) {
    switch instrument {
    case .xpsq8:
      xpsq8ConnectionState = state
    case .waveform:
      waveformConnectionState = state
    }
  }
  
  @MainActor
  func state(for instrument: Instrument) -> CommunicationState {
    switch instrument {
    case .xpsq8:
      return xpsq8ConnectionState
    case .waveform:
      return waveformConnectionState
    }
  }
}

// MARK: - Instrument State Management
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
    
    let invalidateXPSQ8State = instruments.contains(.xpsq8) || blocked.contains(.xpsq8)
    
    if invalidateXPSQ8State {
      await setXPSQ8CanUpdateGroupState(false)
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
    
    if invalidateXPSQ8State {
      await setXPSQ8CanUpdateGroupState(true)
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