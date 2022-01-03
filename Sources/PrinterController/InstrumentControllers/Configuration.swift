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
public struct VISAEthernetConfiguration {
  public var address: String
  public var port: Int
  public var timeout: TimeInterval = 5.0
  public var attributes = MessageBasedInstrumentAttributes()
  
  public init(
    address: String,
    port: Int,
    timeout: TimeInterval = 5.0,
    attributes: MessageBasedInstrumentAttributes = .init()
  ) {
    self.address = address
    self.port = port
    self.timeout = timeout
    self.attributes = attributes
  }
  
  public static var empty: VISAEthernetConfiguration {
    return .init(address: "0.0.0.0", port: 5025)
  }
  
  func makeInstrument() async throws -> MessageBasedInstrument {
    var instrument = try await InstrumentManager.shared.instrumentAt(
      address: address,
      port: port,
      timeout: timeout
    )
    instrument.attributes = attributes
    return instrument
  }
}

// MARK: - XPSQ8 Configuration
public struct XPSQ8Configuration: Sendable {
  public var address: String
  public var port: Int
  public var timeout: TimeInterval = 5.0
  
  public init(
    address: String,
    port: Int,
    timeout: TimeInterval = 5.0
  ) {
    self.address = address
    self.port = port
    self.timeout = timeout
  }
  
  public static var empty: XPSQ8Configuration {
    return .init(address: "0.0.0.0", port: 5001)
  }
  
  func makeInstrument() async throws -> XPSQ8CollectiveController {
    try await XPSQ8CollectiveController(address: address, port: port, timeout: timeout)
  }
}
