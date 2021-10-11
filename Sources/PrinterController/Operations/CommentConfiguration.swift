//
//  CommentConfiguration.swift
//  CommentConfiguration
//
//  Created by Connor Barnes on 10/11/21.
//

import SwiftUI

public struct CommentConfiguration: Hashable, Codable {
  public var comment = "Comment"
  
  public init() { }
}

// MARK: - Running
extension CommentConfiguration: PrinterOperationConfiguration {
  func run(printerController: PrinterController) async throws {
    // Do nothing
  }
}

// MARK: - Binding
public extension Binding where Value == PrinterOperation {
  var commentConfiguration: Binding<CommentConfiguration> {
    Binding<CommentConfiguration> {
      if case let .comment(configuration) = wrappedValue.operationType {
        return configuration
      } else {
        return .init()
      }
    } set: { newValue in
      wrappedValue.operationType = .comment(newValue)
    }
  }
}
