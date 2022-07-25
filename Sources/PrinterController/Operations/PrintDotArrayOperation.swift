//
//  PrintDotArrayOperation.swift
//  
//
//  Created by Connor Barnes on 7/15/22.
//

import SwiftUI

public struct PrintDotArrayConfiguration: Codable, Hashable {
	public var spacing: Double = 1.0
	public var voltage: Double = 1.0
	public var voltageTime: Double = 0.1
	//public var numberOfDots: Int = 1
    //collin
    public var numberOfXDots: Int = 1
    public var numberOfYDots: Int = 1
    //add in dot row control
    
    
	public var numberOfLayers: Int = 1
	
	public init() { }
}

extension PrinterOperation {
	public static func printDotArrayOperation<Body: View>(
		body: @escaping (Binding<PrintDotArrayConfiguration>) -> Body
	) -> PrinterOperation<PrintDotArrayConfiguration, Body> {
		.init(
			kind: .printDotArray,
			configuration: .init(),
			name: "Print Dot Array",
			thumbnailName: "circle.dotted",
			body: body
		) { configuration, printerController in
			// Print the dot array
			let startX = try await printerController.position(in: .x)
			let startY = try await printerController.position(in: .y)
			
			for _ in 0..<configuration.numberOfLayers {
				for _ in 0..<configuration.numberOfYDots {
					for _ in 0..<configuration.numberOfXDots {
						// Columns
						try await printerController.turnVoltageOn()
						try await Task.sleep(nanoseconds: UInt64(configuration.voltageTime * 1_000_000_000))
						try await printerController.turnVoltageOff()
						try await printerController.moveRelative(in: .x, by: configuration.spacing)
					}
					try await printerController.moveAbsolute(in: .x, to: startX)
					try await printerController.moveRelative(in: .y, by: configuration.spacing)
				}
				try await printerController.moveAbsolute(in: .x, to: startX)
				try await printerController.moveAbsolute(in: .y, to: startY)
			}
		}
	}
}
