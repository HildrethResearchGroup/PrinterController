//
//  XPSQ8CollectiveController.swift
//  
//
//  Created by Connor Barnes on 1/3/22.
//

import Foundation
import XPSQ8Kit

class XPSQ8CollectiveController {
	let address: String
	let port: Int
	let timeout: TimeInterval
	
	var statusController: XPSQ8Controller
	var miscellaneousController: XPSQ8Controller
	private var groupWriteControllers: [String : XPSQ8Controller] = [:]
	private var groupReadControllers: [String : XPSQ8Controller] = [:]
	
	init(address: String, port: Int, timeout: TimeInterval = 5.0) async throws {
		self.address = address
		self.port = port
		self.timeout = timeout
		statusController = try await .init(address: address, port: port, timeout: timeout)
		miscellaneousController = try await .init(address: address, port: port, timeout: timeout)
	}
	
	private func makeNewController() async throws -> XPSQ8Controller {
		try await .init(address: address, port: port, timeout: timeout)
	}
	
	func writeController(for group: String) async throws -> XPSQ8Controller {
		if let controller = groupWriteControllers[group] {
			return controller
		} else {
			let controller = try await makeNewController()
			groupWriteControllers[group] = controller
			return controller
		}
	}
	
	func readController(for group: String) async throws -> XPSQ8Controller {
		if let controller = groupReadControllers[group] {
			return controller
		} else {
			let controller = try await makeNewController()
			groupReadControllers[group] = controller
			return controller
		}
	}
}
