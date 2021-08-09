//
//  DisplacementMode.swift
//  DisplacementMode
//
//  Created by Connor Barnes on 8/9/21.
//

public enum DisplacementMode: Codable, Hashable, CaseIterable {
  case large
  case medium
  case small
  case fine
}

// MARK: - CustomStringConvertible
extension DisplacementMode: CustomStringConvertible {
  public var description: String {
    switch self {
    case .large:
      return "Large"
    case .medium:
      return "Medium"
    case .small:
      return "Small"
    case .fine:
      return "Fine"
    }
  }
}
