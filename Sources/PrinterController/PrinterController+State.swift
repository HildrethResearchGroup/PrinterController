////
////  PrinterController+State.swift
////  File
////
////  Created by Connor Barnes on 7/26/21.
////
//
//import Foundation
//
//extension PrinterController {
//	enum Instrument {
//		case xpsq8
//		case waveform
//	}
//	
//	@MainActor
//	func setState(instrument: Instrument, state: InstrumentState) {
//		switch instrument {
//		case .xpsq8:
//			xpsq8State = state
//		case .waveform:
//			waveformState = state
//		}
//	}
//	
//	@MainActor
//	func state(for instrument: Instrument) -> InstrumentState {
//		switch instrument {
//		case .xpsq8:
//			return xpsq8State
//		case .waveform:
//			return waveformState
//		}
//	}
//}
//
//// MARK: - Instrument State
//extension PrinterController {
//	func with<T>(
//		_ instruments: Set<Instrument>,
//		blocking blocked: Set<Instrument> = [],
//		perform action: () async throws -> T
//	) async throws -> T {
//		for instrument in instruments {
//			switch await state(for: instrument) {
//			case .notConnected, .connecting:
//				throw Error.instrumentNotConnected
//			case .notInitialized:
//				throw Error.instrumentNotInitialized
//			case .busy:
//				throw Error.instrumentBusy
//			case .blocked:
//				throw Error.instrumentBlocked
//			default:
//				break
//			}
//		}
//		
//		for instrument in instruments {
//			await setState(instrument: instrument, state: .busy)
//		}
//		
//		for instrument in blocked {
//			await setState(instrument: instrument, state: .blocked)
//		}
//		
//		let result = try await action()
//		
//		for instrument in instruments {
//			await setState(instrument: instrument, state: .ready)
//		}
//		
//		for instrument in blocked {
//			await setState(instrument: instrument, state: .ready)
//		}
//		
//		return result
//	}
//	
//	func with<T>(
//		_ instrument: Instrument,
//		blocking blocked: Set<Instrument> = [],
//		perform action: () async throws -> T
//	) async throws -> T {
//		return try await with([instrument], blocking: blocked, perform: action)
//	}
//	
//	func with<T>(
//		_ instrument: Instrument,
//		blocking blocked: Instrument,
//		perform action: () async throws -> T
//	) async throws -> T {
//		return try await with([instrument], blocking: [blocked], perform: action)
//	}
//	
//	func with<T>(
//		_ instruments: Set<Instrument>,
//		blocking blocked: Instrument,
//		perform action: () async throws -> T
//	) async throws -> T {
//		return try await with(instruments, blocking: [blocked], perform: action)
//	}
//}
