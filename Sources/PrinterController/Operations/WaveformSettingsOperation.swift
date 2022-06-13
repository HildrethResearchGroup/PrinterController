//
//  WaveformSettingsOperation.swift
//  WaveformSettingsOperation
//
//  Created by Connor Barnes on 9/20/21.
//

import SwiftUI

public struct WaveformSettingsConfiguration: Hashable, Codable {
	// TODO: Add ON State
  public var frequency: Double?
  public var amplitude: Double?
  public var offset: Double?
  public var phase: Double?
  public var waveFunction: WaveFunction?
  
  public init() { }
}

extension PrinterOperation {
  public static func waveformSettingsOperation<Body: View>(
    body: @escaping (Binding<WaveformSettingsConfiguration>) -> Body
  ) -> PrinterOperation<WaveformSettingsConfiguration, Body> {
    .init(
      kind: .waveformSettings,
      configuration: .init(),
      name: "Waveform Settings",
      thumbnailName: "waveform.path", body: body) { configuration, printerController in
        if let frequency = configuration.frequency {
          try await printerController.setFrequency(to: frequency)
        }
        
        if let amplitude = configuration.amplitude {
          try await printerController.setAmplifiedVoltage(to: amplitude)
        }
        
        if let offset = configuration.offset {
          try await printerController.setAmplifiedVoltageOffset(to: offset)
        }
        
        if let phase = configuration.phase {
          try await printerController.setPhase(to: phase)
        }
        
        if let waveFunction = configuration.waveFunction {
          try await printerController.setWaveFunction(to: waveFunction)
        }
      }
  }
}

//// MARK: Running
//extension WaveformSettingsConfiguration: PrinterOperationConfiguration {
//  func run(printerController: PrinterController) async throws {
//    if let frequency = frequency {
//      try await printerController.setFrequency(to: frequency)
//    }
//    
//    if let amplitude = amplitude {
//      try await printerController.setVoltage(to: amplitude)
//    }
//    
//    if let offset = offset {
//      try await printerController.setVoltageOffset(to: offset)
//    }
//    
//    if let phase = phase {
//      try await printerController.setPhase(to: phase)
//    }
//    
//    if let waveFunction = waveFunction {
//      try await printerController.setWaveFunction(to: waveFunction)
//    }
//  }
//}
//
//// MARK: - Binding
//public extension Binding where Value == PrinterOperation {
//  var waveformConfiguration: Binding<WaveformSettingsConfiguration> {
//    Binding<WaveformSettingsConfiguration> {
//      if case let .waveformSettings(configuration) = wrappedValue.operationType {
//        return configuration
//      } else {
//        return .init()
//      }
//    } set: { newValue in
//      wrappedValue.operationType = .waveformSettings(newValue)
//    }
//  }
//}
