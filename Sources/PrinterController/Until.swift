//
//  Until.swift
//
//
//  Created by Connor Barnes on 8/4/21.
//

import Foundation

func until(
  _ condition: @autoclosure @escaping () async throws -> Bool,
  frequency: TimeInterval = 0.2
) async rethrows {
  while try await !condition() {
    await Task.sleep(UInt64(1e9))
  }
}

func untilSuccess(times: Int, action: () async throws -> ()) async throws {
  for _ in 0..<(times - 1) {
    do {
      try await action()
      return
    } catch {
      
    }
  }
  
  try await action()
}
