//
//  WaveformState.swift
//  WaveformState
//
//  Created by Connor Barnes on 8/16/21.
//

import Foundation

public struct WaveformState {
  public var updateInterval: TimeInterval? = 0.2
  
  public internal(set) var rawVoltage: Double?
  public internal(set) var rawVoltageOffset: Double?
  public internal(set) var frequency: Double?
  public internal(set) var phase: Double?
  public internal(set) var waveFunction: WaveFunction?
	public internal(set) var impedance: Double?
	public internal(set) var voltageIsOn: Bool?
	
	public var amplifiedVoltage: Double? {
		rawVoltage.flatMap { $0 * 1000 }
	}
	
	public var amplifiedVoltageOffset: Double? {
		rawVoltageOffset.flatMap { $0 * 1000 }
	}
}
