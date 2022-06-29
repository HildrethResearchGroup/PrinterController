//
//  WaitOperation.swift
//
//
//  Created by Connor Barnes on 11/28/21.
//

import SwiftUI

public struct WaitConfiguration: Codable, Hashable {
	public var time: TimeInterval = 1.0
	
	public init() { }
}

extension PrinterOperation {
	public static func waitOperation<Body: View>(
		body: @escaping (Binding<WaitConfiguration>) -> Body
	) -> PrinterOperation<WaitConfiguration, Body> {
		.init(
			kind: .wait,
			configuration: .init(),
			name: "Wait",
			thumbnailName: "clock",
			body: body
		) { configuration, printerController in
			// TODO: Add option to leave or turn off voltage
			//try? await printerController.turnVoltageOff()
			try await printerController.wait(for: configuration.time)
		}
	}
}
