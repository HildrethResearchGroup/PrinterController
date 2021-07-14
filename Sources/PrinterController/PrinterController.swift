//
//  PrinterController.swift
//  
//
//  Created by Connor Barnes on 7/13/21.
//

import XPSQ8Kit

public actor PrinterController {
  var waveformController: WaveformController?
  var xpsq8Controller: XPSQ8Controller?
}

// MARK: - Connecting to Instruments
public extension PrinterController {
  func connectToWaveform(configuration: WaveformConfiguration) async throws {
    waveformController = try await configuration.makeInstrument()
  }
  
  func connectToXPSQ8(configuration: XPSQ8Configuration) async throws {
    xpsq8Controller = try await configuration.makeInstrument()
  }
  
  func disconnectFromWaveform() async {
    waveformController = nil
  }
  
  func disconnectFromXPSQ8() async {
    xpsq8Controller = nil
  }
}
