//
//  CommentOperation.swift
//  CommentOperation
//
//  Created by Connor Barnes on 10/11/21.
//

import SwiftUI

public struct CommentConfiguration: Hashable, Codable {
  public var comment = "Comment"
  
  public init() { }
}

extension PrinterOperation {
  public static func commentOperation<Body: View>(
    body: @escaping (Binding<CommentConfiguration>) -> Body
  ) -> PrinterOperation<CommentConfiguration, Body> {
    .init(
      kind: .comment,
      configuration: .init(),
      body: body
    ) { _, _ in
        // Do nothing (just comment)
      } name: { configuration in
        configuration.comment
      } thumbnailName: { _ in
        "text.bubble.fill"
      }
  }
}
