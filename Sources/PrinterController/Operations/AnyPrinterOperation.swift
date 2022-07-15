//
//  AnyPrinterOperation.swift
//  
//
//  Created by Connor Barnes on 10/19/21.
//

import SwiftUI

public struct AnyPrinterOperation: Identifiable {
  public let kind: Kind
  public var configuration: Any
  public var isEnabled: Bool
  public var continueOnError: Bool
  public let id: UUID
  
  let _name: (Any) -> String
  let _thumbnailName: (Any) -> String
  let _run: (Any, PrinterController) async throws -> Void
  let _body: (Binding<Any>) -> AnyView
  
  public var name: String {
    _name(configuration)
  }
  
  public var thumbnailName: String {
    _thumbnailName(configuration)
  }
  
  public func run(printerController: PrinterController) async throws {
    try await _run(configuration, printerController)
  }
  
  public func body(configuration: Binding<Any>) -> AnyView {
    _body(configuration)
  }
  
  init(
    kind: Kind,
    configuration: Any,
    isEnabled: Bool,
    continueOnError: Bool,
    id: UUID
  ) {
    self.kind = kind
    self.configuration = configuration
    self.isEnabled = isEnabled
    self.continueOnError = continueOnError
    self.id = id
    _name = DynamicDispatch.shared.dispatchName(forKind: kind)
    _thumbnailName = DynamicDispatch.shared.dispatchThumbnailName(forKind: kind)
    _run = DynamicDispatch.shared.dispatchRun(forKind: kind)
    _body = DynamicDispatch.shared.dispatchBody(forKind: kind)
  }
  
  public init<Configuration: Codable & Hashable, Body: View>(
    _ printerOperation: PrinterOperation<Configuration, Body>
  ) {
    kind = printerOperation.kind
    configuration = printerOperation.configuration
    isEnabled = printerOperation.isEnabled
    continueOnError = printerOperation.continueOnError
    id = printerOperation.id
    
    _name = { configuration in
      printerOperation.name(configuration as! Configuration)
    }
    
    _thumbnailName = { configuration in
      printerOperation.thumbnailName(configuration as! Configuration)
    }
    
    _run = { configuration, printerController in
      try await printerOperation.run(configuration as! Configuration, printerController)
    }
    
    _body = { configuration in
      let binding = Binding {
        configuration.wrappedValue as! Configuration
      } set: { newValue in
        configuration.wrappedValue = newValue
      }
      
      return AnyView(printerOperation.body(binding))
    }
  }
}

// MARK: Kind
extension AnyPrinterOperation {
  public enum Kind: Codable, Hashable, CaseIterable {
    case comment
    case voltageToggle
    case waveformSettings
		case home
		case alert
		case wait
		case move
		case printLine
		case gapHeightCalibrate
		case printDotArray
  }
}

// MARK: Codable
extension AnyPrinterOperation: Codable {
  enum CodingKeys: String, CodingKey {
    case kind
    case configuration
    case isEnabled
    case continueOnError
    case id
  }
  
  public func encode(to encoder: Encoder) throws {
    let encode = DynamicDispatch.shared.dispatchEncode(forKind: kind)
    return try encode(kind, configuration, isEnabled, continueOnError, id, encoder)
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let kind = try values.decode(Kind.self, forKey: .kind)
    
    let decode = DynamicDispatch.shared.dispatchDecode(forKind: kind)
    self = try decode(decoder)
  }
}

// MARK: Hashable
extension AnyPrinterOperation: Hashable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
