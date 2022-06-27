//
//  WaveformController+Waveforms.swift
//  WaveformController+Waveforms
//
//  Created by Connor Barnes on 8/16/21.
//

import Cocoa

extension WaveformController {
  var rawVoltage: Double {
    get async throws {
      try await instrument.query("VOLT?", as: Double.self)
    }
  }
  
  var rawVoltageOffset: Double {
    get async throws {
      try await instrument.query("VOLT:OFFS?", as: Double.self)
    }
  }
	
	var amplifiedVoltage: Double {
		get async throws {
			try await rawVoltage * 1000
		}
	}
  
	var amplifiedVoltageOffset: Double {
		get async throws {
			try await rawVoltageOffset * 1000
		}
	}
	
  var frequency: Double {
    get async throws {
      try await instrument.query("FREQ?", as: Double.self)
    }
  }
  
  var phase: Double {
    get async throws {
      try await instrument.query("PHAS?", as: Double.self)
    }
  }
  
  var waveFunction: WaveFunction {
    get async throws {
      let string = try await instrument.query("FUNC?")
      if let waveFunction = WaveFunction(rawValue: string) {
        return waveFunction
      } else {
        throw WaveFunction.Error.unknownFunction
      }
    }
  }
	
	var impedance: Double {
		get async throws {
			try await instrument.query("OUTPUT1:LOAD?", as: Double.self)
		}
	}
	
	var isOutputOn: Bool {
		get async throws {
			try await instrument.query("OUTPUT?", as: Bool.self)
		}
	}
  
  func setRawVoltage(to voltage: Double) async throws {
    try await instrument.write("VOLT \(voltage)")
  }
  
  func setRawVoltageOffset(to offset: Double) async throws {
    try await instrument.write("VOLT:OFFS \(offset)")
  }
	
	func setAmplifiedVoltage(to voltage: Double) async throws {
		try await setRawVoltage(to: voltage / 1000)
	}
	
	func setAmplifiedVoltageOffset(to offset: Double) async throws {
		try await setRawVoltageOffset(to: offset / 1000)
	}
  
  func setFrequency(to frequency: Double) async throws {
    try await instrument.write("FREQ \(frequency)")
  }
  
  func setPhase(to phase: Double) async throws {
    try await instrument.write("PHAS \(phase)")
  }
  
  func setWaveFunction(to waveFunction: WaveFunction) async throws {
    try await instrument.write("FUNC \(waveFunction.rawValue)")
  }
	
	func setImpedance(to impedance: Double) async throws {
		let string = impedance == .infinity ? "INF" : "\(impedance)"
		try await instrument.write("OUTPUT1:LOAD \(string)")
	}
  
  func turnVoltageOn() async throws {
    try await instrument.write("OUTPUT ON")
  }
  
  func turnVoltageOff() async throws {
    try await instrument.write("OUTPUT OFF")
  }
}
