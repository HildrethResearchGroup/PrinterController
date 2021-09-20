//
//  WaveformSettingsConfiguration.swift
//  WaveformSettingsConfiguration
//
//  Created by Connor Barnes on 9/20/21.
//

import SwiftUI

public struct WaveformSettingsConfiguration: Hashable, Codable {
  public var frequency: Double?
  public var amplitude: Double?
  public var offset: Double?
  public var phase: Double?
  public var waveFunction: WaveFunction?
  
  public init() { }
}

// MARK: Running
extension WaveformSettingsConfiguration: PrinterOperationConfiguration {
  func run(printerController: PrinterController) async throws {
    if let frequency = frequency {
      try await printerController.setFrequency(to: frequency)
    }
    
    if let amplitude = amplitude {
      try await printerController.setVoltage(to: amplitude)
    }
    
    if let offset = offset {
      try await printerController.setVoltageOffset(to: offset)
    }
    
    if let phase = phase {
      try await printerController.setPhase(to: phase)
    }
    
    if let waveFunction = waveFunction {
      try await printerController.setWaveFunction(to: waveFunction)
    }
  }
}

// MARK: - Binding
public extension Binding where Value == PrinterOperation {
  var waveformConfiguration: Binding<WaveformSettingsConfiguration> {
    Binding<WaveformSettingsConfiguration> {
      if case let .waveformSettings(configuration) = wrappedValue.operationType {
        return configuration
      } else {
        return .init()
      }
    } set: { newValue in
      wrappedValue.operationType = .waveformSettings(newValue)
    }
  }
}
