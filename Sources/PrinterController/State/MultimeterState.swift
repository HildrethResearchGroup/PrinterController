//
//  MultimeterState.swift
//  
//
//  Created by Connor Barnes on 12/13/21.
//

import Foundation

public struct MultimeterState {
	public var updateInterval: TimeInterval? = 0.2
	
	public internal(set) var rawResistance: Double?
}
