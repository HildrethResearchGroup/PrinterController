//
//  PrinterController+Waveform.swift
//  PrinterController+Waveform
//
//  Created by Connor Barnes on 8/16/21.
//

import Foundation

public extension PrinterController {
  func setVoltage(to voltage: Double) async throws {
    try await with(.waveform) {
      try await waveformController?.setVoltage(to: voltage)
    }
  }
  
  func setVoltageOffset(to offset: Double) async throws {
    try await with(.waveform) {
      try await waveformController?.setVoltageOffset(to: offset)
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
  
  func turnVoltageOn() async throws {
    try await with(.waveform) {
      try await waveformController?.turnVoltageOn()
    }
  }
  
  func turnVoltageOff() async throws {
    try await with(.waveform) {
      try await waveformController?.turnVoltageOff()
    }
  }
}
