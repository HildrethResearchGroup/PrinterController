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
			let locations = zip([PrinterController.Dimension.x, .y, .z],
													[configuration.x, configuration.y, configuration.z])
			
			if configuration.isAbsolute {
				for (dimension, position) in locations {
					try await printerController.moveAbsolute(in: dimension, to: position)
					await printerController.waitFor(xpsq8Status: .readyFromMotion)
				}
			} else {
				for (dimension, position) in locations {
					try await printerController.moveRelative(in: dimension, by: position)
					await printerController.waitFor(xpsq8Status: .readyFromMotion)
				}
			}
		}
	}
}
