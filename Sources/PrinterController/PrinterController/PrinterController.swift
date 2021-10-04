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
  
  @MainActor
  @Published public var waveformState = WaveformState()
  
  @MainActor
  @Published public var printerQueueState = PrinterQueueState()
  
  @MainActor
  @Published public var updateInterval: TimeInterval? = 0.2
  
  public init() {
    Task {
      await withTaskGroup(of: Void.self) { taskGroup in
        taskGroup.async {
          while true {
            try? await self.updateWaveformState()
            try? await self.updateXPSQ8State()
            await Task.sleep(UInt64(1e9 * (self.updateInterval ?? 1.0)))
          }
        }
      }
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
