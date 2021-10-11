//
//  PrinterOperationType+Thumbnail.swift
//  PrinterOperationType+Thumbnail
//
//  Created by Connor Barnes on 9/12/21.
//

extension PrinterOperationType {
  public var thumbnailImageName: String {
    switch self {
    case .voltageToggle(_):
      return "bolt.fill"
    case .waveformSettings(_):
      return "waveform.path"
    case.comment(_):
      return "text.bubble.fill"
    }
  }
}
