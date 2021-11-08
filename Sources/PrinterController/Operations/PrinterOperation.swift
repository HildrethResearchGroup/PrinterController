//
//  PrinterOperation.swift
//  PrinterOperation
//
//  Created by Connor Barnes on 8/29/21.
//

import SwiftUI

public struct PrinterOperation<Configuration: Codable & Hashable, Body: View>: Identifiable {
  public let kind: AnyPrinterOperation.Kind
  public var configuration: Configuration
  public var isEnabled = true
  public var continueOnError = false
  public let id = UUID()
  
  let name: (Configuration) -> String
  let thumbnailName: (Configuration) -> String
  let run: (Configuration, PrinterController) async throws -> Void
  let body: (Binding<Configuration>) -> Body
  
  init(
    kind: AnyPrinterOperation.Kind,
    configuration: Configuration,
    name: String,
    thumbnailName: String,
    body: @escaping (Binding<Configuration>) -> Body,
    run: @escaping (Configuration, PrinterController) async throws -> Void
  ) {
    self.kind = kind
    self.configuration = configuration
    self.name = { _ in name}
    self.thumbnailName = { _ in thumbnailName }
    self.run = run
    self.body = body
  }
  
  init(
    kind: AnyPrinterOperation.Kind,
    configuration: Configuration,
    body: @escaping (Binding<Configuration>) -> Body,
    run: @escaping (Configuration, PrinterController) async throws -> Void,
    name: @escaping (Configuration) -> String,
    thumbnailName: @escaping (Configuration) -> String
  ) {
    self.kind = kind
    self.configuration = configuration
    self.name = name
    self.thumbnailName = thumbnailName
    self.run = run
    self.body = body
  }
}

extension PrinterOperation {
	struct Storage: Codable {
		var kind: AnyPrinterOperation.Kind
		var configuration: Configuration
		var isEnabled: Bool
		var continueOnError: Bool
		var id: UUID
	}
	
	
}
