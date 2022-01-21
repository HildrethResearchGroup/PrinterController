//
//  PrintLineOperation.swift
//  
//
//  Created by Connor Barnes on 1/21/22.
//

import SwiftUI

public struct PrintLineConfiguration: Codable, Hashable {
	public var dimension: PrinterController.Dimension = .x
	public var lineLength: Double = 1.0
	public var voltage: Double = 1.0
	public var numberOfLayers: Int = 1
	
	public init() { }
}

extension PrinterOperation {
	public static func printLineOperation<Body: View>(
		body: @escaping (Binding<PrintLineConfiguration>) -> Body
	) -> PrinterOperation<PrintLineConfiguration, Body> {
		.init(
			kind: .printLine,
			configuration: .init(),
			name: "Print Line",
			thumbnailName: "line.diagonal",
			body: body
		) { configuration, printerController in
			let startingPosition = try await printerController.position(in: configuration.dimension)
			try await printerController.setVoltage(to: configuration.voltage)
			
			for _ in 0..<configuration.numberOfLayers {
				try await printerController.moveAbsolute(in: configuration.dimension, to: startingPosition)
				await printerController.waitFor(xpsq8Status: .readyFromMotion)
				try await printerController.turnVoltageOn()
				
				try await printerController.moveRelative(in: configuration.dimension, by: configuration.lineLength)
				await printerController.waitFor(xpsq8Status: .readyFromMotion)
				try await printerController.turnVoltageOff()
			}
		}
	}
}
