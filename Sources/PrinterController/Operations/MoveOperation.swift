//
//  MoveOperation.swift
//
//
//  Created by Connor Barnes on 11/28/21.
//

import SwiftUI

public struct MoveConfiguration: Codable, Hashable {
	public var isAbsolute = false
	public var x = 0.0
	public var y = 0.0
	public var z = 0.0
	
	public init() { }
}

extension PrinterOperation {
	public static func moveOperation<Body: View>(
		body: @escaping (Binding<MoveConfiguration>) -> Body
	) -> PrinterOperation<MoveConfiguration, Body> {
		.init(
			kind: .move,
			configuration: .init(),
			name: "Move",
			thumbnailName: "move.3d",
			body: body
		) { configuration, printerController in
			if configuration.isAbsolute {
				try await printerController.moveAbsolute(in: .x, to: configuration.x)
				try await printerController.moveAbsolute(in: .y, to: configuration.y)
				try await printerController.moveAbsolute(in: .z, to: configuration.z)
			} else {
				try await printerController.moveRelative(in: .x, by: configuration.x)
				try await printerController.moveRelative(in: .y, by: configuration.y)
				try await printerController.moveRelative(in: .z, by: configuration.z)
			}
		}
	}
}
