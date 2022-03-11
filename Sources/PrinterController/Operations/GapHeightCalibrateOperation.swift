//
//  GapHeightCalibrateOperation.swift
//  
//
//  Created by Connor Barnes on 2/14/22.
//

import SwiftUI

public struct GapHeightCalibrateOperationConfiguration: Codable, Hashable {
	// TODO: Get rid of targetVoltage
	public var targetVoltage = 0.0
	public var displacementAmount = 0.01
	
	public init() {
		
	}
}

public extension PrinterOperation {
	static func gapHeightCalibrateOperation<Body: View>(
		body: @escaping (Binding<GapHeightCalibrateOperationConfiguration>) -> Body
	) -> PrinterOperation<GapHeightCalibrateOperationConfiguration, Body> {
		.init(
			kind: .gapHeightCalibrate,
			configuration: .init(),
			name: "Calibrate Gap Height",
			thumbnailName: "arrow.down.to.line",
			body: body) { configuration, printerController in
				guard var currentResistance = await printerController.multimeterState.rawResistance else {
					throw PrinterController.Error.instrumentNotInitialized
				}
				
				try await printerController.turnVoltageOff()
				
				while currentResistance == .infinity {
					try await printerController.moveRelative(in: .z, by: configuration.displacementAmount)
					await printerController.waitFor(xpsq8Status: .readyFromMotion)
					
					guard let nextResistance = try await printerController.multimeterController?.rawResistance else {
						throw PrinterController.Error.instrumentNotInitialized
					}
					
					currentResistance = nextResistance
				}
				
			}
	}
}
