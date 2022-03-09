//
//  GapHeightCalibrateOperation.swift
//  
//
//  Created by Connor Barnes on 2/14/22.
//

import SwiftUI

public struct GapHeightCalibrateOperationConfiguration: Codable, Hashable {
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
				guard var currentVoltage = await printerController.multimeterState.rawVoltage else {
					throw PrinterController.Error.instrumentNotInitialized
				}
				
				try await printerController.turnVoltageOn()
				
				while currentVoltage < configuration.targetVoltage {
					try await printerController.moveRelative(in: .z, by: configuration.displacementAmount)
					await printerController.waitFor(xpsq8Status: .readyFromMotion)
					
					guard let nextVoltage = try await printerController.multimeterController?.rawVoltage else {
						throw PrinterController.Error.instrumentNotInitialized
					}
					
					currentVoltage = nextVoltage
				}
				
				try await printerController.turnVoltageOff()
			}
	}
}
