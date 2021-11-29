//
//  AlertOperation.swift
//  
//
//  Created by Connor Barnes on 11/28/21.
//

import SwiftUI

public struct AlertConfiguration: Codable, Hashable {
	public var comment: String = "Note"
	
	public init() { }
}

extension PrinterOperation {
	public static func alertOperation<Body: View>(
		body: @escaping (Binding<AlertConfiguration>) -> Body
	) -> PrinterOperation<AlertConfiguration, Body> {
		.init(
			kind: .alert,
			configuration: .init(),
			name: "Alert",
			thumbnailName: "exclamationmark.triangle",
			body: body
		) { configuration, printerController in
			try? await printerController.turnVoltageOff()
			try await printerController.waitForModal(withComment: configuration.comment)
		}
	}
}
