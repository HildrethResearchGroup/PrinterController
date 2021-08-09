//
//  XPSQ8State.swift
//
//
//  Created by Connor Barnes on 8/4/21.
//

import XPSQ8Kit
import Foundation

public struct XPSQ8State {
  public var xPosition: Double?
  public var yPosition: Double?
  public var zPosition: Double?
  public var groupStatus: StageGroup.Status?
  public var updateInterval: TimeInterval? = 0.2
  
  public var xDisplacementMode: DisplacementMode?
  public var yDisplacementMode: DisplacementMode?
  public var zDisplacementMode: DisplacementMode?
  
  var xLastSetDisplacementMode: DisplacementMode?
  var yLastSetDisplacementMode: DisplacementMode?
  var zLastSetDisplacementMode: DisplacementMode?
}

// MARK: Helpers
extension XPSQ8State {
  public func displacementMode(for dimension: PrinterController.Dimension) -> DisplacementMode? {
    switch dimension {
    case .x:
      return xDisplacementMode
    case .y:
      return yDisplacementMode
    case .z:
      return zDisplacementMode
    }
  }
  
  func lastSetDisplacementMode(for dimension: PrinterController.Dimension) -> DisplacementMode? {
    switch dimension {
    case .x:
      return xLastSetDisplacementMode
    case .y:
      return yLastSetDisplacementMode
    case .z:
      return zLastSetDisplacementMode
    }
  }
}
