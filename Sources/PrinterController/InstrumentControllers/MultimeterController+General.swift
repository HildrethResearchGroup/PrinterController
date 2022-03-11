//
//  MultimeterController+General.swift
//  
//
//  Created by Connor Barnes on 2/14/22.
//

import Foundation

extension MultimeterController {
	var rawResistance: Double {
		get async throws {
			try await instrument.write("CONF:RES")
			return try await instrument.query("READ?", as: Double.self)
		}
	}
	
}
