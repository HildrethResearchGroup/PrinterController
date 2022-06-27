//
//  WaveFunction.swift
//  WaveFunction
//
//  Created by Connor Barnes on 8/16/21.
//

public enum WaveFunction: String, Codable, Hashable, CaseIterable {
  case sin = "SIN"
  case square = "SQU"
  case ramp = "RAMP"
  case pulse = "PULS"
  case noise = "NOIS"
  case dc = "DC"
  
  public enum Error: Swift.Error {
    case unknownFunction
  }
  
  public var displayValue: String {
    switch self {
    case .sin:
      return "Sin"
    case .square:
      return "Square"
    case .ramp:
      return "Ramp"
    case .pulse:
      return "Pulse"
    case .noise:
      return "Noise"
    case .dc:
      return "DC"
    }
  }
}

#if canImport(SwiftUI)
extension WaveFunction: Identifiable {
	public var id: String {
		rawValue
	}
}
#endif
