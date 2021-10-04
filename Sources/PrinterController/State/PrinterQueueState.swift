//
//  PrinterQueueState.swift
//  PrinterQueueState
//
//  Created by Connor Barnes on 8/29/21.
//

public struct PrinterQueueState {
  public var queue: [PrinterOperation] = []
  public internal(set) var operationIndex: Int?
  public internal(set) var isRunning: Bool = false
  
  var task: Task<Void, Never>?
}
