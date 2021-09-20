//
//  WaveformState.swift
//  WaveformState
//
//  Created by Connor Barnes on 8/16/21.
//

import Foundation

public struct WaveformState {
  public var updateInterval: TimeInterval? = 0.2
  
  public internal(set) var voltage: Double?
  public internal(set) var voltageOffset: Double?
  public internal(set) var frequency: Double?
  public internal(set) var phase: Double?
  public internal(set) var waveFunction: WaveFunction?
}
