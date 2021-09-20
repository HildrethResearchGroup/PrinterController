//
//  PrinterController.Error.swift
//
//
//  Created by Connor Barnes on 7/22/21.
//

public extension PrinterController {
  enum Error: Swift.Error {
    case couldNotCreateStage
    case instrumentNotConnected
    case instrumentNotInitialized
    case instrumentBlocked
    case instrumentBusy
  }
}
