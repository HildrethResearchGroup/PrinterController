//
//  MultimeterController+General.swift
//  
//
//  Created by Connor Barnes on 2/14/22.
//

import Foundation

extension MultimeterController {
	var rawVoltage: Double {
		get async throws {
			try await instrument.write("CONF:VOLT:DC AUTO")
			try await instrument.write("SAMP:COUN 1")
			return try await instrument.query("READ?", as: Double.self)
		}
	}
}
