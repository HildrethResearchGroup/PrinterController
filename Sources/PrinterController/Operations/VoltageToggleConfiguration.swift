//
//  voltageToggleConfiguration.swift
//  voltageToggleConfiguration
//
//  Created by Connor Barnes on 9/12/21.
//

import SwiftUI

public struct VoltageToggleConfiguration: Hashable, Codable {
  public var turnOn = true
  
  public init() { }
}

// MARK: Running
extension VoltageToggleConfiguration: PrinterOperationConfiguration {
  func run(printerController: PrinterController) async throws {
    if turnOn {
      try await printerController.turnVoltageOn()
    } else {
      try await printerController.turnVoltageOff()
    }
  }
}

// MARK: Binding
public extension Binding where Value == PrinterOperation {
  var voltageConfiguration: Binding<VoltageToggleConfiguration> {
    Binding<VoltageToggleConfiguration> {
      if case let .voltageToggle(configuration) = wrappedValue.operationType {
        return configuration
      } else {
        return .init()
      }
    } set: { newValue in
      wrappedValue.operationType = .voltageToggle(newValue)
    }
  }
}
