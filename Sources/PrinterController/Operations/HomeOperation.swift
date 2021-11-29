//
//  HomeOperation.swift
//  
//
//  Created by Connor Barnes on 11/28/21.
//

import SwiftUI

public struct HomeConfiguration: Hashable, Codable {
	public init() { }
}

extension PrinterOperation {
	public static func homeOperation<Body: View>(
		body: @escaping (Binding<HomeConfiguration>) -> Body
	) -> PrinterOperation<HomeConfiguration, Body> {
		.init(
			kind: .home,
			configuration: .init(),
			name: "Home",
			thumbnailName: "house",
			body: body
		) { configuration, printerController in
			try await printerController.searchForHome()
		}
	}
}
