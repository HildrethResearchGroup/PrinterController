//
//  WaveformController+Waveforms.swift
//  WaveformController+Waveforms
//
//  Created by Connor Barnes on 8/16/21.
//

import Cocoa

extension WaveformController {
  var voltage: Double {
    get async throws {
      try await instrument.query("VOLT?", as: Double.self)
    }
  }
  
  var voltageOffset: Double {
    get async throws {
      try await instrument.query("VOLT:OFFS?", as: Double.self)
    }
  }
  
  var frequency: Double {
    get async throws {
      try await instrument.query("FREQ?", as: Double.self)
    }
  }
  
  var phase: Double {
    get async throws {
      try await instrument.query("PHAS?", as: Double.self)
    }
  }
  
  var waveFunction: WaveFunction {
    get async throws {
      let string = try await instrument.query("FUNC?")
      if let waveFunction = WaveFunction(rawValue: string) {
        return waveFunction
      } else {
        throw WaveFunction.Error.unknownFunction
      }
    }
  }
  
  func setVoltage(to voltage: Double) async throws {
    try await instrument.write("VOLT \(voltage)")
  }
  
  func setVoltageOffset(to offset: Double) async throws {
    try await instrument.write("VOLT:OFFS \(offset)")
  }
  
  func setFrequency(to frequency: Double) async throws {
    try await instrument.write("FREQ \(frequency)")
  }
  
  func setPhase(to phase: Double) async throws {
    try await instrument.write("PHAS \(phase)")
  }
  
  func setWaveFunction(to waveFunction: WaveFunction) async throws {
    try await instrument.write("FUNC \(waveFunction.rawValue)")
  }
  
  func turnVoltageOn() async throws {
    try await instrument.write("OUTPUT ON")
  }
  
  func turnVoltageOff() async throws {
    try await instrument.write("OUTPUT OFF")
  }
}
