//
//  PrinterController+Waveform.swift
//  PrinterController+Waveform
//
//  Created by Connor Barnes on 8/16/21.
//

import Foundation

public extension PrinterController {
  func setRawVoltage(to voltage: Double) async throws {
    try await with(.waveform) {
      try await waveformController?.setRawVoltage(to: voltage)
    }
  }
  
  func setRawVoltageOffset(to offset: Double) async throws {
    try await with(.waveform) {
      try await waveformController?.setRawVoltageOffset(to: offset)
    }
  }
	
	func setAmplifiedVoltage(to voltage: Double) async throws {
		try await with(.waveform) {
			try await waveformController?.setAmplifiedVoltage(to: voltage)
		}
	}
	
	func setAmplifiedVoltageOffset(to offset: Double) async throws {
		try await with(.waveform) {
			try await waveformController?.setAmplifiedVoltageOffset(to: offset)
		}
	}
  
  func setFrequency(to frequency: Double) async throws {
    try await with(.waveform) {
      try await waveformController?.setFrequency(to: frequency)
    }
  }
  
  func setPhase(to phase: Double) async throws {
    try await with(.waveform) {
      try await waveformController?.setPhase(to: phase)
    }
  }
  
  func setWaveFunction(to waveFunction: WaveFunction) async throws {
    try await with(.waveform) {
      try await waveformController?.setWaveFunction(to: waveFunction)
    }
  }
	
	func setImpedance(to impedance: Double) async throws {
		try await with(.waveform) {
			try await waveformController?.setImpedance(to: impedance)
		}
	}
  
  func turnVoltageOn() async throws {
    try await with(.waveform) {
			await setWaveformState(\.voltageIsOn, to: true)
      try await waveformController?.turnVoltageOn()
    }
  }
  
  func turnVoltageOff() async throws {
    try await with(.waveform) {
			await setWaveformState(\.voltageIsOn, to: false)
      try await waveformController?.turnVoltageOff()
    }
  }
}
