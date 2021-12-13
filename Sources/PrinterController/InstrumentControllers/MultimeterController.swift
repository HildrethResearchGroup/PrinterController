//
//  MultimeterController.swift
//  
//
//  Created by Connor Barnes on 12/13/21.
//

import Foundation
import SwiftVISASwift

public actor MultimeterController {
	var instrument: MessageBasedInstrument
	
	init(instrument: MessageBasedInstrument) {
		self.instrument = instrument
	}
}
