//
//  WaveformController.swift
//  
//
//  Created by Connor Barnes on 7/13/21.
//

import Foundation
import SwiftVISASwift

public actor WaveformController {
  var instrument: MessageBasedInstrument
  
  init(instrument: MessageBasedInstrument) {
    self.instrument = instrument
  }
}

