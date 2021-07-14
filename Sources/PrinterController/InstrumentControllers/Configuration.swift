//
//  Configuration.swift
//  
//
//  Created by Connor Barnes on 7/13/21.
//

import Foundation
import SwiftVISASwift
import XPSQ8Kit

// MARK: - Waveform Configuration
public struct WaveformConfiguration {
  public var address: String
  public var port: Int
  public var timeout: TimeInterval = 5.0
  public var attributes = MessageBasedInstrumentAttributes()
  
  public static var empty: WaveformConfiguration {
    return .init(address: "0.0.0.0", port: 5025)
  }
  
  func makeInstrument() async throws -> WaveformController {
    var instrument = try await InstrumentManager.shared.instrumentAt(
      address: address,
      port: port,
      timeout: timeout
    )
    instrument.attributes = attributes
    return WaveformController(instrument: instrument)
  }
}

// MARK: - XPSQ8 Configuration
public struct XPSQ8Configuration: Sendable {
  public var address: String
  public var port: Int
  public var timeout: TimeInterval = 5.0
  
  public static var empty: XPSQ8Configuration {
    return .init(address: "0.0.0.0", port: 5001)
  }
  
  func makeInstrument() async throws -> XPSQ8Controller {
    try await XPSQ8Controller(address: address, port: port, timeout: timeout)
  }
}
