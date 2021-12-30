//
//  PrinterController+Queue.swift
//  PrinterController+Queue
//
//  Created by Connor Barnes on 8/29/21.
//

import Foundation

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
	
	func waitForModal(withComment comment: String) async throws {
		await setPrinterQueueState(\.modalComment, to: comment)
		
		while await printerQueueState.modalComment != nil {
			try await Task.sleep(nanoseconds: 100_000_000)
		}
	}
	
	func wait(for numberOfSeconds: TimeInterval) async throws {
		let start = Date()
		await setPrinterQueueState(\.waitingTimeRemaining, to: numberOfSeconds)
		
		while true {
			// The user can choose to stop waiting at any time, check if they have done so
			if await printerQueueState.waitingTimeRemaining == nil {
				return
			}
			
			let timeElapsed = Date().timeIntervalSince(start)
			let timeRemaining = numberOfSeconds - timeElapsed
			if timeRemaining < 0 {
				await setPrinterQueueState(\.waitingTimeRemaining, to: nil)
				return
			}
			
			await setPrinterQueueState(\.waitingTimeRemaining, to: timeRemaining)
			
			try await Task.sleep(nanoseconds: UInt64(10_000_000))
		}
	}
}
