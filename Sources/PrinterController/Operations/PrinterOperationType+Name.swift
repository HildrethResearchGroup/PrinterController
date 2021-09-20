//
//  PrinterOperationType+Name.swift
//  PrinterOperationType+Name
//
//  Created by Connor Barnes on 9/12/21.
//

extension PrinterOperationType {
  public var name: String {
    switch self {
    case .voltageToggle(_):
      return "Voltage Toggle"
    case .waveformSettings(_):
      return "Waveform Settings"
    }
  }
}
