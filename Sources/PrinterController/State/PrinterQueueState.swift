//
//  PrinterQueueState.swift
//  PrinterQueueState
//
//  Created by Connor Barnes on 8/29/21.
//

import Foundation

public struct PrinterQueueState {
  public var queue: [AnyPrinterOperation] = []
  public internal(set) var operationIndex: Int?
  public internal(set) var isRunning: Bool = false
	public var modalComment: String? = nil
	public var waitingTimeRemaining: TimeInterval? = nil
  
  var task: Task<Void, Never>?
}
