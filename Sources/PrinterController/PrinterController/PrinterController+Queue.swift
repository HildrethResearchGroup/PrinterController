//
//  PrinterController+Queue.swift
//  PrinterController+Queue
//
//  Created by Connor Barnes on 8/29/21.
//

public extension PrinterController {
  func resumeQueue() async {
    await setPrinterQueueState(\.isRunning, to: true)
    await setPrinterQueueState(\.task, to: Task {
      // If the operation index is nil, start from the first operation
      if await printerQueueState.operationIndex == nil {
        await setPrinterQueueState(\.operationIndex, to: printerQueueState.queue.startIndex)
      }
      
      while await printerQueueState.operationIndex != printerQueueState.queue.endIndex {
        if Task.isCancelled {
          break
        }
        
        let operation = await printerQueueState.queue[printerQueueState.operationIndex!]
        
        if operation.isEnabled {
          do {
            try await operation.run(printerController: self)
          } catch {
            if !operation.continueOnError {
              break
            }
          }
        }
        
        await setPrinterQueueState(
          \.operationIndex,
           to: printerQueueState.queue.index(after: printerQueueState.operationIndex!)
        )
      }
      
      // Queue is done running
      await setPrinterQueueState(\.operationIndex, to: nil)
      await setPrinterQueueState(\.isRunning, to: false)
    })
  }
  
  func pauseQueue() async {
    await printerQueueState.task?.cancel()
  }
}
