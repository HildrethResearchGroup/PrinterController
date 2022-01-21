//
//  PrinterController.swift
//  
//
//  Created by Connor Barnes on 7/13/21.
//

import XPSQ8Kit
import SwiftUI

public actor PrinterController: ObservableObject {
//	var xpsq8Controller: XPSQ8Controller?
  var waveformController: WaveformController?
	var multimeterController: MultimeterController?
	var xpsq8CollectiveController: XPSQ8CollectiveController?
  
  @MainActor
  @Published public var xpsq8ConnectionState = CommunicationState.notConnected
  
  @MainActor
  @Published public var waveformConnectionState = CommunicationState.notConnected
	
	@MainActor
	@Published public var multimeterConnectionState = CommunicationState.notConnected
  
  @MainActor
  @Published public var xpsq8State = XPSQ8State()
  
  @MainActor
  @Published public var waveformState = WaveformState()
	
	@MainActor
	@Published public var multimeterState = MultimeterState()
  
  @MainActor
  @Published public var printerQueueState = PrinterQueueState()
  
  @MainActor
	@Published public var updateInterval: TimeInterval? = 0.2
  
  public init() async {
    Task {
      await withTaskGroup(of: Void.self) { taskGroup in
        taskGroup.addTask {
          while true {
						try? await self.updateXPSQ8State()
						try? await Task.sleep(nanoseconds: UInt64(1e9 * (self.updateInterval ?? 1.0)))
          }
        }
				
				taskGroup.addTask {
					while true {
						try? await self.updateWaveformState()
						try? await Task.sleep(nanoseconds: UInt64(1e9 * (self.updateInterval ?? 1.0)))
					}
				}
				
				taskGroup.addTask {
					while true {
						try? await self.updateMultimeterState()
						try? await Task.sleep(nanoseconds: UInt64(1e9 * (self.updateInterval ?? 1.0)))
					}
				}
      }
    }
  }
	
	private init() {
		
	}
	
	public static var staticPreview: PrinterController {
		.init()
	}
}

// MARK: - Connecting to Instruments
public extension PrinterController {
  func connectToWaveform(configuration: VISAEthernetConfiguration) async throws {
    do {
      await setState(instrument: .waveform, state: .connecting)
      sleep(1)
      waveformController = try await WaveformController(instrument: configuration.makeInstrument())
      await setState(instrument: .waveform, state: .notInitialized)
    } catch {
      await setState(instrument: .waveform, state: .notConnected)
      throw error
    }
  }
  
  func connectToXPSQ8(configuration: XPSQ8Configuration) async throws {
    do {
      await setState(instrument: .xpsq8, state: .connecting)
      xpsq8CollectiveController = try await configuration.makeInstrument()
      await setState(instrument: .xpsq8, state: .notInitialized)
    } catch {
      await setState(instrument: .xpsq8, state: .notConnected)
      throw error
    }
  }
	
	func connectToMultimeter(configuration: VISAEthernetConfiguration) async throws {
		do {
			await setState(instrument: .multimeter, state: .connecting)
			sleep(1)
			multimeterController = try await MultimeterController(instrument: configuration.makeInstrument())
			await setState(instrument: .multimeter, state: .notInitialized)
		} catch {
			await setState(instrument: .multimeter, state: .notConnected)
			throw error
		}
	}
  
  func disconnectFromWaveform() async {
    waveformController = nil
    await setState(instrument: .waveform, state: .notConnected)
  }
  
  func disconnectFromXPSQ8() async {
    xpsq8CollectiveController = nil
    await setState(instrument: .waveform, state: .notConnected)
  }
	
	func disconnectFromMultimeter() async {
		multimeterController = nil
		await setState(instrument: .multimeter, state: .notConnected)
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
	
	func initializeMultimeter() async throws {
		// TODO: Implement
		await setState(instrument: .multimeter, state: .ready)
	}
}
