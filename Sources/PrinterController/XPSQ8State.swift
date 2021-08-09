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
}
