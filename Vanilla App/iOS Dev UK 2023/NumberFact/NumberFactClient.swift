import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay

struct NumberFactClient {
	var getFact: (_ number: Int) async throws -> String
}

extension NumberFactClient {
	static var live: Self {
		.init(
			getFact: { int in
				let url = URL(string: "http://numbersapi.com/\(int)")!

				let result = try await URLSession.shared.data(from: url)

				return String(data: result.0, encoding: .utf8)!
			}
		)
	}
}

extension NumberFactClient {
	static var unimplemented: Self {
		.init(
			getFact: XCTUnimplemented("\(self.self).getFact")
		)
	}
}

#if DEBUG
extension NumberFactClient {
	mutating func overrideGetFact(for expectedCount: Int, with response: @escaping () async throws -> String) {
		let fulfill = expectation(description: "Get Fact for \(expectedCount)")
		self.getFact = { @Sendable [self] count in
			if count == expectedCount {
				fulfill()
				return try await response()
			}
			return try await self.getFact(count)
		}
	}
}
#endif
