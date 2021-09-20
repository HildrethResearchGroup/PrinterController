//
//  PrinterOperation.swift
//  PrinterOperation
//
//  Created by Connor Barnes on 8/29/21.
//

import SwiftUI

public struct PrinterOperation: Identifiable, Hashable, Codable {
  public var operationType: PrinterOperationType
  public var continueOnError = false
  public let id: UUID
  
  public init(operationType: PrinterOperationType, continueOnError: Bool = false) {
    self.operationType = operationType
    self.continueOnError = continueOnError
    id = UUID()
  }
  
  func run(printerController: PrinterController) async throws {
    switch operationType {
    case .voltageToggle(let configuration):
      try await configuration.run(printerController: printerController)
    }
  }
  
  public static var allEmptyOperations: [PrinterOperation] {
    [
      .init(operationType: .voltageToggle(.init()))
    ]
  }
}

// MARK: - PrinterOperationType
public enum PrinterOperationType: Hashable, Codable {
  case voltageToggle (VoltageToggleConfiguration)
}

// MARK: - PrinterOperationConfiguration
/// An internal protocol to guarantee that each operation's configuration has the necessary behavior
protocol PrinterOperationConfiguration: Hashable, Codable {
  func run(printerController: PrinterController) async throws
  
  init()
}
